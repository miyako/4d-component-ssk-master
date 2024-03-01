//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=1)
		
		$stringValue:="10円未満を四捨五入する"
		
	: ($code=2)
		
		$stringValue:="10円未満を四捨五入しない"
		
End case 