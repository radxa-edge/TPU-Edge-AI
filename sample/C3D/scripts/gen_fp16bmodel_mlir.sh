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
        --model_name c3d \
        --model_def ../models/onnx/c3d_ucf101.onnx \
        --input_shapes [[$1,3,16,112,112]] \
        --mlir c3d_$1b.mlir
}

function gen_fp16bmodel()
{
    model_deploy.py \
        --mlir c3d_$1b.mlir \
        --quantize F16 \
        --chip $target \
        --model $outdir/c3d_fp16_$1b.bmodel
}

pushd $model_dir
if [ ! -d "$outdir" ]; then
    echo $pwd
    mkdir $outdir
fi
# batch_size=1
gen_mlir 1
gen_fp16bmodel 1
rm c3d* final_opt.onnx

# batch_size=4
gen_mlir 4
gen_fp16bmodel 4
rm c3d* final_opt.onnx
popd