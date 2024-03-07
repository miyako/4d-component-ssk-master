//%attributes = {"invisible":true,"preemptive":"capable"}
C_VARIANT:C1683($1;$value;$0)

$value:=$1

Case of 
	: (Value type:C1509($value)=Is text:K8:3)
		
		$value:=New collection:C1472("";$value;"").join("\"")
		
	: (Value type:C1509($value)=Is collection:K8:32)
		
		C_LONGINT:C283($i)
		
		For ($i;0;$value.length-1)
			$value[$i]:=double_quote ($value[$i])
		End for 
		
End case 

$0:=$value