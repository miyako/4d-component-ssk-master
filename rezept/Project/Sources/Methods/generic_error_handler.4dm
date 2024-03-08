//%attributes = {"invisible":true}
var $CLI : cs:C1710._CLI

$CLI:=cs:C1710._CLI.new()

$CLI\
.print("ERROR"; "red;bold")\
.print(": ")\
.print(String:C10(ERROR))\
.LF()

$CLI\
.print("ERROR METHOD"; "red;bold")\
.print(": ")\
.print(ERROR METHOD)\
.LF()

$CLI\
.print("ERROR LINE"; "red;bold")\
.print(": ")\
.print(String:C10(ERROR LINE))\
.LF()

$CLI\
.print("ERROR FORMULA"; "red;bold")\
.print(": ")\
.print(ERROR FORMULA)\
.LF()

$CLI\
.print("***"+Parse formula:C1576(":C1662")+"***"; "bold")\
.LF()

$chain:=Get call chain:C1662

For each ($link; $chain)
	$CLI\
		.print("database")\
		.print(": ")\
		.print($link.database)\
		.LF()
	$CLI\
		.print("line")\
		.print(": ")\
		.print($link.line)\
		.LF()
	$CLI\
		.print("name")\
		.print(": ")\
		.print($link.name)\
		.LF()
	$CLI\
		.print("type")\
		.print(": ")\
		.print($link.type)\
		.LF()
End for each 

$CLI\
.print("***"+Parse formula:C1576(":C1015")+"***"; "bold")\
.LF()

ARRAY LONGINT:C221($codes; 0)
ARRAY TEXT:C222($components; 0)
ARRAY TEXT:C222($messages; 0)
GET LAST ERROR STACK:C1015($codes; $components; $messages)

For ($i; 1; Size of array:C274($codes))
	$CLI\
		.print("error")\
		.print(": ")\
		.print($codes{$i})\
		.LF()
	$CLI\
		.print("component")\
		.print(": ")\
		.print($components{$i})\
		.LF()
	$CLI\
		.print("message")\
		.print(": ")\
		.print($messages{$i})\
		.LF()
End for 