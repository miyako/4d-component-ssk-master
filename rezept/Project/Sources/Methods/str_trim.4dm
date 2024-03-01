//%attributes = {"invisible":true}
C_TEXT:C284($1; $src; $0; $dst)

$src:=$1

$dst:=$src

//trim
ARRAY LONGINT:C221($pos; 0)
ARRAY LONGINT:C221($len; 0)
If (Match regex:C1019("^\\s*(.*?)\\s*$"; $src; 1; $pos; $len))
	$dst:=Substring:C12($src; $pos{1}; $len{1})
End if 

$dst:=Replace string:C233($dst; Char:C90(0x002C); ""; *)
$dst:=Replace string:C233($dst; Char:C90(0x000D); ""; *)

$0:=$dst