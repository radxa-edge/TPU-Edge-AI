#!/bin/bash
model_dir=$(dirname $(readlink -f "$0"))

if [ ! $1 ]; then
    target=bm1684x
    target_dir=BM1684X
else
    target=${1,,}
    target_dir=${target^^}
    if test $target = "bm1684"
    then
        echo "bm1684 do not support fp16"
        exit
    fi
fi

outdir=../models/$target_dir

function gen_mlir()
{
    model_transform.py \
        --model_name yolov3 \
        --model_def ../models/onnx/yolov3.onnx \
        --input_shapes [[$1,3,608,608]] \
        --output_names 422,536,650 \
        --mean 0.0,0.0,0.0 \
        --scale 0.0039216,0.0039216,0.0039216 \
        --test_input ../datasets/test/dog.jpg \
        --test_result tmp.npz \
        --mlir yolov3_$1b.mlir
}

function gen_fp16bmodel()
{
    model_deploy.py \
        --mlir yolov3_$1b.mlir \
        --quantize F16 \
        --chip $target \
        --test_input ../datasets/test/dog.jpg \
        --test_reference tmp.npz \
        --model yolov3_fp16_$1b.bmodel

    mv yolov3_fp16_$1b.bmodel $outdir/
}

pushd $model_dir
if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi
# batch_size=1
gen_mlir 1
gen_fp16bmodel 1

popd