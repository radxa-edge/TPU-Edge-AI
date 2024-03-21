## Whisper-TPU

Whisper-TPU is an application that utilizes the OpenAI open-source [Whisper](https://github.com/openai/whisper) model. It is ported to Radxa BM1684X chip series products using the Sophon SDK to enable hardware-accelerated inference using the local TPU. This application is designed for rapidly converting speech to text (STT) and, in the future, integrating with ChatGLM2 for understanding and translating speech content. The application features a user-friendly interactive interface implemented using Gradio.

- Clone the repository and switch to the release branch:

    ```bash
    git clone https://github.com/zifeng-radxa/whisper-TPU_py -b release
    ```
    
- Download the Whisper bmodel:

    ```bash
    cd whisper-TPU_py
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/Whisper/tar_downloader.sh
    bash tar_downloader.sh
    tar -xvf Whisper_bmodel.tar.gz
    ```

- Move the downloaded Whisper bmodel files to the `whisper-TPU_py/bmodel` directory:

    ```bash
    mv Whisper_bmodel/bmodel/ .
    ```

- Download ChatGLM2-int8-1024 in the same parent directory with whisper-TPU_py :

    Users can choose one of the three quantization models, ChatGLM2-int4-512, ChatGLM2-int8-1024, and ChatGLM2-int8-2048 depend you needed.

    ```bash
    cd ..
    # ChatGLM2-int8-1024
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-1024/tar_downloader.sh
    bash tar_downloader.sh
    tar chatglm-int8-1024.tar.gz
    
    # ChatGLM2-int4-512
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int4-512/tar_downloader.sh
    bash tar_downloader.sh
    tar chatglm-int4-512.tar.gz
    
    # ChatGLM2-int8-2048
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-2048/tar_downloader.sh
    bash tar_downloader.sh
    tar chatglm-int8-2048.tar.gz
    ```

    The file tree structure should look like this:

    ```bash
    ├── chatglm-int8-1024
    └── whisper-TPU_py
        ├── Whisper_bmodel
        ├── bmodel
        ├── bmwhisper
        │   ├── assets
        │   ├── normalizers
        │   └── third_party
        │       └── untpu
        │           └── lib
        └── test
    ```

- Configure the virtual environment.

    **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

    ```bash
    cd whisper-TPU_py
    python3 -m virtualenv .venv 
    source .venv/bin/activate
    pip3 install --upgrade pip
    pip3 install -r requirements.txt 
    python3 setup.py install
    ```

- Run in CLI mode:

    ```bash
    export LOG_LEVEL=-1
    export LD_LIBRARY_PATH=/opt/sophon/libsophon-current/lib:$LD_LIBRARY_PATH
    bmwhisper ./test/demo.wav --model base --bmodel_dir ./bmodel/ --chip_mode soc
    ```

    Explanation of parameters:

    - `audio`: *Required* - Input audio file.
    - `--model`: Choose a model [base, small, medium].
    - `--bmodel_dir`: Specify the bmodel directory.
    - `--chip_mode`: Run platform mode [soc, pcie].

- Run in Web mode:

    - Clone the Whisper-WebUI repository in the same parent directory as whisper-TPU_py:

        ```bash
        git clone https://github.com/zifeng-radxa/Whisper-WebUI
        ```

        The file tree structure should look like this:

        ```bash
        ├── Whisper-WebUI
        ├── chatglm-int8-1024
        └── whisper-TPU_py
        ```

    - In the virtual environment `.venv` within whisper-TPU_py, install Gradio:

        ```bash
        cd Whisper-WebUI
        pip3 install -r requirements.txt
        ```

  - Configure the desired chatglm2 model path in config.ini, with chatglm2-int8-1024 set as the default.

      ```ini
      [llm_model]
      libtpuchat_path = ../chatglm-int8-1024/libtpuchat.so
      bmodel_path = ../chatglm-int8-1024/w8a16_chatglm2-6b_1024.bmodel
      token_path = ../chatglm-int8-1024/tokenizer.model
      ```
  
  - Start the web service:
  
      ```bash
      python3 main.py
      ```
  
  - Access the web interface in a browser at `bm1684x:7860`.