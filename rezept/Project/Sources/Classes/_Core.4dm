Class constructor
	
Function _getDataFolder() : 4D:C1709.Folder
	
	return Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent.folder("DATA")
	
Function _getDataExportFolder() : 4D:C1709.Folder
	
	return Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent