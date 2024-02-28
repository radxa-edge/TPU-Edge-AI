## EmotiVoice-TPU 

EmotiVoice-TPU 是一款使用网易开源 [EmotiVoice](https://github.com/netease-youdao/EmotiVoice) 模型与 MyShell 开源 [OpenVoice](https://github.com/myshell-ai/OpenVoice) 模型，通过 Sophon SDK 移植到 radxa BM1684X 芯片系列产品上，实现本地 TPU 进行硬件加速推理。
此应用可用于文字生成带情感的语音（TTS）, 并可以利用 OpenVoice 对生成的语音进行音色转换，此应用使用 Gradio 实现用户友好交互界面

- 克隆仓库

    ```bash
    git clone https://github.com/zifeng-radxa/EmotiVoice-TPU
    cd EmotiVoice-TPU
    git checkout -b radxa_v0.1.1 origin/radxa_v0.1.1
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
    cd ..
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
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  pip3 install -r requirements.txt
  ```
- 启动应用
  - CLI 模式运行
  
     ```bash
     TEXT=data/inference/text
     python3 inference_am_vocoder_joint.py \
     --logdir prompt_tts_open_source_joint \
     --config_folder config/joint \
     --test_file $TEXT
     ```

  - Web 模式运行
    ```bash
    streamlit run demo_page.py
    ```

    浏览器访问 bm1684x:8501 端口