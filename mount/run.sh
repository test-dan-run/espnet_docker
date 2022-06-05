#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

cd /workspace/espnet/egs2/mini_an4/asr1

./asr.sh \
    --lang en \
    --train_set train_nodev \
    --valid_set train_dev \
    --test_sets "train_dev test test_seg" \
    --lm_train_text "data/train_nodev/text" "$@" \
    --lm_exp "/mount/exp/transformer/lm_exp" \
    --lm_stats_dir "/mount/exp/transformer/lm_stats" \
    --asr_exp "/mount/exp/transformer/asr_exp" \
    --asr_stats_dir "/mount/exp/transformer/asr_stats" \
    --asr_config "/mount/tuning/train_asr_transformer.yaml" \
    --inference_config "/mount/tuning/decode_transformer.yaml"
    # --use_lm false \
