//%attributes = {"invisible":true}
C_COLLECTION:C1488($1;$values)
C_OBJECT:C1216($dataClass;$e)

$values:=$1

$dataClass:=ds:C1482.修飾語

$e:=$dataClass.new()

$e["項目"]:=New object:C1471
$e["項目"]["変更区分"]:=$values[0]
$e["項目"]["マスター種別"]:=$values[1]
$e["修飾語コード"]:=$values[2]
  //予備
  //予備
$e["項目"]["修飾語名称桁数"]:=$values[5]
$e["項目"]["修飾語名称"]:=$values[6]
  //予備
$e["項目"]["修飾語カナ名称桁数"]:=$values[8]
$e["項目"]["修飾語カナ名称"]:=$values[9]
  //予備
$e["項目"]["修飾語名称_変更情報"]:=$values[11]
$e["項目"]["修飾語カナ名称_変更情報"]:=$values[12]
$e["項目"]["収載年月日"]:=$values[13]
$e["項目"]["変更年月日"]:=$values[14]
$e["項目"]["廃止年月日"]:=$values[15]
$e["項目"]["修飾語管理番号"]:=$values[16]
$e["項目"]["修飾語交換用コード"]:=$values[17]
$e["項目"]["修飾語区分"]:=$values[18]

$e["修飾語名称"]:=$values[6]

$e.save()