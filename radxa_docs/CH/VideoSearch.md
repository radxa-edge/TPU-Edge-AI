## VideoSearch-TPU 

VideoSearch-TPU 文本搜索视频内容，是通过 Image CLIP 模型使用 Sophon SDK 移植到 radxa BM1684X 芯片系列产品上，实现本地 TPU 进行硬件加速推理，
此应用可以通过使用文本对视频内容进行快速搜索并返回搜索结果对应的画面帧和视频位置

- 克隆仓库

    ```bash
    https://github.com/zifeng-radxa/VideoSearch-tpu/tree/main
    ```

- 下载 CLIP bmodels, 将 bmodels 文件夹复制到 VideoSearch-tpu/inference/clip_model/ 中
     ```bash
    cd VideoSearch-tpu/inference/clip_model/
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/ImageSearch/ImageSearch_bmodel.zip
    unzip ImageSearch_bmodel.zip
    mv ImageSearch_bmodel/bmodels .
     ```

  得到文件结构如下

    ```bash
    .
    └── VideoSearch-tpu
        ├── __pycache__
        ├── dbs
        │   ├── CH
        │   ├── EN
        │   ├── scene_video_index
        │   ├── scenemetadata_index
        │   ├── video_scene_index
        │   └── videometadata_index
        ├── inference
        │   ├── __pycache__
        │   ├── clip
        │   │   └── __pycache__
        │   ├── clip_model
        │   │   ├── __pycache__
        │   │   ├── bmodels
        │   │   │   ├── CH
        │   │   │   └── EN
        │   │   └── saved_tokenizer
        │   │       ├── bert_chinese_tokenizer-fast
        │   │       └── bert_chinese_tokenizer-slow
        │   └── utils
        │       └── __pycache__
        ├── scene_snapshot
        ├── video_clip
        └── video_collection
    ```

- 创建虚拟环境

    **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
    ```bash
    cd VideoSearch-tpu
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- 安装依赖包

    ```bash
    pip3 install -r requirements.txt
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
    ```

- 启动 Web 服务

    ```bash
    streamlit run app.py EN 
    # streamlit run app.py CH 
    ```