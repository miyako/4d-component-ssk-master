//%attributes = {}
#DECLARE($method_path : Text; $method_name : Text)

var $code : Text
GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $code)

ARRAY LONGINT:C221($pos; 0)
ARRAY LONGINT:C221($len; 0)

$i:=1

$line:=""

While (Match regex:C1019("(?m)^(.+?):=(.+?)$"; $code; $i; $pos; $len))
	
	$line+=Substring:C12($code; $pos{1}; $len{1})
	$line+=":=("
	$line+=Substring:C12($code; $pos{2}; $len{2})
	$line+="=\"\" && ("
	$line+=Substring:C12($code; $pos{1}; $len{1})
	$line+="#Null))"
	$line+=" ? "
	$line+=Substring:C12($code; $pos{1}; $len{1})
	$line+=" : "
	$line+=Substring:C12($code; $pos{2}; $len{2})
	$line+="\r"
	
	$i:=$pos{0}+$len{0}
End while 

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $line)