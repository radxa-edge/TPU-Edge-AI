## EmotiVoice-TPU 

EmotiVoice-TPU 是一款使用网易开源 [EmotiVoice](https://github.com/netease-youdao/EmotiVoice) 模型与 MyShell 开源 [OpenVoice](https://github.com/myshell-ai/OpenVoice) 模型，通过 Sophon SDK 移植到 radxa BM1684X 芯片系列产品上，实现本地 TPU 进行硬件加速推理。
此应用可用于文字生成带情感的语音（TTS）, 并可以利用 OpenVoice 对生成的语音进行音色转换，此应用使用 Gradio 实现用户友好交互界面

- 克隆仓库

    ```bash
    git clone https://github.com/zifeng-radxa/EmotiVoice-TPU -b radxa_v0.1.2
    ```
    
- 下载模型

    ```bash
    cd EmotiVoice-TPU/model_file
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/EmotiVoice/EmotiVoice_bmodels.tar.gz
    ```
    
- 将 bmodel 放到 EmotiVoice-TPU/model_file 中

    ```bash
    tar -xvf EmotiVoice_bmodels.tar.gz
    mv ./EmotiVoice_bmodels/* .
  ```
  得到文件树架构如下
  
  ```bash
  .
  ├── assets
  │   └── audio
  ├── config
  ├── data
  │   ├── inference
  │   └── youdao
  │       └── text
  ├── frontend
  │   ├── cn2an
  │   └── lexicon
  ├── model_file
  │   ├── EmotiVoice_bmodels
  │   ├── converter
  │   ├── simbert-base-chinese
  │   └── tts
  ├── models
  │   ├── hifigan
  │   └── prompt_tts_modified
  │       └── modules
  ├── temp
  └── tone_color_conversion
  ```

- 创建虚拟环境

  **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
  ```bash
  cd EmotiVoice-TPU
  python3 -m virtualenv .venv
  source .venv/bin/activate
  ```

- 安装依赖

  ```bash
  pip3 install --upgrade pip
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  pip3 install -r requirements.txt
  ```
- 手动安装 silero-vad
  ```bash
  cd ~/.cache/torch/hub/
  # 如果不存在此文件夹，请在 ~/.cache 目录中手动创建
  # mkdir -p torch/hub 
  wget https://github.com/snakers4/silero-vad/archive/refs/tags/v4.0.zip
  unzip v4.0.zip 
  mv silero-vad-4.0 snakers4_silero-vad_master
  ```
  
- 启动应用
  ```bash
  cd EmotiVoice-TPU
  bash run_gr.py
  ```



## 常见问题

- 启动时遇到 OSError: cannot load library 'libsndfile.so': libsndfile.so: cannot open shared object file: No such file or directory

  解决办法：安装 libsndfile1
  ```bash
  sudo apt install libsndfile1
  ```
- 首次启动慢？
  原因：第一次启动时需要下载 nltk_data， 如遇到网络问题，请检查网络

