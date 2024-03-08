$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		OBJECT SET FILTER:C235(*; "負担者番号@"; "!0&9")
		
		Form:C1466.parser:=cs:C1710.ssk.Rezept.new().公費()
		
		Form:C1466.地方公費:={col: Null:C1517; sel: Null:C1517; item: Null:C1517; pos: Null:C1517}
		
		Form:C1466.validate:=Formula:C1597(validate_entry)
		
		OBJECT SET ENABLED:C1123(*; "pbcopy"; False:C215)
		
End case 