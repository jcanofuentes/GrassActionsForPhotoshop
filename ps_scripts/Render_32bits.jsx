// This script renders depth data inside current selection using r.shade command from Grass GIS

#target photoshop
// debug level: 0-2 (0:disable, 1:break on error, 2:break at beginning)
$.level = 0;
$.flags = 0x0080;

debugger; // launch debugger on next line
 
// This folder will be the container of shared data between Photoshop and Grass
var tempFolderPath = $.getenv('SENECA_TEMP_FOLDER')

// TODO: 
// 1. Think how to set the GRASS PATH
// 2. Check if Grass is installed

main();
function main() {
    /*
    var dlg = new Window( "dialog", "Save TIFF 32 bits" );
    dlg.renderPanel = dlg.add('panel', undefined, 'Render parameters');
    dlg.renderPanel.titleSt =dlg.renderPanel.add( "statictext", undefined, "Information about rendering proccedure" );
    dlg.renderPanel.azimuthSlider = dlg.renderPanel.add("slider", undefined, "Slider text")
    dlg.renderPanel.azimuthSlider.value = 50
    dlg.renderPanel.azimuthSlider.width = 200
    dlg.renderPanel.renderButton = dlg.renderPanel.add('button', undefined, 'Render');
    dlg.sizePnl = dlg.add( "panel", undefined, "Dimensions" ); 
    dlg.sizePnl.widthSt = dlg.sizePnl.add( "statictext", undefined, "Width:" ); 
    dlg.sizePnl.widthScrl = dlg.sizePnl.add( "scrollbar", undefined, 300, 300, 800 );
    dlg.sizePnl.widthEt = dlg.sizePnl.add( "edittext" );
    dlg.show();
    dlg.center();
    */

    //alert("Executing Render_32Bits", "Seneca Extension",false)
    //alert( "Script full path: " + $.fileName + "\nOS: " + $.os)
    //$.colorPicker(name)
    //$.writeln("Hola desde la consola")
    //prompt("Set default shared folder", shared_folder, "Seneca Extension")
        
    // If no open document: return
    if (documents.length == 0) {
        alert("There are no documents open.");
        return;
    }

    // Check if the temp folder exists
    if (!Folder(tempFolderPath).exists)
    {
        // Alert user and exit
        alert( "ERROR: Temp folder not found!", "Seneca Extension",false)
    }

	try {
        var docRef = activeDocument;
        
        // Save current history state
        var savedState = docRef.activeHistoryState
        
        // Crop document using current selection
        docRef.crop( docRef.selection.bounds )
         
        // Duplicate the document
        var croppedDoc = app.activeDocument.duplicate()
        
        // Back to the saved history state
        app.activeDocument = docRef; 
        docRef.activeHistoryState = savedState;
        
        // Flatten
        app.activeDocument = croppedDoc; 
        croppedDoc.flatten();
        
        // Save cropped depthmap inside temp folder
        var saveFile = new File(tempFolderPath + "/" + "temp_ps_to_grass.tif");
        var tiffSaveOptions = new TiffSaveOptions();
        tiffSaveOptions = new TiffSaveOptions();
        tiffSaveOptions.embedColorProfile = false;
        tiffSaveOptions.imageCompression = TIFFEncoding.NONE;
        croppedDoc.saveAs(saveFile, tiffSaveOptions, true, Extension.LOWERCASE);
           
        // Execute a batch file that runs the Python script with Grass commands inside  
        cleanCommFile()        
        var batchfile = new File( tempFolderPath + "/" + "shade.bat")
        batchfile.execute()
        
        while (true)
        {
            // Check if the file exists
            var messageJobDoneFile = new File(tempFolderPath + "/" + "grass_job_done.txt");
            if (messageJobDoneFile.exists == true)
            {
                var imgFile = new File(tempFolderPath + "/" + "temp_ps_to_grass_shaded.png");
                var newDocument = app.open( imgFile )
                newDocument.activeLayer.copy()
                app.activeDocument = docRef
                app.activeDocument.paste()
                newDocument.close()
                imgFile.remove()
                break
            }
        }
        
        // Close temp doc
        croppedDoc.close(SaveOptions.DONOTSAVECHANGES);
        
        // Delete from history all the commands your script generated:
        //app.purge (PurgeTarget.HISTORYCACHES);
    }
    catch(e) {
		// it's ok if we don't have any options, continue with defaults
	}
}

function cleanCommFile() {
    var messageJobDoneFile = new File(tempFolderPath + "/" + "grass_job_done.txt");
    if (messageJobDoneFile.exists == true)
    {
        messageJobDoneFile.remove()
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// REFERENCES
//-----------------------------------------------------------------------------------------------------------------------------------------------
// https://extendscript.docsforadobe.dev/extendscript-tools-features/user-notification-dialogs.html#examples
