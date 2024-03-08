$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		OBJECT SET FILTER:C235(*; "負担者番号@"; "!0&9")
		OBJECT SET ENABLED:C1123(*; "pbcopy"; False:C215)
		
End case 