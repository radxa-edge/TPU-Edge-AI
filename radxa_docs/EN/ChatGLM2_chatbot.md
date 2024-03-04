## ChatBot-TPU

ChatBot-TPU is an application that uses the Sophon SDK to port the open-source [ChatGLM2](https://github.com/THUDM/ChatGLM2-6B) model from Tsinghua University's KEG Lab to Radxa BM1684X series products. This allows it to leverage local TPU for hardware-accelerated inference. The application is designed as a chatbot using Gradio, and users can ask it practical questions.

- Clone the repository:

  ```bash
  git clone https://github.com/zifeng-radxa/chatbot
  ```

- Download the ChatGLM2 model. This example provides three ChatGLM2 models: int8-2048, int8-1024, and int4-512. For this example, let's use the int4-512 model (using int4 quantization with a maximum token length of 512).

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

  The file tree structure should look like this:

  ```bash
  .
  ├── chatbot
  └── chatglm-int4-512
  ```

- Modify the `config.ini` configuration file according to the selected model.

  ```bash
  cd chatbot
  vim config.ini
  ```

  ```ini
  [llm_model]
  libtpuchat_path = ../chatglm-int4-512/libtpuchat.so
  bmodel_path = ../chatglm-int4-512/chatglm2-6b_512_int4.bmodel
  token_path = ../chatglm-int4-512/tokenizer.model
  ```

  The `config.ini` file needs to be configured with the correct paths for the model files. If using a different model, modify the paths accordingly.

- Create a virtual environment.

  **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](虚拟环境使用.md).

  ```bash
  python3 -m virtualenv .venv
  source .venv/bin/activate
  ```

- Install dependencies:

  ```bash
  pip3 install -r requirements.txt
  ```

- Import the environment variable:

  ```bash
  export LD_LIBRARY_PATH=/opt/sophon/libsophon-current/lib:$LD_LIBRARY_PATH
  ```

- Start the web service:

  ```bash
  python3 web_demo.py
  ```

- Access the web service via a browser at `bm1684:7860`.