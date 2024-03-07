property 診療行為 : Object
property コメント : Object

Class constructor
	
	This:C1470.診療行為:=This:C1470.ds("診療行為").診療行為
	This:C1470.コメント:=This:C1470.ds("コメント").コメント
	This:C1470.修飾語:=This:C1470.ds("修飾語").修飾語
	This:C1470.特定器材:=This:C1470.ds("特定器材").特定器材
	This:C1470.地方公費:=This:C1470.ds("地方公費").地方公費
	This:C1470.傷病名:=This:C1470.ds("傷病名").傷病名
	
Function get($dataClassName : Text) : Object
	
	If ($dataClassName#"")
		return This:C1470.ds($dataClassName).code
	End if 
	
Function params() : Object
	
	return cs:C1710._params.new()
	
Function ds($dataClassName : Text) : Object
	
	If ($dataClassName#"")
		If (Storage:C1525[$dataClassName]=Null:C1517)
			
			var $export : cs:C1710._export
			$export:=cs:C1710._export.new($dataClassName)
			$export.setup()
			
			Use (Storage:C1525)
				Storage:C1525[$dataClassName]:=OB Copy:C1225($export; ck shared:K85:29)
			End use 
			
		Else 
			$export:=Storage:C1525[$dataClassName]
		End if 
		
		return $export
		
	End if 