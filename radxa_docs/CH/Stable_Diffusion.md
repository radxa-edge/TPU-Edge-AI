## Stable Diffusion-TPU 

Stable Diffusion 是一个可以根据文本生成相应场景照片的生成式大模型，目前使用 [StableDifussion 1.5](https://huggingface.co/runwayml/stable-diffusion-v1-5) 
开源模型通过 sophon SDK 移植到 Radxa BM1684X 系列上进行本地 TPU 硬件加速推理，结合 LCM 与风格 LoRa 实现快速推理生成特色风格图片，并使用 Gradio 实现用户交互


- 克隆仓库并切换成 radxa_v0.2.0 分支

    ```bash
    git clone https://github.com/zifeng-radxa/SD-lcm-tpu.git -b radxa_v0.2.0
    ```
    
- 下载 Stable Diffusion v1.5 风格 Lora models 压缩包
    
    目前提供的预编译的 bmodel 有：
    
    - [awportrait](https://civitai.com/models/61170/awportrait)
    
    - [majicMIX_realistic](https://civitai.com/models/43331/majicmix-realistic)
    
    - [majicMIX_lux](https://civitai.com/models/56967/majicmix-lux)
    
  - [majicMIX_fantasy](https://civitai.com/models/41865/majicmix-fantasy)
  
  - [RealCartoon2.5D](https://civitai.com/models/218376/realcartoon-25d)
  
    用户也可通过 model_export.py 与 [TPU-MLIR](TPU-MLIR) 编译任何 stable_diffusion v1.5 checkpoints
  
  ```bash 
  cd SD-lcm-tpu
  mkdir -p models/basic & cd models/basic
  
  # awportrait
  wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/awportrait/tar_downloader.sh
  bash tar_downloader.sh
    tar -xvf awportrait.tar.gz
    
    # majicMIX_realistic
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/majicMIX_realistic/tar_downloader.sh
    bash tar_downloader.sh
    tar -xvf majicMIX_realistic.tar.gz
    
    # majicMIX_fantasy
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/majicMIX_fantasy/tar_downloader.sh
    bash tar_downloader.sh
    tar -xvf majicMIX_fantasy.tar.gz
    
    # majicMIX_lux
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/majicMIX_lux/tar_downloader.sh
    bash tar_downloader.sh
    tar -xvf majicMIX_lux.tar.gz
    
    # RealCartoon2.5D
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/RealCartoon2.5D/tar_downloader.sh
    bash tar_downloader.sh
    tar -xvf RealCartoon2.5D.tar.gz
    
    # vae only
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/vae/vae.tar.gz
    tar -xvf vae.tar.gz
    ```
    
    得到文件树架构如下
    
    ```bash
    .
    ├── __pycache__
    ├── model_export
    ├── models
    │   └── basic
    │       └── awportrait
    │      
    ├── sd
    │   └── __pycache__
    ├── tokenizer
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
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
    ```
    
- 启动 Web 服务
    ```bash
    bash run.sh
    ```

- 浏览器访问 bm1684x:8999
