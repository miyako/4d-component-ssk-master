//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=1)
		
		$stringValue:="負担上限未満を記載する"
		
	: ($code=2)
		
		$stringValue:="負担上限未満を記載しない"
		
End case 