//%attributes = {"invisible":true}
C_COLLECTION:C1488($1;$col)

$col:=$1

$json:=JSON Stringify:C1217($col)

$dataFolder:=Folder:C1567("/RESOURCES")

C_TEXT:C284($2;$name)

$name:=$2

$dataFolder.file($name+".json").setText($json;"utf-8";Document with LF:K24:22)