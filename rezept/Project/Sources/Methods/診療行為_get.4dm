//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $code)
C_COLLECTION:C1488($2; $記載事項)

$code:=$1
$記載事項:=$2

ARRAY LONGINT:C221($pos; 0)
ARRAY LONGINT:C221($len; 0)

C_OBJECT:C1216($診療行為)

$ds:=ds診療行為

$c診療行為:=$ds.診療行為.query("診療行為コード === :1"; $code)

If ($c診療行為.length=1)
	$診療行為:=$c診療行為[0]
	Use ($記載事項)
		$記載事項.push(OB Copy:C1225($診療行為; ck shared:K85:29; $記載事項))
	End use 
End if 