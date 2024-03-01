//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
C_OBJECT:C1216($0;$EXPORT)

If (Storage:C1525.単位=Null:C1517)
	
	$EXPORT:=New shared object:C1526("単位";New shared collection:C1527)
	
	$単位:=$EXPORT.単位
	
	Use ($単位)
		
		$単位.push(New shared object:C1526("単位コード";"1";"内容";"分"))
		$単位.push(New shared object:C1526("単位コード";"2";"内容";"回"))
		$単位.push(New shared object:C1526("単位コード";"3";"内容";"種"))
		$単位.push(New shared object:C1526("単位コード";"4";"内容";"箱"))
		$単位.push(New shared object:C1526("単位コード";"5";"内容";"巻"))
		$単位.push(New shared object:C1526("単位コード";"6";"内容";"枚"))
		$単位.push(New shared object:C1526("単位コード";"7";"内容";"本"))
		$単位.push(New shared object:C1526("単位コード";"8";"内容";"組"))
		$単位.push(New shared object:C1526("単位コード";"9";"内容";"セット"))
		$単位.push(New shared object:C1526("単位コード";"10";"内容";"個"))
		
		$単位.push(New shared object:C1526("単位コード";"11";"内容";"裂"))
		$単位.push(New shared object:C1526("単位コード";"12";"内容";"方向"))
		$単位.push(New shared object:C1526("単位コード";"13";"内容";"トローチ"))
		$単位.push(New shared object:C1526("単位コード";"14";"内容";"アンプル"))
		$単位.push(New shared object:C1526("単位コード";"15";"内容";"カプセル"))
		$単位.push(New shared object:C1526("単位コード";"16";"内容";"錠"))
		$単位.push(New shared object:C1526("単位コード";"17";"内容";"丸"))
		$単位.push(New shared object:C1526("単位コード";"18";"内容";"包"))
		$単位.push(New shared object:C1526("単位コード";"19";"内容";"瓶"))
		$単位.push(New shared object:C1526("単位コード";"20";"内容";"袋"))
		
		$単位.push(New shared object:C1526("単位コード";"21";"内容";"瓶（袋）"))
		$単位.push(New shared object:C1526("単位コード";"22";"内容";"管"))
		$単位.push(New shared object:C1526("単位コード";"23";"内容";"シリンジ"))
		$単位.push(New shared object:C1526("単位コード";"24";"内容";"回分"))
		$単位.push(New shared object:C1526("単位コード";"25";"内容";"テスト分"))
		$単位.push(New shared object:C1526("単位コード";"26";"内容";"ガラス筒"))
		$単位.push(New shared object:C1526("単位コード";"27";"内容";"桿錠"))
		$単位.push(New shared object:C1526("単位コード";"28";"内容";"単位"))
		$単位.push(New shared object:C1526("単位コード";"29";"内容";"万単位"))
		$単位.push(New shared object:C1526("単位コード";"30";"内容";"フィート"))
		
		$単位.push(New shared object:C1526("単位コード";"31";"内容";"滴"))
		$単位.push(New shared object:C1526("単位コード";"32";"内容";"ｍｇ"))
		$単位.push(New shared object:C1526("単位コード";"33";"内容";"ｇ"))
		$単位.push(New shared object:C1526("単位コード";"34";"内容";"Ｋｇ"))
		$単位.push(New shared object:C1526("単位コード";"35";"内容";"ｃｃ"))
		$単位.push(New shared object:C1526("単位コード";"36";"内容";"ｍＬ"))
		$単位.push(New shared object:C1526("単位コード";"37";"内容";"Ｌ"))
		$単位.push(New shared object:C1526("単位コード";"38";"内容";"ｍＬＶ"))
		$単位.push(New shared object:C1526("単位コード";"39";"内容";"バイアル"))
		$単位.push(New shared object:C1526("単位コード";"40";"内容";"ｃｍ"))
		
		$単位.push(New shared object:C1526("単位コード";"41";"内容";"ｃｍ２"))
		$単位.push(New shared object:C1526("単位コード";"42";"内容";"ｍ"))
		$単位.push(New shared object:C1526("単位コード";"43";"内容";"μＣｉ"))
		$単位.push(New shared object:C1526("単位コード";"44";"内容";"ｍＣｉ"))
		$単位.push(New shared object:C1526("単位コード";"45";"内容";"μｇ"))
		$単位.push(New shared object:C1526("単位コード";"46";"内容";"管（瓶）"))
		$単位.push(New shared object:C1526("単位コード";"47";"内容";"筒"))
		$単位.push(New shared object:C1526("単位コード";"48";"内容";"ＧＢｑ"))
		$単位.push(New shared object:C1526("単位コード";"49";"内容";"ＭＢｑ"))
		$単位.push(New shared object:C1526("単位コード";"50";"内容";"ＫＢｑ"))
		
		$単位.push(New shared object:C1526("単位コード";"51";"内容";"キット"))
		$単位.push(New shared object:C1526("単位コード";"52";"内容";"国際単位"))
		$単位.push(New shared object:C1526("単位コード";"53";"内容";"患者当り"))
		$単位.push(New shared object:C1526("単位コード";"54";"内容";"気圧"))
		$単位.push(New shared object:C1526("単位コード";"55";"内容";"缶"))
		$単位.push(New shared object:C1526("単位コード";"56";"内容";"手術当り"))
		$単位.push(New shared object:C1526("単位コード";"57";"内容";"容器"))
		$単位.push(New shared object:C1526("単位コード";"58";"内容";"ｍＬ（ｇ）"))
		$単位.push(New shared object:C1526("単位コード";"59";"内容";"ブリスター"))
		$単位.push(New shared object:C1526("単位コード";"60";"内容";"シート"))
		
		$単位.push(New shared object:C1526("単位コード";"61";"内容";"カセット"))
		
		$単位.push(New shared object:C1526("単位コード";"101";"内容";"分画"))
		$単位.push(New shared object:C1526("単位コード";"102";"内容";"染色"))
		$単位.push(New shared object:C1526("単位コード";"103";"内容";"種類"))
		$単位.push(New shared object:C1526("単位コード";"104";"内容";"株"))
		$単位.push(New shared object:C1526("単位コード";"105";"内容";"菌株"))
		$単位.push(New shared object:C1526("単位コード";"106";"内容";"照射"))
		$単位.push(New shared object:C1526("単位コード";"107";"内容";"臓器"))
		$単位.push(New shared object:C1526("単位コード";"108";"内容";"件"))
		$単位.push(New shared object:C1526("単位コード";"109";"内容";"部位"))
		$単位.push(New shared object:C1526("単位コード";"110";"内容";"肢"))
		
		$単位.push(New shared object:C1526("単位コード";"111";"内容";"局所"))
		$単位.push(New shared object:C1526("単位コード";"112";"内容";"種目"))
		$単位.push(New shared object:C1526("単位コード";"113";"内容";"スキャン"))
		$単位.push(New shared object:C1526("単位コード";"114";"内容";"コマ"))
		$単位.push(New shared object:C1526("単位コード";"115";"内容";"処理"))
		$単位.push(New shared object:C1526("単位コード";"116";"内容";"指"))
		$単位.push(New shared object:C1526("単位コード";"117";"内容";"歯"))
		$単位.push(New shared object:C1526("単位コード";"118";"内容";"面"))
		$単位.push(New shared object:C1526("単位コード";"119";"内容";"側"))
		$単位.push(New shared object:C1526("単位コード";"120";"内容";"個所"))
		
		$単位.push(New shared object:C1526("単位コード";"121";"内容";"日"))
		$単位.push(New shared object:C1526("単位コード";"122";"内容";"椎間"))
		$単位.push(New shared object:C1526("単位コード";"123";"内容";"筋"))
		$単位.push(New shared object:C1526("単位コード";"124";"内容";"菌種"))
		$単位.push(New shared object:C1526("単位コード";"125";"内容";"項目"))
		$単位.push(New shared object:C1526("単位コード";"126";"内容";"箇所"))
		$単位.push(New shared object:C1526("単位コード";"127";"内容";"椎弓"))
		$単位.push(New shared object:C1526("単位コード";"128";"内容";"食"))
		$単位.push(New shared object:C1526("単位コード";"129";"内容";"根管"))
		$単位.push(New shared object:C1526("単位コード";"130";"内容";"３分の１顎"))
		
		$単位.push(New shared object:C1526("単位コード";"131";"内容";"月"))
		$単位.push(New shared object:C1526("単位コード";"132";"内容";"入院初日"))
		$単位.push(New shared object:C1526("単位コード";"133";"内容";"入院中"))
		$単位.push(New shared object:C1526("単位コード";"134";"内容";"退院時"))
		$単位.push(New shared object:C1526("単位コード";"135";"内容";"初回"))
		$単位.push(New shared object:C1526("単位コード";"136";"内容";"口腔"))
		$単位.push(New shared object:C1526("単位コード";"137";"内容";"顎"))
		$単位.push(New shared object:C1526("単位コード";"138";"内容";"週"))
		$単位.push(New shared object:C1526("単位コード";"139";"内容";"窩洞"))
		$単位.push(New shared object:C1526("単位コード";"140";"内容";"神経"))
		
		$単位.push(New shared object:C1526("単位コード";"141";"内容";"一連"))
		$単位.push(New shared object:C1526("単位コード";"142";"内容";"２週"))
		$単位.push(New shared object:C1526("単位コード";"143";"内容";"２月"))
		$単位.push(New shared object:C1526("単位コード";"144";"内容";"３月"))
		$単位.push(New shared object:C1526("単位コード";"145";"内容";"４月"))
		$単位.push(New shared object:C1526("単位コード";"146";"内容";"６月"))
		$単位.push(New shared object:C1526("単位コード";"147";"内容";"１２月"))
		$単位.push(New shared object:C1526("単位コード";"148";"内容";"５年"))
		$単位.push(New shared object:C1526("単位コード";"149";"内容";"妊娠中"))
		$単位.push(New shared object:C1526("単位コード";"150";"内容";"検査当り"))
		
		$単位.push(New shared object:C1526("単位コード";"151";"内容";"１疾患当り"))
		  //
		$単位.push(New shared object:C1526("単位コード";"153";"内容";"装置"))
		$単位.push(New shared object:C1526("単位コード";"154";"内容";"１歯１回"))
		$単位.push(New shared object:C1526("単位コード";"155";"内容";"１口腔１回"))
		$単位.push(New shared object:C1526("単位コード";"156";"内容";"床"))
		$単位.push(New shared object:C1526("単位コード";"157";"内容";"１顎１回"))
		$単位.push(New shared object:C1526("単位コード";"158";"内容";"椎体"))
		$単位.push(New shared object:C1526("単位コード";"159";"内容";"初診時"))
		$単位.push(New shared object:C1526("単位コード";"160";"内容";"１分娩当り"))
		
	End use 
	
	
	Use (Storage:C1525)
		Storage:C1525.単位:=$EXPORT
	End use 
	
	Use ($EXPORT)
		
		$EXPORT.params:=Formula:C1597(new_query_params )
		
	End use 
	
Else 
	$EXPORT:=Storage:C1525.単位
End if 

$0:=$EXPORT