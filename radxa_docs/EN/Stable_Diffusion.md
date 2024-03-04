## Stable Diffusion-TPU

Stable Diffusion is a generative large model that can generate scene photos based on text descriptions. It uses the open-source model [Stable Diffusion 1.5](https://huggingface.co/runwayml/stable-diffusion-v1-5). This model has been ported to the Radxa BM1684X series for local TPU hardware-accelerated inference using the Sophon SDK. The combination of LCM (LoRa Communication Module) and LoRa enables fast inference to generate stylized images. Gradio is utilized to provide user interaction.

- Clone the repository and switch to the radxa_v0.1.0 branch:

    ```bash
    git clone https://github.com/zifeng-radxa/SD-lcm-tpu.git
    cd SD-lcm-tpu
    git checkout -b radxa_v0.1.0 origin/radxa_v0.1.0
    ```

- Download the Stable Diffusion models archive:

    ```bash 
    wget https://github.com/zifeng-radxa/SD-lcm-tpu/releases/download/lcm_1.0/zip_downloader.sh
    bash zip_downloader.sh
    unzip models.zip
    ```

    The resulting file structure should look like this:

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

- Set up the environment.

  **Create a virtual environment; otherwise, it may affect the normal operation of other applications.** Refer to [this guide](虚拟环境使用.md) for virtual environment usage.

    ```bash
    cd SD-lcm-tpu
    python3 -m virtualenv .venv 
    source .venv/bin/activate
    ```

- Install dependencies:

    ```bash
    pip3 install -r requirements.txt
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/sophon_arm-3.7.0-py3-none-any.whl
    ```

- Set environment variables:

    ```bash
    export LD_LIBRARY_PATH=/opt/sophon/libsophon-current/lib:$LD_LIBRARY_PATH
    ```

    **(Recommended)** This application uses Sophon-OpenCV for hardware acceleration. You need to set the environment variable for Sophon-OpenCV. Alternatively, you can use the pip source for `python-opencv-headless`.

    ```bash
    export PYTHONPATH=/opt/sophon/sophon-opencv-latest/opencv-python/:$PYTHONPATH
    ```

- Start the web service:

    ```bash
    python3 gr.py
    # or 
    # bash run.sh
    ```

- Access the web service through a browser at `bm1684x:8999`.