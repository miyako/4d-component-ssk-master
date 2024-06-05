Class extends DataClass

Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710._特定器材
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710._特定器材
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->; *)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710._特定器材
	
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
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	var $i : Integer
	
	var $files1; $files2 : Collection
	$files1:=This:C1470._getFiles(["t@"; "特定器材@"])
	$files2:=This:C1470._getFiles(["rezept-master-03@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710._CLI.new()
	End if 
	
	$CLI.print("master for 特定器材..."; "bold")
	
	If ($files1.length#0) || ($files2.length#0)
		This:C1470._truncateTable()._pauseIndexes()
	End if 
	
	If ($files1.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		For each ($file1; $files1)
			$CLI.print($file1.path; "244").LF()
			$csv:=$file1.getText("windows-31j"; Document with LF:K24:22)
			$i:=1
			While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
				$i:=$pos{1}+$len{1}
				$line:=Substring:C12($csv; $pos{1}; $len{1})
				$values:=Split string:C1554($line; ",")
				This:C1470._trimDoubleQuotes($values)
				This:C1470._createRecords($CLI; $values; $verbose)
			End while 
			cs:C1710._Package.new().setProperty("特定器材"; $file1.fullName)
			$CLI.CR().print("records imported..."; "bold")
			$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		End for each 
	End if 
	
	$CLI.print("master for 労災特定器材..."; "bold")
	
	If ($files2.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		For each ($file2; $files2)
			$CLI.print($file2.path; "244").LF()
			$csv:=$file2.getText("windows-31j"; Document with LF:K24:22)
			$i:=1
			While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
				$i:=$pos{1}+$len{1}
				$line:=Substring:C12($csv; $pos{1}; $len{1})
				$values:=Split string:C1554($line; ",")
				This:C1470._trimDoubleQuotes($values)
				This:C1470._createRecords($CLI; $values; $verbose)
			End while 
			cs:C1710._Package.new().setProperty("労災特定器材"; $file2.fullName)
			$CLI.CR().print("records imported..."; "bold")
			$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		End for each 
	End if 
	
	If ($files1.length#0) || ($files2.length#0)
		This:C1470._resumeIndexes()
	End if 
	
Function _createRecords($CLI : cs:C1710._CLI; $values : Collection; $verbose : Boolean)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.query("特定器材コード == :1"; $values[2]).first()
	
	If ($e=Null:C1517) && This:C1470._mayCreate($values[0])
		$e:=$dataClass.new()
		$e["項目"]:={}
		$e["特定器材名・規格名"]:={}
		$e["単位"]:={}
		$e["新又は現金額"]:={}
		$e["項目"]["上下限年齢"]:={}
		$e["旧金額"]:={}
		$e["項目"]["告示番号"]:={}
	End if 
	
	If ($e#Null:C1517)
		
		$e["項目"]["変更区分"]:=$values[0]
		
		If (This:C1470._mayCreate($values[0]))
			
			$e["項目"]["マスター種別"]:=($values[1]="" && ($e["項目"]["マスター種別"]#Null:C1517)) ? $e["項目"]["マスター種別"] : $values[1]
			$e["特定器材コード"]:=($values[2]="" && ($e["特定器材コード"]#Null:C1517)) ? $e["特定器材コード"] : $values[2]
			$e["特定器材名・規格名"]["漢字有効桁数"]:=($values[3]="" && ($e["特定器材名・規格名"]["漢字有効桁数"]#Null:C1517)) ? $e["特定器材名・規格名"]["漢字有効桁数"] : $values[3]
			$e["特定器材名・規格名"]["漢字名称"]:=($values[4]="" && ($e["特定器材名・規格名"]["漢字名称"]#Null:C1517)) ? $e["特定器材名・規格名"]["漢字名称"] : $values[4]
			$e["特定器材名・規格名"]["カナ有効桁数"]:=($values[5]="" && ($e["特定器材名・規格名"]["カナ有効桁数"]#Null:C1517)) ? $e["特定器材名・規格名"]["カナ有効桁数"] : $values[5]
			$e["特定器材名・規格名"]["カナ名称"]:=($values[6]="" && ($e["特定器材名・規格名"]["カナ名称"]#Null:C1517)) ? $e["特定器材名・規格名"]["カナ名称"] : $values[6]
			$e["単位"]["コード"]:=($values[7]="" && ($e["単位"]["コード"]#Null:C1517)) ? $e["単位"]["コード"] : $values[7]
			$e["単位"]["漢字有効桁数"]:=($values[8]="" && ($e["単位"]["漢字有効桁数"]#Null:C1517)) ? $e["単位"]["漢字有効桁数"] : $values[8]
			$e["単位"]["漢字名称"]:=($values[9]="" && ($e["単位"]["漢字名称"]#Null:C1517)) ? $e["単位"]["漢字名称"] : $values[9]
			$e["新又は現金額"]["金額種別"]:=($values[10]="" && ($e["新又は現金額"]["金額種別"]#Null:C1517)) ? $e["新又は現金額"]["金額種別"] : $values[10]
			$e["新又は現金額"]["新又は現金額"]:=($values[11]="" && ($e["新又は現金額"]["新又は現金額"]#Null:C1517)) ? $e["新又は現金額"]["新又は現金額"] : $values[11]
			$e["項目"]["名称使用識別"]:=($values[12]="" && ($e["項目"]["名称使用識別"]#Null:C1517)) ? $e["項目"]["名称使用識別"] : $values[12]
			$e["項目"]["年齢加算区分"]:=($values[13]="" && ($e["項目"]["年齢加算区分"]#Null:C1517)) ? $e["項目"]["年齢加算区分"] : $values[13]
			$e["項目"]["上下限年齢"]["下限年齢"]:=($values[14]="" && ($e["項目"]["上下限年齢"]["下限年齢"]#Null:C1517)) ? $e["項目"]["上下限年齢"]["下限年齢"] : $values[14]
			$e["項目"]["上下限年齢"]["上限年齢"]:=($values[15]="" && ($e["項目"]["上下限年齢"]["上限年齢"]#Null:C1517)) ? $e["項目"]["上下限年齢"]["上限年齢"] : $values[15]
			$e["旧金額"]["旧金額種別"]:=($values[16]="" && ($e["旧金額"]["旧金額種別"]#Null:C1517)) ? $e["旧金額"]["旧金額種別"] : $values[16]
			$e["旧金額"]["旧金額"]:=($values[17]="" && ($e["旧金額"]["旧金額"]#Null:C1517)) ? $e["旧金額"]["旧金額"] : $values[17]
			$e["項目"]["漢字名称変更区分"]:=($values[18]="" && ($e["項目"]["漢字名称変更区分"]#Null:C1517)) ? $e["項目"]["漢字名称変更区分"] : $values[18]
			$e["項目"]["カナ名称変更区分"]:=($values[19]="" && ($e["項目"]["カナ名称変更区分"]#Null:C1517)) ? $e["項目"]["カナ名称変更区分"] : $values[19]
			$e["項目"]["酸素等区分"]:=($values[20]="" && ($e["項目"]["酸素等区分"]#Null:C1517)) ? $e["項目"]["酸素等区分"] : $values[20]
			$e["項目"]["特定器材種別(1)"]:=($values[21]="" && ($e["項目"]["特定器材種別(1)"]#Null:C1517)) ? $e["項目"]["特定器材種別(1)"] : $values[21]
			$e["項目"]["上限価格"]:=($values[22]="" && ($e["項目"]["上限価格"]#Null:C1517)) ? $e["項目"]["上限価格"] : $values[22]
			$e["項目"]["上限点数"]:=($values[23]="" && ($e["項目"]["上限点数"]#Null:C1517)) ? $e["項目"]["上限点数"] : $values[23]
			$e["項目"]["公表順序番号"]:=($values[25]="" && ($e["項目"]["公表順序番号"]#Null:C1517)) ? $e["項目"]["公表順序番号"] : $values[25]
			$e["項目"]["廃止・新設関連"]:=($values[26]="" && ($e["項目"]["廃止・新設関連"]#Null:C1517)) ? $e["項目"]["廃止・新設関連"] : $values[26]
			$e["項目"]["変更年月日"]:=($values[27]="" && ($e["項目"]["変更年月日"]#Null:C1517)) ? $e["項目"]["変更年月日"] : $values[27]
			$e["項目"]["経過措置年月日"]:=($values[28]="" && ($e["項目"]["経過措置年月日"]#Null:C1517)) ? $e["項目"]["経過措置年月日"] : $values[28]
			$e["項目"]["廃止年月日"]:=($values[29]="" && ($e["項目"]["廃止年月日"]#Null:C1517)) ? $e["項目"]["廃止年月日"] : $values[29]
			$e["項目"]["告示番号"]["別表番号"]:=($values[30]="" && ($e["項目"]["告示番号"]["別表番号"]#Null:C1517)) ? $e["項目"]["告示番号"]["別表番号"] : $values[30]
			$e["項目"]["告示番号"]["区分番号"]:=($values[31]="" && ($e["項目"]["告示番号"]["区分番号"]#Null:C1517)) ? $e["項目"]["告示番号"]["区分番号"] : $values[31]
			$e["項目"]["DPC適用区分"]:=($values[32]="" && ($e["項目"]["DPC適用区分"]#Null:C1517)) ? $e["項目"]["DPC適用区分"] : $values[32]
			
			$e["基本漢字名称"]:=($values[36]="" && ($e["基本漢字名称"]#Null:C1517)) ? $e["基本漢字名称"] : $values[36]
			
			var $newFormat : Boolean
			
			If ($values.length>37)
				$newFormat:=True:C214
				$e["項目"]["再製造単回使用医療機器"]:=($values[37]="" && ($e["項目"]["再製造単回使用医療機器"]#Null:C1517)) ? $e["項目"]["再製造単回使用医療機器"] : $values[37]
			End if 
			
		End if 
		
		$e.save()
		
		If ($verbose)
			$CLI.CR().print($values[4]; "226").EL()
			If ($newFormat)
				$CLI.print(" 【新】"; "82;bold")
			End if 
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