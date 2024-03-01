//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Integer)->$stringValue : Text

Case of 
	: ($code=0)
		
		$stringValue:="使用しない"  //設定の必要がない場合
		
	: ($code=1)
		
		$stringValue:="患者負担あり"  //医療費患者負担とは別で負担あり
		
	: ($code=2)
		
		$stringValue:="患者負担あり（上限あり）"  //医療費月上限額に食事患者負担が含まれる場合
		
	: ($code=3)
		
		$stringValue:="患者負担なし"
		
	: ($code=4)
		
		$stringValue:="患者負担あり（消費税あり）"  //自費保険以外無効
		
End case 