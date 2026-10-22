# Build steps for the Accelerated Python image, run by brev/dockerfile after the
# Python packages are installed.

export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Native build tools for the C++ interop notebooks, and both MPI
# implementations. Accelerated Python uses OpenMPI by default; the PyHPC kernel
# selects MPICH.
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  cmake \
  ninja-build \
  mpich \
  libmpich-dev \
  openmpi-bin \
  libopenmpi-dev
update-alternatives --set mpi /usr/bin/mpicc.openmpi
update-alternatives --set mpirun /usr/bin/mpirun.openmpi
rm -rf /var/lib/apt/lists/*

# PyHPC kernel: the same Python environment with MPICH and its own IPython
# startup directory.
multiarch="$(gcc -dumpmachine)"
ln -sfn libmpich.so.12 "/usr/lib/${multiarch}/libmpi.so.12"
mkdir -p /opt/pyhpc-mpi/bin /opt/pyhpc-ipython/profile_default/startup
for tool in mpirun mpiexec mpicc mpicxx; do
  ln -sfn "/usr/bin/${tool}.mpich" "/opt/pyhpc-mpi/bin/${tool}"
done
ln -sfn /usr/bin/hydra_pmi_proxy /opt/pyhpc-mpi/bin/hydra_pmi_proxy
cp ipython-startup-matplotlib-theme.py /opt/pyhpc-ipython/profile_default/startup/10-matplotlib-theme.py
chmod -R a+rwX /opt/pyhpc-ipython
python -m ipykernel install --prefix="${VIRTUAL_ENV}" --name=pyhpc --display-name="Python 3 (PyHPC)"

# Profiler-backed kernels for in-place notebook cell profiling.
nsightful-ncu install --prefix="${VIRTUAL_ENV}" '--profiler-args=--set full --clock-control none'
nsightful-nsys install --prefix="${VIRTUAL_ENV}" '--profiler-args=--trace=cuda,nvtx,osrt'

# All three kernels run with the PyHPC environment.
python - <<'EOF'
import json, os
from pathlib import Path

root = Path(os.environ["VIRTUAL_ENV"]) / "share/jupyter/kernels"
env = {"IPYTHONDIR": "/opt/pyhpc-ipython", "MPI4PY_MPIABI": "mpich", "PATH": "/opt/pyhpc-mpi/bin:${PATH}"}
for name in ("pyhpc", "nsightful-ncu", "nsightful-nsys"):
    path = root / name / "kernel.json"
    path.write_text(json.dumps(dict(json.loads(path.read_text()), env=env), indent=2) + "\n")
EOF

python -c 'from mpi4py import MPI; assert MPI.get_vendor()[0] == "Open MPI", MPI.get_vendor()'
MPI4PY_MPIABI=mpich PATH="/opt/pyhpc-mpi/bin:${PATH}" \
  python -c 'from mpi4py import MPI; assert MPI.get_vendor()[0] == "MPICH", MPI.get_vendor()'
