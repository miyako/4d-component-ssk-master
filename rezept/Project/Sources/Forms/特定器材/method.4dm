Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		Form:C1466.特定器材:=ds:C1482._特定器材.query("項目.変更区分 == :1"; "9")
		
End case 