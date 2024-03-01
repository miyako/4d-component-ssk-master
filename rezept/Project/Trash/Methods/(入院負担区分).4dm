//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=0)
		
		$stringValue:="使用しない"  //設定の必要がない場合
		
	: ($code=1)
		
		$stringValue:="患者負担あり"  //医療費の患者負担がある場合
		
	: ($code=2)
		
		$stringValue:="患者負担なし"  //医療費の患者負担がない場合
		
End case 