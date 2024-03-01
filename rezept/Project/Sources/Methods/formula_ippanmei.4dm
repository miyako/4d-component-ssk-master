//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($1;$一般名処方)
C_BOOLEAN:C305($0)

C_TEXT:C284($薬価基準コード;$一般名コード;$例外コード)

$薬価基準コード:=$1.薬価基準コード
$一般名コード:=This:C1470.一般名コード
$例外コード:=This:C1470.項目.例外コード

If ($例外コード="")
	$0:=Substring:C12($薬価基準コード;1;9)=Substring:C12($一般名コード;1;9)
End if 