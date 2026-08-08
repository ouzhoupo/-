from pathlib import Path

# 配置文件位置
cfg_file = Path(
    r"E:\workkkkkkkk\model\pond_s1s2_v7\pond_s1s2_v7\output\20240501\hangbuhe\monitor_cfg_test_maxarea.yaml"
)

# 新工程根目录
root = r"E:/workkkkkkkk/model/pond_s1s2_v7/pond_s1s2_v7"

# 检查文件
if not cfg_file.exists():
    raise FileNotFoundError(f"找不到配置文件: {cfg_file}")

# 读取
text = cfg_file.read_text(encoding="utf-8")

# 逐行修复
lines = text.splitlines()

new_lines = []

for line in lines:

    # 修复 source_water_mask_dir
    if line.startswith("source_water_mask_dir:"):
        line = (
            'source_water_mask_dir: '
            f'"{root}/output/20240501/hangbuhe"'
        )

    # 修复 water_tif
    elif line.startswith("water_tif:"):
        line = (
            'water_tif: '
            f'"{root}/output/20240501/hangbuhe/water_mask_2024-05-01.tif"'
        )

    # 修复输出目录
    elif line.startswith("out_dir:"):
        line = (
            'out_dir: '
            f'"{root}/output/20240501/final/hangbuhe_test_no_buffer"'
        )

    new_lines.append(line)


# 保存
cfg_file.write_text(
    "\n".join(new_lines),
    encoding="utf-8"
)

print("配置文件修改完成：")
print(cfg_file)