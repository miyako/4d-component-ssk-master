//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($code : Text; $collection : Collection)->$isComment : Boolean

var $rezept : cs:C1710.rezept
$rezept:=cs:C1710.rezept.new()

var $コメント : Object
$コメント:=$rezept.get("コメント")[$code]

If ($コメント#Null:C1517)
	Use ($collection)
		$collection.push(OB Copy:C1225($コメント; ck shared:K85:29; $collection))
	End use 
	$isComment:=True:C214
Else 
	TRACE:C157
End if 

$0:=$isComment