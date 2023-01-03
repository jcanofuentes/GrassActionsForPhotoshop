#!/usr/bin/env python
import time
import os

# import GRASS Python bindings (see also pygrass)
import grass.script as gscript
import grass.script.setup as gsetup

def main():
	#gscript.message('Current GRASS GIS 7 environment:')
	#print(gscript.gisenv())
	tempFolder = os.getenv('SENECA_TEMP_FOLDER')
	# Import depthmap created from Photohsop
	gscript.run_command('r.in.gdal', input=tempFolder + "\\temp_ps_to_grass.tif", output="FROM_PHOTOSHOP", overwrite=True)
	# Set computational region
	gscript.run_command('g.region', rast="FROM_PHOTOSHOP", flags = "ap")
	# Render it with r.relief command
	gscript.run_command('r.relief', input="FROM_PHOTOSHOP", output="FROM_PHOTOSHOP_RELIEF", altitude=30, azimuth=60, overwrite=True)
	# Export shaded image
	gscript.run_command('r.out.gdal', flags="cm", input="FROM_PHOTOSHOP_RELIEF", output=tempFolder + "\\temp_ps_to_grass_shaded.png", format='PNG' , overwrite=True)
	# We need some sort of 'job finish' message, so we create an empty file for this
	f = open(tempFolder + "\\grass_job_done.txt", "w")
if __name__ == '__main__':
    main()
	
