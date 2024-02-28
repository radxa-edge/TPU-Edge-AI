## Real-ESRGAN-TPU

Real-ESRGAN-TPU 视频/图片分辨率超分应用，通过使用腾讯ARC实验室开源 [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) 系列模型，使用 Sophon SDK 移植到 radxa BM1684X 系列芯片上，实现本地 TPU 进行硬件加速推理，
此应用可用于对视频/图片进行分辨率提升达到 2560x1920 画质，并提供多种针对不同场景使用的优化模型，可对真实场景，动漫视频进行针对性优化，并实现真实人面增强 （[GFPGAN](https://github.com/TencentARC/GFPGAN)）还原功能，此应用使用 Gradio 和 Streamlit 实现用户友好交互界面


- 克隆仓库
  ```bash
  git clone https://github.com/zifeng-radxa/Real-ESRGAN-tpu_Web.git
  ```

- 克隆人脸增强工具箱
  ```bash
  cd Real-ESRGAN-tpu_Web
  git clone https://github.com/zifeng-radxa/GFPGAN.git
  git clone https://github.com/zifeng-radxa/FACEXLIB.git
  ```

- 创建虚拟环境

    **必须创建虚拟环境，否则可能会影响其他应用的正常运行**， 虚拟环境使用请参考[这里](虚拟环境使用.md)
  ```bash
  pip3 install basicsr -i https://pypi.python.org/simple
  pip3 install -r requirements.txt
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  ```

- 下载模型

  ```bash
  python3 download_models.py
  ```

- 启动应用

  - 通过 gradio 启动

  ```bash
  bash run_gr.sh
  ```

  - 通过 streamlit 启动
  ```bash
  bash run_st.sh
  ```
