# YOLOv7

## 目录

- [YOLOv7](#yolov7)
  - [目录](#目录)
  - [1. 简介](#1-简介)
  - [2. 特性](#2-特性)
  - [3. 准备数据与模型](#3-准备数据与模型)
  - [4. 模型编译](#4-模型编译)
    - [4.1 TPU-NNTC编译BModel](#41-tpu-nntc编译bmodel)
    - [4.2 TPU-MLIR编译BModel](#42-tpu-mlir编译bmodel)
  - [5. 例程测试](#5-例程测试)
  - [6. 精度测试](#6-精度测试)
    - [6.1 测试方法](#61-测试方法)
    - [6.2 测试结果](#62-测试结果)
  - [7. 性能测试](#7-性能测试)
    - [7.1 bmrt_test](#71-bmrt_test)
    - [7.2 程序运行性能](#72-程序运行性能)
  - [8. FAQ](#8-faq)
  



## 1. 简介

`YOLOv7`是基于anchor的one-stage目标检测算法,在准确率和速度上超越了以往的YOLO系列；
​本例程对[yolov7官方开源仓库](https://github.com/WongKinYiu/yolov7)v0.1版本的模型和算法进行移植，使之能在SOPHON BM1684和BM1684X上进行推理测试。

## 2. 特性

* 支持BM1684X(x86 PCIe、SoC)和BM1684(x86 PCIe、SoC、arm PCIe)
* 支持FP32、FP16(BM1684X)、INT8模型编译和推理
* 支持基于BMCV预处理的C++推理
* 支持基于OpenCV和BMCV预处理的Python推理
* 支持单batch和多batch模型推理
* 支持1个输出和3个输出模型推理
* 支持图片和视频测试

## 3. 准备数据与模型

​	如果您使用BM1684，建议使用TPU-NNTC编译BModel，Pytorch模型在编译前要导出成torchscript模型或onnx模型；如果您使用BM1684X，建议使用TPU-MLIR编译BModel，Pytorch模型在编译前要导出成onnx模型，具体可参考[YOLOv7模型导出](./docs/yolov7_Export_Guide.md)。

​	同时，您需要准备用于测试的数据，如果量化模型，还要准备用于量化的数据集。

​	本例程在`scripts`目录下提供了相关模型和数据集的下载脚本`download.sh`，您也可以自己准备模型和数据集，并参考[4. 模型编译](https://vscode-remote+ssh-002dremote-002b11-002e73-002e12-002e77.vscode-resource.vscode-cdn.net/home/jin.zhang/chencp/examples/LPRNet/README.md#4-模型转换)进行模型转换。

```bash
# 安装unzip，若已安装请跳过，非ubuntu系统视情况使用yum或其他方式安装
sudo apt install unzip
chmod -R +x scripts/
./scripts/download.sh
```
下载的模型包括：
```
./models
├── BM1684
│   ├── yolov7_v0.1_3output_fp32_1b.bmodel  # 使用TPU-NNTC编译，用于BM1684的FP32 BModel，batch_size=1
│   ├── yolov7_v0.1_3output_fp32_4b.bmodel  # 使用TPU-NNTC编译，用于BM1684的FP32 BModel，batch_size=4
│   ├── yolov7_v0.1_3output_int8_1b.bmodel  # 使用TPU-NNTC编译，用于BM1684的INT8 BModel，batch_size=1
│   └── yolov7_v0.1_3output_int8_4b.bmodel  # 使用TPU-NNTC编译，用于BM1684的INT8 BModel，batch_size=4
├── BM1684X
│   ├── yolov7_v0.1_3output_fp16_1b.bmodel  # 使用TPU-MLIR编译，用于BM1684X的FP16 BModel，batch_size=1
│   ├── yolov7_v0.1_3output_fp16_4b.bmodel  # 使用TPU-MLIR编译，用于BM1684X的FP16 BModel，batch_size=4
│   ├── yolov7_v0.1_3output_fp32_1b.bmodel  # 使用TPU-MLIR编译，用于BM1684X的FP32 BModel，batch_size=1
│   ├── yolov7_v0.1_3output_fp32_4b.bmodel  # 使用TPU-MLIR编译，用于BM1684X的FP32 BModel，batch_size=4
│   ├── yolov7_v0.1_3output_int8_1b.bmodel  # 使用TPU-MLIR编译，用于BM1684X的INT8 BModel，batch_size=1
│   └── yolov7_v0.1_3output_int8_4b.bmodel  # 使用TPU-MLIR编译，用于BM1684X的INT8 BModel，batch_size=4
├── onnx
│   ├── yolov7_qtable
│   ├── yolov7_v0.1_3output_1b.onnx # 导出的onnx模型，batch_size=1
│   └── yolov7_v0.1_3output_4b.onnx # 导出的onnx模型，batch_size=4
└── torch
    └── yolov7_v0.1_3outputs.torchscript.pt # trace后的torchscript模型
```
下载的数据包括：
```
./datasets
├── test                                      # 测试图片
├── test_car_person_1080P.mp4                 # 测试视频
├── coco.names                                # coco类别名文件
├── coco128                                   # coco128数据集，用于模型量化
└── coco                                      
    ├── val2017_1000                               # coco val2017数据集
    └── instances_val2017_1000.json                # coco val2017数据集标签文件，用于计算精度评价指标  
```


​	模型信息：

| 模型名称 | [yolov7.pt](https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7.pt) |
| :------- | :----------------------------------------------------------- |
| 训练集   | MS COCO                                                      |
| 概述     | 80类通用目标检测                                             |
| 输入数据 | images, [batch_size, 3, 640, 640], FP32，NCHW，RGB planar    |
| 输出数据 | [batch_size, 3, 80, 80, 85], FP32 <br />[batch_size, 3, 40, 40, 85], FP32  <br />[batch_size, 3, 20, 20, 85], FP32  <br /> |
| 其他信息 | YOLO_ANCHORS: [12,16, 19,36, 40,28,  36,75, 76,55, 72,146,  142,110, 192,243, 459,401] |
| 前处理   | BGR->RGB、/255.0                                             |
| 后处理   | nms等                                                        |



## 4. 模型编译

导出的模型需要编译成BModel才能在SOPHON TPU上运行，如果使用下载好的BModel可跳过本节。如果您使用BM1684，建议使用TPU-NNTC编译BModel;如果您使用BM1684X，建议使用TPU-MLIR编译BModel。

### 4.1 **TPU-NNTC编译BModel**

​	模型编译前需要安装TPU-NNTC，具体方法可参考[《TPU-NNTC开发参考手册》](../../docs/Environment_Install_Guide.md#1-tpu-nntc环境搭建)。安装好后需在TPU-NNTC环境中进入例程目录。

- 生成FP32 BModel

使用TPU-NNTC将trace后的torchscript模型编译为FP32 BModel，具体方法可参考《TPU-NNTC开发参考手册》的“BMNETP 使用”(请从[算能官网](https://developer.sophgo.com/site/index/material/28/all.html)相应版本的SDK中获取)。

本例程在`scripts`目录下提供了编译FP32 BModel的脚本。请注意修改`gen_fp32bmodel_nntc.sh`中的torchscript模型路径、生成模型目录和输入大小shapes等参数，并在执行时指定BModel运行的目标平台（支持BM1684），如：

```bash
./scripts/gen_fp32bmodel_nntc.sh BM1684
```

执行上述命令会在`models/BM1684/`下生成`yolov7s_v0.1_3output_fp32_1b.bmodel`文件，即转换好的FP32 BModel。

- 生成INT8 BModel

使用TPU-NNTC量化torchscript模型的方法可参考《TPU-NNTC开发参考手册》的“模型量化”(请从[算能官网](https://developer.sophgo.com/site/index/material/28/all.html)相应版本的SDK中获取)，以及[模型量化注意事项](../../docs/Calibration_Guide.md#1-注意事项)。

本例程在`scripts`目录下提供了TPU-NNTC量化INT8 BModel的脚本，请注意修改`gen_int8bmodel_nntc.sh`中的torchscript模型路径、生成模型目录和输入大小shapes等参数，在执行时输入BModel的目标平台，如：

```shell
./scripts/gen_int8bmodel_nntc.sh BM1684
```

上述脚本会在`models/BM1684`下生成`yolov7_v0.1_3output_int8_1b.bmodel`等文件，即转换好的INT8 BModel。

### 4.2 TPU-MLIR编译BModel
模型编译前需要安装TPU-MLIR，具体可参考[TPU-MLIR环境搭建](../../docs/Environment_Install_Guide.md#2-tpu-mlir环境搭建)。安装好后需在TPU-MLIR环境中进入例程目录。使用TPU-MLIR将onnx模型编译为BModel，具体方法可参考《TPU-MLIR快速入门手册》的“3. 编译ONNX模型”(请从[算能官网](https://developer.sophgo.com/site/index/material/31/all.html)相应版本的SDK中获取)。

- 生成FP32 BModel

本例程在`scripts`目录下提供了TPU-MLIR编译FP32 BModel的脚本，请注意修改`gen_fp32bmodel_mlir.sh`中的onnx模型路径、生成模型目录和输入大小shapes等参数，并在执行时指定BModel运行的目标平台（支持BM1684X），如：

```bash
./scripts/gen_fp32bmodel_mlir.sh bm1684x
```

执行上述命令会在`models/BM1684X/`下生成`yolov7_v0.1_3output_fp32_1b.bmodel`文件，即转换好的FP32 BModel。

- 生成FP16 BModel

本例程在`scripts`目录下提供了TPU-MLIR编译FP16 BModel的脚本，请注意修改`gen_fp16bmodel_mlir.sh`中的onnx模型路径、生成模型目录和输入大小shapes等参数，并在执行时指定BModel运行的目标平台（支持BM1684X），如：

```bash
./scripts/gen_fp16bmodel_mlir.sh bm1684x
```

执行上述命令会在`models/BM1684X/`下生成`yolov7_v0.1_3output_fp16_1b.bmodel`文件，即转换好的FP16 BModel。

- 生成INT8 BModel

本例程在`scripts`目录下提供了量化INT8 BModel的脚本，请注意修改`gen_int8bmodel_mlir.sh`中的onnx模型路径、生成模型目录和输入大小shapes等参数，在执行时输入BModel的目标平台（支持BM1684X），如：

```shell
./scripts/gen_int8bmodel_mlir.sh bm1684x
```

上述脚本会在`models/BM1684X`下生成`yolov7_v0.1_3output_int8_1b.bmodel`等文件，即转换好的INT8 BModel。

## 5. 例程测试

- [C++例程](./cpp/README.md)
- [Python例程](./python/README.md)

## 6. 精度测试

### 6.1 测试方法

首先，参考[C++例程](cpp/README.md#32-测试图片)或[Python例程](python/README.md#22-测试图片)推理要测试的数据集，生成预测的json文件，注意修改数据集(datasets/coco/val2017_1000)和相关参数(conf_thresh=0.001、nms_thresh=0.65)。  
然后，使用`tools`目录下的`eval_coco.py`脚本，将测试生成的json文件与测试集标签json文件进行对比，计算出目标检测的评价指标，命令如下：

```bash
# 安装pycocotools，若已安装请跳过
pip3 install pycocotools
# 请根据实际情况修改程序路径和json文件路径
python3 tools/eval_coco.py --gt_path datasets/coco/instances_val2017_1000.json --result_json results/yolov7_v0.1_3output_fp32_1b.bmodel_val2017_1000_opencv_python_result.json
```
### 6.2 测试结果
在coco2017val_1000数据集上，精度测试结果如下：

|   测试平台    |      测试程序     |              测试模型               | AP@IoU=0.5:0.95 | AP@IoU=0.5 |
| ------------ | ---------------- | ----------------------------------- | ------------- | -------- |
| BM1684 PCIe  | yolov7_opencv.py | yolov7_v0.1_3output_fp32_1b.bmodel | 0.514 | 0.699 |
| BM1684 PCIe  | yolov7_opencv.py | yolov7_v0.1_3output_int8_1b.bmodel | 0.505 | 0.696 |
| BM1684 PCIe  | yolov7_bmcv.py   | yolov7_v0.1_3output_fp32_1b.bmodel | 0.504 | 0.687 |
| BM1684 PCIe  | yolov7_bmcv.py   | yolov7_v0.1_3output_int8_1b.bmodel | 0.497 | 0.684 |
| BM1684 PCIe  | yolov7_bmcv.pcie | yolov7_v0.1_3output_fp32_1b.bmodel | 0.494 | 0.696 |
| BM1684 PCIe  | yolov7_bmcv.pcie | yolov7_v0.1_3output_int8_1b.bmodel | 0.487 | 0.691 |
| BM1684X PCIe | yolov7_opencv.py | yolov7_v0.1_3output_fp32_1b.bmodel | 0.514 | 0.700 |
| BM1684X PCIe | yolov7_opencv.py | yolov7_v0.1_3output_fp16_1b.bmodel | 0.514 | 0.700 |
| BM1684X PCIe | yolov7_opencv.py | yolov7_v0.1_3output_int8_1b.bmodel | 0.511 | 0.698 |
| BM1684X PCIe | yolov7_bmcv.py   | yolov7_v0.1_3output_fp32_1b.bmodel | 0.504 | 0.687 |
| BM1684X PCIe | yolov7_bmcv.py   | yolov7_v0.1_3output_fp16_1b.bmodel | 0.504 | 0.688 |
| BM1684X PCIe | yolov7_bmcv.py   | yolov7_v0.1_3output_int8_1b.bmodel | 0.501 | 0.687 |
| BM1684X PCIe | yolov7_bmcv.pcie | yolov7_v0.1_3output_fp32_1b.bmodel | 0.493 | 0.696 |
| BM1684X PCIe | yolov7_bmcv.pcie | yolov7_v0.1_3output_fp16_1b.bmodel | 0.494 | 0.696 |
| BM1684X PCIe | yolov7_bmcv.pcie | yolov7_v0.1_3output_int8_1b.bmodel | 0.492 | 0.698 |
> **测试说明**：  
1. batch_size=4和batch_size=1的模型精度一致；
2. SoC和PCIe的模型精度一致；
3. AP@IoU=0.5:0.95为area=all对应的指标。

## 7. 性能测试
### 7.1 bmrt_test
使用bmrt_test测试模型的理论性能：
```bash
# 请根据实际情况修改要测试的bmodel路径和devid参数
bmrt_test --bmodel models/BM1684/yolov7_v0.1_3output_fp32_1b.bmodel
```
测试结果中的`calculate time`就是模型推理的时间，多batch size模型应当除以相应的batch size才是每张图片的理论推理时间。
测试各个模型的理论推理时间，结果如下：

|                  测试模型                   | calculate time(ms) |
| ------------------------------------------- | ----------------- |
| BM1684/yolov7_v0.1_3output_fp32_1b.bmodel  | 87.2 |
| BM1684/yolov7_v0.1_3output_int8_1b.bmodel  | 48.9 |
| BM1684/yolov7_v0.1_3output_int8_4b.bmodel  | 19.4 |
| BM1684X/yolov7_v0.1_3output_fp32_1b.bmodel | 97.8 |
| BM1684X/yolov7_v0.1_3output_fp16_1b.bmodel | 19.3 |
| BM1684X/yolov7_v0.1_3output_fp16_4b.bmodel | 18.4 |
| BM1684X/yolov7_v0.1_3output_int8_1b.bmodel | 9.1 |
| BM1684X/yolov7_v0.1_3output_int8_4b.bmodel | 8.4 |

> **测试说明**：  
1. 性能测试结果具有一定的波动性；
2. `calculate time`已折算为平均每张图片的推理时间；
3. SoC和PCIe的测试结果基本一致。

### 7.2 程序运行性能
参考[C++例程](cpp/README.md)或[Python例程](python/README.md)运行程序，并查看统计的解码时间、预处理时间、推理时间、后处理时间。C++例程打印的预处理时间、推理时间、后处理时间为整个batch处理的时间，需除以相应的batch size才是每张图片的处理时间。

在不同的测试平台上，使用不同的例程、模型测试`datasets/coco/val2017_1000`，conf_thresh=0.5，nms_thresh=0.5，性能测试结果如下：

|    测试平台  |     测试程序      |             测试模型                | decode_time | preprocess_time | inference_time | postprocess_time |
| ----------- | ---------------- | ----------------------------------- | -------- | --------- | --------- | --------- |
| BM1684 SoC  | yolov7_opencv.py | yolov7_v0.1_3output_fp32_1b.bmodel | 17.8       | 27.8     | 93.9      | 144.0 |
| BM1684 SoC  | yolov7_opencv.py | yolov7_v0.1_3output_int8_1b.bmodel | 16.3       | 23.8     | 70.3      | 143.2 |
| BM1684 SoC  | yolov7_opencv.py | yolov7_v0.1_3output_int8_4b.bmodel | 14.6       | 25.1     | 41.2      | 148.2 |
| BM1684 SoC  | yolov7_bmcv.py   | yolov7_v0.1_3output_fp32_1b.bmodel | 3.0        | 3.0      | 88.9      | 139.9 |
| BM1684 SoC  | yolov7_bmcv.py   | yolov7_v0.1_3output_int8_1b.bmodel | 3.0        | 2.6      | 54.9      | 147.2 |
| BM1684 SoC  | yolov7_bmcv.py   | yolov7_v0.1_3output_int8_4b.bmodel | 2.8        | 2.4      | 24.5      | 150.8 |
| BM1684 SoC  | yolov7_bmcv.soc  | yolov7_v0.1_3output_fp32_1b.bmodel | 14.2       | 1.9      | 82.9      | 20.5 |
| BM1684 SoC  | yolov7_bmcv.soc  | yolov7_v0.1_3output_int8_1b.bmodel | 14.7       | 1.7      | 48.7      | 21.9 |
| BM1684 SoC  | yolov7_bmcv.soc  | yolov7_v0.1_3output_int8_4b.bmodel | 14.5       | 1.6      | 19.3      | 21.5 |
| BM1684X SoC | yolov7_opencv.py | yolov7_v0.1_3output_fp32_1b.bmodel | 15.0       | 26.6     | 142.5     | 135.9 |
| BM1684X SoC | yolov7_opencv.py | yolov7_v0.1_3output_fp16_1b.bmodel | 3.2        | 24.7     | 39.5      | 133.4 |
| BM1684X SoC | yolov7_opencv.py | yolov7_v0.1_3output_int8_1b.bmodel | 15.0       | 22.3     | 22.3      | 132.1 |
| BM1684X SoC | yolov7_opencv.py | yolov7_v0.1_3output_int8_4b.bmodel | 18.5       | 22.4     | 18.7      | 107.7 |
| BM1684X SoC | yolov7_bmcv.py   | yolov7_v0.1_3output_fp32_1b.bmodel | 2.6        | 2.3      | 114.9     | 133.7 |
| BM1684X SoC | yolov7_bmcv.py   | yolov7_v0.1_3output_fp16_1b.bmodel | 2.6        | 2.2      | 35.9      | 132.4 |
| BM1684X SoC | yolov7_bmcv.py   | yolov7_v0.1_3output_int8_1b.bmodel | 2.6        | 2.2      | 19.0      | 133.3|
| BM1684X SoC | yolov7_bmcv.py   | yolov7_v0.1_3output_int8_4b.bmodel | 2.4        | 2.1      | 17.9      | 149.5 |
| BM1684X SoC | yolov7_bmcv.soc  | yolov7_v0.1_3output_fp32_1b.bmodel | 13.9       | 0.8      | 131.1     | 20.7 |
| BM1684X SoC | yolov7_bmcv.soc  | yolov7_v0.1_3output_fp16_1b.bmodel | 13.9       | 0.8      | 29.4      | 20.7 |
| BM1684X SoC | yolov7_bmcv.soc  | yolov7_v0.1_3output_int8_1b.bmodel | 13.9       | 0.8      | 12.6      | 20.8 |
| BM1684X SoC | yolov7_bmcv.soc  | yolov7_v0.1_3output_int8_4b.bmodel | 12.3       | 0.7      | 9.5       | 18.7 |

> **测试说明**：  
1. 时间单位均为毫秒(ms)，统计的时间均为平均每张图片处理的时间；
2. 性能测试结果具有一定的波动性，建议多次测试取平均值；
3. BM1684/1684X SoC的主控处理器均为8核 ARM A53 42320 DMIPS @2.3GHz，PCIe上的性能由于处理器的不同可能存在较大差异；
4. 图片分辨率对解码时间影响较大，推理结果对后处理时间影响较大，不同的测试图片可能存在较大差异。 

## 8. FAQ
请参考[FAQ](../../docs/FAQ.md)查看一些常见的问题与解答。