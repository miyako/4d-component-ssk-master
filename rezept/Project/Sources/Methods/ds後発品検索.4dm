//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $薬価基準コード)
C_OBJECT:C1216($0; $後発医薬品)

$薬価基準コード:=$1
$後発医薬品:=Null:C1517

$params:=cs:C1710._params.new()

$params.attributes.医薬品コード:="薬価基準収載医薬品コード"
$params.parameters.検索値:=$薬価基準コード

$es:=ds:C1482.後発医薬品.query(":医薬品コード === :検索値"; $params)

If ($es.length#0)
	$後発医薬品:=$es[0]
End if 

$0:=$後発医薬品