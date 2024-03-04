## Whisper-TPU

Whisper-TPU is an application that utilizes the OpenAI open-source [Whisper](https://github.com/openai/whisper) model. It is ported to Radxa BM1684X chip series products using the Sophon SDK to enable hardware-accelerated inference using the local TPU. This application is designed for rapidly converting speech to text (STT) and, in the future, integrating with ChatGLM2 for understanding and translating speech content. The application features a user-friendly interactive interface implemented using Gradio.

- Clone the repository and switch to the release branch:

    ```bash
    git clone https://github.com/zifeng-radxa/whisper-TPU_py
    git checkout -b release origin/release
    ```

- Download the Whisper bmodel:

    ```bash
    cd whisper-TPU_py
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/Whisper/zip_downloader.sh
    bash zip_downloader.sh
    unzip Whisper_bmodel.zip
    ```

- Move the downloaded Whisper bmodel files to the `whisper-TPU_py/bmodel` directory:

    ```bash
    mv Whisper_bmodel/bmodel/* ./bmodel
    ```

- Download ChatGLM-int8-1024 in the parent directory:

    ```bash
    cd ..
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-1024/zip_downloader.sh
    bash zip_downloader.sh
    unzip chatglm-int8-1024.zip
    ```

    The file tree structure should look like this:

    ```bash
    .
    ├── chatglm-int8-1024
    └── whisper-TPU_py
        ├── bmodel
        ├── bmwhisper
        │   ├── __pycache__
        │   ├── assets
        │   ├── normalizers
        │   └── third_party
        │       └── untpu
        │           └── lib
        ├── build
        │   ├── bdist.linux-aarch64
        │   └── lib
        │       └── bmwhisper
        │           ├── assets
        │           ├── normalizers
        │           └── third_party
        │               └── untpu
        │                   └── lib
        ├── dist
        ├── sophon_whisper.egg-info
        └── test
    ```

- Configure the virtual environment.

    **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

    ```bash
    python3 -m virtualenv .venv 
    source .venv/bin/activate
    pip3 install -r requirements.txt 
    python3 setup.py install
    ```

- Run in CLI mode:

    ```bash
    export LOG_LEVEL=-1
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

  - Start the web service:

  ```bash
  python3 main.py
    ```

  - Access the web interface in a browser at `bm1684x:7860`.