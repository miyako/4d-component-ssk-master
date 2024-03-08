//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	$form:={}
	$form.parser:=cs:C1710.ssk.Rezept.new().公費()
	$form.地方公費:={col: Null:C1517; sel: Null:C1517; item: Null:C1517; pos: Null:C1517}
	$form.validate:=Formula:C1597(validate_entry)
	
	$window:=Open form window:C675("公費")
	DIALOG:C40("公費"; $form; *)
	
End if 