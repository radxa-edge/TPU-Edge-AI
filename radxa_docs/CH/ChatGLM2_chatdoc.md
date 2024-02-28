## ChatDoc-TPU 

ChatDoc-TPU 是一款将清华大学 KEG 实验室开源 [ChatGLM2](https://github.com/THUDM/ChatGLM2-6B) 模型通过 Sophon SDK 移植到 Radxa BM1684X 芯片系列产品上实现本地 TPU 硬件加速推理，并使用 Streamlit 设计成易于用户交互的文件聊天机器人

- 安装须知
    
    在安装 ChatDoc-TPU 之前，请使用 memory_edit 工具修改当前设备的内存分配，TPU 内存需要12GB，使用方式参考[内存分布修改工具](内存分布修改工具.md)
    > 推荐 NPU 7168 MB	VPU 2048 MB	VPP 3072 MB 

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

    **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)

    ```bash
    cd chatdoc
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- 安装依赖

    ```bash
    pip3 install -r requirements.txt 
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
    ```

- 启动 Web 服务

  - TPU embedding 模式启动（占用更多 TPU 内存）
    ```bash
    bash run_emb_tpu.sh
    ```

  - CPU embedding 模式启动（占用更多系统内存）
    ```bash
    bash run.sh
    ```

- 浏览器访问 bm1684x:8501 端口
