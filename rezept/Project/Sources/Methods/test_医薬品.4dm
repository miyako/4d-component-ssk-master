//%attributes = {"invisible":true}
/*
アップデートするには

*/

If (False:C215)
	
	//import_医薬品
	import_一般名処方
	import_後発医薬品
	
	$ds:=ds医薬品(True:C214)
	
End if 

/*

使用するには

*/

$ds:=ds医薬品

$q:="@"

$col:=$ds.医薬品.query("一般名.一般名処方の標準的な記載 == :1"; $q)

ARRAY TEXT:C222($masterCodes; 0)
ARRAY TEXT:C222($masterNames; 0)

COLLECTION TO ARRAY:C1562($col; $masterCodes; "医薬品コード"; $masterNames; "医薬品名・規格名.漢字名称")
