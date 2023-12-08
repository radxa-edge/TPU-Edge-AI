# Radxa Model-Zoo Introduction

## Overview

Radxa Model-Zoo is based on the [Sophon demo](https://github.com/sophgo/sophon-demo) and has been further developed independently by Radxa. Radxa Model-Zoo provides a collection of ported routines and precompiled TPU platform models for mainstream algorithms. This includes model compilation and quantization based on TPU-NNTC and TPU-MLIR, porting of the inference engine based on BMRuntime, and algorithm porting for pre- and post-processing based on BMCV/OpenCV.

Radxa Model-Zoo is developed using the [SophonSDK](https://developer.sophon.ai/site/index/material/all/all.html) interface. SophonSDK is a deep learning SDK customized by Algorithmic Capability Technology based on its independently developed deep learning processor. It covers capabilities such as model optimization and efficient runtime support needed in the neural network inference stage, providing an easy-to-use, efficient full-stack solution for deep learning application development and deployment. Currently, it is compatible with BM1684X.

## Directory Structure and Explanation

| Directory                                   | Algorithm Category                 | Programming Language | BModel         | Multi-Batch Support | Preprocessing Library |
| ------------------------------------------- | ---------------------------------- | -------------------- | -------------- | ------------------- | --------------------- |
| [LPRNet](./sample/LPRNet/README.md)         | License Plate Recognition          | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [ResNet](./sample/ResNet/README.md)         | Image Classification               | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [RetinaFace](./sample/RetinaFace/README.md) | Face Detection                     | C++/Python           | FP32           | YES                 | BMCV/OpenCV           |
| [segformer](./sample/segformer/README.md)   | Semantic Segmentation              | C++/Python           | FP32/FP16      | YES                 | BMCV/OpenCV           |
| [yolact](./sample/yolact/README.md)         | Instance Segmentation              | Python               | FP32           | YES                 | BMCV/OpenCV           |
| [PP-OCR](./sample/PP-OCR/README.md)         | OCR                                | C++/Python           | FP32/FP16      | YES                 | BMCV/OpenCV           |
| [OpenPose](./sample/OpenPose/README.md)     | Human Pose Detection               | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [C3D](./sample/C3D/README.md)               | Video Action Recognition           | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [DeepSORT](./sample/DeepSORT/README.md)     | Multi-Object Tracking              | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [ByteTrack](./sample/ByteTrack/README.md)   | Multi-Object Tracking              | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [CenterNet](./sample/CenterNet/README.md)   | Object Detection, Pose Recognition | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV                  |
| [YOLOv5](./sample/YOLOv5/README.md)         | Object Detection                   | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [YOLOv34](./sample/YOLOv34/README.md)       | Object Detection                   | C++/Python           | FP32/INT8      | NO                  | BMCV/OpenCV           |
| [YOLOX](./sample/YOLOX/README.md)           | Object Detection                   | C++/Python           | FP32/INT8      | YES                 | BMCV/OpenCV           |
| [SSD](./sample/SSD/README.md)               | Object Detection                   | C++/Python           | FP32/INT8      | YES                 | BMCV/OpenCV           |
| [YOLOv7](./sample/YOLOv7/README.md)         | Object Detection                   | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [YOLOv8](./sample/YOLOv8/README.md)         | Object Detection                   | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [YOLOv5_opt](./sample/YOLOv5_opt/README.md) | Object Detection                   | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [ppYOLOv3](./sample/ppYOLOv3/README.md)     | Object Detection                   | C++/Python           | FP32/FP16/INT8 | YES                 | BMCV/OpenCV           |
| [WeNet](./sample/WeNet/README.md)           | Speech Recognition                 | C++/Python           | FP32/FP16      | YES                 | -                     |
| [BERT](./sample/BERT/README.md)             | Language Model                     | C++/Python           | FP32/FP16      | YES                 | -                     |
| [ChatGLM2](./sample/chatglm2/README.md)     | Language Model                     | C++/Python           | FP16/INT8/INT4 | YES                 | -                     |
| [Llama2](./sample/Llama2/README.md)         | Language Model                     | C++                  | FP16/INT8/INT4 | YES                 | -                     |

## Environment Dependencies

Radxa Model-Zoo primarily depends on tpu-mlir, tpu-nntc, libsophon, sophon-ffmpeg, sophon-opencv, and sophon-sail. The version requirements are as follows:

| Radxa Model-Zoo | tpu-mlir | tpu-nntc | libsophon | sophon-ffmpeg | sophon-opencv | sophon-sail | Release Date |
| --------------- | -------- | -------- | --------- | ------------- | ------------- | ----------- | ------------ |
| 0.1.0           | >=1.2.2  | >=3.1.7  | >=0.4.6   | >=0.6.0       | >=0.6.0       | >=3.7.0     | >=23.10.01   |