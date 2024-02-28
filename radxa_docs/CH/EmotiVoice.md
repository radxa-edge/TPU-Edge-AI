## EmotiVoice-TPU 

EmotiVoice-TPU 是一款使用网易开源 [EmotiVoice](https://github.com/netease-youdao/EmotiVoice) 模型与 MyShell 开源 [OpenVoice](https://github.com/myshell-ai/OpenVoice) 模型，通过 Sophon SDK 移植到 radxa BM1684X 芯片系列产品上，实现本地 TPU 进行硬件加速推理。
此应用可用于文字生成带情感的语音（TTS）, 并可以利用 OpenVoice 对生成的语音进行音色转换，此应用使用 Gradio 实现用户友好交互界面

- 克隆仓库

    ```bash
    git clone https://github.com/zifeng-radxa/EmotiVoice-TPU
    cd EmotiVoice-TPU
    git checkout -b radxa_v0.1.1 origin/radxa_v0.1.2
    ```

- 下载模型

    ```bash
    cd EmotiVoice-TPU/model_file
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/EmotiVoice/EmotiVoice_bmodels.tar.gz
    tar -xvf EmotiVoice_bmodels.tar.gz
    ```

- 将 bmodel 放到 EmotiVoice-TPU/model_file 中

    ```bash
    mv ./EmotiVoice_bmodels/* .
    ```
  得到文件树架构如下
  
  ```bash
   .
  ├── assets
  │   └── audio
  ├── config
  │   └── __pycache__
  ├── data
  │   ├── inference
  │   └── youdao
  │       └── text
  ├── frontend
  │   ├── __pycache__
  │   ├── cn2an
  │   │   └── __pycache__
  │   └── lexicon
  ├── model_file
  │   ├── checkpoints
  │   │   ├── base_speakers
  │   │   │   ├── EN
  │   │   │   └── ZH
  │   │   └── converter
  │   ├── converter
  │   ├── simbert-base-chinese
  │   └── tts
  ├── models
  │   ├── __pycache__
  │   ├── hifigan
  │   │   └── __pycache__
  │   └── prompt_tts_modified
  │       ├── __pycache__
  │       └── modules
  │           └── __pycache__
  ├── processed
  │   ├── 11-0-100_JOJuisUHwdBwzxx1
  │   │   └── wavs
  │   ├── aa-0-100_cZ4h9uSFcfVGpLbH
  │   │   └── wavs
  │   ├── aa_cZ4h9uSFcfVGpLbH
  │   │   └── wavs
  │   ├── src-8051_OoJ4upo8cObQYzad
  │   │   └── wavs
  │   ├── src-8051_PD41WhiCfhMutBT_^
  │   │   └── wavs
  │   └── src-8051_uKXaq015HqJSmJ67
  │       └── wavs
  ├── temp
  └── tone_color_conversion
      └── __pycache__


  
  ```

- 创建虚拟环境

  **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
  ```bash
  python3 -m virtualenv .venv
  source .venv/bin/activate
  ```

- 安装依赖

  ```bash
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  pip3 install -r requirements.txt
  ```
- 启动应用
  ```bash
  bash run_gr.py
  ```