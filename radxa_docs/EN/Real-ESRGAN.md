## Real-ESRGAN-TPU

Real-ESRGAN-TPU is an application for video/image resolution super-resolution using the Tencent ARC Lab's open-source [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) models. It is ported to Radxa BM1684X chip series using the Sophon SDK for local TPU hardware-accelerated inference. This application enhances the resolution of videos/images to achieve 2560x1920 quality. It provides various optimization models for different scenarios, allowing targeted optimization for real scenes and anime videos. Additionally, it incorporates real face enhancement using [GFPGAN](https://github.com/TencentARC/GFPGAN). The application uses Gradio and Streamlit for user-friendly interaction.

- Clone the repository:
  
  ```bash
  git clone https://github.com/zifeng-radxa/Real-ESRGAN-tpu_Web.git
  ```

- Clone the face enhancement toolbox:

  ```bash
  cd Real-ESRGAN-tpu_Web
  git clone https://github.com/zifeng-radxa/GFPGAN.git
  git clone https://github.com/zifeng-radxa/FACEXLIB.git
  ```

- Create a virtual environment.

  **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

  ```bash
  pip3 install basicsr -i https://pypi.python.org/simple
  pip3 install -r requirements.txt
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  ```

- Download models:

  ```bash
  python3 download_models.py
  ```

- Run the application:

  - Run using Gradio:

  ```bash
  bash run_gr.sh
  ```

  - Run using Streamlit:

  ```bash
  bash run_st.sh
  ```