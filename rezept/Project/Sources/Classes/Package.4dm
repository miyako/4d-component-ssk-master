Class constructor
	
Function _getPackage() : 4D:C1709.File
	
	return Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent.file("package.json")
	
Function setProperty($key : Text; $value : Variant) : cs:C1710.Package
	
	var $file : 4D:C1709.File
	$file:=This:C1470._getPackage()
	
	If ($file.exists)
		
		var $json : Text
		$json:=$file.getText("utf-8"; Document with CR:K24:21)
		
		var $package : Object
		$package:=JSON Parse:C1218($json; Is object:K8:27)
	Else 
		$package:={}
	End if 
	
	$package[$key]:=$value
	$file.setText(JSON Stringify:C1217($package))
	
	return This:C1470
	