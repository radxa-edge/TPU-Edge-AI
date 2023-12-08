[简体中文](./README.md) | [English](./README_EN.md)

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
    * [3.2 测试图片](#32-测试图片)
    * [3.3 测试视频](#33-测试视频)

cpp目录下提供了C++例程以供参考使用，具体情况如下：
| 序号  | C++例程      | 说明                                 |
| ---- | ------------- | -----------------------------------  |
| 1    | segformer_bmcv   | 使用FFmpeg解码、BMCV前处理、BMRT推理   |
| 2    | segformer_sail   | 使用SAIL解码、SAIL前处理、SAIL推理   |

## 1. 环境准备
### 1.1 x86/arm PCIe平台
如果您在x86/arm平台安装了PCIe加速卡（如SC系列加速卡），可以直接使用它作为开发环境和运行环境。您需要安装libsophon、sophon-opencv和sophon-ffmpeg，具体步骤可参考[x86-pcie平台的开发和运行环境搭建](../../../docs/Environment_Install_Guide.md#3-x86-pcie平台的开发和运行环境搭建)或[arm-pcie平台的开发和运行环境搭建](../../../docs/Environment_Install_Guide.md#5-arm-pcie平台的开发和运行环境搭建)。

### 1.2 SoC平台
如果您使用SoC平台（如SE、SM系列边缘设备），刷机后在`/opt/sophon/`下已经预装了相应的libsophon、sophon-opencv和sophon-ffmpeg运行库包，可直接使用它作为运行环境。通常还需要一台x86主机作为开发环境，用于交叉编译C++程序。


## 2. 程序编译
C++程序运行前需要编译可执行文件。
### 2.1 x86/arm PCIe平台
可以直接在PCIe平台上编译程序：
#### 2.1.1 bmcv
```bash
cd cpp/segformer_bmcv
mkdir build && cd build
cmake .. 
make
cd ..
```
编译完成后，会在segformer_bmcv目录下生成segformer_bmcv.pcie。

#### 2.1.2 sail

```bash
cd cpp/segformer_sail
mkdir build && cd build
cmake ..
make
cd ..
```
编译完成后，会在segformer_sail目录下生成segformer_sail.pcie。

### 2.2 SoC平台
通常在x86主机上交叉编译程序，您需要在x86主机上使用SOPHON SDK搭建交叉编译环境，将程序所依赖的头文件和库文件打包至soc-sdk目录中，具体请参考[交叉编译环境搭建](../../../docs/Environment_Install_Guide.md#41-交叉编译环境搭建)。本例程主要依赖libsophon、sophon-opencv和sophon-ffmpeg运行库包。

交叉编译环境搭建好后，使用交叉编译工具链编译生成可执行文件：
#### 2.2.1 bmcv
```bash
cd cpp/segformer_bmcv
mkdir build && cd build
#请根据实际情况修改-DSDK的路径，需使用绝对路径。
cmake -DTARGET_ARCH=soc -DSDK=/path_to_sdk/soc-sdk ..  
make
```
编译完成后，会在segformer_bmcv目录下生成segformer_bmcv.soc。

#### 2.2.2 sail

```bash
cd cpp/segformer_sail
mkdir build && cd build
#请根据实际情况修改-DSDK和-DSAIL_PATH的路径，需使用绝对路径。
cmake -DTARGET_ARCH=soc -DSDK=/path_to_sdk/soc-sdk -DSAIL_PATH=/path_to_sail/sophon-sail/build_soc/sophon-sail ..
make
```
编译完成后，会在segformer_sail目录下生成segformer_sail.soc。

## 3. 推理测试
对于PCIe平台，可以直接在PCIe平台上推理测试；对于SoC平台，需将交叉编译生成的可执行文件及所需的模型、测试数据拷贝到SoC平台中测试。测试的参数及运行方式是一致的，下面主要以PCIe模式进行介绍。

### 3.1 参数说明
可执行程序默认有一套参数，请注意根据实际情况进行传参，`segformer_bmcv.pcie与segformer_sail.pcie参数相同。`以segformer_bmcv.pcie为例，具体参数说明如下：
```bash
Usage: segformer_bmcv.pcie [params]

        --bmodel (value:../../models/BM1684/segformers_v6.1_3output_fp32_1b.bmodel)
                bmodel file path
        --palette (cityscapes)
                palette   classname
        --dev_id (value:0)
                TPU device id
        --help (value:true)
                print help information.
        --input (value:../../datasets/test)
                input path, images direction or video file path

```
> **注意：** CPP传参与python不同，需要用等于号，例如`./segformer_bmcv.pcie --bmodel=xxx`。

### 3.2 测试图片
图片测试实例如下，支持对整个图片文件夹进行测试。
```bash
./segformer_bmcv.pcie --input=../../datasets/cityscapes --bmodel=../../models/BM1684/segformer.b0.512x1024.city.160k_fp32_1b.bmodel --dev_id=0 --palette=cityscapes 
```
测试结束后，会将预测的图片保存在`results/images`下。


### 3.3 测试视频
视频测试实例如下，支持对视频流进行测试。
```bash
./segformer_bmcv.pcie --input=../../datasets/cityscapes_video.avi --bmodel=../../models/BM1684/segformer.b0.512x1024.city.160k_fp32_1b.bmodel --dev_id=0  --palette=cityscapes
```
测试结束后，会将预测结果画在图片上并保存在`results/images`中。


>**注意：**

若在SoC模式下执行报错:
```bash
./segformer_sail.soc: error while loading shared libraries: libsail.so: cannot open shared object file: No such file or directory
```
请设置如下环境变量:
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/sophon/sophon-sail/lib
```
