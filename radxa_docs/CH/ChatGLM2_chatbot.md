## ChatBot-TPU 

ChatBot-TPU 是使用 Sophon SDK 将清华大学 KEG 实验室开源 [ChatGLM2](https://github.com/THUDM/ChatGLM2-6B) 模型移植到 radxa BM1684X 芯片系列产品上， 使其能利用本地 TPU 进行硬件加速推理，并使用 Gradio 设计成聊天机器人, 用户可以向其询问一些实际问题

- 克隆仓库

  ```bash
  git clone https://github.com/zifeng-radxa/chatbot
  ```

- 下载 chatglm2 模型，本案例提供三种 chatglm2 模型，分别是 int8-2048，int8-1024，int4-512

    假设我们使用int4-512模型（采用int4的量化，最大token长度为512）
    
    ```bash
    # chatglm-int4-512
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int4-512/tar_downloader.sh
    bash tar_downloader.sh
    tar -xvf chatglm-int4-512.tar.gz
    
    # chatglem-int8-1024
    # wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-1024/tar_downloader.sh
    # bash tar_downloader.sh
    # tar -xvf chatglm-int8-1024.tar.gz
    
    # chatglm-int8-2048
    # wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-2048/tar_downloader.sh
    # bash tar_downloader.sh
    # tar -xvf chatglm-int8-2048.tar.gz
    ```

    得到文件树架构如下
    
    ```bash
    .
    ├── chatbot
    └── chatglm-int4-512
    ```

- 根据所选模型修改 config.ini配置文件
  
    ```
    cd chatbot
    vim config.ini
    ```
    
    ```bash
    [llm_model]
    libtpuchat_path = ../chatglm-int4-512/libtpuchat.so
    bmodel_path = ../chatglm-int4-512/chatglm2-6b_512_int4.bmodel
    token_path = ../chatglm-int4-512/tokenizer.model
    ```
    
    config.ini 需要配置正确的模型文件。若要改更为其他模型文件，请修改配置文件中的模型文件路径。


- 配置环境 

    **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
    ```bash
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- 安装依赖包
    ```bash
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
    ```
    
- 导入环境变量
    ```bash
    export LD_LIBRARY_PATH=/opt/sophon/libsophon-current/lib:$LD_LIBRARY_PATH
    ```
  
- 启动 Web 服务
    ```bash
    python3 web_demo.py
    ```

- 浏览器访问 bm1684:7860 端口