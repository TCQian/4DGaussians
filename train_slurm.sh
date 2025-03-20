#!/bin/bash

#SBATCH --job-name=BouncingBals          # Job name
#SBATCH --time=48:00:00                  # Time limit hrs:min:sec
#SBATCH --gres=gpu:a100-40:1
#SBATCH --mail-type=ALL                  # Get email for all status updates
#SBATCH --mail-user=e0407638@u.nus.edu   # Email for notifications
#SBATCH --mem=16G                        # Request 16GB of memory

source ~/.bashrc
conda activate 4dg

# bouncingballs
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/bouncingballs --port 6017 --expname "dnerf/bouncingballs" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/bouncingballs.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/bouncingballs/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/bouncingballs.py

# hellwarrior
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/hellwarrior --port 6017 --expname "dnerf/hellwarrior" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/hellwarrior.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/hellwarrior/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/hellwarrior.py

# hook
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/hook --port 6017 --expname "dnerf/hook" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/hook.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/hook/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/hook.py

# jumpingjacks
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/jumpingjacks --port 6017 --expname "dnerf/jumpingjacks" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/jumpingjacks.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/jumpingjacks/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/jumpingjacks.py

# mutant
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/mutant --port 6017 --expname "dnerf/mutant" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/mutant.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/mutant/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/mutant.py

# standup
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/standup --port 6017 --expname "dnerf/standup" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/standup.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/standup/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/standup.py

# trex
srun python train.py -s /home/e/e0407638/github/4DGaussians/dataset/data/trex --port 6017 --expname "dnerf/trex" --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/trex.py
srun python render.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/trex/" --skip_train --configs /home/e/e0407638/github/4DGaussians/arguments/dnerf/trex.py

# evaluation
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/bouncingballs/"
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/hellwarrior/"
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/hook/"
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/jumpingjacks/"
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/mutant/"
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/standup/"
srun python metrics.py --model_path "/home/e/e0407638/github/4DGaussians/output/dnerf/trex/"
