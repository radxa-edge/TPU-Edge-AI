## ImageSearch-TPU

ImageSearch-TPU is an application that allows text-based searching of images. It uses the Image CLIP model, ported to Radxa BM1684X chip series products using the Sophon SDK for local TPU hardware-accelerated inference. This application enables quick searching of an image library using text and provides a user-friendly interactive interface using Streamlit.

- Clone the repository:

    ```bash 
    git clone https://github.com/zifeng-radxa/ImageSearch-tpu
    ```

- Download CLIP bmodel:

     ```bash
    cd clip_image_search/clip
    wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/ImageSearch/ImageSearch_bmodel.zip
    unzip ImageSearch_bmodel.zip
    ```

    Move the `bmodel` to `ImageSearch_bmodel/bmodels/`:

    ```bash
    rm -rf bmodels/
    mv ./ImageSearch_bmodel/bmodels/ .
    ```

  The file tree structure should look like this:

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

- Create a virtual environment.

  **It is essential to create a virtual environment to avoid potential conflicts with other applications.** For instructions on using a virtual environment, refer to [this guide](Virtualenv_usage.md).

    ```bash
    cd ImageSearch-tpu
    python3 -m virtualenv .venv
    source .venv/bin/activate
    ```

- Install dependencies:

    ```bash
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
    pip3 install https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/tpu_perf-1.2.31-py3-none-manylinux2014_aarch64.whl
    ```

- Start the web service:

    ```bash
    streamlit run app.py CH # for ChineseCLIP VIT-B16
    streamlit run app.py EN # for CLIP-VIT-B32 
    ```
