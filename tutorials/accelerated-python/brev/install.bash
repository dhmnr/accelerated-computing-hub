# Build steps for the Accelerated Python image, run by brev/dockerfile after the
# Python packages are installed.

# OpenMPI for the mpi4py examples.
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  openmpi-bin \
  libopenmpi-dev
rm -rf /var/lib/apt/lists/*

# Profiler-backed kernels for in-place notebook cell profiling.
nsightful-ncu install --prefix="${VIRTUAL_ENV}" '--profiler-args=--set full --clock-control none'
nsightful-nsys install --prefix="${VIRTUAL_ENV}" '--profiler-args=--trace=cuda,nvtx,osrt'

OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
  python -c 'from mpi4py import MPI; assert MPI.get_vendor()[0] == "Open MPI", MPI.get_vendor()'
