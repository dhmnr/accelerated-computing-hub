# NVIDIA Accelerated Computing Hub

This repository is a home for open learning materials related to GPU computing.  You will find user guides, tutorials, and other works freely available for all learners interested in GPU computing.

The intention is to create a living project where documents, examples, best practices, optimizations, and new features can become both visible and accessible to users quickly and easily.

## Tutorials and Syllabi

The following interactive tutorials are available. Each runs locally or on any cloud GPU instance with Docker Compose, and many notebooks also run on [Google Colab](https://colab.research.google.com).

| Content | Docker Compose | GPU | Requirements |
|---------|----------------|---------------|---------------|
| [CUDA Tile Tutorial](tutorials/accelerated-python/notebooks/syllabi/cutile.ipynb) | [docker-compose.yml](tutorials/accelerated-python/docker/docker-compose.yml) | A10G | - |
| [CUDA C++ Tutorial](tutorials/cuda-cpp/README.md) | [docker-compose.yml](tutorials/cuda-cpp/docker/docker-compose.yml) | L40S, L4, or T4 | - |
| [Standard Parallelism Tutorial](tutorials/stdpar/README.md) | [docker-compose.yml](tutorials/stdpar/docker/docker-compose.yml) | 4xL4, 2xL4, 2xL40S, or 1x L40S | Linux 6.1.24+, 6.2.11+, or 6.3+ (for HMM) |
| [Accelerated Python Tutorial](tutorials/accelerated-python/README.md) | [docker-compose.yml](tutorials/accelerated-python/docker/docker-compose.yml) | L40S, L4, or T4; A10G or newer Ampere/Ada/Blackwell for CUDA Tile; 4xL4 or 2xL4 for distributed | Host driver with CUDA 13 support |
| [PyHPC Tutorial](tutorials/pyhpc/README.md) | [docker-compose.yml](tutorials/pyhpc/docker/docker-compose.yml) | L40S, L4, or T4 | - |
| [NVIDIA Warp Tutorial](tutorials/warp/README.md) | [docker-compose.yml](tutorials/warp/docker/docker-compose.yml) | L40S, L4, or T4 | - |
| [Sim2Real Blogs](tutorials/sim2real-blogs/README.md) | [docker-compose.yml](tutorials/sim2real-blogs/docker/docker-compose.yml) | L40S, L4, or T4 | - |
| [nvmath-python Tutorial](tutorials/nvmath-python/README.md) | [docker-compose.yml](tutorials/nvmath-python/docker/docker-compose.yml) | 4xL4, 2xL4, 2xL40S, or 1x L40S | - |
| [CUDA Python Tutorial - CuPy, cuDF, CCCL, & Kernels - 8 Hours](tutorials/accelerated-python/notebooks/syllabi/cuda_python__cupy_cudf_cccl_kernels__8_hours.ipynb) | [docker-compose.yml](tutorials/accelerated-python/docker/docker-compose.yml) | L40S, L4, or T4 | - |
| [CUDA Python Tutorial - CuPy, SIMT, & Tile - 8 Hours](tutorials/accelerated-python/notebooks/syllabi/cuda_python__cupy_simt_tile__8_hours.ipynb) | [docker-compose.yml](tutorials/accelerated-python/docker/docker-compose.yml) | A10G | - |
| [CUDA Python Tutorial - cuda.core & CCCL - 2 Hours](tutorials/accelerated-python/notebooks/syllabi/cuda_python__cuda_core_cccl__2_hours.ipynb) | [docker-compose.yml](tutorials/accelerated-python/docker/docker-compose.yml) | L40S, L4, or T4 | - |
| [PyHPC Tutorial - NumPy, CuPy, & mpi4py - 4 Hours](tutorials/pyhpc/notebooks/syllabi/pyhpc__numpy_cupy_mpi4py__4_hours.ipynb) | [docker-compose.yml](tutorials/pyhpc/docker/docker-compose.yml) | 4xL4, 2xL4, 2xL40S, or 1x L40S | Host driver with CUDA 13 support |
| [PyHPC Tutorial - CuPy, Kernels, MPI, JAX, OMP, Interop - 2 Days](tutorials/pyhpc/notebooks/syllabi/pyhpc__cupy_kernels_mpi_jax_omp_interop__2_days.ipynb) | [docker-compose.yml](tutorials/pyhpc/docker/docker-compose.yml) | L40S, L4, or T4 | Host driver with CUDA 13 support |
| [GPU Deployment Tutorial](tutorials/gpu-deployment/gpu-deployment-from-scratch.md) | | | |
| [Newton Robot Tasks Tutorial](tutorials/newton/README.md) | [docker-compose.yml](tutorials/newton/docker/docker-compose.yml) | NVIDIA GPU with a CUDA 13.1-compatible driver; local CPU path available | See tutorial requirements |

## License

All written materials (user guides, documentation, presentations) are subject to [Creative Commons CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

All codes (notebook code, coding examples) are subject to [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Contact

For additional help, please use [NVIDIA's CUDA Developer Forums](https://forums.developer.nvidia.com/c/accelerated-computing/cuda).
