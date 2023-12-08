# C++例程

## 目录

* [1. 环境准备](#1-环境准备)
    * [1.1 x86/arm PCIe平台](#11-x86arm-pcie平台)
    * [1.2 SoC平台](#12-soc平台)
* [2. 程序编译](#2-程序编译)
    * [2.1 x86/arm PCIe平台](#21-x86arm-pcie平台)
    * [2.2 SoC平台](#22-soc平台)
* [3. 推理测试](#3-推理测试)
    * [3.1 参数说明](#31-参数说明)
    * [3.2 测试mot数据集](#32-测试mot数据集)
    * [3.3 测试视频](#33-测试视频)

cpp目录下提供了C++例程以供参考使用，具体情况如下：
| 序号  | C++例程      | 说明                                 |
| ---- | ------------- | -----------------------------------  |
| 1    | deepsort_bmcv   | 使用FFmpeg解码、BMCV前处理、BMRT推理   |

## 1. 环境准备

### 1.1 x86/arm PCIe平台
如果您在x86/arm平台安装了PCIe加速卡（如SC系列加速卡），可以直接使用它作为开发环境和运行环境。您需要安装libsophon、sophon-opencv和sophon-ffmpeg，具体步骤可参考[x86-pcie平台的开发和运行环境搭建](../../../docs/Environment_Install_Guide.md#3-x86-pcie平台的开发和运行环境搭建)或[arm-pcie平台的开发和运行环境搭建](../../../docs/Environment_Install_Guide.md#5-arm-pcie平台的开发和运行环境搭建)。

本C++例程依赖Eigen，您需要在编译c++程序的机器上运行如下命令安装：
```bash
sudo apt install libeigen3-dev
```


### 1.2 SoC平台
如果您使用SoC平台（如SE、SM系列边缘设备），刷机后在`/opt/sophon/`下已经预装了相应的libsophon、sophon-opencv和sophon-ffmpeg运行库包，可直接使用它作为运行环境。通常还需要一台x86主机作为开发环境，用于交叉编译C++程序。

本C++例程依赖Eigen，您需要在编译c++程序的机器上运行如下命令安装：
```bash
sudo apt install libeigen3-dev
```

## 2. 程序编译
C++程序运行前需要编译可执行文件。
### 2.1 x86/arm PCIe平台
可以直接在PCIe平台上编译程序：

```bash
cd cpp/deepsort_bmcv
mkdir build && cd build
cmake .. 
make
cd ..
```
编译完成后，会在deepsort_bmcv目录下生成deepsort_bmcv.pcie。

### 2.2 SoC平台
通常在x86主机上交叉编译程序，您需要在x86主机上使用SOPHON SDK搭建交叉编译环境，将程序所依赖的头文件和库文件打包至soc-sdk目录中，具体请参考[交叉编译环境搭建](../../../docs/Environment_Install_Guide.md#41-交叉编译环境搭建)。本例程主要依赖libsophon、sophon-opencv和sophon-ffmpeg运行库包。

交叉编译环境搭建好后，使用交叉编译工具链编译生成可执行文件：

```bash
cd cpp/deepsort_bmcv
mkdir build && cd build
#请根据实际情况修改-DSDK的路径，需使用绝对路径。
cmake -DTARGET_ARCH=soc -DSDK=/path_to_sdk/soc-sdk ..  
make
```
编译完成后，会在deepsort_bmcv目录下生成deepsort_bmcv.soc。

## 3. 推理测试
对于PCIe平台，可以直接在PCIe平台上推理测试；对于SoC平台，需将交叉编译生成的可执行文件及所需的模型、测试数据拷贝到SoC平台中测试。测试的参数及运行方式是一致的，下面主要以PCIe模式进行介绍。

### 3.1 参数说明
可执行程序默认有一套参数，请注意根据实际情况进行传参，具体参数说明如下：
```bash
Usage: deepsort_bmcv.pcie [params] 

        --bmodel_detector (value:../../models/BM1684X/yolov5s_v6.1_3output_int8_1b.bmodel)
                detector bmodel file path
        --bmodel_extractor (value:../../models/BM1684X/extractor_fp16_1b.bmodel)
                extractor bmodel file path
        --classnames (value:./coco.names)
                class names file path
        --config (value:./deep_sort.yaml)
                config params
        --dev_id (value:0)
                TPU device id
        --help (value:true)
                print help information.
        --input (value:../../datasets/test_car_person_1080P.mp4)
                input path, video file path or image folder
```
**注意：** 

1. CPP传参与python不同，需要用等于号，例如`./deepsort_bmcv.pcie --bmodel_detector=xxx`。

2. 目标检测模型和卡尔曼滤波的自定义参数，相关参数可以在`deep_sort.yaml`中修改。

### 3.2 测试MOT数据集
MOT数据集测试实例如下，支持对整个文件夹里的所有图片进行测试。
```bash
./deepsort_bmcv.pcie --input=../../datasets/mot15_trainset/ADL-Rundle-6/img1 --bmodel_detector=../../models/BM1684X/yolov5s_v6.1_3output_int8_1b.bmodel --bmodel_extractor=../../models/BM1684X/extractor_fp32_1b.bmodel --dev_id=0
```
测试结束后，会将预测的帧保存在`results/images`下，预测的结果保存在`results/mot_eval/ADL-Rundle-6_extractor_fp32_1b.bmodel.txt`下，同时会打印推理耗时等信息。

```bash
############################
SUMMARY: DeepSORT test
############################
[                  decode time]  loops:  593 avg: 0.015000 ms  #平均每帧的解码耗时  
[                  yolov5 time]  loops:  592 avg: 19.957000 ms #目标检测模型平均每个batch的耗时  
[            yolov5 preprocess]  loops:  592 avg: 1.579000 ms  #目标检测模型平均每个batch的预处理耗时 
[             yolov5 inference]  loops:  592 avg: 3.443000 ms  #目标检测模型平均每个batch的推理耗时
[           yolov5 postprocess]  loops:  592 avg: 14.924000 ms #目标检测模型平均每个batch的后处理耗时
[post 1: get output and decode]  loops:  592 avg: 14.856000 ms
[         post 2: filter boxes]  loops:  592 avg: 0.028000 ms
[                  post 3: nms]  loops:  592 avg: 0.022000 ms
[                deepsort time]  loops:  592 avg: 7.358000 ms  #deepsort单帧流程的耗时  
[               extractor time]  loops:  592 avg: 5.565000 ms  #单帧调用特征提取器的总耗时
[         extractor preprocess]  loops: 1000 avg: 0.191000 ms  #特征提取模型平均每个crop batch的预处理耗时
[          extractor inference]  loops: 1000 avg: 0.513000 ms  #特征提取模型平均每个crop batch的推理耗时
[         deepsort postprocess]  loops:  592 avg: 1.782000 ms  #deepsort平均每帧的的后处理耗时
[                  encode time]  loops:  592 avg: 31.477000 ms #平均每帧画框和编码的时间
avg_crops_per_batch: 7.195946                                  #平均每帧的目标数
#VideoDecFFM exit 
FeatureExtractor dtor ...
YoloV5 dtor ...
```

### 3.3 测试视频
视频测试实例如下，支持对视频流进行测试。
```bash
./deepsort_bmcv.pcie --input=../../datasets/test_car_person_1080P.mp4 --bmodel_detector=../../models/BM1684X/yolov5s_v6.1_3output_int8_1b.bmodel --bmodel_extractor=../../models/BM1684X/extractor_fp32_1b.bmodel --dev_id=0
```
测试结束后，会将预测结果画在图片上并保存在`results/video`中，预测的结果保存在`results/mot_eval/test_car_person_1080P.mp4_extractor_fp32_1b.bmodel.txt`下，同时会打印推理耗时等信息，打印的信息条目可以参考3.2中的解释。