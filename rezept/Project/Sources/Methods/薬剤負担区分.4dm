//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=0)
		
		$stringValue:="使用しない"
		
	: ($code=1)
		
		$stringValue:="患者負担あり"
		
	: ($code=2)
		
		$stringValue:="患者負担あり（上限あり）"
		
	: ($code=3)
		
		$stringValue:="患者負担なし"
		
End case 