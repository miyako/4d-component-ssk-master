Class extends DataClass

Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710._医薬品
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710._医薬品
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->; *)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710._医薬品
	
	var $pTable : Pointer
	$pTable:=This:C1470._getTablePointer()
	
	TRUNCATE TABLE:C1051($pTable->)
	SET DATABASE PARAMETER:C642($pTable->; Table sequence number:K37:31; 0)
	
	return This:C1470
	
Function _getDataFolder() : 4D:C1709.Folder
	
	return cs:C1710._Core.new()._getDataFolder()
	
Function _sortFiles($param : Object)
	
	var $file1; $file2 : 4D:C1709.File
	
	$file1:=$param.value
	$file2:=$param.value2
	
	$name1:=$file1.name
	$name2:=$file2.name
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019(".+(\\d{8})"; $name1; 1; $pos; $len))
		$name1:=Substring:C12($name1; $pos{1}; $len{1})
	End if 
	
	If (Match regex:C1019(".+(\\d{8})"; $name2; 1; $pos; $len))
		$name2:=Substring:C12($name2; $pos{1}; $len{1})
	End if 
	
	$param.result:=$name1<$name2
	
Function _getFiles($names : Collection) : Collection
	
	$dataFiles:=[]
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder()
	
	$files:=$folder.files()
	$files:=$files.query("name in :1 and extension in :2"; $names; [".csv"; ".txt"; ".zip"])
	
	If ($files.length#0)
		var $file : 4D:C1709.File
		For each ($file; $files.sort(This:C1470._sortFiles))
			If ($file.extension=".zip")
				$archive:=ZIP Read archive:C1637($file)
				$archiveFiles:=$archive.root.files()
				If ($archiveFiles.length#0)
					$dataFiles.push($archiveFiles[0])
				End if 
			Else 
				$dataFiles.push($file)
			End if 
		End for each 
	End if 
	
	return $dataFiles
	
Function _getFile($names : Collection) : 4D:C1709.File
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder()
	
	$files:=$folder.files()
	$files:=$files.query("name in :1 and extension in :2"; $names; [".csv"; ".txt"; ".zip"])
	
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
	
Function regenerate($CLI : cs:C1710._CLI; $verbose : Boolean)
	
	var $files : Collection
	$files:=This:C1470._getFiles(["y@"; "医薬品@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710._CLI.new()
	End if 
	
	$CLI.print("master for 医薬品..."; "bold")
	
	If ($file.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		This:C1470._truncateTable()._pauseIndexes()
		For each ($file; $files)
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
				This:C1470._createRecords($CLI; $values; $verbose)
			End while 
			$CLI.CR().print("records imported..."; "bold")
			$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		End for each 
		
		This:C1470._resumeIndexes()
		
		cs:C1710._Package.new().setProperty("医薬品"; $file.fullName)
		
	End if 
	
Function _createRecords($CLI : cs:C1710._CLI; $values : Collection; $verbose : Boolean)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.query("医薬品コード == :1"; $values[2]).first()
	
	If ($e=Null:C1517) && This:C1470._mayCreate($values[0])
		$e:=$dataClass.new()
		$e["項目"]:={}
		$e["医薬品名・規格名"]:={}
		$e["単位"]:={}
		$e["新又は現金額"]:={}
		$e["旧金額"]:={}
		$e["一般名処方マスタ"]:={}
	End if 
	
	If ($e#Null:C1517)
		
		$e["項目"]["変更区分"]:=$values[0]
		
		If (This:C1470._mayCreate($values[0]))
			
			$e["項目"]["マスター種別"]:=($values[1]="" && ($e["項目"]["マスター種別"]#Null:C1517)) ? $e["項目"]["マスター種別"] : $values[1]
			$e["医薬品コード"]:=($values[2]="" && ($e["医薬品コード"]#Null:C1517)) ? $e["医薬品コード"] : $values[2]
			$e["医薬品名・規格名"]["漢字有効桁数"]:=($values[3]="" && ($e["医薬品名・規格名"]["漢字有効桁数"]#Null:C1517)) ? $e["医薬品名・規格名"]["漢字有効桁数"] : $values[3]
			$e["医薬品名・規格名"]["漢字名称"]:=($values[4]="" && ($e["医薬品名・規格名"]["漢字名称"]#Null:C1517)) ? $e["医薬品名・規格名"]["漢字名称"] : $values[4]
			$e["医薬品名・規格名"]["カナ有効桁数"]:=($values[5]="" && ($e["医薬品名・規格名"]["カナ有効桁数"]#Null:C1517)) ? $e["医薬品名・規格名"]["カナ有効桁数"] : $values[5]
			$e["医薬品名・規格名"]["カナ名称"]:=($values[6]="" && ($e["医薬品名・規格名"]["カナ名称"]#Null:C1517)) ? $e["医薬品名・規格名"]["カナ名称"] : $values[6]
			$e["単位"]["コード"]:=($values[7]="" && ($e["単位"]["コード"]#Null:C1517)) ? $e["単位"]["コード"] : $values[7]
			$e["単位"]["漢字有効桁数"]:=($values[8]="" && ($e["単位"]["漢字有効桁数"]#Null:C1517)) ? $e["単位"]["漢字有効桁数"] : $values[8]
			$e["単位"]["漢字名称"]:=($values[9]="" && ($e["単位"]["漢字名称"]#Null:C1517)) ? $e["単位"]["漢字名称"] : $values[9]
			$e["新又は現金額"]["金額種別"]:=($values[10]="" && ($e["新又は現金額"]["金額種別"]#Null:C1517)) ? $e["新又は現金額"]["金額種別"] : $values[10]
			$e["新又は現金額"]["新又は現金額"]:=($values[11]="" && ($e["新又は現金額"]["新又は現金額"]#Null:C1517)) ? $e["新又は現金額"]["新又は現金額"] : $values[11]
			$e["項目"]["麻薬・毒薬・覚せい剤原料・向精神薬"]:=($values[13]="" && ($e["項目"]["麻薬・毒薬・覚せい剤原料・向精神薬"]#Null:C1517)) ? $e["項目"]["麻薬・毒薬・覚せい剤原料・向精神薬"] : $values[13]
			$e["項目"]["神経破壊剤"]:=($values[14]="" && ($e["項目"]["神経破壊剤"]#Null:C1517)) ? $e["項目"]["神経破壊剤"] : $values[14]
			$e["項目"]["生物学的製剤"]:=($values[15]="" && ($e["項目"]["生物学的製剤"]#Null:C1517)) ? $e["項目"]["生物学的製剤"] : $values[15]
			$e["項目"]["後発品"]:=($values[16]="" && ($e["項目"]["後発品"]#Null:C1517)) ? $e["項目"]["後発品"] : $values[16]
			$e["項目"]["歯科特定薬剤"]:=($values[18]="" && ($e["項目"]["歯科特定薬剤"]#Null:C1517)) ? $e["項目"]["歯科特定薬剤"] : $values[18]
			$e["項目"]["造影(補助)剤"]:=($values[19]="" && ($e["項目"]["造影(補助)剤"]#Null:C1517)) ? $e["項目"]["造影(補助)剤"] : $values[19]
			$e["項目"]["注射容量"]:=($values[20]="" && ($e["項目"]["注射容量"]#Null:C1517)) ? $e["項目"]["注射容量"] : $values[20]
			$e["項目"]["収載方式等識別"]:=($values[21]="" && ($e["項目"]["収載方式等識別"]#Null:C1517)) ? $e["項目"]["収載方式等識別"] : $values[21]
			$e["項目"]["商品名等関連"]:=($values[22]="" && ($e["項目"]["商品名等関連"]#Null:C1517)) ? $e["項目"]["商品名等関連"] : $values[22]
			$e["旧金額"]["旧金額種別"]:=($values[23]="" && ($e["旧金額"]["旧金額種別"]#Null:C1517)) ? $e["旧金額"]["旧金額種別"] : $values[23]
			$e["旧金額"]["旧金額"]:=($values[24]="" && ($e["旧金額"]["旧金額"]#Null:C1517)) ? $e["旧金額"]["旧金額"] : $values[24]
			$e["項目"]["漢字名称変更区分"]:=($values[25]="" && ($e["項目"]["漢字名称変更区分"]#Null:C1517)) ? $e["項目"]["漢字名称変更区分"] : $values[25]
			$e["項目"]["カナ名称変更区分"]:=($values[26]="" && ($e["項目"]["カナ名称変更区分"]#Null:C1517)) ? $e["項目"]["カナ名称変更区分"] : $values[26]
			$e["項目"]["剤形"]:=($values[27]="" && ($e["項目"]["剤形"]#Null:C1517)) ? $e["項目"]["剤形"] : $values[27]
			$e["項目"]["変更年月日"]:=($values[29]="" && ($e["項目"]["変更年月日"]#Null:C1517)) ? $e["項目"]["変更年月日"] : $values[29]
			$e["項目"]["廃止年月日"]:=($values[30]="" && ($e["項目"]["廃止年月日"]#Null:C1517)) ? $e["項目"]["廃止年月日"] : $values[30]
			$e["項目"]["薬価基準コード"]:=($values[31]="" && ($e["項目"]["薬価基準コード"]#Null:C1517)) ? $e["項目"]["薬価基準コード"] : $values[31]
			$e["項目"]["公表順序番号"]:=($values[32]="" && ($e["項目"]["公表順序番号"]#Null:C1517)) ? $e["項目"]["公表順序番号"] : $values[32]
			$e["項目"]["経過措置年月日又は商品名医薬品コード使用期限"]:=($values[33]="" && ($e["項目"]["経過措置年月日又は商品名医薬品コード使用期限"]#Null:C1517)) ? $e["項目"]["経過措置年月日又は商品名医薬品コード使用期限"] : $values[33]
			$e["基本漢字名称"]:=($values[34]="" && ($e["基本漢字名称"]#Null:C1517)) ? $e["基本漢字名称"] : $values[34]
			
			var $newFormat : Boolean
			
			If ($values.length>35)
				$newFormat:=True:C214
				$e["項目"]["薬価基準収載年月日"]:=($values[35]="" && ($e["項目"]["薬価基準収載年月日"]#Null:C1517)) ? $e["項目"]["薬価基準収載年月日"] : $values[35]
				If ($values.length>36)
					$e["一般名処方マスタ"]["一般名コード"]:=($values[36]="" && ($e["一般名処方マスタ"]["一般名コード"]#Null:C1517)) ? $e["一般名処方マスタ"]["一般名コード"] : $values[36]
				End if 
				If ($values.length>37)
					$e["一般名処方マスタ"]["一般名処方の標準的な記載"]:=($values[37]="" && ($e["一般名処方マスタ"]["一般名処方の標準的な記載"]#Null:C1517)) ? $e["一般名処方マスタ"]["一般名処方の標準的な記載"] : $values[37]
				End if 
				If ($values.length>38)
					$e["一般名処方マスタ"]["一般名処方加算対象区分"]:=($values[38]="" && ($e["一般名処方マスタ"]["一般名処方加算対象区分"]#Null:C1517)) ? $e["一般名処方マスタ"]["一般名処方加算対象区分"] : $values[38]
				End if 
				If ($values.length>39)
					$e["項目"]["抗HIV薬区分"]:=($values[39]="" && ($e["項目"]["抗HIV薬区分"]#Null:C1517)) ? $e["項目"]["抗HIV薬区分"] : $values[39]
				End if 
			End if 
			
		End if 
		
		$e.save()
		
		If ($verbose)
			$CLI.CR().print($values[4]; "226")
			If ($newFormat)
				$CLI.print(" 【新】"; "82;bold")
			End if 
			$CLI.EL()
		End if 
		
	End if 
	
Function _mayCreate($value : Text) : Boolean
	
	Case of 
		: ($value="0")  //継続
			return True:C214
		: ($value="1")  //抹消
			return False:C215
		: ($value="2")  //復活
			return True:C214
		: ($value="3")  //新規
			return True:C214
		: ($value="5")  //変更
			return True:C214
		: ($value="9")  //廃止
			return False:C215
	End case 
	
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