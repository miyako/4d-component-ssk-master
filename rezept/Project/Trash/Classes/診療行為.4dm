property 診療行為コード : Text
property 基本漢字名称 : Text
property 診療行為省略名称 : Object
property 新又は現点数 : Object
property 旧点数 : Object
property 項目 : Object

Class constructor($診療行為 : cs:C1710._診療行為Entity)
	
	For each ($attribute; $診療行為)
		This:C1470[$attribute]:=$診療行為[$attribute]
	End for each 