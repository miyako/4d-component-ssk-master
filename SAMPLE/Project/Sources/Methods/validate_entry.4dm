//%attributes = {"invisible":true}
#DECLARE($idx : Text)

$event:=FORM Event:C1606

Case of 
	: ($event.code=On After Edit:K2:43)
		$value:=Get edited text:C655
	Else 
		$value:=Form:C1466["負担者番号"+$idx]
End case 

$status:=Form:C1466.parser.parse($value)

Form:C1466["保険制度"+$idx]:=$status.保険制度

$制度の略称:=String:C10($status.制度の略称)

Form:C1466.区分:=New collection:C1472($status.区分; $制度の略称).join(" "; ck ignore null or empty:K85:5)

$start:=Length:C16(Form:C1466.区分)-Length:C16($制度の略称)

Form:C1466.地方公費.col:=$status.地方公費

OBJECT SET ENABLED:C1123(*; "pbcopy"; $status.地方公費#Null:C1517)

If ($制度の略称#"")
	ST SET ATTRIBUTES:C1093(*; "区分"; $start; 0; Attribute bold style:K65:1; 1; Attribute text color:K65:7; "#666666")
End if 

Form:C1466["法別番号"+$idx]:=$status.法別番号
Form:C1466["都道府県番号"+$idx]:=$status.都道府県番号
Form:C1466["保険者別番号"+$idx]:=$status.保険者別番号

If ($status.検証番号#Null:C1517)
	Form:C1466["検証番号"+$idx]:=$status.検証番号.value
	OBJECT SET VISIBLE:C603(*; "warning"+$idx; Not:C34($status.検証番号.match))
	OBJECT SET VISIBLE:C603(*; "検証番号"+$idx; Not:C34($status.検証番号.match))
Else 
	Form:C1466["検証番号"+$idx]:=""
	OBJECT SET VISIBLE:C603(*; "warning"+$idx; False:C215)
End if 