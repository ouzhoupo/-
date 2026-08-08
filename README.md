# pond_s1s2_v7

安徽史灌区小型水体遥感监测模型

## 功能

基于 Sentinel-1 + Sentinel-2 融合：

- 水体识别
- 塘坝提取
- 面积计算
- 蓄水量估算

## Workflow

S1 SAR
+
S2 optical

↓

water probability

↓

water mask

↓

pond extraction

↓

DEM volume estimation


## Current optimization

River/channel spatial constraint optimization


## Quickstart（快速上手）

下面提供最小可复现的快速启动步骤，适用于本仓库的 `fuse-water` 子命令。

1) 环境准备

- 推荐使用 conda（便于安装 GDAL / rasterio 等系统依赖）：

```bash
conda create -n pond python=3.10 -y
conda activate pond
pip install -r requirements.txt
# 注意：在部分系统上 rasterio/GDAL 可能需要额外系统包，或使用 conda-forge 提供的二进制包：
# conda install -c conda-forge rasterio gdal
```

2) 配置最小示例数据与配置

- 在 `config/` 下准备一个演示配置（例如 `config/demo.yaml`），指向你的示例影像路径或 SAFE 目录。
- 若没有真实影像，可准备少量代表性样本放在 `sample_data/`（由你本地准备并非必须上传到仓库）。

3) 运行最小演示

- 假设已有 `config/demo.yaml`：

```bash
python code/s1s2_pond_production.py fuse-water --config config/demo.yaml --log-level INFO
```

- 运行后会在配置中指定的 `out_dir` 生成输出文件：`water_prob_{date}.tif`, `water_mask_{date}.tif`, `source_flag_{date}.tif`, `confidence_{date}.tif` 以及汇总 `fusion_summary_{date}.json`。

4) 模型权重与大文件（建议）

- 请不要将大型权重文件或原始遥感影像直接提交到 Git（仓库已新增 .gitattributes 以便启用 Git LFS）。
- 若需在团队中管理权重，推荐把权重放到云存储（S3 / Google Drive）并在仓库中放置 `scripts/download_weights.sh` 来下载它们。启用 LFS 的本地示例命令：

```bash
git lfs install
git lfs track "*.pth" "*.h5" "*.tif"
git add .gitattributes
git commit -m "Enable Git LFS tracking for large files"
```

5) 移除已被跟踪的缓存（本仓库示例）

- 本次改动建议把 `code/__pycache__` 从 Git 索引中移除（不会删除本地文件）。在本地可运行：

```bash
git rm -r --cached code/__pycache__
git commit -m "Remove __pycache__ from repository index"
git push origin add-gitignore-quickstart
```

（也可在合并 PR 后在主分支上执行相同命令）

6) 问题与诊断

- 如果在运行过程中遇到 GDAL / rasterio 的环境问题，请把 `pip install` 或 `conda install` 的错误输出贴到 issue 中，我会帮你定位依赖问题。


---

如果你希望我也添加 Dockerfile 或 GitHub Actions CI（例如运行 lint 或 smoke test），告诉我我会把示例加入 PR。