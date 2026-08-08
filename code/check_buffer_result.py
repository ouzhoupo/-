from pathlib import Path
import geopandas as gpd


root = Path(
    r"E:\workkkkkkkk\model\pond_s1s2_v7\pond_s1s2_v7"
)


for shp in root.rglob("*.shp"):
    try:
        gdf = gpd.read_file(shp)

        types = set(gdf.geometry.geom_type)

        if "LineString" in types or "MultiLineString" in types:
            print("\n发现线状数据:")
            print(shp)
            print(types)
            print("数量:", len(gdf))

    except Exception as e:
        pass