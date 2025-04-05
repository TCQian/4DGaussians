#!/bin/bash

#SBATCH --job-name=BouncingBals          # Job name
#SBATCH --time=48:00:00                  # Time limit hrs:min:sec
#SBATCH --gres=gpu:a100-40:1
#SBATCH --mail-type=ALL                  # Get email for all status updates
#SBATCH --mail-user=e0407638@u.nus.edu   # Email for notifications
#SBATCH --mem=16G                        # Request 16GB of memory

source ~/.bashrc
conda activate 4dg

python train.py -s /home/e/e0407638/github/4DGaussians/data/multipleview/bearRun --port 6017 --expname "multipleview/bearRun" --configs /home/e/e0407638/github/4DGaussians/arguments/multipleview/default.py

python render.py --model_path "output/multipleview/bearRun/"  --skip_train --configs arguments/multipleview/default.py

python metrics.py --model_path "output/multipleview/bearRun/"