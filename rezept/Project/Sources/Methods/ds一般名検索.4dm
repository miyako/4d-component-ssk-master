//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $薬価基準コード)
C_OBJECT:C1216($0; $一般名)

$薬価基準コード:=$1
$一般名:=Null:C1517

$params:=new_query_params

If (True:C214)
	
	$params.attributes.例外コード:="項目.例外コード"
	$params.attributes.一般名コード:="一般名コード"
	$params.parameters.例外コード:="例外コード"
	$params.parameters.検索値:=Substring:C12($薬価基準コード; 1; 9)+"@"
	$es:=ds:C1482.一般名処方.query(":例外コード !== :例外コード and :一般名コード == :検索値"; $params)
	
End if 

If ($es.length#0)
	$一般名:=$es[0]
Else 
	
	$params.attributes.医薬品コード:="項目.薬価基準収載医薬品コード"
	$params.parameters.検索値:=$薬価基準コード
	
	$es:=ds:C1482.一般名処方例外.query(":医薬品コード === :検索値"; $params)
	
	If ($es.length#0)
		$一般名:=$es[0]
	End if 
	
End if 

$0:=$一般名