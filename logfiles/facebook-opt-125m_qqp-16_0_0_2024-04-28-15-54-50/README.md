---
language:
- en
license: other
tags:
- generated_from_trainer
model-index:
- name: facebook-opt-125m_qqp-16_0_0_2024-04-28-15-54-50
  results: []
---

<!-- This model card has been generated automatically according to the information the Trainer had access to. You
should probably proofread and complete it, then remove this comment. -->

# facebook-opt-125m_qqp-16_0_0_2024-04-28-15-54-50

This model is a fine-tuned version of [facebook/opt-125m](https://huggingface.co/facebook/opt-125m) on an unknown dataset.

## Model description

More information needed

## Intended uses & limitations

More information needed

## Training and evaluation data

More information needed

## Training procedure

### Training hyperparameters

The following hyperparameters were used during training:
- learning_rate: 1e-05
- train_batch_size: 2
- eval_batch_size: 10
- seed: 0
- distributed_type: multi-GPU
- optimizer: Adam with betas=(0.9,0.999) and epsilon=1e-08
- lr_scheduler_type: linear
- lr_scheduler_warmup_ratio: 0.1
- num_epochs: 20.0

### Training results



### Framework versions

- Transformers 4.28.0
- Pytorch 1.13.0a0+d321be6
- Datasets 2.19.0
- Tokenizers 0.13.3
