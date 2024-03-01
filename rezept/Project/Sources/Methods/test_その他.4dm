//%attributes = {"invisible":true}
/*

アップデートするには

*/

//$薬価基準コード:="2149045F2025"
//$e一般名:=ds一般名検索($薬価基準コード)

//$s:=ds診療行為.診療行為.query("基本漢字名称 == :1"; "一般名処方加算１（処方箋料）（経過措置）")

If (True:C214)  //23.05.11再読み込み（労災がインポートされていなかったため）
	
	//2024.02.06
	//2023.12.26
	//2023.11.27
	
	import_診療行為
	$ds:=ds診療行為(True:C214)  //"113045350","14","院内トリアージ実施料（特例）" "113045550","26","特定疾患療養管理料（１００床未満・療養指導）（特例）
	
	
Else 
	
	import_コメント
	$ds:=dsコメント(True:C214)
	
	import_特定器材
	$ds:=ds特定器材(True:C214)
	
	//import_医薬品
	$ds:=ds医薬品(True:C214)
	
	import_修飾語
	$ds:=ds修飾語(True:C214)
	
	import_傷病名
	$ds:=ds傷病名(True:C214)
	
	import_一般名処方
	import_後発医薬品
	
	
End if 