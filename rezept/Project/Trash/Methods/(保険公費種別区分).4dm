//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=7)
		
		$stringValue:="一般公費"
		
	: ($code=2)
		
		$stringValue:="補助公費"
		
	: ($code=3)
		
		$stringValue:="主補公費"
		
End case 