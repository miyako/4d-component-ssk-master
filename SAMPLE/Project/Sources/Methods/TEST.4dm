//%attributes = {}
/*

基本マスター

*/

SHOW ON DISK:C922(Folder:C1567(fk user preferences folder:K87:10).parent.folder("com.4d.rezept").platformPath)

cs:C1710.ssk.GitHub.new()  //最新のマスターを非同期ダウンロードする

var $rezept : cs:C1710.ssk.Rezept
$rezept:=cs:C1710.ssk.Rezept.new()

$info:=$rezept.getInfo()

If (False:C215)
	$rezept.switch($info.data[0])  //マスターを切り替える
End if 

$コメント:=$rezept.get("コメント"; "810000001")

$単位:=$rezept.get("単位"; "1")
$診療行為:=$rezept.get("診療行為"; "150405210")

$queryParams:={}
$queryParams.attributes:={ベースアップ評価料1: "項目.外来・在宅ベースアップ評価料(1)"}
$queryParams.parameters:={空: ""}

$診療行為:=$rezept.診療行為.query(":ベースアップ評価料1 == :空"; $queryParams)

$診療行為:=$rezept.get("診療行為"; "150444590")


$特定器材:=$rezept.特定器材.query("項目.再製造単回使用医療機器 != :1"; "")

$医薬品:=$rezept.医薬品.query("項目.薬価基準収載年月日 != :1"; "")
$医薬品:=$rezept.get("医薬品"; "610406079")

SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($医薬品; *))

$公費:=$rezept.公費().parse("9947")