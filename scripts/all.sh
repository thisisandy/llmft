#!/bin/bash

# Define base model and script parameters
model="facebook/opt-125m"
learning_rate=0.00001
epochs=1
max_train_samples=160
warmup_ratio=0.1
bsz=32
num_gpus=1
port=8000
log_dir="./logs"
status_file="$log_dir/status.log"

# Ensure log directory exists
mkdir -p "$log_dir"

# Tasks array
tasks=("mnli" "cola" "qqp")

# Define base directories for script types
declare -A script_paths
script_paths[verbalexpr_ft]="./scripts/pattern_verbalizer_ft"
script_paths[vanilla_ft]="./scripts/vanilla_ft"
script_paths[in_context]="./scripts/in_context"

# Function to run script and log status
run_script() {
    local task=$1
    local script=$2
    local log_file="$log_dir/$task-$(basename $script).log"

    # Run the script and capture exit status
    bash $script $task $@ 3>&1 1>>$log_file 2>&1
    local status=$?

    # Log success or failure
    if [ $status -eq 0 ]; then
        echo "$script on $task: SUCCESS" >> $status_file
    else
        echo "$script on $task: FAILED with status $status" >> $status_file
    fi
}

# Loop over tasks and script types
for task in "${tasks[@]}"; do
    # in_context scripts
    script="${script_paths[in_context]}/$task/run_minimal.sh"
    run_script $task $script $bsz $model $num_gpus $port

    # verbalexpr_ft and vanilla_ft scripts
    for type in verbalexpr_ft vanilla_ft; do
        script="${script_paths[$type]}/$task/run.sh"
        run_script $task $script $max_train_samples $epochs $warmup_ratio $bsz $num_gpus $learning_rate $model $port
    done


done
