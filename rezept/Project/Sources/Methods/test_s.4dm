//%attributes = {}

//ds._診療行為.regenerate()

//$codes:=Split string(Get text from pasteboard; "\r\n")

//For each ($code; $codes)

var $rezept : cs:C1710.Rezept
$rezept:=cs:C1710.Rezept.new()
$診療行為:=$rezept.get("診療行為"; "150423950")

//ASSERT($診療行為#Null)

//End for each 