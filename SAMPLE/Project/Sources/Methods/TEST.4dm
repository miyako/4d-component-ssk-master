//%attributes = {}
/*

基本マスター

*/

cs:C1710.ssk.GitHub.new()  //最新のマスターを非同期ダウンロードする

var $rezept : cs:C1710.ssk.Rezept
$rezept:=cs:C1710.ssk.Rezept.new()

$info:=$rezept.getInfo()
If (False:C215)
	$rezept.switch($info.data[1])  //マスターを切り替える
End if 

$コメント:=$rezept.get("コメント"; "810000001")

$単位:=$rezept.get("単位"; "1")
$診療行為:=$rezept.get("診療行為"; "150405210")

$診療行為:=$rezept.診療行為.query("基本漢字名称 == :1"; "@術中術後自己血回収術@")
$診療行為:=$rezept.get("診療行為"; "160230050")

$医薬品:=$rezept.医薬品.query("後発品.項目.同一剤形・規格の後発医薬品がある先発医薬品 == :1"; "○")
$医薬品:=$rezept.get("医薬品"; "610406079")

$公費:=$rezept.公費().parse("9947")