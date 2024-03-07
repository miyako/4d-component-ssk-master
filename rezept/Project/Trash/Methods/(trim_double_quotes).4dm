//%attributes = {"invisible":true,"preemptive":"capable"}
C_VARIANT:C1683($1;$value;$0)

$value:=$1

Case of 
	: (Value type:C1509($value)=Is text:K8:3)
		
		ARRAY LONGINT:C221($pos;0)
		ARRAY LONGINT:C221($len;0)
		
		If (Match regex:C1019("([\"])([^\"]*)([\"])";$value;1;$pos;$len))
			$value:=Substring:C12($value;$pos{2};$len{2})
		End if 
		
	: (Value type:C1509($value)=Is collection:K8:32)
		
		C_LONGINT:C283($i)
		
		For ($i;0;$value.length-1)
			$value[$i]:=trim_double_quotes ($value[$i])
		End for 
		
End case 

$0:=$value