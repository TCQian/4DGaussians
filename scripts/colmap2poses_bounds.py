import os
import sys
import numpy as np
import pycolmap

def load_sparse_model(sparse_dir):
    return pycolmap.Reconstruction(sparse_dir)

def pose_from_colmap(image):
    # COLMAP uses world-to-camera; invert to get camera-to-world
    Rwc = image.rotmat().T
    twc = -Rwc @ image.tvec
    return Rwc, twc

def make_pose_matrix(Rwc, twc):
    pose = np.eye(4)
    pose[:3, :3] = Rwc
    pose[:3, 3] = twc
    return pose

def compute_bounds(points3D, pose):
    # Transform all points into the camera coordinate system
    cam_points = np.linalg.inv(pose) @ np.vstack([points3D.T, np.ones((1, points3D.shape[0]))])
    z_vals = cam_points[2, :]
    return np.percentile(z_vals, 0.1), np.percentile(z_vals, 99.9)

def main():
    sparse_dir = sys.argv[1]  # path to sparse/ (containing cameras.bin/images.bin)
    output_path = sys.argv[2] # path to save poses_bounds_multipleview.npy

    recon = load_sparse_model(sparse_dir)
    points3D = np.array([p.xyz for p in recon.points3D.values()])

    poses_bounds = []

    for img_id, img in sorted(recon.images.items()):
        cam = recon.cameras[img.camera_id]
        Rwc, twc = pose_from_colmap(img)
        pose = make_pose_matrix(Rwc, twc)

        near, far = compute_bounds(points3D, pose)

        pose_flat = pose[:3, :4].reshape(-1)
        poses_bounds.append(np.concatenate([pose_flat, [near, far]]))

    poses_bounds = np.stack(poses_bounds)
    np.save(output_path, poses_bounds)
    print("Saved poses_bounds_multipleview.npy to", output_path)

if __name__ == "__main__":
    main()
