Class constructor
	
Function setIntValue($dom : Text; $path : Text; $intValue : Integer)
	
	var $nodes : Collection
	
	$nodes:=Split string:C1554($path; "@")
	
	If ($nodes.length>1)
		
		$attribute:=DOM Find XML element:C864($dom; $nodes[0]+"[@"+$nodes[1]+"]")
		
		If (OK=0)
			$attribute:=DOM Create XML element:C865($dom; $nodes[0])
		End if 
		
		If (OK=1)
			DOM SET XML ATTRIBUTE:C866($attribute; $nodes[1]; $intValue)
		End if 
		
	End if 
	
Function getBoolValue($dom : Text; $path : Text)->$boolValue : Variant
	
	var $stringValue : Text
	var $nodes : Collection
	
	$nodes:=Split string:C1554($path; "@")
	
	If ($nodes.length>1)
		
		$attribute:=DOM Find XML element:C864($dom; $nodes[0]+"[@"+$nodes[1]+"]")
		
		If (OK=1)
			DOM GET XML ATTRIBUTE BY NAME:C728($attribute; $nodes[1]; $stringValue)
			$boolValue:=($stringValue="true")
		End if 
		
	End if 
	
Function getStringValue($dom : Text; $path : Text)->$stringValue : Variant
	
	var $value : Text
	var $nodes : Collection
	
	$nodes:=Split string:C1554($path; "@")
	
	If ($nodes.length>1)
		
		$attribute:=DOM Find XML element:C864($dom; $nodes[0]+"[@"+$nodes[1]+"]")
		
		If (OK=1)
			DOM GET XML ATTRIBUTE BY NAME:C728($attribute; $nodes[1]; $value)
			$stringValue:=$value
		End if 
		
	End if 
	