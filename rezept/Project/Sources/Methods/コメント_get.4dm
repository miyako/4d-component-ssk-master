//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $code)
C_COLLECTION:C1488($2; $記載事項)
C_BOOLEAN:C305($0; $isComment)

$code:=$1
$記載事項:=$2

$ds:=dsコメント

C_OBJECT:C1216($コメント)

$コメント:=$ds.code[$code]

If ($コメント#Null:C1517)
	Use ($記載事項)
		$記載事項.push(OB Copy:C1225($コメント; ck shared:K85:29; $記載事項))
	End use 
	$isComment:=True:C214
Else 
	TRACE:C157
End if 

If (False:C215)
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	If (Match regex:C1019("(\\d{1})(\\d{2})(\\d{6})"; $code; 1; $pos; $len))
		$区分:=Substring:C12($code; $pos{1}; $len{1})
		$パターン:=Substring:C12($code; $pos{2}; $len{2})
		$番号:=Substring:C12($code; $pos{3}; $len{3})
		$ds:=dsコメント
		$cコメント:=$ds.コメント.query("コメントコード.区分 === :1 and コメントコード.パターン === :2 and コメントコード.番号 === :3"; $区分; $パターン; $番号)
		If ($cコメント.length=1)
			$コメント:=$cコメント[0]
			Use ($記載事項)
				$記載事項.push(OB Copy:C1225($コメント; ck shared:K85:29; $記載事項))
			End use 
			$isComment:=True:C214
		End if 
	End if 
End if 

$0:=$isComment