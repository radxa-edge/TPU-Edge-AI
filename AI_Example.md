# AI Example 

## 虚拟环境使用

每个应用之间因为依赖包版本可能存在不一致或者版本冲突，所以每个应用应创建一个虚拟环境以安装各自的依赖，保持相互隔离

我们推荐使用虚拟环境来构建应用的运行环境。下面将介绍使用 virtualenv 来管理虚拟环境

- 建立教程 

下载 virtualenv (如已经安装，可跳过)

```bash
pip3 install virtualenv 
# If you are in China
# pip3 install virtualenv -i https://pypi.tuna.tsinghua.edu.cn/simple
```

- 在需要创建虚拟环境的应用目录下创建虚拟环境

```bash
python3 -m virtualenv .venv
```

- 启动虚拟环境

```bash
source .venv/bin/activate
```

- 退出虚拟环境

```bash
deactivate
```

- 删除虚拟环境

```bash
rm -rf .venv
```



## 内存分布修改工具

- 安装内存修改工具 memory_edit

```bash
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/memory_edit_V1.6.1.deb
sudo apt install ./memory_edit_V1.6.1.deb
```

- 使用方法

```bash
memory_edit.sh -p bm1684x_sm7m_v1.0.dtb # check device memory 
memory_edit.sh -c -npu 7360 -vpu 2360 -vpp 4096 bm1684x_sm7m_v1.0.dtb # change device memory
sudo cp /opt/sophon/memory_edit/emmcboot.itb /boot/emmcboot.itb && sync
sudo reboot
```

参数解析

-p [dts name] 查看当前设备 TPU 内存分布状态

-c [dts name] 修改 TPU 内存 

​	-npu 修改 npu 内存

​	-vpp 修改 vpp 内存

​	-vpu 修改 vpu 内存

*Example*

```bash
/opt/sophon/memory_edit/memory_edit.sh -p [dts name] # for print infomation
/opt/sophon/memory_edit/memory_edit.sh -c -npu 0x80000000 -vpu 0x80000000 -vpp 0x80000000 [dts name] # for config mem, The memory size unit is Byte
/opt/sophon/memory_edit/memory_edit.sh -c -npu 2048 -vpu 2048 -vpp 2048 [dts name] # for config mem, The memory size unit is MiB
/opt/sophon/memory_edit/memory_edit.sh -d # for de_emmcboot.itb
/opt/sophon/memory_edit/memory_edit.sh -e # for en_emmcboot.itb
/opt/sophon/memory_edit/memory_edit.sh --clean # clean this dir
```

*如何确定当前设备 dts name ?*

利用串口工具  [minicom](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom) 监听开机日志，下载方式请参考[官方文档](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom)

```bash
sudo minicom -D /dev/ttyUSB0 
```

在开机日志开头里找 dtb  *本案例即 bm1684x_sm7m_v1.0.dtb*

```bash
found dtb@139: bitmain-bm1684x-sm7m-v1.0                                        
Selecting config 'bitmain-bm1684x-sm7m-v1.0'  
```



## Stable Diffusion-TPU Setup

Stable Diffusion 是一个可以根据文本生产相应场景照片的大模型，目前移植到BM1684X上

- 克隆仓库并切换成 lcm_1.0 tag

```bash
git clone https://github.com/zifeng-radxa/SD-lcm-tpu.git
cd SD-lcm-tpu
git switch lcm_1.0
```

- 下载 Stable Diffusion 压缩包

```bash 
wget https://github.com/zifeng-radxa/SD-lcm-tpu/releases/download/lcm_1.0/zip_downloader.sh
bash zip_downloader.sh
unzip models.zip
```

得到文件树架构如下

```bash
.
└── Stable_Diffusion-TPU
    ├── dist
    │   └── assets
    │       └── svg
    ├── models
    │   ├── basic
    │   │   └── babes20
    │   └── controlnet
    ├── sdr
    │   └── __pycache__
    └── tokenizer
```

