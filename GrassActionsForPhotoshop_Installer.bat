@echo off

goto :Main

::----------------------------------------------------------------------
::-- Main
::--
::-- param:   none
::-- return:  none
::----------------------------------------------------------------------
:Main
	set sourcePath=%~dp0
	set tmpVBSFile=%sourcePath%\tmp.vbs
	set outputResult=Empty

	call:checkPermissions		
	
	call:PrintWithVBS "Welcome to the 'SENECA extensions for Photoshop' setup. First, you have to select the GRASS installation folder"
	
	set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Usual path is: C:\Program Files\GRASS GIS X.X',0,0).self.path""
	for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
	
	REM Check for grass*.bat 
	setlocal enabledelayedexpansion
	cd /D !folder!
	if exist "grass*.bat" (
		call:PrintWithVBS  "Your GRASS installation is at: !folder!"
	) else (
		call:PrintWithVBS "Grass is not found, exitting setup"
		timeout 3
		exit
	)
	
	REM Create an environment variable for later use
	call:PrintWithVBS "New environment variable added: SENECA_GRASS_FOLDER"
	setx -m SENECA_GRASS_FOLDER "!folder!"
	setx env SENECA_GRASS_FOLDER /M

	REM Ask the user for the 'SENECA temporal folder' place
	call:PrintWithVBS "This extension needs a folder where the necessary files will be save to allow communication between Photoshop and GRASS. Please select the drive where you want this folder to be created (an SSD drive is preferable)"
	set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Select drive...',0,0).self.path""
	for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder_2=%%I"
	setlocal enabledelayedexpansion

	REM Actually creates the folder
	cd /D %folder_2%
	mkdir "SENECA_TEMP_FOLDER"
	cd "SENECA_TEMP_FOLDER"
	setx -m SENECA_TEMP_FOLDER "%cd%"
	setx env SENECA_TEMP_FOLDER /M

	REM Copy files to temp folder
	xcopy /s/z "%source_path%\grass_scripts" "%cd%"


	REM Last questions...
	call:PrintWithVBS "Don't forget to copy all jsx files to Photshop script folder (usually at: C:\Program Files\Adobe\Adobe Photoshop XXXX\Presets\Scripts)"
	call:PrintWithVBS "Finally, don't forget to create a Grass Location and update the file 'shade.bat' with the correct one"

	timeout 3
	exit
	
::----------------------------------------------------------------------
::-- checkPermissions
::-- Check for admin privileges. Stop script execution if no admin 
::-- rights
::--
::-- param:   none
::-- return:  none
::----------------------------------------------------------------------

:checkPermissions
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Administrator privileges detected, the installation continues.
    ) else (
        call:PrintWithVBS "ERROR: Launch this program as an administrator by right-clicking on the executable file and choosing 'Run as administrator.'"
		timeout 3
		exit
    )
    
	goto :eof
	
::----------------------------------------------------------------------
::-- PrintWithVBS
::-- Shows a msgbox using VBS
::--
::-- param: the message inbetween double quotes
::----------------------------------------------------------------------
:PrintWithVBS
	echo msgbox "%~1" > %tmpVBSFile%
	cscript /nologo %tmpVBSFile%
	goto :eof

REM Recent changes: 
REM 03/01/2023 Now it works for both Grass 7.6 and Grass 7.8




