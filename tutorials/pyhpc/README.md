# PyHPC Tutorial

Python for high-performance computing: NumPy and CuPy, CUDA kernel authoring,
MPI with mpi4py, JAX, PyOMP, and Python/C++ interoperability, ending in a
Shallow Water Equations case study.

- [Notebooks](./notebooks) containing lessons and exercises organized by topic. The fundamentals and kernel lessons are copies of the matching [Accelerated Python](../accelerated-python/README.md) lessons.
- [Slides](./slides) containing the lecture content for the lessons.
- [Syllabi](./notebooks/syllabi) that select a subset of the notebooks for a particular learning objective.
- [Docker Compose file](./brev/docker-compose.yml) for creating Brev Launchables or running locally.

Brev Launchables of this tutorial should use:
- L40S, L4, or T4 instances.
- A host driver with CUDA 13 support.
- Crusoe or any other provider with Flexible Ports.

## Syllabi

- [PyHPC - NumPy, CuPy, & mpi4py - 4 Hours](./notebooks/syllabi/pyhpc__numpy_cupy_mpi4py__4_hours.ipynb)
- [PyHPC - CuPy, Kernels, MPI, JAX, OMP, Interop - 2 Days](./notebooks/syllabi/pyhpc__cupy_kernels_mpi_jax_omp_interop__2_days.ipynb)

Applications 81 through 87 form one ordered case study. They solve the same 1D
Shallow Water Equations problem with NumPy, JAX, PyOMP, nanobind, CppJIT/CUB,
and mpi4py. Notebooks 81 through 86 write measurements to `timings.json`; run
them before notebook 87, which compares the results. CppJIT is not installed in
the current tutorial image, so notebook 85 does not run there yet.

The `Python 3 (PyHPC)` and Nsight profiler kernels only select course-specific
startup and MPI settings: MPICH is used for local multi-rank exercises, while
the default Python kernel uses OpenMPI. For CSCS Alps/Daint deployment, follow the [CSCS launch
guide](../../docs/cscs.md).

## Notebooks

### Fundamentals

| # | Exercise | Link | Solution |
|---|----------|------|----------|
| 01 | NumPy Intro: `ndarray` Basics | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/01__numpy_intro__ndarray_basics.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/solutions/01__numpy_intro__ndarray_basics__SOLUTION.ipynb) |
| 03 | NumPy to CuPy: `ndarray` Basics | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/03__numpy_to_cupy__ndarray_basics.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/solutions/03__numpy_to_cupy__ndarray_basics__SOLUTION.ipynb) |
| 05 | Memory Spaces: Power Iteration | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/05__memory_spaces__power_iteration.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/solutions/05__memory_spaces__power_iteration__SOLUTION.ipynb) |
| 06 | Asynchrony: Power Iteration | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/06__asynchrony__power_iteration.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/fundamentals/solutions/06__asynchrony__power_iteration__SOLUTION.ipynb) |

### Kernels

| # | Exercise | Link | Solution |
|---|----------|------|----------|
| 40 | Kernel Authoring: Copy | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/kernels/40__kernel_authoring__copy.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/kernels/solutions/40__kernel_authoring__copy__SOLUTION.ipynb) |
| 41 | Kernel Authoring: Book Histogram | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/kernels/41__kernel_authoring__book_histogram.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/kernels/solutions/41__kernel_authoring__book_histogram__SOLUTION.ipynb) |

### Distributed

| # | Exercise | Link | Solution |
|---|----------|------|----------|
| 60 | mpi4py | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/distributed/60__mpi4py.ipynb) | |
| 62 | mpi4py: Heat Equation | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/distributed/62__mpi4py__heat_equation.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/distributed/solutions/62__mpi4py__heat_equation__SOLUTION.ipynb) |

### Applications

| # | Exercise | Link | Solution |
|---|----------|------|----------|
| 80 | C++ Interoperability | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/80__cpp_interop.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/solutions/80__cpp_interop__SOLUTION.ipynb) |
| 81 | Shallow Water Equations: NumPy Baseline | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/81__swe__intro.ipynb) | |
| 82 | Shallow Water Equations: JAX | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/82__swe__jax.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/solutions/82__swe__jax__SOLUTION.ipynb) |
| 83 | Shallow Water Equations: PyOMP | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/83__swe__pyomp.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/solutions/83__swe__pyomp__SOLUTION.ipynb) |
| 84 | Shallow Water Equations: nanobind | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/84__swe__nanobind.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/solutions/84__swe__nanobind__SOLUTION.ipynb) |
| 85 | Shallow Water Equations: CppJIT and CUB | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/85__swe__cppjit__cub.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/solutions/85__swe__cppjit__cub__SOLUTION.ipynb) |
| 86 | Shallow Water Equations: mpi4py | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/86__swe__mpi4py.ipynb) | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/solutions/86__swe__mpi4py__SOLUTION.ipynb) |
| 87 | Shallow Water Equations: Synthesis | [![](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/NVIDIA/accelerated-computing-hub/blob/main/tutorials/pyhpc/notebooks/applications/87__swe__synthesis.ipynb) | |
