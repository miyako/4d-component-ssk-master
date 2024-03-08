//%attributes = {"invisible":true,"executedOnServer":true,"preemptive":"capable"}
#DECLARE($dataClassName : Text) : Object

var $file : 4D:C1709.File
$file:=cs:C1710._Export.new()._dataFolder.file($dataClassName+".data")

If ($file#Null:C1517) && ($file.exists)
	
	var $data : Blob
	$data:=$file.getContent()
	
	var $object : Object
	BLOB TO VARIABLE:C533($data; $object)
	
	return $object
	
End if 