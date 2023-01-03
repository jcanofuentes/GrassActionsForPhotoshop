::@echo off
setlocal

cd /D %SENECA_GRASS_FOLDER%

grass76 E:\Grass_data\Tutorial\PERMANENT\ --exec python %SENECA_TEMP_FOLDER%\Render_32bits.py

pause



::cd C:\Program Files\GRASS GIS 7.6

REM -- Working with Python scripts
::grass76 E:\Grass_data\Tutorial\PERMANENT\ --exec python C:\seneca_temp_folder\Render_32bits.py


REM grass76.bat C:\seneca_temp_folder\temp_ps_to_grass.tif  --tmp-location XY --exec r.neighbors --help
REM grass76 E:\Grass_data\Tutorial\PERMANENT\ --exec r.in.gdal --overwrite input=C:\seneca_temp_folder\temp_ps_to_grass.tif output=FROM_PHOTOSHOP_1 
REM grass76 E:\Grass_data\Tutorial\PERMANENT\ --exec r.relief input=FROM_PHOTOSHOP_1 output=relief altitude=30 azimuth=60 --overwrite
