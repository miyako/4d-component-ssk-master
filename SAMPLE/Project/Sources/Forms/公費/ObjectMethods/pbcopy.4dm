If (FORM Event:C1606.code=On Clicked:K2:4)
	
	SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217(Form:C1466.地方公費.col; *))
	INVOKE ACTION:C1439(ak show clipboard:K76:58)
	
End if 