//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	
	$window:=Open form window:C675("記載事項等")
	DIALOG:C40("記載事項等"; *)
	
End if 