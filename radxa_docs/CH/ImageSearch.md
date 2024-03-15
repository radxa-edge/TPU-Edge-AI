## ImageSearch-TPU 

ImageSearch-TPU 文本搜索图片，是使用 Image CLIP 模型通过 Sophon SDK 移植到 radxa BM1684X 芯片系列产品上，实现本地 TPU 硬件加速推理，
可对大量已有图片基础下通过文字对图片库进行快搜索，并使用 Streamlit 实现用户友好交互界面

- 克隆仓库

    ```bash 
    git clone https://github.com/zifeng-radxa/ImageSearch-tpu
    ```

- 下载 CLIP bmodel

     ```bahs
    cd ImageSearch-tpu/clip_image_search/clip
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/ImageSearch/ImageSearch_bmodel.zip
    unzip ImageSearch_bmodel.zip
    ```

    将 bmodel 放到 ImageSearch_bmodel/bmodels/ 中
    
    ```bash
    rm -rf bmodels/
    mv ./ImageSearch_bmodel/bmodels/ .
    ```

    得到文件树架构如下
    
    ```bash
    .
    └── ImageSearch-tpu
        ├── __pycache__
        ├── clip_image_search
        │   ├── __pycache__
        │   └── clip
        │       ├── ImageSearch_bmodel
        │       ├── __pycache__
        │       ├── bmodels
        │       │   ├── CH
        │       │   └── EN
        │       └── saved_tokenizer
        │           ├── bert_chinese_tokenizer-fast
        │           └── bert_chinese_tokenizer-slow
        ├── gallery_collection
        ├── images
        └── results
            ├── CH
            └── EN
    ```

- 创建虚拟环境

    **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
    ```bash
    cd ImageSearch-tpu
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- 安装依赖包
    ```bash
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
    ```
    
- 启动 Web 服务
    ```bash
    streamlit run app.py EN # for CLIP-VIT-B32 
    streamlit run app.py CH # for ChineseCLIP VIT-B16
    ```
