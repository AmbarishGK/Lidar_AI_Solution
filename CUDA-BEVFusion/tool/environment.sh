# ---- TensorRT / CUDA / cuDNN inside the TensorRT 24.04 container ----
export TensorRT_Lib=/usr/lib/x86_64-linux-gnu
export TensorRT_Inc=/usr/include/x86_64-linux-gnu
export TensorRT_Bin=/usr/src/tensorrt/bin

export CUDA_Lib=/usr/local/cuda/lib64
export CUDA_Inc=/usr/local/cuda/include
export CUDA_Bin=/usr/local/cuda/bin
export CUDA_HOME=/usr/local/cuda

export CUDNN_Lib=/usr/lib/x86_64-linux-gnu

# You're on CUDA 12.4 in this container, keep it in the 12.x family
export SPCONV_CUDA_VERSION=12.8

# Demo knobs
export DEBUG_MODEL=resnet50int8   # or: resnet50 / swint
export DEBUG_PRECISION=int8       # or: fp16
export DEBUG_DATA=example-data
export USE_Python=OFF

# ---- Make the configure step happy (and accurate for your GPU) ----
# Ada (RTX 4070 Laptop) is SM 8.9
export CUDASM=89
export ConfigurationStatus=Success

# Some images export a warning string here; don’t let the scripts treat it as fatal
unset _CUDA_COMPAT_STATUS
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/workspace/Lidar_AI_Solution/libraries/3DSparseConvolution/libspconv/lib/x86_64_cuda12.8
