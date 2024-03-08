If (Form event code:C388=On Data Change:K2:15)
	
	$記載事項:=Form:C1466.記載事項
	
	$pCategory:=OBJECT Get pointer:C1124(Object named:K67:5; "category")
	
	$steps:=$記載事項.steps[($pCategory->)-1]
	
	Form:C1466.update_pattern($記載事項; $steps; Self:C308->)
	
End if 