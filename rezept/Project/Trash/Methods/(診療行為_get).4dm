//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Text; $collection : Collection)

var $rezept : cs:C1710.rezept
$rezept:=cs:C1710.rezept.new()

var $c診療行為 : Collection
$c診療行為:=$rezept.診療行為.query("診療行為コード === :1"; $code)

If ($c診療行為.length=1)
	var $診療行為 : Object
	$診療行為:=$c診療行為[0]
	Use ($collection)
		$collection.push(OB Copy:C1225($診療行為; ck shared:K85:29; $collection))
	End use 
End if 