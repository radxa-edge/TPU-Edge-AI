[简体中文](./README.md) | [English](./README_EN.md)

## Radxa Model-Zoo 介绍


## 简介
Radxa Model-Zoo 基于 [Sophon demo](https://github.com/sophgo/sophon-demo) 进行二次开发，由Radxa独立管理，Radxa Model-Zoo 提供一系列主流算法的移植例程与预编译好的TPU平台模型下载。包括基于TPU-NNTC和TPU-MLIR的模型编译与量化，基于BMRuntime的推理引擎移植，以及基于BMCV/OpenCV的前后处理算法移植。

Radxa Model--Zoo 利用 [SophonSDK](https://developer.sophon.ai/site/index/material/all/all.html) 接口进行开发，SophonSDK是算能科技基于其自主研发的深度学习处理器所定制的深度学习SDK，涵盖了神经网络推理阶段所需的模型优化、高效运行时支持等能力，为深度学习应用开发和部署提供易用、高效的全栈式解决方案。目前可兼容BM1684X。

## 目录结构与说明
| 目录                                        | 算法类别         | 编程语言    | BModel | 支持多batch | 预处理库 |
|---                                          |---              |---          | ---     |---          |---      |
| [LPRNet](./sample/LPRNet/README.md)         | 车牌识别          | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [ResNet](./sample/ResNet/README.md)         | 图像分类          | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [RetinaFace](./sample/RetinaFace/README.md) | 人脸检测          | C++/Python | FP32           | YES | BMCV/OpenCV |
| [segformer](./sample/segformer/README.md)   | 语义分割           | C++/Python | FP32/FP16      | YES | BMCV/OpenCV |
| [yolact](./sample/yolact/README.md)         | 实例分割          | Python     | FP32           | YES | BMCV/OpenCV |
| [PP-OCR](./sample/PP-OCR/README.md)         | OCR              | C++/Python | FP32/FP16      | YES | BMCV/OpenCV |
| [OpenPose](./sample/OpenPose/README.md)     | 人体关键点检测     | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [C3D](./sample/C3D/README.md)               | 视频动作识别       | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [DeepSORT](./sample/DeepSORT/README.md)     | 多目标跟踪         | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [ByteTrack](./sample/ByteTrack/README.md)   | 多目标跟踪         | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [CenterNet](./sample/CenterNet/README.md)   | 目标检测、姿态识别 | C++/Python | FP32/FP16/INT8 | YES | BMCV |
| [YOLOv5](./sample/YOLOv5/README.md)         | 目标检测          | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [YOLOv34](./sample/YOLOv34/README.md)       | 目标检测          | C++/Python | FP32/INT8      | NO  | BMCV/OpenCV |
| [YOLOX](./sample/YOLOX/README.md)           | 目标检测          | C++/Python | FP32/INT8      | YES | BMCV/OpenCV |
| [SSD](./sample/SSD/README.md)               | 目标检测          | C++/Python | FP32/INT8      | YES | BMCV/OpenCV |
| [YOLOv7](./sample/YOLOv7/README.md)         | 目标检测           | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV|
| [YOLOv8](./sample/YOLOv8/README.md)         | 目标检测           | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV |
| [YOLOv5_opt](./sample/YOLOv5_opt/README.md) | 目标检测           | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV|
| [ppYOLOv3](./sample/ppYOLOv3/README.md)     | 目标检测           | C++/Python | FP32/FP16/INT8 | YES | BMCV/OpenCV|
| [WeNet](./sample/WeNet/README.md)           | 语音识别           | C++/Python | FP32/FP16      | YES | -   |
| [BERT](./sample/BERT/README.md)             | 语言模型           | C++/Python | FP32/FP16      | YES | -   |
| [ChatGLM2](./sample/chatglm2/README.md)     | 语言模型           | C++/Python | FP16/INT8/INT4 | YES | -   |
| [Llama2](./sample/Llama2/README.md)         | 语言模型           | C++        | FP16/INT8/INT4 | YES | -   |



## 环境依赖
Radxa Model-Zoo主要依赖tpu-mlir、tpu-nntc、libsophon、sophon-ffmpeg、sophon-opencv、sophon-sail，其版本要求如下：
|Radxa Model-Zoo|tpu-mlir |tpu-nntc |libsophon|sophon-ffmpeg|sophon-opencv|sophon-sail| 发布日期   |
|--------|------------| --------|---------|---------    |----------   | ------    | --------  |
| 0.1.0 | >=1.2.2     | >=3.1.7 | >=0.4.6 | >=0.6.0     | >=0.6.0     | >=3.7.0   | >=23.10.01|
