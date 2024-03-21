## VideoSearch-TPU

VideoSearch-TPU is an application that allows text-based searching of video content. It uses the Image CLIP model, ported to Radxa BM1684X chip series products using the Sophon SDK for local TPU hardware-accelerated inference. This application enables rapid searching of video content using text and returns corresponding frames and video positions for the search results.

- Clone the repository:

  ```bash
  git clone https://github.com/zifeng-radxa/VideoSearch-tpu.git
  ```

- Download CLIP bmodels, and copy the `bmodels` folder to `VideoSearch-tpu/inference/clip_model/`:

  ```bash
  cd VideoSearch-tpu/inference/clip_model/
  rm -rf ./bmodels
  wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/ImageSearch/ImageSearch_bmodel.zip
  unzip ImageSearch_bmodel.zip
  mv ImageSearch_bmodel/bmodels .
  ```

  The file structure should look like this:

  ```bash
  .
  ├── dbs
  │   ├── CH
  │   └── EN
  ├── inference
  │   ├── clip
  │   ├── clip_model
  │   │   ├── ImageSearch_bmodel
  │   │   │   └── bmodels
  │   │   │       ├── CH
  │   │   │       └── EN
  │   │   └── saved_tokenizer
  │   │       ├── bert_chinese_tokenizer-fast
  │   │       └── bert_chinese_tokenizer-slow
  │   └── utils
  ├── scene_snapshot
  └── video_collection
  ```

- Create a virtual environment.

  **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

  ```bash
  cd VideoSearch-tpu
  python3 -m virtualenv .venv
  source .venv/bin/activate
  ```

- Install dependencies:

  ```bash
  pip3 install --upgrade pip
  pip3 install -r requirements.txt
  pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
  ```

- Import Environment Variables

    VideoSearch does not support sophon-opencv. If sophon-opencv is set in the environment variables, please unset it.

    ```bash
    export LD_LIBRARY_PATH=/opt/sophon/libsophon-current/lib:$LD_LIBRARY_PATH
    ```

- Start the web service:

  ```bash
  streamlit run app.py EN 
  ```