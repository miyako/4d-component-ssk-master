//%attributes = {"invisible":true}
C_COLLECTION:C1488($0;$col)

C_TEXT:C284($1;$name)

$name:=$1

$dataFolder:=Folder:C1567("/RESOURCES")

$json:=$dataFolder.file($name+".json").getText("utf-8";Document with LF:K24:22)

$col:=JSON Parse:C1218($json;Is collection:K8:32)

$0:=$col