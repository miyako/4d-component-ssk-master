Class constructor
	
Function build($name : Text)
	
	$compileProject:=File:C1566(Structure file:C489; fk platform path:K87:2)
	
	If ($name="")
		$name:=$compileProject.name
	End if 
	
	var $buildApp : cs:C1710.BuildApp
	$buildApp:=cs:C1710.BuildApp.new()
	$buildApp.BuildApplicationName:=$name
	$buildApp.BuildComponent:=True:C214
	$buildApp.PackProject:=True:C214
	
	var $destFolder : 4D:C1709.Folder
	$destFolder:=Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent
	
	If (Is macOS:C1572)
		$buildApp.BuildMacDestFolder:=$destFolder.platformPath
	Else 
		$buildApp.BuildWinDestFolder:=$destFolder.platformPath
	End if 
	
	$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	$tempFolder.create()
	$buildProject:=$tempFolder.file("buildApp.4DSettings")
	
	$buildApp.toFile($buildProject)
	
	var $CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=cs:C1710.BuildApp_CLI.new()
	$CLI.compile($compileProject)
	$CLI.build($buildProject; $compileProject)
	
	$CLI.print($destFolder.folder("Components").folder($name+".4dbase").path; "244").LF()