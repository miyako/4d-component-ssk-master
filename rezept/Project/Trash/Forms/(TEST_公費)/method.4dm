$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		OBJECT SET FILTER:C235(*; "負担者番号@"; "!0&9")
		
		Form:C1466.parser:=cs:C1710.公費.new()
		
		Form:C1466.validate:=Formula:C1597(validate_entry)
		
End case 