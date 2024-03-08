//%attributes = {}
$rezept:=cs:C1710.Rezept.new()

$info:=$rezept.getInfo()

$rezept.switch($info.data[1])

//$診療行為:=$rezept.get("単位"; "1")

//$診療行為:=$rezept.get("診療行為"; "150405210")



