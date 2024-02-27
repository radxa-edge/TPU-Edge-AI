## Stable Diffusion-TPU 

Stable Diffusion 是一个可以根据文本生成相应场景照片的生成式大模型，目前通过 sophon SDK 移植到 Radxa BM1684X 系列上进行硬件加速推理，实现离线部署


- 克隆仓库并切换成 radxa_v0.1.0 分支

    ```bash
    git clone https://github.com/zifeng-radxa/SD-lcm-tpu.git
    cd SD-lcm-tpu
    git checkout -b radxa_v0.1.0 origin/radxa_v0.1.0
    ```

  - 下载 Stable Diffusion models 压缩包

      ```bash 
      wget https://github.com/zifeng-radxa/SD-lcm-tpu/releases/download/lcm_1.0/zip_downloader.sh
      bash zip_downloader.sh
      unzip models.zip
      ```

      得到文件树架构如下
    
      ```bash
    ├── flagged
    ├── models
    │   ├── basic
    │   │   └── babes20lcm
    │   │  
    │   ├── controlnet
    │   └── other
    ├── sd
    │   └── __pycache__
    ├── tokenizer
    ├── tokenizerV21
    └── tokenizer_2
      ```

- 配置环境 

  **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
    ```bash
    cd SD-lcm-tpu
    python3 -m virtualenv .venv 
    source .venv/bin/activate
    ```

- 安装依赖

    ```bash
    pip3 install -r requirements.txt
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/sophon_arm-3.7.0-py3-none-any.whl
    ```

- 导入环境变量
    ```bash
    export LD_LIBRARY_PATH=/opt/sophon/libsophon-current/lib:$LD_LIBRARY_PATH
    ```
  （推荐）此应用使用 sophon-opencv 作为硬件加速，需要导入 sophon-opencv 环境变量, 亦可使用 pip3 源的 python-opencv-headless
  ```bash
  export PYTHONPATH=/opt/sophon/sophon-opencv-latest/opencv-python/:$PYTHONPATH
  ```


- 启动 Web 服务

    ```bash
    python3 gr.py
    # or 
    # bash run.sh
    ```

- 浏览器访问 bm1684x:8999
