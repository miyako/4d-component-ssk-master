//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=0)
		
		$stringValue:="社保と国保の両方に印刷"
		
	: ($code=1)
		
		$stringValue:="社保との併用に限り印刷"
		
	: ($code=2)
		
		$stringValue:="国保か広域連合との併用に限り印刷"
		
	: ($code=3)
		
		$stringValue:="印刷しない"
		
	: ($code=4)
		
		$stringValue:="国保との併用に限り印刷"
		
	: ($code=5)
		
		$stringValue:="広域連合との併用に限り印刷"
		
End case 