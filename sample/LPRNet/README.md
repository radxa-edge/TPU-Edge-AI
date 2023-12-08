# LPRNet
## 目录

  * [1. 简介](#1-简介)
  * [2. 特性](#2-特性)
  * [3. 准备模型与数据](#3-准备模型与数据)
  * [4. 模型编译](#4-模型编译)
  * [5. 例程测试](#5-例程测试)
  * [6. 精度测试](#6-精度测试)
    * [6.1 测试方法](#61-测试方法)
    * [6.2 测试结果](#62-测试结果)
  * [7. 性能测试](#7-性能测试)
    * [7.1 bmrt_test](#71-bmrt_test)
    * [7.2 程序运行性能](#72-程序运行性能)

## 1. 简介

本例程对[LNRNet_Pytorch](https://github.com/sirius-ai/LPRNet_Pytorch)的模型和算法进行移植，使之能在SOPHON BM1684和BM1684X上进行推理测试。

**论文:** [LPRNet: License Plate Recognition via Deep Neural Networks](https://arxiv.org/abs/1806.10447v1)

LPRNet(License Plate Recognition via Deep Neural Networks)，是一种轻量级卷积神经网络，可实现无需进行字符分割的端到端车牌识别。  
LPRNet的优点可以总结为如下三点：  
(1)LPRNet不需要字符预先分割，车牌识别的准确率高、算法实时性强、支持可变长字符车牌识别。对于字符差异比较大的各国车牌均能够端到端进行训练。  
(2)LPRNet是第一个没有使用RNN的实时轻量级OCR算法，能够在各种设备上运行，包括嵌入式设备。  
(3)LPRNet具有足够好的鲁棒性，在视角和摄像畸变、光照条件恶劣、视角变化等复杂的情况下，仍表现出较好的识别效果。 

![avatar](pics/1.png)

在此非常感谢Sergey Zherzdev、 Alexey Gruzdev、 sirius-ai等人的贡献。


## 2. 特性
* 支持BM1684X(x86 PCIe、SoC)和BM1684(x86 PCIe、SoC、arm PCIe)
* 支持FP32、FP16(BM1684X)、INT8模型编译和推理
* 支持基于OpenCV和BMCV预处理的C++推理
* 支持基于OpenCV和BMCV预处理的Python推理
* 支持单batch和多batch模型推理
* 支持图片测试


## 3. 准备模型与数据
建议使用TPU-MLIR编译BModel，Pytorch模型在编译前要导出成onnx模型。具体可参考[LPRNet模型导出](./docs/LPRNet_Export_Guide.md)。

同时，您需要准备用于测试的数据集，如果量化模型，还要准备用于量化的数据集。

​本例程在`scripts`目录下提供了相关模型和数据的下载脚本`download.sh`，您也可以自己准备模型和数据集，并参考[4. 模型编译](#4-模型编译)进行模型转换。

```bash
# 安装unzip，若已安装请跳过
sudo apt install unzip
# 安装7z，若已安装请跳过
sudo apt install p7zip
sudo apt install p7zip-full

chmod -R +x scripts/
./scripts/download.sh

```
执行后，模型保存至`models/`，数据集下载并解压至`datasets/`
```
下载的模型包括：
./models
├── BM1684
│   ├── lprnet_fp32_1b.bmodel               # 使用TPU-MLIR编译，用于BM1684的FP32 BModel，batch_size=1
│   ├── lprnet_int8_1b.bmodel               # 使用TPU-MLIR编译，用于BM1684的INT8 BModel，batch_size=1
│   └── lprnet_int8_4b.bmodel               # 使用TPU-MLIR编译，用于BM1684的INT8 BModel，batch_size=4
├── BM1684X
│   ├── lprnet_fp32_1b.bmodel               # 使用TPU-MLIR编译，用于BM1684X的FP32 BModel，batch_size=1
│   ├── lprnet_fp16_1b.bmodel               # 使用TPU-MLIR编译，用于BM1684X的FP16 BModel，batch_size=1
│   ├── lprnet_int8_1b.bmodel               # 使用TPU-MLIR编译，用于BM1684X的INT8 BModel，batch_size=1
│   └── lprnet_int8_4b.bmodel               # 使用TPU-MLIR编译，用于BM1684X的INT8 BModel，batch_size=4
│── torch
│   ├── Final_LPRNet_model.pth              # 原始模型
│   └── LPRNet_model_trace.pt               # trace后的JIT模型
└── onnx
    ├── lprnet_1b.onnx                      # 导出的onnx模型，batch_size=1
    └── lprnet_4b.onnx                      # 导出的onnx模型，batch_size=4   


下载的数据包括：
./datasets
├── test                                    # 测试图片
├── test_label.json                         # test测试集的标签文件
├── test_md5                                # 量化数据集(mlir)
└── test_md5_lmdb                           # 用于量化的lmdb数据集(nntc)

```
模型信息：

| 原始模型 | Final_LPRNet_model.pth  | 
| ------- | ----------------------   |
| 概述     | 基于ctc的车牌识别模型，支持蓝牌、新能源车牌等中国车牌，可识别字符共67个。| 
| 骨干网络 | LPRNet                   | 
| 训练集   | 未说明                    | 
| 运算量   | 148.75 MFlops            |
| 输入数据 | [batch_size, 3, 24, 94], FP32，NCHW |
| 输出数据 | [batch_size, 68, 18], FP32 |
| 前处理   | resize,减均值,除方差,HWC->CHW |
| 后处理   | ctc_decode                 |


## 4. 模型编译
导出的模型需要编译成BModel才能在SOPHON TPU上运行，如果使用下载好的BModel可跳过本节。建议使用TPU-MLIR编译BModel。

模型编译前需要安装TPU-MLIR，具体可参考[TPU-MLIR环境搭建](../../docs/Environment_Install_Guide.md#1-tpu-mlir环境搭建)。安装好后需在TPU-MLIR环境中进入例程目录。使用TPU-MLIR将onnx模型编译为BModel，具体方法可参考《TPU-MLIR快速入门手册》的“3. 编译ONNX模型”(请从[算能官网](https://developer.sophgo.com/site/index/material/31/all.html)相应版本的SDK中获取)。

- 生成FP32 BModel

​本例程在`scripts`目录下提供了TPU-MLIR编译FP32 BModel的脚本，请注意修改`gen_fp32bmodel_mlir.sh`中的onnx模型路径、生成模型目录和输入大小shapes等参数，并在执行时指定BModel运行的目标平台（**支持BM1684/BM1684X**），如：

```bash
./scripts/gen_fp32bmodel_mlir.sh bm1684
#or
./scripts/gen_fp32bmodel_mlir.sh bm1684x
```

​执行上述命令会在`models/BM1684`或`models/BM1684X/`下生成`lprnet_fp32_1b.bmodel`文件，即转换好的FP32 BModel。

- 生成FP16 BModel

​本例程在`scripts`目录下提供了TPU-MLIR编译FP16 BModel的脚本，请注意修改`gen_fp16bmodel_mlir.sh`中的onnx模型路径、生成模型目录和输入大小shapes等参数，并在执行时指定BModel运行的目标平台（**支持BM1684X**），如：

```bash
./scripts/gen_fp16bmodel_mlir.sh bm1684x
```

​执行上述命令会在`models/BM1684X/`下生成`lprnet_fp16_1b.bmodel`文件，即转换好的FP16 BModel。

- 生成INT8 BModel

​本例程在`scripts`目录下提供了量化INT8 BModel的脚本，请注意修改`gen_int8bmodel_mlir.sh`中的onnx模型路径、生成模型目录和输入大小shapes等参数，在执行时输入BModel的目标平台（**支持BM1684/BM1684X**），如：

```shell
./scripts/gen_int8bmodel_mlir.sh bm1684
#或
./scripts/gen_int8bmodel_mlir.sh bm1684x
```

​上述脚本会在`models/BM1684`或`models/BM1684X/`下生成`lprnet_int8_1b.bmodel`等文件，即转换好的INT8 BModel。


## 5. 例程测试
* [C++例程](cpp/README.md)
* [Python例程](python/README.md)

## 6. 精度测试
### 6.1 测试方法

首先，参考[C++例程](cpp/README.md#32-测试图片)或[Python例程](python/README.md#22-测试图片)推理要测试的数据集，生成预测的json文件。  
然后，使用`tools`目录下的`eval_ccpd.py`脚本，将测试生成的json文件与测试集标签json文件进行对比，计算出目标检测的评价指标，命令如下：
```bash

# 请根据实际情况修改程序路径和json文件路径
python3 tools/eval_ccpd.py --gt_path datasets/test_label.json --result_json cpp/lprnet_bmcv/results/lprnet_fp32_1b.bmodel_test_bmcv_cpp_result.json
```

### 6.2 测试结果
在test数据集上，精度测试结果如下：
|   测试平台    |      测试程序      |        测试模型        |    acc    |
| ------------ | ---------------- | --------------------- | ------------- 
| BM1684 PCIe  | lprnet_opencv.py | lprnet_fp32_1b.bmodel |   0.894       |
| BM1684 PCIe  | lprnet_opencv.py | lprnet_int8_1b.bmodel | 0.858         |
| BM1684 PCIe  | lprnet_opencv.py | lprnet_int8_4b.bmodel | 0.881         |
| BM1684 PCIe  | lprnet_bmcv.py   | lprnet_fp32_1b.bmodel | 0.88         |
| BM1684 PCIe  | lprnet_bmcv.py   | lprnet_int8_1b.bmodel | 0.857         |
| BM1684 PCIe  | lprnet_bmcv.py   | lprnet_int8_4b.bmodel | 0.865         |
| BM1684 PCIe  | lprnet_opencv.pcie | lprnet_fp32_1b.bmodel | 0.88         |
| BM1684 PCIe  | lprnet_opencv.pcie | lprnet_int8_1b.bmodel | 0.857         |
| BM1684 PCIe  | lprnet_opencv.pcie | lprnet_int8_4b.bmodel | 0.869         |
| BM1684 PCIe  | lprnet_bmcv.pcie | lprnet_fp32_1b.bmodel | 0.88         |
| BM1684 PCIe  | lprnet_bmcv.pcie | lprnet_int8_1b.bmodel | 0.857         |
| BM1684 PCIe  | lprnet_bmcv.pcie | lprnet_int8_4b.bmodel | 0.869         |
| BM1684X PCIe | lprnet_opencv.py | lprnet_fp32_1b.bmodel | 0.894         |
| BM1684X PCIe | lprnet_opencv.py | lprnet_fp16_1b.bmodel | 0.894         |
| BM1684X PCIe | lprnet_opencv.py | lprnet_int8_1b.bmodel | 0.867         | 
| BM1684X PCIe | lprnet_opencv.py | lprnet_int8_4b.bmodel | 0.88         | 
| BM1684X PCIe | lprnet_bmcv.py   | lprnet_fp32_1b.bmodel | 0.882         | 
| BM1684X PCIe | lprnet_bmcv.py   | lprnet_fp16_1b.bmodel | 0.882         | 
| BM1684X PCIe | lprnet_bmcv.py   | lprnet_int8_1b.bmodel | 0.861        | 
| BM1684X PCIe | lprnet_bmcv.py   | lprnet_int8_4b.bmodel | 0.88        | 
| BM1684X PCIe | lprnet_opencv.pcie | lprnet_fp32_1b.bmodel | 0.882         | 
| BM1684X PCIe | lprnet_opencv.pcie | lprnet_fp16_1b.bmodel | 0.882         | 
| BM1684X PCIe | lprnet_opencv.pcie | lprnet_int8_1b.bmodel | 0.861         | 
| BM1684X PCIe | lprnet_opencv.pcie | lprnet_int8_4b.bmodel | 0.872         | 
| BM1684X PCIe | lprnet_bmcv.pcie | lprnet_fp32_1b.bmodel | 0.882        | 
| BM1684X PCIe | lprnet_bmcv.pcie | lprnet_fp16_1b.bmodel | 0.882         | 
| BM1684X PCIe | lprnet_bmcv.pcie | lprnet_int8_1b.bmodel | 0.861         | 
| BM1684X PCIe | lprnet_bmcv.pcie | lprnet_int8_4b.bmodel | 0.872         | 

> **测试说明**：  

1. SoC和PCIe的模型精度一致。 
2. LPRNet网络中包含mean算子，会把所有batch数据加和求平均，当多batch推理时，同一张图片在不同的batch组合中可能会有不同的推理结果; 

## 7. 性能测试
### 7.1 bmrt_test
使用bmrt_test测试模型的理论性能：
```bash
# 请根据实际情况修改要测试的bmodel路径和devid参数
bmrt_test --bmodel models/BM1684/lprnet_fp32_1b.bmodel
```
测试结果中的`calculate time`就是模型推理的时间，多batch size模型应当除以相应的batch size才是每张图片的理论推理时间。
测试各个模型的理论推理时间，结果如下：

|            测试模型            | calculate time(ms) |
| ----------------------------- | ----------------- |
| BM1684/lprnet_fp32_1b.bmodel  | 1.144              |
| BM1684/lprnet_int8_1b.bmodel  | 1.070              |
| BM1684/lprnet_int8_4b.bmodel  | 0.304               |
| BM1684X/lprnet_fp32_1b.bmodel | 0.779             |
| BM1684X/lprnet_fp16_1b.bmodel | 0.531               |
| BM1684X/lprnet_int8_1b.bmodel | 0.484               |
| BM1684X/lprnet_int8_4b.bmodel | 0.229              |

> **测试说明**：  
1. 性能测试结果具有一定的波动性；
2. `calculate time`已折算为平均每张图片的推理时间；
3. SoC和PCIe的测试结果基本一致。

### 7.2 程序运行性能
参考[C++例程](cpp/README.md)或[Python例程](python/README.md)运行程序，并查看统计的解码时间、预处理时间、推理时间、后处理时间。C++例程打印的预处理时间、推理时间、后处理时间为整个batch处理的时间，需除以相应的batch size才是每张图片的处理时间。

在不同的测试平台上，使用不同的例程、模型测试`datasets/test`，性能测试结果如下：
|    测试平台  |     测试程序      |      测试模型          |decode_time|preprocess_time|inference_time|postprocess_time| 
| ----------- | ---------------- | --------------------- | -------- | --------- | --------- | --------- |
| BM1684 SoC  | lprnet_opencv.py | lprnet_fp32_1b.bmodel | 0.5     | 0.14      | 2.33      | 0.13       |
| BM1684 SoC  | lprnet_opencv.py | lprnet_int8_1b.bmodel | 0.48     | 0.15      | 1.35      | 0.14       |
| BM1684 SoC  | lprnet_opencv.py | lprnet_int8_4b.bmodel | 0.32     | 0.08      | 0.45      | 0.06       |
| BM1684 SoC  | lprnet_bmcv.py   | lprnet_fp32_1b.bmodel | 0.6      | 0.33       | 2.01      | 0.15       |
| BM1684 SoC  | lprnet_bmcv.py   | lprnet_int8_1b.bmodel | 0.66      | 0.35      | 1.07      | 0.15       |
| BM1684 SoC  | lprnet_bmcv.py   | lprnet_int8_4b.bmodel | 0.45      | 0.25       | 0.33     | 0.06       |
| BM1684 SoC  | lprnet_opencv.soc | lprnet_fp32_1b.bmodel | 0.537      | 0.211       | 1.642      | 0.072      |
| BM1684 SoC  | lprnet_opencv.soc | lprnet_int8_1b.bmodel | 0.696      | 0.277       | 0.656      | 0.077      |
| BM1684 SoC  | lprnet_opencv.soc | lprnet_int8_4b.bmodel | 0.46      | 0.695       | 0.232       | 0.048      |
| BM1684 SoC  | lprnet_bmcv.soc | lprnet_fp32_1b.bmodel | 1.629      | 0.283       | 1.664     | 0.08      |
| BM1684 SoC  | lprnet_bmcv.soc | lprnet_int8_1b.bmodel | 1.627      | 0.285       | 0.661      | 0.075      |
| BM1684 SoC  | lprnet_bmcv.soc | lprnet_int8_4b.bmodel | 1.184      | 0.647      | 0.233       | 0.047      |
| BM1684X SoC | lprnet_opencv.py | lprnet_fp32_1b.bmodel | 0.89     | 0.17      | 1.57      | 0.14       |
| BM1684X SoC | lprnet_opencv.py | lprnet_int8_1b.bmodel | 0.96     | 0.2      | 1.43      | 0.16       |
| BM1684X SoC | lprnet_opencv.py | lprnet_int8_4b.bmodel | 0.85     | 0.1      | 0.55      | 0.07       |
| BM1684X SoC | lprnet_bmcv.py   | lprnet_fp32_1b.bmodel | 0.84      | 0.27      | 1.41      | 0.18       |
| BM1684X SoC | lprnet_bmcv.py   | lprnet_int8_1b.bmodel | 0.86      | 0.27       | 1.01       | 0.19       |
| BM1684X SoC | lprnet_bmcv.py   | lprnet_int8_4b.bmodel | 0.51      | 0.17      | 0.36       | 0.07       |
| BM1684X SoC | lprnet_opencv.soc | lprnet_fp32_1b.bmodel | 0.646      | 0.28       | 0.782      | 0.082      |
| BM1684X SoC | lprnet_opencv.soc | lprnet_int8_1b.bmodel | 0.655      | 0.288       | 0.46       | 0.086      |
| BM1684X SoC | lprnet_opencv.soc | lprnet_int8_4b.bmodel | 0.459      | 0.838       | 0.933       | 0.212      |
| BM1684X SoC | lprnet_bmcv.soc | lprnet_fp32_1b.bmodel | 1.84      | 0.203       | 0.831      | 0.093      |
| BM1684X SoC | lprnet_bmcv.soc | lprnet_int8_1b.bmodel | 1.658      | 0.181       | 0.529       | 0.92      |
| BM1684X SoC | lprnet_bmcv.soc | lprnet_int8_4b.bmodel | 1.523      | 0.511       | 0.979      | 0.244      |


> **测试说明**：  
1. 时间单位均为毫秒(ms)，统计的时间均为平均每张图片处理的时间；
2. 性能测试结果具有一定的波动性，建议多次测试取平均值；
3. BM1684/1684X SoC的主控处理器均为8核 ARM A53 42320 DMIPS @2.3GHz，PCIe上的性能由于处理器的不同可能存在较大差异；

