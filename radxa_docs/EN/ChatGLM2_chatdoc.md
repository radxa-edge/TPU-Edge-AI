## ChatDoc-TPU

ChatDoc-TPU is an application that uses the Sophon SDK to port the open-source [ChatGLM2](https://github.com/THUDM/ChatGLM2-6B) model from Tsinghua University's KEG Lab to Radxa BM1684X series products. This allows it to leverage local TPU for hardware-accelerated inference. The application is designed as an interactive file chatbot using Streamlit.

- Prerequisites:

  Before installing ChatDoc-TPU, please use the `memory_edit` tool to modify the current device's memory allocation. TPU memory requires 12GB, and the usage can be referred to in the [Memory Edit Tool](内存分布修改工具.md).
  > Recommended NPU 7168 MB, VPU 2048 MB, VPP 3072 MB

- Clone the repository:

  ```bash
  git clone https://github.com/zifeng-radxa/chatdoc
  ```

- Download ChatDoc embedding files and the `chatglm2-int8-2048` bmodel:

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

  The file tree structure should look like this:

  ```bash
  .
  ├── chatdoc
  │   ├── data
  │   │   ├── db
  │   │   └── uploaded
  │   ├── embedding
  │   │   └── 1_Pooling
  │   ├── embedding_tpu
  │   │   ├── __pycache__
  │   │   └── text2vec
  │   │       ├── __pycache__
  │   │       ├── model_file
  │   │       ├── tokenizer_cache
  │   │       └── utils
  │   │           └── __pycache__
  │   └── static
  └── chatglm-int8-2048
  
  ```

- Create a virtual environment.

  **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](虚拟环境使用.md).

  ```bash
  cd chatdoc
  python3 -m virtualenv .venv
  source .venv/bin/activate
  ```

- Install dependencies:

  ```bash
  pip3 install -r requirements.txt 
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  ```

- Start the web service:

  - TPU embedding mode (uses more TPU memory):

    ```bash
    bash run_emb_tpu.sh
    ```

  - CPU embedding mode (uses more system memory):

    ```bash
    bash run.sh
    ```

- Access the web service via a browser at `bm1684x:8501`.