- 配置环境 ***必须创建虚拟环境，否则可能会影响其他应用的正常运行***

```bash
cd Stable_Diffusion-TPU
python3 -m virtualenv .venv 
source .venv/bin/activate
```

- 由于依赖版本的问题，需手动更改  Werkzeug 版本

```bash
pip3 install -r re
```

- 启动 Web 服务

```bash
bash run.sh
```

- 浏览器访问 bm1684x:7019





## ChatBot-TPU Setup

- 克隆仓库

```bash
git clone https://github.com/zifeng-radxa/chatbot
```

- 下载 chatglm模型，本案例提供三种 chatglm 模型 分别是int8-2048，int8-1024，int4-512

假设我们使用int4-512模型(采用int4的量化，最大token长度为512)

```bash
# chatglm-int4-512
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int4-512/zip_downloader.sh
bash zip_downloader.sh
unzip chatglm-int4-512.zip

# chatglem-int8-1024
# wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-1024/zip_downloader.sh
# bash zip_downloader.sh
# unzip chatglm-int8-1024.zip

# chatglm-int8-2048
# wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-2048/zip_downloader.sh
# bash zip_downloader.sh
# unzip chatglm-int8-2048.zip
```

得到文件树架构如下

```bash
.
├── chatbot
└── chatglm-int4-512
```

- 修改 config.ini配置文件

```
cd chatbot
vim config.ini
```

```bash
[llm_model]
libtpuchat_path = ../chatglm-int4-512/libtpuchat.so
bmodel_path = ../chatglm-int4-512/chatglm2-6b_512_int4.bmodel
token_path = ../chatglm-int4-512/tokenizer.model
```

config.ini需要配置正确的模型文件。若要改更为其他模型文件，请修改配置文件中的模型文件路径。

- 创建虚拟环境

```bash
python3 -m virtualenv .venv
source .venv/bin/activate
```

- 安装依赖包

```bash
pip3 install -r requirements.txt
# if you are in China
# pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

- 启动 Web 服务

```bash
python3 web_demo.py
```

- 浏览器访问 bm1684:7860 端口



## ChatDoc-TPU Setup

在安装 ChatDoc-TPU 之前，请使用 Memory_edit 工具修改当前设备的内存分配，使用方式参考内存分布修改工具栏目

- NPU 7168 MB
- VPU 2048 MB
- VPP 3072 MB 



- 克隆仓库

```bash
git clone https://github.com/zifeng-radxa/chatdoc
```

- 下载 ChatDoc embedding 文件 与 chatglm2-int8-2048 bmodel

```bash
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-2048/zip_downloader.sh
bash zip_downloader.sh
unzip chatglm-int8-2048.zip
```

```bash
cd chatdoc
# TPU version
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/embedding/embedding_tpu.zip
# CPU version 
# wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/embedding/embedding.zip

unzip embedding_tpu.zip
# CPU version
# unzip embedding.zip
```

- 得到文件树架构如下

```bash
.
├── chatdoc
│   ├── data
│   │   ├── db
│   │   └── uploaded
│   ├── embedding
│   │   └── 1_Pooling
│   ├── embedding_tpu
│   │   ├── __pycache__
│   │   └── text2vec
│   │       ├── __pycache__
│   │       ├── model_file
│   │       ├── tokenizer_cache
│   │       └── utils
│   │           └── __pycache__
│   └── static
└── chatglm-int8-2048

```

- 创建虚拟环境

```bash
cd chatdoc
python3 -m virtualenv .venv
source .venv/bin/activate
```

- 安装依赖

```bash
pip3 install -r requirements.txt 

