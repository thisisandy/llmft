#!/bin/bash

# Define base model and script parameters
model="facebook/opt-125m"
learning_rate=0.00001
epochs=40
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
    local script=$1
    local task=$2
    shift 2  # Shift the first two arguments to get additional arguments for the script
    # Print to terminal about the script being run
    echo "Running $script for task $task with parameters $@"
    # Run the script without redirecting standard output or standard error
    bash "$script" "$task" "$@"
    # Capture the exit status of the script
    local status=$?
    # Log success or failure based on the exit status
    if [ $status -eq 0 ]; then
        echo "$script on $task: SUCCESS" >> "$status_file"
    else
        echo "$script on $task: FAILED with status $status" >> "$status_file"
    fi
}

# Loop over tasks and script types
for task in "${tasks[@]}"; do
    # in_context scripts
    script="${script_paths[in_context]}/$task/run_minimal.sh"
    run_script "$script" "$task" "$bsz" "$model" "$num_gpus" "$port"

    # verbalexpr_ft and vanilla_ft scripts
    for type in "verbalexpr_ft" "vanilla_ft"; do
        script="${script_paths[$type]}/$task/run.sh"
        run_script "$script" "$task" "$max_train_samples" "$epochs" "$warmup_ratio" "$bsz" "$num_gpus" "$learning_rate" "$model" "$port"
    done
done
