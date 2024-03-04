## EmotiVoice-TPU

EmotiVoice-TPU is an application that utilizes the open-source [EmotiVoice](https://github.com/netease-youdao/EmotiVoice) model from Netease and the open-source [OpenVoice](https://github.com/myshell-ai/OpenVoice) model from MyShell. It is ported to Radxa BM1684X chip series products using the Sophon SDK for local TPU hardware-accelerated inference. This application is designed for generating emotionally expressive text-to-speech (TTS) and can use OpenVoice for voice conversion on the generated speech. The application features a user-friendly interactive interface implemented using Gradio.

- Clone the repository:

    ```bash
    git clone https://github.com/zifeng-radxa/EmotiVoice-TPU
    cd EmotiVoice-TPU
    git checkout -b radxa_v0.1.1 origin/radxa_v0.1.2
    ```

- Download models:

    ```bash
    cd EmotiVoice-TPU/model_file
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/EmotiVoice/EmotiVoice_bmodels.tar.gz
    tar -xvf EmotiVoice_bmodels.tar.gz
    ```

- Move the `bmodel` files to the `EmotiVoice-TPU/model_file` directory:

    ```bash
    mv ./EmotiVoice_bmodels/* .
    ```
  The file tree structure should look like this:
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


- Create a virtual environment.

    **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

    ```bash
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- Install dependencies:

    ```bash
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
    pip3 install -r requirements.txt
    ```

- Manually install silero-vad:

    ```bash
    cd ~/.cache/torch/hub/
    wget https://github.com/snakers4/silero-vad/archive/refs/tags/v4.0.zip
    unzip v4.0.zip 
    mv silero-vad-4.0 snakers4_silero-vad_master
    ```

- Start the application:

    ```bash
    bash run_gr.py
    ```