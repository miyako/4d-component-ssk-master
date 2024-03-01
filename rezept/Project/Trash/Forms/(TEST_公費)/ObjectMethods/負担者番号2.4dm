$event:=FORM Event:C1606

Case of 
	: ($event.code=On After Edit:K2:43) | ($event.code=On Getting Focus:K2:7)
		
		Form:C1466.validate("2")
		
End case 