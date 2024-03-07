Class constructor
	
Function 単位() : Object
	
	If (Storage:C1525.単位=Null:C1517)
		
		$EXPORT:=New object:C1471("単位"; New shared collection:C1527)
		
		This:C1470.単位
		
		$sharedCollection:=$EXPORT.単位
		
		Use ($sharedCollection)
			
			
		End use 
		
		Use (Storage:C1525)
			Storage:C1525.単位:=$EXPORT
		End use 
		
	Else 
		$EXPORT:=Storage:C1525.単位
	End if 
	
	return $EXPORT