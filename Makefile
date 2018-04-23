data-dir = data/processed
gdb = data/raw/us_pbg00_2007.gdb

all: $(data-dir)/ecoregion_summaries.csv $(data-dir)/housing_density.csv

data/processed/ecoregion_summaries.csv: R/get-ecoregion-summaries.R  \
	data/raw/us_eco_l3/us_eco_l3.shp \
	R/aggregate-climate-data.R \
	data/raw/climate-data.csv
		Rscript --vanilla R/aggregate-climate-data.R
		Rscript --vanilla R/get-ecoregion-summaries.R

data/processed/housing_density.csv: R/summarize-housing-density.R \
	data/raw/us_eco_l3/us_eco_l3.shp \
	data/raw/us_pbg00_2007.gdb
		gdal_rasterize -a HDEN80 -of GTiff -tr 4000 4000 $(gdb) data/processed/den80.tif
		gdal_rasterize -a HDEN90 -of GTiff -tr 4000 4000 $(gdb) data/processed/den90.tif
		gdal_rasterize -a HDEN00 -of GTiff -tr 4000 4000 $(gdb) data/processed/den00.tif
		gdal_rasterize -a HDEN10 -of GTiff -tr 4000 4000 $(gdb) data/processed/den10.tif
		gdal_rasterize -a HDEN20 -of GTiff -tr 4000 4000 $(gdb) data/processed/den20.tif
		Rscript --vanilla R/summarize-housing-density.R

data/raw/us_pbg00_2007.gdb:
		wget -nc -O data/raw/us_pbg00.zip http://silvis.forest.wisc.edu/sites/default/files/maps/pbg00_old/gis/us_pbg00.zip
		unzip data/raw/us_pbg00.zip -d data/raw/
		rm data/raw/us_pbg00.zip

data/raw/us_eco_l3/us_eco_l3.shp: 
		wget -nc -O data/raw/us_eco_l3.zip ftp://newftp.epa.gov/EPADataCommons/ORD/Ecoregions/us/us_eco_l3.zip
		unzip -o data/raw/us_eco_l3.zip -d data/raw/us_eco_l3
		rm data/raw/us_eco_l3.zip

data/raw/mtbs_fod_pts_data/mtbs_fod_pts_20170501.shp:
		wget -nc -O data/raw/mtbs_fod_pts_data.zip https://edcintl.cr.usgs.gov/downloads/sciweb1/shared/MTBS_Fire/data/composite_data/fod_pt_shapefile/mtbs_fod_pts_data.zip
		unzip -o data/raw/mtbs_fod_pts_data.zip -d data/raw/mtbs_fod_pts_data
		rm data/raw/mtbs_fod_pts_data.zip