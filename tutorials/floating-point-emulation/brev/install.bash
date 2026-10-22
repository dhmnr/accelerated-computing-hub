# Build steps for the floating-point emulation image, run by brev/dockerfile.

# MathDx headers in /opt/nvidia/mathdx/25.12, where cmake/common.cmake looks
# for them, and libmathdx on the default library path.
MATHDX_URL=https://developer.nvidia.com/downloads/compute/cublasdx/redist/cublasdx/cuda13
curl -fsSL "${MATHDX_URL}/nvidia-mathdx-25.12.1-cuda13.tar.gz" | tar -xz -C /tmp
mkdir -p /opt/nvidia
mv /tmp/nvidia-mathdx-25.12.1-cuda13/nvidia/mathdx /opt/nvidia/mathdx
rm -rf /tmp/nvidia-mathdx-25.12.1-cuda13
mkdir -p /opt/nvidia/libmathdx
curl -fsSL "${MATHDX_URL}/libmathdx-Linux-x86_64-0.3.1-cuda13.0.tar.gz" | tar -xz -C /opt/nvidia/libmathdx
echo /opt/nvidia/libmathdx/lib > /etc/ld.so.conf.d/libmathdx.conf
ldconfig
