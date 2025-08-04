#!/bin/bash

#SBATCH --job-name=dynerf_cut_roasted_beef    # Job name
#SBATCH --time=5:00:00                        # Time limit hrs:min:sec
#SBATCH --gres=gpu:a100-40:1
#SBATCH --mail-type=ALL                       # Get email for all status updates
#SBATCH --mail-user=e0407638@u.nus.edu        # Email for notifications
#SBATCH --mem=16G                             # Request 16GB of memory

source ~/.bashrc
conda activate 4dg

srun python train.py -s data/dynerf/cut_roasted_beef --port 6470 --expname "dynerf/cut_roasted_beef" --configs arguments/dynerf/cut_roasted_beef.py 
srun python render.py --model_path output/dynerf/cut_roasted_beef --configs arguments/dynerf/cut_roasted_beef.py --skip_train
srun python metrics.py --model_path "output/dynerf/cut_roasted_beef/"
