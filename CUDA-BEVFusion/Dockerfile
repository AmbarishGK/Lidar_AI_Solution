# You can override BASE_IMAGE at build time if you like
ARG BASE_IMAGE=nvcr.io/nvidia/tensorrt:24.04-py3
FROM ${BASE_IMAGE}

# Basic build + runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget unzip cmake build-essential libprotobuf-dev protobuf-compiler \
    python3-pip python3-dev python3-setuptools \
 && rm -rf /var/lib/apt/lists/*

# Python deps used by the project scripts
RUN pip3 install --no-cache-dir onnx numpy pyyaml

# Workspace
WORKDIR /workspace

# Pull the repo (recursive per project note)
RUN git clone --recursive https://github.com/NVIDIA-AI-IOT/Lidar_AI_Solution.git

# Prepare environment for CUDA-BEVFusion
WORKDIR /workspace/Lidar_AI_Solution/CUDA-BEVFusion

# Write tool/environment.sh with correct container paths
RUN printf '%s\n' \
'export TensorRT_Lib=/usr/lib/x86_64-linux-gnu' \
'export TensorRT_Inc=/usr/include/x86_64-linux-gnu' \
'export TensorRT_Bin=/usr/src/tensorrt/bin' \
'' \
'export CUDA_Lib=/usr/local/cuda/lib64' \
'export CUDA_Inc=/usr/local/cuda/include' \
'export CUDA_Bin=/usr/local/cuda/bin' \
'export CUDA_HOME=/usr/local/cuda' \
'' \
'export CUDNN_Lib=/usr/lib/x86_64-linux-gnu' \
'' \
'# For CUDA-11.x: SPCONV_CUDA_VERSION=11.4' \
'# For CUDA-12.x: SPCONV_CUDA_VERSION=12.6' \
'export SPCONV_CUDA_VERSION=12.6' \
'' \
'# resnet50 / resnet50int8 / swint' \
'export DEBUG_MODEL=resnet50int8' \
'# fp16 / int8' \
'export DEBUG_PRECISION=int8' \
'export DEBUG_DATA=example-data' \
'export USE_Python=OFF' \
> tool/environment.sh && chmod +x tool/environment.sh

# Convenience script: builds engines + runs the demo
RUN printf '%s\n' \
'#!/bin/bash' \
'set -euo pipefail' \
'cd /workspace/Lidar_AI_Solution/CUDA-BEVFusion' \
'. tool/environment.sh' \
'echo "[Env]"; env | egrep "TensorRT_|CUDA_|CUDNN_|DEBUG_|SPCONV_" || true' \
'if [ ! -d "example-data" ] || [ ! -d "model" ]; then' \
'  echo "[!] Missing example-data/ or model/ under /workspace/Lidar_AI_Solution/CUDA-BEVFusion";' \
'  echo "    Mount or copy them before running. See host instructions."; exit 1;' \
'fi' \
'bash tool/build_trt_engine.sh' \
'bash src/onnx/make_pb.sh' \
'bash tool/run.sh' \
> /usr/local/bin/run_bevfusion.sh && chmod +x /usr/local/bin/run_bevfusion.sh

CMD ["/bin/bash"]
