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
