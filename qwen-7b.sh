export WANDB_PROJECT=Qwen-2-VL-7B-Video-GRPO
export WANDB_NAME=llava-video-4k

mkdir -p /data/wangxd/ckpt/$WANDB_PROJECT/$WANDB_NAME

CUDA_VISIBLE_DEVICES=0,1,2,4 torchrun --nproc_per_node="4" \
    --nnodes="1" \
    --node_rank="0" \
    --master_addr="127.0.0.1" \
    --master_port="12352" \
    src/open_r1/grpo.py \
    --deepspeed scripts/zero3_offload.json \
    --output_dir /data/wangxd/ckpt/$WANDB_PROJECT/$WANDB_NAME \
    --model_name_or_path /data/wangxd/models/Qwen2-VL-7B-Instruct \
    --dataset_name xxx \
    --jsonl_path /home/user/wangxd/open-r1-multimodal/data/LLaVA-Video-large-swift-origin.jsonl \
    --max_prompt_length 4096 \
    --learning_rate 1e-6 \
    --beta 0.04 \
    --per_device_train_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --logging_steps 1 \
    --bf16 \
    --torch_dtype bfloat16 \
    --data_seed 42 \
    --report_to wandb \
    --gradient_checkpointing true \
    --attn_implementation flash_attention_2 \
    --num_train_epochs 2 \
    --run_name $WANDB_NAME \
    --save_steps 20 \
    --save_total_limit 8 \
    --save_only_model true