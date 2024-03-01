Class extends DataClass

Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710.医薬品
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710.医薬品
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710.医薬品
	
	var $pTable : Pointer
	$pTable:=This:C1470._getTablePointer()
	
	TRUNCATE TABLE:C1051($pTable->)
	SET DATABASE PARAMETER:C642($pTable->; Table sequence number:K37:31; 0)
	
	return This:C1470
	
Function _getDataFolder() : 4D:C1709.Folder
	
	return Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent.folder("DATA")
	
Function _getFile($names : Collection) : 4D:C1709.File
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder()
	
	$files:=$folder.files()
	$files:=$files.query("name in :1 and extension in :2"; $names; [".csv"; ".zip"])
	
	If ($files.length#0)
		var $file : 4D:C1709.File
		$file:=$files[0]
		If ($file.extension=".zip")
			$archive:=ZIP Read archive:C1637($file)
			$files:=$archive.root.files()
			If ($files.length#0)
				return $files[0]
			End if 
		Else 
			return $file
		End if 
	End if 
	
Function regenerate($CLI : cs:C1710.CLI)
	
	var $file : 4D:C1709.File
	$file:=This:C1470._getFile(["y@"; "医薬品@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710.CLI.new()
	End if 
	
	$CLI.print("master for 医薬品..."; "bold")
	
	If ($file=Null:C1517)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		
		This:C1470._truncateTable()._pauseIndexes()
		
		$csv:=$file.getText("windows-31j"; Document with LF:K24:22)
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		var $i : Integer
		$i:=1
		
		While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
			
			$i:=$pos{1}+$len{1}
			$line:=Substring:C12($csv; $pos{1}; $len{1})
			$values:=Split string:C1554($line; ",")
			
			This:C1470._trimDoubleQuotes($values)
			This:C1470._createRecords($CLI; $values)
			
		End while 
		
		$CLI.CR().EL().print("records imported..."; "bold")
		$CLI.print(String:C10(This:C1470.getCount()); "82;bold").LF()
		
		This:C1470._resumeIndexes()
		
		cs:C1710.Package.new().setProperty("医薬品"; $file.fullName)
		
	End if 
	
Function _createRecords($CLI : cs:C1710.CLI; $values : Collection)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.new()
	
	$e["項目"]:={}
	$e["医薬品名・規格名"]:={}
	$e["単位"]:={}
	$e["新又は現金額"]:={}
	$e["旧金額"]:={}
	
	$e["項目"]["変更区分"]:=$values[0]
	$e["項目"]["マスター種別"]:=$values[1]
	$e["医薬品コード"]:=$values[2]
	$e["医薬品名・規格名"]["漢字有効桁数"]:=$values[3]
	$e["医薬品名・規格名"]["漢字名称"]:=$values[4]
	$e["医薬品名・規格名"]["カナ有効桁数"]:=$values[5]
	$e["医薬品名・規格名"]["カナ名称"]:=$values[6]
	$e["単位"]["コード"]:=$values[7]
	$e["単位"]["漢字有効桁数"]:=$values[8]
	$e["単位"]["漢字名称"]:=$values[9]
	$e["新又は現金額"]["金額種別"]:=$values[10]
	$e["新又は現金額"]["新又は現金額"]:=$values[11]
	//予備
	$e["項目"]["麻薬・毒薬・覚せい剤原料・向精神薬"]:=$values[13]
	$e["項目"]["神経破壊剤"]:=$values[14]
	$e["項目"]["生物学的製剤"]:=$values[15]
	$e["項目"]["後発品"]:=$values[16]
	//予備
	$e["項目"]["歯科特定薬剤"]:=$values[18]
	$e["項目"]["造影(補助)剤"]:=$values[19]
	$e["項目"]["注射容量"]:=$values[20]
	$e["項目"]["収載方式等識別"]:=$values[21]
	$e["項目"]["商品名等関連"]:=$values[22]
	$e["旧金額"]["旧金額種別"]:=$values[23]
	$e["旧金額"]["旧金額"]:=$values[24]
	$e["項目"]["漢字名称変更区分"]:=$values[25]
	$e["項目"]["カナ名称変更区分"]:=$values[26]
	$e["項目"]["剤形"]:=$values[27]
	//予備
	$e["項目"]["変更年月日"]:=$values[29]
	$e["項目"]["廃止年月日"]:=$values[30]
	$e["項目"]["薬価基準コード"]:=$values[31]
	$e["項目"]["公表順序番号"]:=$values[32]
	$e["項目"]["経過措置年月日又は商品名医薬品コード使用期限"]:=$values[33]
	$e["基本漢字名称"]:=$values[34]
	
	If ($values.length>35)
		$e["項目"]["薬価基準収載年月日"]:=$values[35]
	End if 
	
	If ($values.length>36)
		$e["一般名処方マスタ"]["一般名コード"]:=$values[36]
	End if 
	
	If ($values.length>37)
		$e["一般名処方マスタ"]["一般名処方の標準的な記載"]:=$values[37]
	End if 
	
	If ($values.length>38)
		$e["一般名処方マスタ"]["一般名処方加算対象区分"]:=$values[38]
	End if 
	
	If ($values.length>39)
		$e["項目"]["抗HIV薬区分"]:=$values[39]
	End if 
	
	$e.save()
	
	//$CLI.CR().EL().print($values[4]; "226")
	
Function _trimDoubleQuotes($values : Variant)->$value : Variant
	
	$value:=$values
	
	Case of 
		: (Value type:C1509($value)=Is text:K8:3)
			
			ARRAY LONGINT:C221($pos; 0)
			ARRAY LONGINT:C221($len; 0)
			
			If (Match regex:C1019("([\"])([^\"]*)([\"])"; $value; 1; $pos; $len))
				$value:=Substring:C12($value; $pos{2}; $len{2})
			End if 
			
		: (Value type:C1509($value)=Is collection:K8:32)
			
			C_LONGINT:C283($i)
			
			For ($i; 0; $value.length-1)
				$value[$i]:=This:C1470._trimDoubleQuotes($value[$i])
			End for 
			
	End case 
	
	return $value