Class extends CLI

Function build($buildProject : 4D:C1709.File; $compileProject : 4D:C1709.File; $buildDestinationPath : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	var $BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=cs:C1710.BuildApp.new($buildProject)
	
	$BuildApp.findLicenses()
	
	var $BuildApplicationName; $CompanyName : Text
	
	$BuildApplicationName:=$CLI._getStringValue($BuildApp; "BuildApplicationName")
	
	If ($BuildApplicationName#"")
		$BuildApplicationName:=$BuildApp.BuildApplicationName
	Else 
		$BuildApplicationName:=$compileProject.name
	End if 
	
	$CLI._printTask("Set application name")
	$CLI._printItem($BuildApplicationName)
	
	$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName")
	
	If ($CompanyName="")
		$CompanyName:="com.4d"
	End if 
	
	$CLI._printTask("Set identifier prefix")
	$CLI._printItem($CompanyName)
	
	var $version; $domain : Text
	$version:=This:C1470._getVersionFromPackageJson($compileProject)
	
	If ($version#"")
		For each ($domain; ["Client"; "Common"; "RuntimeVL"; "Server"])
			$BuildApp.Versioning[$domain][$domain+"Version"]:=$version
		End for each 
	End if 
	
	$BuildDestFolderPath:=This:C1470._setDestination($BuildApp; $buildDestinationPath)
	
	var $platform : Text
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	$targets:=New collection:C1472
	
	If (Bool:C1537($BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt))
		If (Bool:C1537($BuildApp.BuildApplicationSerialized))
			$targets.push("Serialized")
		End if 
		If (Bool:C1537($BuildApp.BuildApplicationLight))
			$targets.push("Light")
		End if 
	End if 
	If (Bool:C1537($BuildApp.BuildComponent))
		$targets.push("Component")
	End if 
	If (Bool:C1537($BuildApp.CS.BuildServerApplication))
		If (Bool:C1537($BuildApp.SourcesFiles.CS.ServerIncludeIt))
			$targets.push("Server")
		End if 
		If (Bool:C1537($BuildApp.SourcesFiles.CS.ClientMacIncludeIt))
			$targets.push("ClientMac")
		End if 
		If (Bool:C1537($BuildApp.SourcesFiles.CS.ClientWinIncludeIt))
			$targets.push("ClientWin")
		End if 
	End if 
	If (Bool:C1537($BuildApp.BuildCompiled))
		$targets.push("Compiled")
	End if 
	
	$CLI._printTask("Set targets")
	$CLI._printList($targets)
	
	var $xmlParser : cs:C1710._SettingsXmlParser
	
	$xmlParser:=cs:C1710._SettingsXmlParser.new()
	
	$settings:=$xmlParser.parse($compileProject)
	
	$sdi_application:=$settings.sdi_application
	$publication_name:=$settings.publication_name
	
	If ($publication_name="")
		$publication_name:=$compileProject.name
	End if 
	
	$BuildCSUpgradeable:=$CLI._getBoolValue($BuildApp; "CS.BuildCSUpgradeable")
	If (Not:C34($targets.includes("Server")))
		$BuildApp.CS.BuildCSUpgradeable:=False:C215
	End if 
	
	var $BuildDestFolder : 4D:C1709.Folder
	
	For each ($target; $targets.orderBy(ck descending:K85:8))
		
		Case of 
			: ($target="Serialized") | ($target="Light")
				
				If ($BuildDestFolderPath#"")
					
					$BuildDestFolder:=Folder:C1567($BuildDestFolderPath; fk platform path:K87:2).folder("Final Application")
					$BuildDestFolder.create()
					
					$CLI._printTask("Set destination folder")
					$CLI._printStatus($BuildDestFolder#Null:C1517)
					$CLI._printPath($BuildDestFolder)
					
					$RuntimeVL___Folder:="RuntimeVL"+$platform+"Folder"
					
					$RuntimeVLFolderPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.RuntimeVL."+$RuntimeVL___Folder)
					
					If ($RuntimeVLFolderPath#"")
						
						var $RuntimeVLFolder : 4D:C1709.Folder
						$RuntimeVLFolder:=Folder:C1567($RuntimeVLFolderPath; fk platform path:K87:2)
						
						$CLI._printTask("Check runtime folder")
						$CLI._printStatus($RuntimeVLFolder.exists)
						$CLI._printPath($RuntimeVLFolder)
						
						If ($RuntimeVLFolder.exists)
							
							$targetRuntimeVLFolder:=$CLI._copyRuntime($BuildApp; $RuntimeVLFolder; $BuildDestFolder; $compileProject; $BuildApplicationName; $sdi_application; $publication_name)
							
							$CLI._copyPlugins($BuildApp; $targetRuntimeVLFolder; $compileProject; $target)
							
							$CLI._copyComponents($BuildApp; $targetRuntimeVLFolder; $compileProject; $target)
							
							$CLI._updateProperty($BuildApp; $targetRuntimeVLFolder; $CompanyName; $BuildApplicationName; $sdi_application; $publication_name)
							
							$CLI._copyDatabase($BuildApp; $targetRuntimeVLFolder; $compileProject; $BuildApplicationName; $publication_name; $target)
							
							If ($target="Serialized")
								$CLI._generateLicense($BuildApp; $targetRuntimeVLFolder; $target)
							End if 
							
							$CLI.quickSign($BuildApp; $targetRuntimeVLFolder)
							
						End if 
						
					End if 
					
				End if 
				
			: ($target="Server")
				
				If ($BuildDestFolderPath#"")
					
					$BuildDestFolder:=Folder:C1567($BuildDestFolderPath; fk platform path:K87:2).folder("Client Server executable")
					$BuildDestFolder.create()
					
					$CLI._printTask("Set destination folder")
					$CLI._printStatus($BuildDestFolder#Null:C1517)
					$CLI._printPath($BuildDestFolder)
					
					$Server___Folder:="Server"+$platform+"Folder"
					
					$ServerFolderPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$Server___Folder)
					
					If ($ServerFolderPath#"")
						
						var $ServerFolder : 4D:C1709.Folder
						$ServerFolder:=Folder:C1567($ServerFolderPath; fk platform path:K87:2)
						
						$CLI._printTask("Check server runtime folder")
						$CLI._printStatus($ServerFolder.exists)
						$CLI._printPath($ServerFolder)
						
						If ($ServerFolder.exists)
							
							$targetServerFolder:=$CLI._copyRuntime($BuildApp; $ServerFolder; $BuildDestFolder; $compileProject; $BuildApplicationName; $sdi_application; $publication_name; $target)
							
							$CLI._copyPlugins($BuildApp; $targetServerFolder; $compileProject; $target)
							
							$CLI._copyComponents($BuildApp; $targetServerFolder; $compileProject; $target)
							
							$CLI._updateProperty($BuildApp; $targetServerFolder; $CompanyName; $BuildApplicationName; $sdi_application; $publication_name; $target)
							
							$CLI._copyDatabase($BuildApp; $targetServerFolder; $compileProject; $BuildApplicationName; $publication_name; $target)
							
							$IsOEM:=$CLI._getBoolValue($BuildApp; "SourcesFiles.CS.IsOEM")
							
							If ($IsOEM)
								$CLI._generateLicense($BuildApp; $targetServerFolder; $target)
							End if 
							
							$CLI.quickSign($BuildApp; $targetServerFolder)
							
							$success:=True:C214
							
						End if 
						
					End if 
					
				End if 
				
			: ($target="Compiled")
				
				If ($BuildDestFolderPath#"")
					
					$BuildDestFolder:=Folder:C1567($BuildDestFolderPath; fk platform path:K87:2).folder("Compiled Database")
					$BuildDestFolder.create()
					
					$targetFolder:=$BuildDestFolder.folder($BuildApplicationName)
					
					$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
					
					If ($targetFolder.path#$localProjectFolder.path)
						If ($targetFolder.exists)
							$targetFolder.delete(Delete with contents:K24:24)
						End if 
					End if 
					
					$targetFolder.create()
					
					$CLI._printTask("Set destination folder")
					$CLI._printStatus($targetFolder.exists)
					$CLI._printPath($targetFolder)
					
					$CLI._copyDatabase($BuildApp; $targetFolder; $compileProject; $BuildApplicationName; $publication_name; $target)
					
					$CLI._copyPlugins($BuildApp; $targetFolder; $compileProject; $target)
					
					$CLI._copyComponents($BuildApp; $targetServerFolder; $compileProject; $target)
					
					$CLI.quickSign($BuildApp; $targetFolder)
					
					$success:=True:C214
					
				End if 
				
			: ($target="Component")
				
				If ($BuildDestFolderPath#"")
					
					$BuildDestFolder:=Folder:C1567($BuildDestFolderPath; fk platform path:K87:2).folder("Components")
					$BuildDestFolder.create()
					
					$targetPackage:=$BuildDestFolder.folder($BuildApplicationName+".4dbase")
					
					$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
					
					If ($targetPackage.path#$localProjectFolder.path)
						If ($targetPackage.exists)
							$targetPackage.delete(Delete with contents:K24:24)
						End if 
					End if 
					
					$targetPackage.create()
					
					$CLI._printTask("Set destination folder")
					$CLI._printStatus($targetPackage.exists)
					$CLI._printPath($targetPackage)
					
					$CLI._copyDatabase($BuildApp; $targetPackage; $compileProject; $BuildApplicationName; $publication_name; $target)
					
					$CLI.quickSign($BuildApp; $targetPackage)
					
					$success:=True:C214
					
				End if 
				
			: (($target="ClientMac") | ($target="ClientWin")) && (Not:C34($BuildCSUpgradeable))
				
				If ($BuildDestFolderPath#"")
					
					$BuildDestFolder:=Folder:C1567($BuildDestFolderPath; fk platform path:K87:2).folder("Client Server executable")
					$BuildDestFolder.create()
					
					$CLI._printTask("Set destination folder")
					$CLI._printStatus($BuildDestFolder#Null:C1517)
					$CLI._printPath($BuildDestFolder)
					
					If (Is macOS:C1572)
						$Client___Folder:="Client"+$platform+"FolderToMac"
					Else 
						$Client___Folder:="Client"+$platform+"FolderToWin"
					End if 
					
					$ClientFolderPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$Client___Folder)
					
					If ($ClientFolderPath#"")
						
						var $ClientFolder : 4D:C1709.Folder
						$ClientFolder:=Folder:C1567($ClientFolderPath; fk platform path:K87:2)
						
						$CLI._printTask("Check runtime folder")
						$CLI._printStatus($ClientFolder.exists)
						$CLI._printPath($ClientFolder)
						
						If ($ClientFolder.exists)
							
							$targetClientFolder:=$CLI._copyRuntime($BuildApp; $ClientFolder; $BuildDestFolder; $compileProject; $BuildApplicationName; $sdi_application; $publication_name; $target)
							
							$CLI._updateProperty($BuildApp; $targetClientFolder; $CompanyName; $BuildApplicationName; $sdi_application; $publication_name; $target)
							
							$CLI._copyDatabase($BuildApp; $targetClientFolder; $compileProject; $BuildApplicationName; $publication_name; $target)
							
							$IsOEM:=$CLI._getBoolValue($BuildApp; "SourcesFiles.CS.IsOEM")
							
							If ($IsOEM)
								$CLI._generateLicense($BuildApp; $targetClientFolder; $target)
							End if 
							
							$CLI.quickSign($BuildApp; $targetClientFolder)
							
							$success:=True:C214
							
						End if 
						
					End if 
					
				End if 
				
		End case 
		
	End for each 
	
Function clean($compileProject : 4D:C1709.File)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$packageFolder:=$compileProject.parent.parent
	
	$folders:=New collection:C1472
	
	For each ($folder; $packageFolder.folders(fk ignore invisible:K87:22))
		If ($folder.fullName="userPreferences.@")
			$_folder:=$folder.folder("CompilerIntermediateFiles")
			If ($_folder.exists)
				$folders.push($_folder)
			End if 
		End if 
	End for each 
	
	If ($folders.length#0)
		$CLI._printTask("Delete compiler intermediate files").LF()
		For each ($folder; $folders)
			$CLI._printPath($folder)
			$folder.delete(Delete with contents:K24:24)
		End for each 
	End if 
	
	$DerivedDataFolder:=$packageFolder.folder("Project").folder("DerivedData")
	If ($DerivedDataFolder.exists)
		$CLI._printTask("Delete derived data").LF()
		$CLI._printPath($DerivedDataFolder)
		$DerivedDataFolder.delete(Delete with contents:K24:24)
	End if 
	
Function compile($compileProject : 4D:C1709.File)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$localProjectFile:=File:C1566(Structure file:C489; fk platform path:K87:2)
	
	If ($compileProject.path=$localProjectFile.path) && (Is compiled mode:C492)
		
		//skip
		
	Else 
		
		$options:=New object:C1471
		$options.generateSymbols:=False:C215
		$options.generateSyntaxFile:=True:C214
		
		$BuildApp:=cs:C1710.BuildApp.new()
		
		$options.plugins:=$BuildApp.findPluginsFolder($compileProject)
		
		If ($options.plugins#Null:C1517)
			$CLI._printTask("Use plugins")
			$plugins:=$BuildApp.findPlugins($compileProject)
			$CLI._printList($plugins.extract("folder.name"))
			$CLI._printPath($options.plugins)
		End if 
		
		$options.components:=$BuildApp.findComponents($compileProject; True:C214)
		
		If ($options.components.length#0)
			$CLI._printTask("Use components")
			$CLI._printList($options.components.extract("name"))
			For each ($component; $BuildApp.findComponents($compileProject))
				$CLI._printPath($component)
			End for each 
		End if 
		
		If (Is macOS:C1572)
			$options.targets:=New collection:C1472("arm64_macOS_lib"; "x86_64_generic")
		End if 
		
		$CLI._printTask("Compile project")
		
		$status:=Compile project:C1760($compileProject; $options)
		
		$CLI._printStatus($status.success)
		$CLI._printPath($compileProject)
		
		For each ($error; $status.errors)
			If ($error.isError)
				$CLI.print($error.message; "177;bold")
			Else 
				$CLI.print($error.message; "166;bold")
			End if 
			If ($error.code#Null:C1517)
				$CLI.print("...").print($error.code.path+"#"+String:C10($error.lineInFile); "244").LF()
			End if 
		End for each 
		
	End if 
	
Function quickSign($BuildApp : cs:C1710.BuildApp; $RuntimeFolder : 4D:C1709.Folder)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	If (Is macOS:C1572)
		
		$CLI._printTask("Sign app")
		$CLI._printPath($RuntimeFolder)
		
		sign($BuildApp; $RuntimeFolder)
		
	End if 
	
Function _copyComponents($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$compileProject : 4D:C1709.File; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	$components:=$BuildApp.findComponents($compileProject)
	
	If (Is Windows:C1573)
		$ContentsFolder:=$RuntimeFolder
	Else 
		$ContentsFolder:=$RuntimeFolder.folder("Contents")
	End if 
	
	Case of 
		: ($buildApplicationType="Compiled")
			$targetComponentsFolder:=$RuntimeFolder.parent.folder("Components")
		Else 
			$targetComponentsFolder:=$ContentsFolder.folder("Components")
	End case 
	
	var $component : Object
	
	For each ($component; $components)
		
		Case of 
			: ($component.extension=".4DProject")
				//interpreted component for dev
			: ($BuildApp.ArrayExcludedComponentName.Item.includes($component.name))
				
			Else 
				
				$targetComponentsFolder.create()
				$targetComponent:=$component.copyTo($targetComponentsFolder; fk overwrite:K87:5)
				
				$CLI._printTask("Copy component")
				$CLI._printItem($component.name)
				$CLI._printPath($targetComponent)
				
		End case 
		
	End for each 
	
Function _copyDatabase($BuildApp : cs:C1710.BuildApp; \
$targetFolder : 4D:C1709.Folder; \
$sourceProjectFile : 4D:C1709.File; $BuildApplicationName : Text; $publication_name : Text; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	$BuildCSUpgradeable:=$CLI._getBoolValue($BuildApp; "CS.BuildCSUpgradeable")
	
	$ProjectFolder:=$sourceProjectFile.parent
	
	var $ContentsFolder : 4D:C1709.Folder
	
	If (Is Windows:C1573)
		$ContentsFolder:=$targetFolder
	Else 
		$ContentsFolder:=$targetFolder.folder("Contents")
	End if 
	
	Case of 
		: ($buildApplicationType="Compiled")
			$ContentsFolder:=$targetFolder
		: ($buildApplicationType="Component")
			$ContentsFolder:=$targetFolder
		: ($buildApplicationType="Server")
			$ContentsFolder:=$ContentsFolder.folder("Server Database")
		Else 
			$ContentsFolder:=$ContentsFolder.folder("Database")
	End case 
	
	$ContentsFolder.create()
	
	var $targetEmbedProjectFile : 4D:C1709.File
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	$DatabaseToEmbedInClientFolder:="DatabaseToEmbedInClient"+$platform+"Folder"
	
	$DatabaseToEmbedInClient:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$DatabaseToEmbedInClientFolder)
	
	Case of 
		: (($buildApplicationType="Client@") && (Not:C34($BuildCSUpgradeable))) || ($buildApplicationType="Upgrade4DClient")
			
			If ($DatabaseToEmbedInClient#"")
				
				$targetName:=$BuildApplicationName+" Client"
				
				$startupProjectFolder:=Folder:C1567($DatabaseToEmbedInClient; fk platform path:K87:2)
				
				If ($startupProjectFolder.exists)
					
					$CLI._printTask("Copy startup project").LF()
					
					$folders:=$startupProjectFolder.folders(fk ignore invisible:K87:22).query("name in :1"; New collection:C1472("Components"; "Resources"; "Libraries"; "Extras"))
					
					For each ($folder; $folders)
						$targetProjectFolder:=$folder.copyTo($ContentsFolder)
						$CLI._printPath($targetProjectFolder)
					End for each 
					
					For each ($file; $startupProjectFolder.files(fk ignore invisible:K87:22))
						$targetProjectFile:=$file.copyTo($ContentsFolder)
						If ($targetProjectFile.extension=".4DZ")
							$targetProjectFile.rename($targetName+".4DZ")
						End if 
						$CLI._printPath($targetProjectFile)
					End for each 
					
				End if 
				
				$PluginsFolder:=$startupProjectFolder.folder("Plugins")
				$bundles:=$PluginsFolder.folders(fk ignore invisible:K87:22).query("extension == :1"; ".bundle")
				
				If ($bundles.length#0)
					
					$targetPluginsFolder:=$ContentsFolder.parent.folder("Plugins")
					$targetPluginsFolder.create()
					
					$CLI._printTask("Copy startup plugins").LF()
					
					For each ($bundle; $bundles)
						$CLI._printPath($bundle.copyTo($targetPluginsFolder; fk overwrite:K87:5))
					End for each 
					
				End if 
				
			Else 
				
				var $EnginedServer : Text
				$database_shortcut:=DOM Create XML Ref:C861("database_shortcut")
				DOM SET XML ATTRIBUTE:C866($database_shortcut; "is_remote"; True:C214)
				DOM SET XML ATTRIBUTE:C866($database_shortcut; "server_database_name"; $publication_name)
				
				$IPAddress:=$CLI._getStringValue($BuildApp; "CS.IPAddress")
				$PortNumber:=$CLI._getIntValue($BuildApp; "CS.PortNumber")
				
				var $server_path : Text
				
				If ($IPAddress#"")
					$server_path:=$IPAddress
				End if 
				If ($PortNumber>0)
					$server_path:=$server_path+":"+String:C10($PortNumber)
				Else 
					$server_path:=$server_path+":19813"
				End if 
				
				If ($server_path#"")
					DOM SET XML ATTRIBUTE:C866($database_shortcut; "server_path"; $server_path)
				End if 
				
				$ClientServerSystemFolderName:=$CLI._getStringValue($BuildApp; "CS.ClientServerSystemFolderName")
				
				If ($ClientServerSystemFolderName#"")
					DOM SET XML ATTRIBUTE:C866($database_shortcut; "cache_folder_name"; $ClientServerSystemFolderName)
				End if 
				
				$linkFile:=$ContentsFolder.file("EnginedServer.4DLink")
				
				DOM EXPORT TO FILE:C862($database_shortcut; $linkFile.platformPath)
				DOM CLOSE XML:C722($database_shortcut)
				
				$CLI._printTask("Create link file")
				$CLI._printStatus($linkFile.exists)
				$CLI._printPath($linkFile)
				
			End if 
			
		: ($buildApplicationType="Client@")
			//keep it
		Else 
			
			$CompiledDatabaseToIncludeIt:=$CLI._getBoolValue($BuildApp; "CS.MacCompiledDatabaseToWinIncludeIt")
			$CompiledDatabaseToInclude:=$CLI._getStringValue($BuildApp; "CS.MacCompiledDatabaseToWin")
			
			If ($buildApplicationType="Server") && ($CompiledDatabaseToIncludeIt) && ($CompiledDatabaseToInclude#"")
				
				$MacProjectFolder:=Folder:C1567($CompiledDatabaseToInclude; fk platform path:K87:2)
				
				If ($MacProjectFolder.exists)
					
					$CLI._printTask("Copy compiled mac project").LF()
					
					$folders:=$MacProjectFolder.folders(fk ignore invisible:K87:22).query("name in :1"; New collection:C1472("Components"; "Resources"; "Libraries"; "Extras"))
					
					For each ($folder; $folders)
						$targetProjectFolder:=$folder.copyTo($ContentsFolder)
						$CLI._printPath($targetProjectFolder)
					End for each 
					
					For each ($file; $MacProjectFolder.files(fk ignore invisible:K87:22))
						$targetProjectFile:=$file.copyTo($ContentsFolder)
						If ($targetProjectFile.extension=".4DZ")
							$targetProjectFile.rename($BuildApplicationName+".4DZ")
						End if 
						$CLI._printPath($targetProjectFile)
					End for each 
					
				End if 
				
			Else 
				
				$targetProjectFolder:=$ProjectFolder.copyTo($ContentsFolder)
				
				$CLI._printTask("Set database folder")
				$CLI._printStatus($targetProjectFolder.exists)
				$CLI._printPath($targetProjectFolder)
				
				$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
				
				If ($targetProjectFolder.path#($localProjectFolder.path+"@"))
					
					$folders:=New collection:C1472($targetProjectFolder.folder("Trash"))
					$folders.push($targetProjectFolder.folder("Sources").folder("DatabaseMethods"))
					$folders.push($targetProjectFolder.folder("Sources").folder("TableForms"))
					$folders.push($targetProjectFolder.folder("Sources").folder("Triggers"))
					$folders.push($targetProjectFolder.folder("Sources").folder("Classes"))
					$folders.push($targetProjectFolder.folder("Sources").folder("Methods"))
					$folders.push($targetProjectFolder.folder("Sources").folder("Forms"))
					
					$files:=New collection:C1472
					
					For each ($folder; $folders)
						$files.combine($folder.files(fk ignore invisible:K87:22).query("extension == :1"; ".4dm"))
					End for each 
					
					For each ($file; $files)
						$file.delete()
					End for each 
					
					$Forms:=$folders.pop()
					
					For each ($folder; $folders)
						$folder.delete(Delete with contents:K24:24)
					End for each 
					
				End if 
				
				$files:=$ContentsFolder.folder("Project").files(fk ignore invisible:K87:22).query("extension == :1"; ".4DProject")
				
				If ($files.length#0)
					
					$targetProjectFile:=$files[0]
					
					$PortNumber:=$CLI._getIntValue($BuildApp; "CS.PortNumber")
					
					If ($PortNumber>0)
						
						var $xmlParser : cs:C1710._SettingsXmlParser
						
						$xmlParser:=cs:C1710._SettingsXmlParser.new()
						
						$xmlParser.setPortNumber($targetProjectFile; $PortNumber)
						
					End if 
					
					$CLI._printTask("Rename project")
					$targetProjectFile:=$targetProjectFile.rename($BuildApp.BuildApplicationName+".4DProject")
					$CLI._printStatus($targetProjectFile.exists)
					$CLI._printPath($targetProjectFile)
					
					$PackProject:=$CLI._getBoolValue($BuildApp; "PackProject")
					
					If ($PackProject)
						
						$zip:=New object:C1471
						$zip.files:=New collection:C1472($targetProjectFolder)
						
						$UseStandardZipFormat:=$CLI._getBoolValue($BuildApp; "UseStandardZipFormat")
						
						If ($UseStandardZipFormat)
							$zip.encryption:=ZIP Encryption none:K91:3
						Else 
							$zip.encryption:=-1
						End if 
						
						$targetProjectFile:=$ContentsFolder.file($BuildApp.BuildApplicationName+".4DZ")
						
						$zip.callback:=$CLI._zipCallback2
						
						$CLI._printTask("Archive project folder")
						
						$status:=ZIP Create archive:C1640($zip; $targetProjectFile)
						
						$CLI.CR()._printTask("Archive project folder")
						$CLI._printStatus($status.success)
						$CLI._printPath($targetProjectFile)
						
						If ($targetProjectFolder.path#$localProjectFolder.path)
							$targetProjectFolder.delete(Delete with contents:K24:24)
						End if 
						
					End if 
					
					$folders:=$ProjectFolder.parent.folders(fk ignore invisible:K87:22).query("name in :1"; New collection:C1472("Resources"; "Libraries"; "Default Data"; "Extras"))
					
					If ($folders.length#0)
						
						$CLI._printTask("Copy database folders").LF()
						For each ($folder; $folders)
							If (Not:C34($PackProject)) && ($folder.name#"Default Data")
								$CLI._printPath($folder.copyTo($ContentsFolder.folder("Project")))
							Else 
								$CLI._printPath($folder.copyTo($ContentsFolder))
							End if 
						End for each 
						
					End if 
					
				End if 
				
			End if 
			
	End case 
	
	Case of 
		: ($buildApplicationType="Server")
			
			$ServerEmbedsProjectDirectory:=$CLI._getBoolValue($BuildApp; "CS.ServerEmbedsProjectDirectoryFile")
			
			If ($ServerEmbedsProjectDirectory)
				$directoryFile:=$ProjectFolder.parent.folder("Settings").file("directory.json")
				If ($directoryFile.exists)
					$targetDirectoryFile:=$directoryFile.copyTo($targetProjectFolder.parent.folder("Settings"))
					
					$CLI._printTask("Copy directory file")
					$CLI._printStatus($targetDirectoryFile.exists)
					$CLI._printPath($targetDirectoryFile)
					
				End if 
			End if 
			
	End case 
	
Function _copyPlugins($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$compileProject : 4D:C1709.File; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	var $plugins : Collection
	
	$plugins:=$BuildApp.findPlugins($compileProject)
	
	If (Is Windows:C1573)
		$ContentsFolder:=$RuntimeFolder
	Else 
		$ContentsFolder:=$RuntimeFolder.folder("Contents")
	End if 
	
	Case of 
		: ($buildApplicationType="Compiled")
			$targetPluginsFolder:=$ContentsFolder.parent.folder("Plugins")
		Else 
			$targetPluginsFolder:=$ContentsFolder.folder("Plugins")
	End case 
	
	var $plugin : Object
	
	For each ($plugin; $plugins)
		
		Case of 
			: ($BuildApp.ArrayExcludedPluginID.Item.includes($plugin.manifest.id))
				
			: ($BuildApp.ArrayExcludedPluginName.Item.includes($plugin.manifest.name))
				
			Else 
				
				$targetPluginsFolder.create()
				$targetPlugin:=$plugin.folder.copyTo($targetPluginsFolder; fk overwrite:K87:5)
				
				$CLI._printTask("Copy plugin")
				$CLI._printItem($plugin.manifest.name)
				$CLI._printPath($targetPlugin)
				
		End case 
		
	End for each 
	
Function _copyRuntime($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$BuildDestFolder : 4D:C1709.Folder; $compileProject : 4D:C1709.File; $BuildApplicationName : Text; \
$sdi_application : Boolean; $publication_name : Text; $buildApplicationType : Text)->$targetFolder : 4D:C1709.Folder
	
	$CLI:=This:C1470
	
	$BuildCSUpgradeable:=$CLI._getBoolValue($BuildApp; "CS.BuildCSUpgradeable")
	
	Case of 
		: ($buildApplicationType="Server")
			$targetName:=$BuildApplicationName+" Server"
		: ($buildApplicationType="Client@") | ($buildApplicationType="Upgrade4DClient")
			$targetName:=$BuildApplicationName+" Client"
		Else 
			$targetName:=$BuildApplicationName
	End case 
	
	If (Is macOS:C1572)
		$targetName:=$targetName+".app"
	End if 
	
	$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
	
	$targetFolder:=$BuildDestFolder.folder($targetName)
	
	If ($targetFolder.exists)
		If ($targetFolder.path#($localProjectFolder.path+"@"))
			
			If ($buildApplicationType="Client@") && ($BuildCSUpgradeable)
				//keep it
			Else 
				$targetFolder.delete(Delete with contents:K24:24)
			End if 
		End if 
	End if 
	
	If ($buildApplicationType="Client@") && ($BuildCSUpgradeable)
		$targetFolder:=$BuildDestFolder.folder($targetName)
	Else 
		$targetFolder:=$RuntimeFolder.copyTo($BuildDestFolder; $targetName; fk overwrite:K87:5)
		$CLI._printTask("Copy runtime folder")
		$CLI._printStatus($targetFolder.exists)
		$CLI._printPath($targetFolder)
	End if 
	
	If ($targetFolder.exists)
		
		If (Is Windows:C1573)
			$ContentsFolder:=$targetFolder
		Else 
			$ContentsFolder:=$targetFolder.folder("Contents")
		End if 
		
		Case of 
			: ($buildApplicationType="Server")
				$RuntimeExecutableName:="4D Server"
			Else 
				$RuntimeExecutableName:="4D Volume Desktop"
		End case 
		
		Case of 
			: ($buildApplicationType="Client@") | ($buildApplicationType="Upgrade4DClient")
				$executableName:=$BuildApplicationName+" Client"
			Else 
				$executableName:=$BuildApplicationName
		End case 
		
		If (Is macOS:C1572)
			$executableFile:=$ContentsFolder.folder("MacOS").file($RuntimeExecutableName)
		Else 
			$executableName:=$executableName+".exe"
			Case of 
				: ($buildApplicationType="Server")
					$executableFile:=$targetFolder.file($RuntimeExecutableName+".exe")
				Else 
					$executableFile:=$targetFolder.file($RuntimeExecutableName+".4DE")
			End case 
		End if 
		
		If ($buildApplicationType="Client@") && ($BuildCSUpgradeable)
			//keep it
		Else 
			$targetExecutableFile:=$executableFile.rename($executableName)
			$CLI._printTask("Rename executable file")
			$CLI._printStatus($targetExecutableFile.exists)
			$CLI._printPath($targetExecutableFile)
		End if 
		
		If ($buildApplicationType="Client@") && ($BuildCSUpgradeable)
			//keep it
		Else 
			If (Is Windows:C1573)
				Case of 
					: ($buildApplicationType="Server")
						$resourceFile:=$ContentsFolder.folder("Resources").file($RuntimeExecutableName+".rsr")
					Else 
						$resourceFile:=$ContentsFolder.file($RuntimeExecutableName+".rsr")
				End case 
				$targetResourceFile:=$resourceFile.rename($BuildApplicationName+".rsr")
			Else 
				$resourceFile:=$ContentsFolder.folder("Resources").file($RuntimeExecutableName+".rsrc")
				$targetResourceFile:=$resourceFile.rename($BuildApplicationName+".rsrc")
			End if 
			$CLI._printTask("Rename resource file")
			$CLI._printStatus($targetResourceFile.exists)
			$CLI._printPath($targetResourceFile)
		End if 
		
		Case of 
			: ($buildApplicationType="Server")
				
				If ($BuildCSUpgradeable)
					
					$Upgrade4DClientFolder:=$ContentsFolder.folder("Upgrade4DClient")
					
					$Upgrade4DClientFolder.create()
					
					$info:=$CLI._createUpgradeClientManifest($BuildApp; $BuildApplicationName)
					
					//opposite platform (.4darchive)
					
					$targetPlatform:=(Is macOS:C1572 ? "Win" : "Mac")
					$hostPlatform:=(Is macOS:C1572 ? "Mac" : "Win")
					
					$Client___IncludeIt:=$CLI._getBoolValue($BuildApp; "SourcesFiles.CS.Client"+$targetPlatform+"IncludeIt")
					$Client___FolderPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS.Client"+$targetPlatform+"FolderTo"+$hostPlatform)
					$Client___IconFor___Path:="Client"+$targetPlatform+"IconFor"+$hostPlatform+"Path"
					$ClientIconPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$Client___IconFor___Path)
					
					If ($Client___IncludeIt) && ($Client___FolderPath#"")
						
						$ClientFile:=File:C1566($Client___FolderPath; fk platform path:K87:2)
						$CLI._printTask("Check client file")
						$CLI._printStatus($ClientFile.exists)
						$CLI._printPath($ClientFile)
						
						If ($ClientFile.exists)
							
							$_targetPlatform:=Lowercase:C14($targetPlatform; *)
							
							$info[$_targetPlatform+"Update"]:="update."+$_targetPlatform+".4darchive"
							$targetClientFile:=$ClientFile.copyTo($Upgrade4DClientFolder; "update."+$_targetPlatform+".4darchive")
							$CLI._printTask("Copy client file")
							$CLI._printStatus($targetClientFile.exists)
							$CLI._printPath($targetClientFile)
							
						End if 
					End if 
					
					//host platform (.exe or .app)
					
					$Client___IncludeIt:=$CLI._getBoolValue($BuildApp; "SourcesFiles.CS.Client"+$hostPlatform+"IncludeIt")
					$Client___FolderPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS.Client"+$hostPlatform+"FolderTo"+$hostPlatform)
					$Client___IconFor___Path:="Client"+$hostPlatform+"IconFor"+$hostPlatform+"Path"
					$ClientIconPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$Client___IconFor___Path)
					
					If ($Client___IncludeIt) && ($Client___FolderPath#"")
						
						var $ClientFolder : 4D:C1709.Folder
						$ClientFolder:=Folder:C1567($Client___FolderPath; fk platform path:K87:2)
						
						$CLI._printTask("Check client folder")
						$CLI._printStatus($ClientFolder.exists)
						$CLI._printPath($ClientFolder)
						
						If ($ClientFolder.exists)
							
							$_hostPlatform:=Lowercase:C14($hostPlatform; *)
							
							$info[$_hostPlatform+"Update"]:="update."+$_hostPlatform+".4darchive"
							
							$CLI._copyRuntime($BuildApp; $ClientFolder; $BuildDestFolder; $compileProject; $BuildApplicationName; $sdi_application; $publication_name; "Upgrade4DClient")
							
						End if 
						
					End if 
					
					$targetManifestFile:=$Upgrade4DClientFolder.file("info.json")
					$targetManifestFile.setText(JSON Stringify:C1217($info; *))
					
					$CLI._printTask("Create info.json")
					$CLI._printStatus($targetManifestFile.exists)
					$CLI._printPath($targetManifestFile)
					
				End if 
				
			: ($buildApplicationType="Upgrade4DClient")
				
				$target:="Client"+(Is macOS:C1572 ? "Mac" : "Win")
				
				$CLI._updateProperty($BuildApp; $targetFolder; $CompanyName; $BuildApplicationName; $sdi_application; $publication_name; $target)
				
				$CLI._copyDatabase($BuildApp; $targetFolder; $compileProject; $BuildApplicationName; $publication_name; $buildApplicationType)
				
				$IsOEM:=$CLI._getBoolValue($BuildApp; "SourcesFiles.CS.IsOEM")
				
				If ($IsOEM)
					$CLI._generateLicense($BuildApp; $targetFolder; $target)
				End if 
				
				$CLI.quickSign($BuildApp; $targetFolder)
				
				$zip:=New object:C1471
				$zip.files:=New collection:C1472($targetFolder)
				$zip.encryption:=ZIP Encryption none:K91:3
				
				$targetServerName:=$BuildApplicationName+" Server"
				
				If (Is macOS:C1572)
					$targetServerName:=$targetServerName+".app"
				End if 
				
				$targetServerFolder:=$targetFolder.parent.folder($targetServerName)
				
				If (Is Windows:C1573)
					$Upgrade4DClientFolder:=$targetServerFolder.folder("Upgrade4DClient")
				Else 
					$Upgrade4DClientFolder:=$targetServerFolder.folder("Contents").folder("Upgrade4DClient")
				End if 
				
				$targetArchiveFile:=$Upgrade4DClientFolder.file("update."+(Is macOS:C1572 ? "mac" : "win")+".4darchive")
				
				$zip.callback:=$CLI._zipCallback1
				
				$CLI._printTask("Archive client")
				
				$status:=ZIP Create archive:C1640($zip; $targetArchiveFile)
				
				$CLI.CR()._printTask("Archive client")
				$CLI._printStatus($status.success)
				$CLI._printPath($targetArchiveFile)
				
		End case 
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("PHP"))
		
		$moduleFolder:=$ContentsFolder.folder("Resources").folder("php")
		
		If ($moduleFolder.exists)
			
			$CLI._printTask("Delete PHP module")
			$CLI._printStatus($moduleFolder.exists)
			$CLI._printPath($moduleFolder)
			
			$moduleFolder.delete(Delete with contents:K24:24)
			
		End if 
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("MeCab"))
		
		$moduleFolder:=$ContentsFolder.folder("Resources").folder("mecab")
		
		If ($moduleFolder.exists)
			
			$CLI._printTask("Delete MeCab module")
			$CLI._printStatus($moduleFolder.exists)
			$CLI._printPath($moduleFolder)
			
			$moduleFolder.delete(Delete with contents:K24:24)
			
		End if 
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("4D Updater"))
		
		$moduleFolder:=$ContentsFolder.folder("Resources").folder("Updater")
		
		If ($moduleFolder.exists)
			
			$CLI._printTask("Delete 4D Updater module")
			$CLI._printStatus($moduleFolder.exists)
			$CLI._printPath($moduleFolder)
			
			$moduleFolder.delete(Delete with contents:K24:24)
			
		End if 
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("SpellChecker"))
		
		$moduleFolder:=$ContentsFolder.folder("Resources").folder("Spellcheck")
		
		If ($moduleFolder.exists)  //does not exist for server
			
			$CLI._printTask("Delete SpellChecker module")
			$CLI._printStatus($moduleFolder.exists)
			$CLI._printPath($moduleFolder)
			
			$moduleFolder.delete(Delete with contents:K24:24)
			
		End if 
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("CEF"))
		
		$moduleFolder:=$ContentsFolder.folder("Native Components").folder("WebViewerCEF.bundle")
		
		If ($moduleFolder.exists)
			
			$CLI._printTask("Delete CEF module")
			$CLI._printStatus($moduleFolder.exists)
			$CLI._printPath($moduleFolder)
			
			$moduleFolder.delete(Delete with contents:K24:24)
			
			If (Is macOS:C1572)
				//symlink
				$file:=$ContentsFolder.folder("Frameworks").file("Chromium Embedded Framework.framework")
				$CLI._printPath($file)
				$file.delete()
			Else 
				//
			End if 
			
		End if 
		
	End if 
	
Function _createUpgradeClientManifest($BuildApp : cs:C1710.BuildApp; $BuildApplicationName)->$info : Object
	
	$CLI:=This:C1470
	
	$info:=New object:C1471
	
	$info.BuildName:=$BuildApplicationName
	$info.BuildInfoVersion:=$CLI._getVersioning($BuildApp; "Version"; "Client")
	$info.BuildHardLink:=""
	$info.BuildCreator:=$CLI._getVersioning($BuildApp; "Creator"; "Client")
	$info.BuildRangeVersMin:=$CLI._getIntValue($BuildApp; "CS.RangeVersMin")
	$info.BuildRangeVersMax:=$CLI._getIntValue($BuildApp; "CS.RangeVersMax")
	$info.BuildCurrentVers:=$CLI._getIntValue($BuildApp; "CS.CurrentVers")
	$info.MacCertificate:=$CLI._getStringValue($BuildApp; "SignApplication.MacCertificate")
	$info.MacSignature:=$CLI._getBoolValue($BuildApp; "SignApplication.MacSignature")
	$info["com.4D.HideDataExplorerMenuItem"]:=$CLI._getBoolValue($BuildApp; "CS.HideDataExplorerMenuItem")
	$info["com.4D.HideRuntimeExplorerMenuItem"]:=$CLI._getBoolValue($BuildApp; "CS.HideRuntimeExplorerMenuItem")
	$info.BuildIPPort:=$CLI._getIntValue($BuildApp; "CS.PortNumber")
	$info.ServerPlatform:=Is macOS:C1572 ? "Mac" : "Win"
	
Function _generateLicense($BuildApp : cs:C1710.BuildApp; $targetFolder : 4D:C1709.Folder; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	var $platform; $ArrayLicense___ : Text
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	$ArrayLicense___:="ArrayLicense"+$platform
	
	$licenses:=$BuildApp.Licenses[$ArrayLicense___].Item
	
	$CLI._printTask("Search licenses").LF()
	
	For each ($license; $licenses)
		$license:=Path to object:C1547($license).name
		$license:=Substring:C12($license; $license="R-@" ? 3 : 1)
		$license:=Insert string:C231($license; "-"; 8)
		$license:=Insert string:C231($license; "-"; 15)
		$license:=Insert string:C231($license; "-"; 21)
		$license:=Change string:C234($license; "XXXXXX-XXXXX-XXX"; 9)
		$CLI.print($license; "244").LF()
	End for each 
	
	$UUDs:=$licenses.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4UUD@"))
	$UOEs:=$licenses.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4UOE@"))
	$UOSs:=$licenses.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4UOS@"))
	$DOMs:=$licenses.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4DOM@"))
	$DDPs:=$licenses.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4DDP@"))
	
	var $status : Object
	
	Case of 
		: ($buildApplicationType="Client@")
			
		: ($buildApplicationType="Server") && ($DOMs.length#0) && ($UOSs.length#0)
			
			$status:=Create deployment license:C1811($targetFolder; File:C1566($UOSs[0]; fk platform path:K87:2); File:C1566($DOMs[0]; fk platform path:K87:2))
			
		Else 
			
			Case of 
				: ($UOEs.length#0)
					
					$status:=Create deployment license:C1811($targetFolder; File:C1566($UOEs[0]; fk platform path:K87:2))
					
				: ($UUDs.length#0)
					
					$status:=Create deployment license:C1811($targetFolder; File:C1566($UUDs[0]; fk platform path:K87:2))
					
			End case 
			
	End case 
	
	If ($status#Null:C1517)
		
		$CLI._printTask("Generate license")
		$CLI._printStatus($status.success)
		If ($status.file#Null:C1517)
			$CLI._printPath(File:C1566($status.file))
		End if 
		For each ($error; $status.errors)
			$CLI.print($error.message; "177;bold").LF()
		End for each 
	End if 
	
Function _getBoolValue($BuildApp : cs:C1710.BuildApp; $path : Text)->$boolValue : Boolean
	
	$CLI:=This:C1470
	
	var $settings : Variant
	
	$settings:=$BuildApp
	
	$pathComponents:=Split string:C1554($path; "."; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	
	For each ($pathComponent; $pathComponents) Until ($settings=Null:C1517)
		$settings:=$settings[$pathComponent]
	End for each 
	
	If ($settings#Null:C1517)
		$boolValue:=Bool:C1537($settings)
	End if 
	
Function _getIntValue($BuildApp : cs:C1710.BuildApp; $path : Text)->$intValue : Integer
	
	$CLI:=This:C1470
	
	var $settings : Variant
	
	$settings:=$BuildApp
	
	$pathComponents:=Split string:C1554($path; "."; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	
	For each ($pathComponent; $pathComponents) Until ($settings=Null:C1517)
		$settings:=$settings[$pathComponent]
	End for each 
	
	If ($settings#Null:C1517)
		$intValue:=Int:C8(Num:C11(String:C10($settings); "."))
	End if 
	
Function _getStringValue($BuildApp : cs:C1710.BuildApp; $path : Text)->$stringValue : Text
	
	$CLI:=This:C1470
	
	var $settings : Variant
	
	$settings:=$BuildApp
	
	$pathComponents:=Split string:C1554($path; "."; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	
	For each ($pathComponent; $pathComponents) Until ($settings=Null:C1517)
		$settings:=$settings[$pathComponent]
	End for each 
	
	If ($settings#Null:C1517)
		$stringValue:=String:C10($settings)
	End if 
	
Function _getVersionFromPackageJson($compileProject : 4D:C1709.File) : Text
	
	var $packageFile : 4D:C1709.File
	$packageFile:=$compileProject.parent.parent.parent.file("package.json")
	If ($packageFile#Null:C1517) && ($packageFile.exists)
		var $json : Text
		$json:=$packageFile.getText()
		var $package : Object
		$package:=JSON Parse:C1218($json; Is object:K8:27)
		If ($package#Null:C1517)
			return $package.version
		End if 
	End if 
	
Function _getVersioning($BuildApp : cs:C1710.BuildApp; $key : Text; $domain : Text)->$value : Text
	
	If ($domain#"")
		If ($BuildApp.Versioning[$domain][$domain+$key]#Null:C1517)
			If ($BuildApp.Versioning[$domain][$domain+$key]#"")
				$value:=$BuildApp.Versioning[$domain][$domain+$key]
			End if 
		End if 
	End if 
	
	If ($value="")
		If ($BuildApp.Versioning.Common["Common"+$key]#Null:C1517)
			If ($BuildApp.Versioning.Common["Common"+$key]#"")
				$value:=$BuildApp.Versioning.Common["Common"+$key]
			End if 
		End if 
	End if 
	
Function _printItem($item : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($item; "39").LF()
	
Function _printItemToList($item : Text; $count : Integer)->$CLI : cs:C1710.BuildApp_CLI
	
	If ($count#0)
		$CLI.print(","+$item; "39")
	Else 
		$CLI.print($item; "39")
	End if 
	
Function _printList($list : Collection)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($list.join(","); "39").LF()
	
Function _printPath($path : Object)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	If (OB Instance of:C1731($path; 4D:C1709.File) || OB Instance of:C1731($path; 4D:C1709.Folder))
		$CLI.print($path.path; "244").LF()
	End if 
	
Function _printStatus($success : Boolean)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	If ($success)
		$CLI.print("success"; "82;bold").LF()
	Else 
		$CLI.print("failure"; "196;bold").LF()
	End if 
	
Function _printTask($task : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($task; "bold").print("...")
	
Function _resolvePath($POSIX : Text) : 4D:C1709.Folder
	
	var $cd : 4D:C1709.Folder
	$cd:=Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2)
	
	var $pathComponent : Text
	For each ($pathComponent; Split string:C1554($POSIX; "/"; sk ignore empty strings:K86:1))
		Case of 
			: ($pathComponent=".")
				
			: ($pathComponent="..")
				$cd:=$cd.parent
			Else 
				$cd:=$cd.folder($pathComponent)
		End case 
	End for each 
	
	return $cd
	
Function _setDestination($BuildApp : cs:C1710.BuildApp; $buildDestinationPath : Text)->$BuildDestFolderPath : Text
	
	$CLI:=This:C1470
	
	var $platform; $Build___DestFolder : Text
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	$Build___DestFolder:="Build"+$platform+"DestFolder"
	
	If ($buildDestinationPath#"")
		
		$CLI.print("Set build destination path"; "177;bold").LF()
		$BuildDestFolder:=$CLI._resolvePath($buildDestinationPath)
		$BuildDestFolder.create()
		
		$BuildDestFolderPath:=$BuildDestFolder.platformPath
		
		$BuildApp[$Build___DestFolder]:=$BuildDestFolderPath
		$CLI.print($BuildDestFolder.path; "244").LF()
		
	Else 
		
		$BuildDestFolderPath:=$CLI._getStringValue($BuildApp; $Build___DestFolder)
		
	End if 
	
Function _updateProperty($BuildApp : cs:C1710.BuildApp; \
$targetRuntimeFolder : 4D:C1709.Folder; \
$CompanyName : Text; \
$BuildApplicationName : Text; \
$sdi_application : Boolean; $publication_name : Text; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	If (Is Windows:C1573)
		$ContentsFolder:=$targetRuntimeFolder.folder("Resources")
	Else 
		$ContentsFolder:=$targetRuntimeFolder.folder("Contents")
	End if 
	
	var $propertyListFile : 4D:C1709.File
	
	$propertyListFile:=$ContentsFolder.file("Info.plist")
	
	$keys:=New collection:C1472
	
	$info:=New object:C1471
	$winInfo:=New object:C1471
	
	$info.BuildName:=$BuildApplicationName
	$keys.push("BuildName")
	
	$info["BuildHardLink"]:=""
	$info["com.4D.BuildApp.ReadOnlyApp"]:="true"
	$keys.push("BuildHardLink")
	$keys.push("com.4D.BuildApp.ReadOnlyApp")
	
	If (Is macOS:C1572)
		Case of 
			: ($buildApplicationType="Server")
				$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName; "server").join("."; ck ignore null or empty:K85:5)
			: ($buildApplicationType="Client@")
				$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName; "client").join("."; ck ignore null or empty:K85:5)
			Else 
				$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName).join("."; ck ignore null or empty:K85:5)
		End case 
		$keys.push("CFBundleIdentifier")
	End if 
	
	Case of 
		: ($buildApplicationType="Client@")
			$BuildApplicationName:=$BuildApplicationName+" Client"
	End case 
	
	If (Is macOS:C1572)
		$info.CFBundleDisplayName:=$BuildApplicationName
		$info.CFBundleName:=$BuildApplicationName
		$info.CFBundleExecutable:=$BuildApplicationName
		$keys.push("CFBundleName")
		$keys.push("CFBundleDisplayName")
		$keys.push("CFBundleExecutable")
	Else 
		$winInfo.OriginalFilename:=$BuildApplicationName+".exe"
		$winInfo.ProductName:=$BuildApplicationName
		$keys.push("OriginalFilename")
		$keys.push("ProductName")
	End if 
	
	If (Is macOS:C1572)
		$info.NSDesktopFolderUsageDescription:=""
		$info.NSDocumentsFolderUsageDescription:=""
		$info.NSDownloadsFolderUsageDescription:=""
		$info.NSNetworkVolumesUsageDescription:=""
		$info.NSRemovableVolumesUsageDescription:=""
		$info.NSAppleEventsUsageDescription:=""
		$info.NSCalendarsUsageDescription:=""
		$info.NSCameraUsageDescription:=""
		$info.NSContactsUsageDescription:=""
		$info.NSLocationUsageDescription:=""
		$info.NSSystemAdministrationUsageDescription:=""
		$info.NSPhotoLibraryUsageDescription:=""
		$info.NSRemindersUsageDescription:=""
		$info.NSMicrophoneUsageDescription:=""
		$keys.push("NSAppleEventsUsageDescription")
		$keys.push("NSCalendarsUsageDescription")
		$keys.push("NSCameraUsageDescription")
		$keys.push("NSContactsUsageDescription")
		$keys.push("NSLocationUsageDescription")
		$keys.push("NSMicrophoneUsageDescription")
		$keys.push("NSPhotoLibraryUsageDescription")
		$keys.push("NSRemindersUsageDescription")
		$keys.push("NSSystemAdministrationUsageDescription")
		$keys.push("NSDesktopFolderUsageDescription")
		$keys.push("NSDocumentsFolderUsageDescription")
		$keys.push("NSDownloadsFolderUsageDescription")
		$keys.push("NSNetworkVolumesUsageDescription")
		$keys.push("NSRemovableVolumesUsageDescription")
	End if 
	
	Case of 
		: ($buildApplicationType="Server")
			$BuildApplicationName:=$BuildApplicationName
	End case 
	
	$info.DataFileConversionMode:="0"
	$keys.push("DataFileConversionMode")
	
	If (Is Windows:C1573)
		$info.SDIRuntime:=$sdi_application ? "1" : "0"
		$keys.push("SDIRuntime")
	Else 
		$info.SDIRuntime:="0"
		$keys.push("SDIRuntime")
	End if 
	
	$ClientWinSingleInstance:=$CLI._getBoolValue($BuildApp; "CS.ClientWinSingleInstance")
	
	If ($ClientWinSingleInstance)
		$info["4D_SingleInstance"]:="1"
		$keys.push("4D_SingleInstance")
	End if 
	
	$RangeVersMin:=$CLI._getIntValue($BuildApp; "CS.RangeVersMin")
	
	$info["BuildRangeVersMin"]:=String:C10($RangeVersMin)
	$keys.push("BuildRangeVersMin")
	
	$RangeVersMax:=$CLI._getIntValue($BuildApp; "CS.RangeVersMax")
	
	$info["BuildRangeVersMax"]:=String:C10($RangeVersMax)
	$keys.push("BuildRangeVersMax")
	
	$CurrentVers:=$CLI._getIntValue($BuildApp; "CS.CurrentVers")
	
	$info["CurrentVers"]:=String:C10($CurrentVers)
	$keys.push("CurrentVers")
	
	Case of 
		: ($buildApplicationType="Client@")
			
			$platform:=(Is macOS:C1572 ? "Mac" : "Win")
			$DatabaseToEmbedInClientFolder:="DatabaseToEmbedInClient"+$platform+"Folder"
			
			$DatabaseToEmbedInClient:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$DatabaseToEmbedInClientFolder)
			
			If ($DatabaseToEmbedInClient="")
				$info.PublishName:=$publication_name
				$keys.push("PublishName")  //this forces connection to server
			End if 
			
			$info["com.4d.BuildApp.dataless"]:="true"
			$keys.push("com.4d.BuildApp.dataless")
			
			$ClientServerSystemFolderName:=$CLI._getStringValue($BuildApp; "CS.ClientServerSystemFolderName")
			
			If ($ClientServerSystemFolderName#"")
				$info["BuildCacheFolderNameClient"]:=$ClientServerSystemFolderName
				$keys.push("BuildCacheFolderNameClient")
			End if 
			
			$ServerSelectionAllowed:=$CLI._getBoolValue($BuildApp; "CS.ServerSelectionAllowed")
			$info["com.4D.BuildApp.ServerSelectionAllowed"]:=$ServerSelectionAllowed ? "true" : "false"
			$keys.push("com.4D.BuildApp.ServerSelectionAllowed")
			
			$ClientWinSingleInstance:=$CLI._getBoolValue($BuildApp; "CS.ClientWinSingleInstance")
			$info["4D_MultipleClient"]:=$ClientWinSingleInstance ? "1" : "0"
			$keys.push("4D_MultipleClient")
			
			$ShareLocalResourcesOnClient:=$CLI._getBoolValue($BuildApp; "CS.ShareLocalResourcesOnWindowsClient")
			$info["RemoteSharedResources"]:=$ShareLocalResourcesOnClient ? "true" : "false"
			$keys.push("RemoteSharedResources")
			
		: ($buildApplicationType="Server")
			
			$ServerStructureFolderName:=$CLI._getStringValue($BuildApp; "CS.ServerStructureFolderName")
			
			If ($ServerStructureFolderName#"")
				$info["com.4d.ServerCacheFolderName"]:=$ServerStructureFolderName
				$keys.push("com.4d.ServerCacheFolderName")
			End if 
			
			$ServerDataCollection:=$CLI._getBoolValue($BuildApp; "CS.ServerDataCollection")
			
			If ($ServerDataCollection)
				$info["com.4d.dataCollection"]:="true"
				$info["DataCollection"]:="true"
				$keys.push("com.4d.dataCollection")
				$keys.push("DataCollection")
			End if 
			
			$HideAdministrationMenuItem:=$CLI._getBoolValue($BuildApp; "CS.HideAdministrationMenuItem")
			
			If ($HideAdministrationMenuItem)
				$info["com.4D.HideAdministrationWindowMenuItem"]:="true"
				$keys.push("com.4D.HideAdministrationWindowMenuItem")
			End if 
			
			$info["com.4D.BuildApp.LastDataPathLookup"]:=$CLI._getStringValue($BuildApp; "CS.LastDataPathLookup")
			$keys.push("com.4D.BuildApp.LastDataPathLookup")
			
		Else 
			
			$info["com.4D.BuildApp.LastDataPathLookup"]:=$CLI._getStringValue($BuildApp; "RuntimeVL.LastDataPathLookup")
			$keys.push("com.4D.BuildApp.LastDataPathLookup")
			
	End case 
	
	$HideDataExplorerMenuItem:=$CLI._getBoolValue($BuildApp; "CS.HideDataExplorerMenuItem")
	
	If ($HideDataExplorerMenuItem)
		$info["com.4D.HideDataExplorerMenuItem"]:="true"
		$keys.push("com.4D.HideDataExplorerMenuItem")
	End if 
	
	$HideRuntimeExplorerMenuItem:=$CLI._getBoolValue($BuildApp; "CS.HideRuntimeExplorerMenuItem")
	
	If ($HideRuntimeExplorerMenuItem)
		$info["com.4D.HideRuntimeExplorerMenuItem"]:="true"
		$keys.push("com.4D.HideRuntimeExplorerMenuItem")
	End if 
	
	var $platform; $RuntimeVLIcon___Path : Text
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	var $ClientIconFile : 4D:C1709.File
	
	Case of 
		: ($buildApplicationType="ClientMac")
			
			$ClientMacIconFor___Path:="ClientMacIconFor"+$platform+"Path"
			
			$ClientMacIconPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$ClientMacIconFor___Path)
			
			If ($ClientMacIconPath#"")
				$ClientIconFile:=File:C1566($ClientMacIconPath; fk platform path:K87:2)
				If ($ClientIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$targetIconFile.fullName
						$keys.push("CFBundleIconFile")
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
					Else 
						$winInfo.WinIcon:=$ClientIconFile.path
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
		: ($buildApplicationType="ClientWin")
			
			$ClientWinIconFor___Path:="ClientWinIconFor"+$platform+"Path"
			
			$ClientWinIconPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$ClientWinIconFor___Path)
			
			If ($ClientWinIconPath#"")
				$ClientIconFile:=File:C1566($ClientWinIconPath; fk platform path:K87:2)
				If ($ClientIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$targetIconFile.fullName
						$keys.push("CFBundleIconFile")
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
					Else 
						$winInfo.WinIcon:=$ClientIconFile.path
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
		: ($buildApplicationType="Server")
			
			$ServerIcon___Path:="ServerIcon"+$platform+"Path"
			
			$ServerIconPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.CS."+$ServerIcon___Path)
			
			If ($ServerIconPath#"")
				var $ServerIconFile : 4D:C1709.File
				$ServerIconFile:=File:C1566($ServerIconPath; fk platform path:K87:2)
				If ($ServerIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$ServerIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$targetIconFile.fullName
						$keys.push("CFBundleIconFile")
						$targetIconFile:=$ServerIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
					Else 
						$winInfo.WinIcon:=$ServerIconFile.path
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
		Else 
			
			$RuntimeVLIcon___Path:="RuntimeVLIcon"+$platform+"Path"
			
			$RuntimeVLIconPath:=$CLI._getStringValue($BuildApp; "SourcesFiles.RuntimeVL."+$RuntimeVLIcon___Path)
			
			If ($RuntimeVLIconPath#"")
				var $RuntimeVLIconFile : 4D:C1709.File
				$RuntimeVLIconFile:=File:C1566($RuntimeVLIconPath; fk platform path:K87:2)
				If ($RuntimeVLIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$targetIconFile.fullName
						$keys.push("CFBundleIconFile")
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
					Else 
						$winInfo.WinIcon:=$RuntimeVLIconFile.path
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
	End case 
	
	Case of 
		: ($buildApplicationType="Client@")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Client")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Client")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Client")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Client")
			$Creator:=$CLI._getVersioning($BuildApp; "Creator"; "Client")
			$Comment:=$CLI._getVersioning($BuildApp; "Comment"; "Client")
			$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName"; "Client")
			$FileDescription:=$CLI._getVersioning($BuildApp; "FileDescription"; "Client")
			$FileInternalName:=$CLI._getVersioning($BuildApp; "InternalName"; "Client")
			$LegalTrademark:=$CLI._getVersioning($BuildApp; "LegalTrademark"; "Client")
			$PrivateBuild:=$CLI._getVersioning($BuildApp; "PrivateBuild"; "Client")
			$SpecialBuild:=$CLI._getVersioning($BuildApp; "SpecialBuild"; "Client")
		: ($buildApplicationType="Server")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Server")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Server")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Server")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Server")
			$Creator:=$CLI._getVersioning($BuildApp; "Creator"; "Server")
			$Comment:=$CLI._getVersioning($BuildApp; "Comment"; "Server")
			$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName"; "Server")
			$FileDescription:=$CLI._getVersioning($BuildApp; "FileDescription"; "Server")
			$FileInternalName:=$CLI._getVersioning($BuildApp; "InternalName"; "Server")
			$LegalTrademark:=$CLI._getVersioning($BuildApp; "LegalTrademark"; "Server")
			$PrivateBuild:=$CLI._getVersioning($BuildApp; "PrivateBuild"; "Server")
			$SpecialBuild:=$CLI._getVersioning($BuildApp; "SpecialBuild"; "Server")
		Else 
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "RuntimeVL")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "RuntimeVL")
			$Creator:=$CLI._getVersioning($BuildApp; "Creator"; "RuntimeVL")
			$Comment:=$CLI._getVersioning($BuildApp; "Comment"; "RuntimeVL")
			$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName"; "RuntimeVL")
			$FileDescription:=$CLI._getVersioning($BuildApp; "FileDescription"; "RuntimeVL")
			$FileInternalName:=$CLI._getVersioning($BuildApp; "InternalName"; "RuntimeVL")
			$LegalTrademark:=$CLI._getVersioning($BuildApp; "LegalTrademark"; "RuntimeVL")
			$PrivateBuild:=$CLI._getVersioning($BuildApp; "PrivateBuild"; "RuntimeVL")
			$SpecialBuild:=$CLI._getVersioning($BuildApp; "SpecialBuild"; "RuntimeVL")
	End case 
	
	If ($Version#"")
		$info.CFBundleVersion:=$Version
		$info.CFBundleShortVersionString:=$info.CFBundleVersion
		$keys.push("CFBundleVersion")
		$keys.push("CFBundleShortVersionString")
		If (Is Windows:C1573)
			$winInfo.ProductVersion:=$Version
			$winInfo.FileVersion:=$winInfo.ProductVersion
			$keys.push("ProductVersion")
			$keys.push("FileVersion")
		End if 
	End if 
	
	If ($Copyright#"")
		$info.CFBundleGetInfoString:=$Copyright
		$info.NSHumanReadableCopyright:=$info.CFBundleGetInfoString
		$keys.push("CFBundleVersion")
		$keys.push("CFBundleShortVersionString")
		If (Is Windows:C1573)
			$winInfo.LegalCopyright:=$Copyright
			$keys.push("LegalCopyright")
		End if 
	End if 
	
	If ($Creator#"")
		$keys.push("Creator")
	End if 
	
	If ($Comment#"")
		$keys.push("Comment")
	End if 
	
	If ($CompanyName#"")
		$winInfo.CompanyName:=$CompanyName
		$keys.push("CompanyName")
	End if 
	
	If ($FileDescription#"")
		$winInfo.FileDescription:=$FileDescription
		$keys.push("FileDescription")
	End if 
	
	If ($FileInternalName#"")
		$winInfo.InternalName:=$FileInternalName
		$keys.push("FileInternalName")
	End if 
	
	If ($PrivateBuild#"")
		$keys.push("PrivateBuild")
	End if 
	
	If ($SpecialBuild#"")
		$keys.push("SpecialBuild")
	End if 
	
	If (Is Windows:C1573)
		
		If (Not:C34($BuildApp.ArrayExcludedModuleName.Item.includes("4D Updater")))
			
			$targetUpdatorFolder:=$targetRuntimeFolder.folder("Resources").folder("Updater")
			$elevatedManifestFile:=$targetUpdatorFolder.file("elevated.manifest")
			$normalManifestFile:=$targetUpdatorFolder.file("normal.manifest")
			
			var $targetMaifestFile : 4D:C1709.File
			
			Case of 
				: ($buildApplicationType="Client@")
					
					If (Bool:C1537($BuildApp.AutoUpdate.CS.Client.StartElevated)) || (Bool:C1537($BuildApp.AutoUpdate.CS.ClientUpdateWin.StartElevated))
						$targetMaifestFile:=$elevatedManifestFile.copyTo($targetUpdatorFolder; "Updater.exe.manifest"; fk overwrite:K87:5)
					End if 
					
				: ($buildApplicationType="Server")
					
					If (Bool:C1537($BuildApp.AutoUpdate.CS.Server.StartElevated)) || (Bool:C1537($BuildApp.AutoUpdate.CS.Server.StartElevated))
						$targetMaifestFile:=$elevatedManifestFile.copyTo($targetUpdatorFolder; "Updater.exe.manifest"; fk overwrite:K87:5)
					End if 
					
				Else 
					
					If (Bool:C1537($BuildApp.AutoUpdate.RuntimeVL.StartElevated))
						$targetMaifestFile:=$elevatedManifestFile.copyTo($targetUpdatorFolder; "Updater.exe.manifest"; fk overwrite:K87:5)
					End if 
					
			End case 
			
			If ($targetMaifestFile#Null:C1517)
				$CLI._printTask("Set updater manifest")
				$CLI._printPath($targetMaifestFile)
			End if 
			
		End if 
		
	End if 
	
	$CLI._printTask("Update property list")
	$CLI._printList($keys)
	$CLI._printPath($propertyListFile)
	
	$propertyListFile.setAppInfo($info)
	
	If (Is Windows:C1573)
		$targetRuntimeFolder.file($BuildApplicationName+".exe").setAppInfo($winInfo)
	End if 
	
	$CLI._updatePropertyStrings($BuildApp; $targetRuntimeFolder; $info)
	
Function _updatePropertyStrings($BuildApp : cs:C1710.BuildApp; \
$targetFolder : 4D:C1709.Folder; $info : Object)
	
	$CLI:=This:C1470
	
	$folders:=$targetFolder.folder("Contents").folder("Resources").folders(fk ignore invisible:K87:22).query("extension == :1"; ".lproj")
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	var $key : Text
	$keys:=New collection:C1472
	$lproj:=New collection:C1472
	
	For each ($folder; $folders)
		
		$files:=$folder.files().query("fullName == :1"; "InfoPlist.strings")
		
		For each ($file; $files)
			$changed:=False:C215
			$strings:=$file.getText("utf-16le"; Document with LF:K24:22)
			$lines:=Split string:C1554($strings; "\n")
			For each ($key; $info)
				For ($i; 1; $lines.length)
					$line:=$lines[$i-1]
					If (Match regex:C1019("^(\\S+)(\\s*=\\s*)\"(.*)\"(.*)"; $line; 1; $pos; $len))
						If ($key=Substring:C12($line; $pos{1}; $len{1}))
							$oper:=Substring:C12($line; $pos{2}; $len{2})
							$term:=Substring:C12($line; $pos{4}; $len{4})
							$oldValue:=Substring:C12($line; $pos{3}; $len{3})
							$newValue:=$info[$key]
							$lines[$i-1]:=$key+$oper+"\""+$newValue+"\""+$term
							$keys.push($key)
							$changed:=True:C214
						End if 
					End if 
				End for 
			End for each 
			If ($changed)
				$file.setText($lines.join("\n"); "utf-16le"; Document with LF:K24:22)
				$lproj.push($file)
			End if 
		End for each 
	End for each 
	
	If ($lproj.length#0)
		$CLI._printTask("Update strings")
		$CLI._printList($keys.distinct())
		For each ($file; $lproj)
			$CLI._printPath($file)
		End for each 
	End if 
	
Function _zipCallback1($progress : Integer)
	
	$CLI:=cs:C1710.CLI.new()
	
	$value:=String:C10($progress)
	$value:=Substring:C12("   "+$value; Length:C16($value)+1)
	
	$value+="%%"
	
	$CLI.CR().print("Archive client"; "bold").print("...").print($value; "226")
	
Function _zipCallback2($progress : Integer)
	
	$CLI:=cs:C1710.CLI.new()
	
	$value:=String:C10($progress)
	$value:=Substring:C12("   "+$value; Length:C16($value)+1)
	
	$value+="%%"
	
	$CLI.CR().print("Archive project folder"; "bold").print($value; "226")
	