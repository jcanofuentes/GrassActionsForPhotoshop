@echo off
setlocal

REM Store current path
set source_path=%~dp0
echo "SOURCE PATH:" %source_path%

REM Check for Admin privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Administrator PRIVILEGES Detected! 
) ELSE (
    echo msgbox "ERROR: Launch this program as an administrator by right-clicking on the executable file and choosing 'Run as administrator.'" > %tmp%\tmp.vbs
	cscript /nologo %tmp%\tmp.vbs
	del %tmp%\tmp.vbs
	exit
)

REM Installation info...
echo msgbox "Welcome to the 'SENECA extensions for Photoshop' setup" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs

REM More info...
echo msgbox "First, you have to select the GRASS installation folder" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs

REM Ask the user for the GRASS installation folder
set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Usual path is: C:\Program Files\GRASS GIS 7.X',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion

REM Check for grass76.bat 
cd /D !folder!
if exist "grass*.bat" (
	echo msgbox "Your GRASS installation is at: !folder!" > %tmp%\tmp.vbs
	cscript /nologo %tmp%\tmp.vbs
	del %tmp%\tmp.vbs
) else (
	REM Grass not found...exitting
	echo msgbox "Grass is not found, exitting setup" > %tmp%\tmp.vbs
	cscript /nologo %tmp%\tmp.vbs
	del %tmp%\tmp.vbs
	exit
)

REM Create an environment variable for later use
echo msgbox "New environment variable added: SENECA_GRASS_FOLDER" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
setx -m SENECA_GRASS_FOLDER "!folder!"
setx env SENECA_GRASS_FOLDER /M

REM Ask the user for the 'SENECA temporal folder' place
echo msgbox "This extension needs a folder where the necessary files will be save to allow communication between Photoshop and GRASS. Please select the drive where you want this folder to be created (an SSD drive is preferable)" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
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
echo msgbox "Don't forget to copy the Render_32bits.jsx file to C:\Program Files\Adobe\Adobe Photoshop XXXX\Presets\Scripts" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs

echo msgbox "Finally, don't forget to create a Grass Location and update the file 'shade.bat' with the correct one" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs

pause 10

REM Recent changes: 
REM 03/01/2023 Now it works for both Grass 7.6 and Grass 7.8




