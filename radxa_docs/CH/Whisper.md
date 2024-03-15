## Whisper-TPU

Whisper-TPU 是一款使用 OpenAI 开源的 [Whisper](https://github.com/openai/whisper) 模型使用 Sophon SDK 将其移植到 Radxa BM1684X 芯片系列产品上，实现使用本地 TPU 进行硬件加速推理，此应用可用于对语音进行快速转文字（STT）， 并在未来接入 ChatGLM2 对语音内容进行理解和翻译。
此应用使用 Gradio 实现友好用户交互界面

- 克隆仓库，并转到 release 分支

    ```bash
    git clone https://github.com/zifeng-radxa/whisper-TPU_py -b release
    ```
    
- 下载 whisper bmodel 

    ```bash
    cd whisper-TPU_py
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/Whisper/zip_downloader.sh
    bash zip_downloader.sh
    unzip Whisper_bmodel.zip
    ```

- 将下载的 whisper bmodel 放入 whisper-TPU_py/bmodel 中

    ```bash
    mv Whisper_bmodel/bmodel/ .
    ```

- 在 whisper-TPU_py 同级目录下载 chatglm-int8-1024 

    ```bash
    cd ..
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/chatglm-int8-1024/zip_downloader.sh
    bash zip_downloader.sh
    unzip chatglm-int8-1024.zip
    ```

    得到文件树架构如下
    
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
    
- 配置虚拟环境

    **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
    ```bash
    cd whisper-TPU_py
    python3 -m virtualenv .venv 
    source .venv/bin/activate
    pip3 install --upgrade pip
    pip3 install -r requirements.txt 
    python3 setup.py install
    ```

-  CLI 模式运行

    ```bash
    export LOG_LEVEL=-1
    bmwhisper ./test/demo.wav --model base --bmodel_dir ./bmodel/ --chip_mode soc
    ```
    
    参数解释
    
    audio *必须*  输入的音频文件
    
    --model 选择模型 [base, small, medium]
    
    --bmodel_dir 指定 bmodel 目录
    
    --chip_mode 运行平台模式 [soc, pcie]



- Web 模式运行

    - 在 whisper-TPU_py 同级目录下克隆Whisper-WebUI仓库

    ```bash
    git clone https://github.com/zifeng-radxa/Whisper-WebUI
    ```

    得到文件树架构如下
    
    ```bash
    ├── Whisper-WebUI
    ├── chatglm-int8-1024
    └── whisper-TPU_py
    ```

    - 在 whisper-TPU_py 的 **虚拟环境** .venv 中下载 gradio

    ```bash
    cd Whisper-WebUI
    pip3 install -r requirements.txt
    ```

  - 启动 Web 服务
  ```bash
  python3 main.py
  ```

  - 浏览器访问端口 bm1684x:7860