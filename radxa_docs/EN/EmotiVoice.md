## EmotiVoice-TPU

EmotiVoice-TPU is an application that utilizes the open-source [EmotiVoice](https://github.com/netease-youdao/EmotiVoice) model from Netease and the open-source [OpenVoice](https://github.com/myshell-ai/OpenVoice) model from MyShell. It is ported to Radxa BM1684X chip series products using the Sophon SDK for local TPU hardware-accelerated inference. This application is designed for generating emotionally expressive text-to-speech (TTS) and can use OpenVoice for voice conversion on the generated speech. The application features a user-friendly interactive interface implemented using Gradio.

- Clone the repository:

    ```bash
    git clone https://github.com/zifeng-radxa/EmotiVoice-TPU -b radxa_v0.1.2
    ```
    
- Download models:

    ```bash
    cd EmotiVoice-TPU/model_file
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/EmotiVoice/EmotiVoice_bmodels.tar.gz
    ```
    
- Move the `bmodel` files to the `EmotiVoice-TPU/model_file` directory:

    ```bash
    tar -xvf EmotiVoice_bmodels.tar.gz
    mv ./EmotiVoice_bmodels/* .
  ```
  The file tree structure should look like this:
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


- Create a virtual environment.

    **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

    ```bash
    cd EmotiVoice-TPU
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- Install dependencies:

    ```bash
    pip3 install --upgrade pip
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
    pip3 install -r requirements.txt
    ```

- Manually install silero-vad:

    ```bash
    cd ~/.cache/torch/hub/
    # If this folder does not exist, create it manually in the ~/.cache directory
    # mkdir -p torch/hub 
    wget https://github.com/snakers4/silero-vad/archive/refs/tags/v4.0.zip
    unzip v4.0.zip 
    mv silero-vad-4.0 snakers4_silero-vad_master
    ```

- Start the application:

    ```bash
    bash run_gr.py
    ```



### Frequently Asked Questions

- Encounter `OSError: cannot load library 'libsndfile.so': libsndfile.so: cannot open shared object file: No such file or directory` at startup.

  Solution: Install libsndfile1.
  ```bash
  sudo apt install libsndfile1
  ```

- Slow startup for the first time?

  Cause: The first startup requires downloading nltk_data. If you encounter network issues, please check your network connection.