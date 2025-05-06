import json
import os

import numpy as np
import torchvision.transforms as T
from PIL import Image
from torch.utils.data import Dataset

from scene.dataset_readers import setup_camera
from utils.graphics_utils import focal2fov


class PanopticDataset(Dataset):
    def __init__(self, datadir: str, json_path: str, split: str = "train"):
        """
        datadir: root folder containing 'ims/' and the JSON
        json_path: e.g. 'train_meta.json' or 'test_meta.json'
        split: just for API symmetry; you can ignore or extend it
        """
        full_json = os.path.join(datadir, json_path)
        with open(full_json, "r") as f:
            meta = json.load(f)

        self.datadir = datadir
        self.w = meta["w"]
        self.h = meta["h"]
        self.max_time = len(meta["fn"])
        self.entries = []

        # each frame index has lists of focals, w2c, filenames, cam_ids
        for frame_idx in range(self.max_time):
            time = frame_idx / self.max_time
            focals = meta["k"][frame_idx]
            w2cs = meta["w2c"][frame_idx]
            fns = meta["fn"][frame_idx]
            cam_ids = meta["cam_id"][frame_idx]

            for focal, w2c, fn, cid in zip(focals, w2cs, fns, cam_ids):
                self.entries.append(
                    {
                        "time": time,
                        "focal": focal,
                        "w2c": np.array(w2c, dtype=np.float32),
                        "filename": fn,
                        "cam_id": cid,
                    }
                )

        # precompute FOVs once
        self.FovY = focal2fov(self.entries[0]["focal"], self.h)
        self.FovX = focal2fov(self.entries[0]["focal"], self.w)
        self.transform = T.ToTensor()

    def __len__(self):
        return len(self.entries)

    def __getitem__(self, idx):
        e = self.entries[idx]

        # 1) load image
        img_path = os.path.join(self.datadir, "ims", e["filename"])
        img = Image.open(img_path).convert("RGB")
        img = self.transform(img)  # [3, H, W], float in [0,1]

        # 2) build camera
        cam = setup_camera(
            w=self.w, h=self.h, k=e["focal"], w2c=e["w2c"], near=0.01, far=100
        )
        # you may want to overwrite cam.tanfovx/y if setup_camera doesn't use our FOVs:
        cam.tanfovx = np.tan(self.FovX * 0.5)
        cam.tanfovy = np.tan(self.FovY * 0.5)

        return {"camera": cam, "image": img, "time": e["time"], "cam_id": e["cam_id"]}