# if you are in China
# pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
pip3 install ./tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
```

启动 Web 服务 (*确保已进入虚拟环境*)

- TPU 模式启动

  ```bash
  bash run_emb_tpu.sh
  ```

- CPU 模式启动

  ```bash
  bash run.sh
  ```

- 浏览器访问 bm1684x:8501 端口





## Whisper-TPU Setup

- 克隆仓库，并转到 release 分支

```bash
git clone https://github.com/zifeng-radxa/whisper-TPU_py
git checkout -b release origin/release
```

- 下载 whisper bmodel 

```bash
cd whisper-TPU_py
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/Whisper/zip_downloader.sh
bash zip_downloader.sh
unzip Whisper_bmodel.zip
```

- 将下载的 whisper bmodel 放入 whisper-TPU_py/bmodel 中

```bash
mv Whisper_bmodel/bmodel/* ./bmodel
```

- 在 whisper-TPU_py 同级目录下载 chatglm-int8-1024 

```bash
cd ..
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-1024/zip_downloader.sh
bash zip_downloader.sh
unzip chatglm-int8-1024.zip
```

得到文件树架构如下

```bash
.
├── chatglm-int8-1024
└── whisper-TPU_py
    ├── bmodel
    ├── bmwhisper
    │   ├── __pycache__
    │   ├── assets
    │   ├── normalizers
    │   └── third_party
    │       └── untpu
    │           └── lib
    ├── build
    │   ├── bdist.linux-aarch64
    │   └── lib
    │       └── bmwhisper
    │           ├── assets
    │           ├── normalizers
    │           └── third_party
    │               └── untpu
    │                   └── lib
    ├── dist
    ├── sophon_whisper.egg-info
    └── test

```

- 配置虚拟环境

```bash
python3 -m virtualenv .venv 
source .venv/bin/activate
pip3 install -r requirements.txt 
python3 setup.py install
```

### CLI 模式运行

```bash
export LOG_LEVEL=-1
bmwhisper ./test/demo.wav --model base --bmodel_dir ./bmodel/ --chip_mode soc
```

参数解释

audio *必须*  输入的音频文件

--model 选择模型 [base, small, medium]

--bmodel_dir 指定 bmodel 目录

--chip_mode 运行平台模式 [soc, pcie]



### Web 模式运行

- *在 whisper-TPU_py 同级目录下*

```bash
git clone https://github.com/zifeng-radxa/Whisper-WebUI
```

得到文件树架构如下

```bash
├── Whisper-WebUI
├── chatglm-int8-1024
└── whisper-TPU_py
```

- *在 whisper-TPU_py 的 **虚拟环境** .venv 中下载 gradio*

```bash
cd Whisper-WebUI
pip3 install -r requirements.txt
```

- 启动 Web 服务

```bash
python3 main.py
```

- 浏览器访问端口 bm1684x:7860





## EmotiVoice-TPU Setup

- 克隆仓库

```bash
git clone https://github.com/zifeng-radxa/EmotiVoice-TPU
cd EmotiVoice-TPU
git checkout -b radxa_v0.1.0 origin/radxa_v0.1.0
```

- 下载模型

```bash
cd EmotiVoice-TPU/model_file
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/EmotiVoice/EmotiVoice_bmodel.zip
unzip EmotiVoice_bmodel.zip
```

- 将 bmodel 放到 EmotiVoice-TPU/model_file 中

```bash
mv ./EmotiVoice_bmodel/* .
```

- 手动生成 ouputs 目录

```bash
mkdir -p outputs/prompt_tts_open_source_joint/test_audio/audio/
```

得到文件树架构如下

```bash
.
└── EmotiVoice-TPU
    ├── __pycache__
    ├── assets
    │   └── audio
    ├── cn2an
    │   └── __pycache__
    ├── config
    │   └── joint
    │       └── __pycache__
    ├── data
    │   ├── inference
    │   └── youdao
    │       └── text
    ├── lexicon
    ├── model_file
    │   └── simbert-base-chinese
    ├── models
    │   ├── __pycache__
    │   ├── hifigan
    │   │   └── __pycache__
    │   └── prompt_tts_modified
    │       ├── __pycache__
    │       └── modules
    │           └── __pycache__
    ├── outputs
    │   └── prompt_tts_open_source_joint
    │       └── test_audio
    │           └── audio
    └── text

```

- 创建虚拟环境

```bash
python3 -m virtualenv .venv
source .venv/bin/activate
```

- 安装依赖

```bash
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
pip3 install ./tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
pip3 install -r requirements.txt
```

**CLI 模式运行**

```bash
TEXT=data/inference/text
python3 inference_am_vocoder_joint.py \
--logdir prompt_tts_open_source_joint \
--config_folder config/joint \
--test_file $TEXT
```

**Web 模式运行**

- 启动Web服务

```bash
streamlit run demo_page.py
```

- 浏览器访问 bm1684x:8501 端口





## ImageSearch-TPU Setup

- 克隆仓库

```bash ]
git clone https://github.com/zifeng-radxa/ImageSearch-tpu
```

- 下载 CLIP bmodel

 ```bahs
cd clip_image_search/clip
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/ImageSearch/ImageSearch_bmodel.zip
unzip ImageSearch_bmodel.zip
 ```

将 bmodel 放到 ImageSearch_bmodel/bmodels/ 中

```bash
rm -rf bmodels/
mv ./ImageSearch_bmodel/bmodels/ .
```

得到文件树架构如下

```bash
.
└── ImageSearch-tpu
    ├── __pycache__
    ├── clip_image_search
    │   ├── __pycache__
    │   └── clip
    │       ├── ImageSearch_bmodel
    │       ├── __pycache__
    │       ├── bmodels
    │       │   ├── CH
    │       │   └── EN
    │       └── saved_tokenizer
    │           ├── bert_chinese_tokenizer-fast
    │           └── bert_chinese_tokenizer-slow
    ├── gallery_collection
    ├── images
    └── results
        ├── CH
        └── EN
```

- 创建虚拟环境

```bash
cd ImageSearch-tpu
python3 -m virtualenv .venv
source .venv/bin/activate
```

- 安装依赖包

```bash
pip install -r requirements.txt
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
pip3 install ./tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
```

- 启动 Web 服务

```bash
cd ..
streamlit run app.py CH # for ChineseCLIP VIT-B16
streamlit run app.py EN # for CLIP-VIT-B32 
```





## VideoSearch-TPU Setup

- 克隆仓库

```bash
https://github.com/zifeng-radxa/VideoSearch-tpu/tree/main
```

- 下载 CLIP bmodels, 将bmodels文件夹复制到VideoSearch-tpu/inference/clip_model/中

 ```bash
cd VideoSearch-tpu/inference/clip_model/
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/ImageSearch/ImageSearch_bmodel.zip
unzip ImageSearch_bmodel.zip

mv IImageSearch_bmodel/bmodels .
 ```

- 得到文件结构如下

```bash
.
└── VideoSearch-tpu
    ├── __pycache__
    ├── dbs
    │   ├── CH
    │   ├── EN
    │   ├── scene_video_index
    │   ├── scenemetadata_index
    │   ├── video_scene_index
    │   └── videometadata_index
    ├── inference
    │   ├── __pycache__
    │   ├── clip
    │   │   └── __pycache__
    │   ├── clip_model
    │   │   ├── __pycache__
    │   │   ├── bmodels
    │   │   │   ├── CH
    │   │   │   └── EN
    │   │   └── saved_tokenizer
    │   │       ├── bert_chinese_tokenizer-fast
    │   │       └── bert_chinese_tokenizer-slow
    │   └── utils
    │       └── __pycache__
    ├── scene_snapshot
    ├── video_clip
    └── video_collection
```

- 创建虚拟环境

```bash
cd VideoSearch-tpu
python3 -m virtualenv .venv
source .venv/bin/activate
```

- 安装依赖包

```bash
pip install -r requirements.txt
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
pip3 install ./tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
```

- 启动 Web 服务

```bash
streamlit run app.py EN 
# streamlit run app.py CH 
```

