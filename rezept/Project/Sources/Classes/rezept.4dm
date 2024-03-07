property コメント : Object
property 診療行為 : Object
property 修飾語 : Object
property 特定器材 : Object
property 地方公費 : Object
property 傷病名 : Object
property 医薬品 : Object
property 単位 : Object

Class constructor
	
	var $property : Text
	For each ($property; This:C1470._properties())
		This:C1470[$property]:=This:C1470._ds($property)[$property]
	End for each 
	
	This:C1470.記載事項等:=This:C1470._ds("記載事項等").記載事項等
	
	//MARK:public
	
Function get($dataClassName : Text; $code : Text) : Object
	
	Case of 
		: (This:C1470._properties().includes($dataClassName))
			return This:C1470._ds($dataClassName).code[$code]
		Else 
			return 
	End case 
	
	//MARK:-
	
Function 公費() : cs:C1710._公費
	
	return cs:C1710._公費.new()
	
	//MARK:-
	
	//MARK:private
	
Function _properties() : Collection
	
	return ["コメント"; "診療行為"; "修飾語"; "特定器材"; "地方公費"; "傷病名"; "医薬品"; "単位"]
	
Function _ds($dataClassName : Text) : Object
	
	If ($dataClassName#"")
		If (Storage:C1525[$dataClassName]=Null:C1517)
			
			var $export : cs:C1710._Export
			$export:=cs:C1710._Export.new($dataClassName)
			
			Case of 
				: ($dataClassName="単位")
					$export.setup_t()
				: ($dataClassName="記載事項等")
					$export.setup_k()
				: ($dataClassName="医薬品")
					$export.setup_i()
				Else 
					$export.setup()
			End case 
			
			Use (Storage:C1525)
				Storage:C1525[$dataClassName]:=OB Copy:C1225($export; ck shared:K85:29)
			End use 
			
		Else 
			$export:=Storage:C1525[$dataClassName]
		End if 
		
		return $export
		
	End if 