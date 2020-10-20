
eval "$(cat ~/.bashrc | tail -n +10)"


workon ${obs_venv}
echo ${obs_venv}
# Exit script on error.
set -e
# Echo each command, easier for debugging.
set -x

usage() {
  cat << END_OF_USAGE
  Converts TensorFlow checkpoint to EdgeTPU-compatible TFLite file.

  --checkpoint_num  Checkpoint number, by default 0.
  --help            Display this help.
END_OF_USAGE
}

ckpt_number=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --checkpoint_num)
      ckpt_number=$2
      shift 2 ;;
    --help)
      usage
      exit 0 ;;
    --*)
      echo "Unknown flag $1"
      usage
      exit 1 ;;
  esac
done

source "$PWD/images/setup/constants.sh"
# use constansts .sh  fix
echo ${TRAIN_DIR}


OUTPUT_DIR=/models/research/object_detection/images/model_out
CKPT_DIR=/models/research/object_detection/training
#  fix
#TRAIN_DIR=${MODEL_DIR}

rm -rf "${OUTPUT_DIR}"
mkdir "${OUTPUT_DIR}"


echo "GENERATING label file..."
#cp ${IMAGEWORKDIR}/labels.txt ${OUTPUT_DIR}



echo "EXPORTING frozen graph from checkpoint..."
python3 $PWD/export_tflite_ssd_graph.py \
  --pipeline_config_path="${CKPT_DIR}/pipeline.config" \
  --trained_checkpoint_prefix="${CKPT_DIR}/model.ckpt-${ckpt_number}" \
  --output_directory="${OUTPUT_DIR}" \
  --add_postprocessing_op=true

echo "CONVERTING frozen graph to TF Lite file..."
tflite_convert \
  --output_file="${OUTPUT_DIR}/output_tflite_graph.tflite" \
  --graph_def_file="${OUTPUT_DIR}/tflite_graph.pb" \
  --inference_type=QUANTIZED_UINT8 \
  --input_arrays="${INPUT_TENSORS}" \
  --output_arrays="${OUTPUT_TENSORS}" \
  --mean_values=128 \
  --std_dev_values=128 \
  --input_shapes=1,300,300,3 \
  --change_concat_input_ranges=false \
  --allow_nudging_weights_to_use_fast_gemm_kernel=true \
  --allow_custom_ops

echo "TFLite graph generated at ${OUTPUT_DIR}/output_tflite_graph.tflite"
