//%attributes = {"invisible":true,"preemptive":"incapable"}
/*

アップデートするには

*/

If (False:C215)
	
	$ds:=ds記載事項等(True:C214)
	
End if 

/*

使用するには

*/

var $rezept : cs:C1710.rezept
$rezept:=cs:C1710.rezept.new()

$s:=$rezept.診療行為.query("基本漢字名称 == :1"; "@術中術後自己血回収術@")

$ds:=ds記載事項等

$k:=$ds.診療行為コード["150405210"]