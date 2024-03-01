Class extends _XmlParser

Class constructor
	
	Super:C1705()
	
Function _parse($settingsFile : 4D:C1709.File)->$status : Object
	
	$status:=New object:C1471("sdi_application"; Null:C1517; "allow_user_settings"; Null:C1517)
	
	If ($settingsFile.exists)
		
		$dom:=DOM Parse XML source:C719($settingsFile.platformPath)
		
		If (OK=1)
			
			$status.sdi_application:=This:C1470.getBoolValue($dom; "/preferences/com.4d/interface/user@sdi_application")
			$status.allow_user_settings:=This:C1470.getBoolValue($dom; "/preferences/com.4d/general@allow_user_settings")
			
			DOM CLOSE XML:C722($dom)
			
		End if 
		
	End if 
	
Function setPortNumber($projectFile : 4D:C1709.File; $portNumber : Integer)
	
	If ($projectFile#Null:C1517) && (OB Instance of:C1731($projectFile; 4D:C1709.File)) && ($projectFile.exists)
		
		$projectSettingsFile:=$projectFile.parent.folder("Sources").file("settings.4DSettings")
		
		If ($projectSettingsFile.exists)
			
			$dom:=DOM Parse XML source:C719($projectSettingsFile.platformPath)
			
			If (OK=1)
				
				This:C1470.setIntValue($dom; "/preferences/com.4d/server/network/options@publication_port"; $portNumber)
				
				DOM EXPORT TO FILE:C862($dom; $projectSettingsFile.platformPath)
				
				DOM CLOSE XML:C722($dom)
				
			End if 
			
		End if 
		
	End if 
	
Function parse($projectFile : 4D:C1709.File)->$status : Object
	
	$status:=New object:C1471("sdi_application"; False:C215; "allow_user_settings"; False:C215; "publication_name"; "")
	
	If ($projectFile#Null:C1517) && (OB Instance of:C1731($projectFile; 4D:C1709.File)) && ($projectFile.exists)
		
		$projectSettingsFile:=$projectFile.parent.folder("Sources").file("settings.4DSettings")
		
		$projectStatus:=This:C1470._parse($projectSettingsFile)
		
		$status.sdi_application:=Bool:C1537($projectStatus.sdi_application)
		$status.allow_user_settings:=Bool:C1537($projectStatus.allow_user_settings)
		$status.publication_name:=$projectStatus.publication_name=Null:C1517 ? "" : $projectStatus.publication_name
		
		If ($status.allow_user_settings)
			
			$userSettingsFile:=$projectFile.parent.parent.folder("Settings").file("settings.4DSettings")
			
			$userStatus:=This:C1470._parse($userSettingsFile)
			
			If ($userStatus.sdi_application#Null:C1517)
				$status.sdi_application:=$userStatus.sdi_application
			End if 
			
			If ($userStatus.publication_name#Null:C1517)
				$status.publication_name:=$userStatus.publication_name
			End if 
			
		End if 
		
	End if 