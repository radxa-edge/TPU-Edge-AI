## Stable Diffusion-TPU

Stable Diffusion is a generative large model that can generate scene photos based on text descriptions. It uses the open-source model [Stable Diffusion 1.5](https://huggingface.co/runwayml/stable-diffusion-v1-5). This model has been ported to the Radxa BM1684X series for local TPU hardware-accelerated inference using the Sophon SDK. The combination of LCM (LoRa Communication Module) and LoRa enables fast inference to generate stylized images. Gradio is utilized to provide user interaction.

- Clone the repository and switch to the radxa_v0.2.0 branch:

    ```bash
    git clone https://github.com/zifeng-radxa/SD-lcm-tpu.git -b radxa_v0.2.0
    ```
    
- Download the Stable Diffusion v1.5 Lora style models compressed package.

  Currently, the pre-compiled bmodels available are:

  - [awportrait](https://civitai.com/models/61170/awportrait)

  - [majicMIX_realistic](https://civitai.com/models/43331/majicmix-realistic)

  - [majicMIX_lux](https://civitai.com/models/56967/majicmix-lux)

  - [majicMIX_fantasy](https://civitai.com/models/41865/majicmix-fantasy)

  - [RealCartoon2.5D](https://civitai.com/models/218376/realcartoon-25d)

  Users can also compile any stable_diffusion v1.5 checkpoints using model_export.py with [TPU-MLIR](TPU-MLIR). For details, please refer to [model_export/README.md](https://github.com/zifeng-radxa/SD-lcm-tpu/blob/radxa_v0.2.0/model_export/README.md)

  Only awportrait.tar.gz contains VAE. If needed, please download VAE separately and refer to model_path.py for modification of each model's path.
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

  The resulting file tree structure is as follows:

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

- Set up the environment.

  **Create a virtual environment; otherwise, it may affect the normal operation of other applications.** Refer to [this guide](虚拟环境使用.md) for virtual environment usage.

    ```bash
    cd SD-lcm-tpu
    python3 -m virtualenv .venv 
    source .venv/bin/activate
    ```

- Install dependencies:

    ```bash
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
    ```

- Start the web service:

    ```bash
    bash run.sh
    ```

- Access the web service through a browser at `bm1684x:8999`.