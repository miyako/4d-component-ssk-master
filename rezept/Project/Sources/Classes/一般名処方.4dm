Class extends DataClass

Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710.一般名処方
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710.一般名処方
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710.一般名処方
	
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
	$files:=$files.query("name in :1 and extension in :2"; $names; [".xlsx"])
	
	If ($files.length#0)
		return $files[0]
	End if 
	
Function regenerate($CLI : cs:C1710.CLI)
	
	var $file : 4D:C1709.File
	$file:=This:C1470._getFile(["ippanmeishohoumaster_@"; "一般名処方@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710.CLI.new()
	End if 
	
	$CLI.print("master for 一般名処方..."; "bold")
	
	If ($file=Null:C1517)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		
		This:C1470._truncateTable()._pauseIndexes()
		
		var $sheet : Object
		//%W-533.4
		$json:=XLSX TO JSON($file.platformPath)
		//%W+533.4
		$data:=JSON Parse:C1218($json; Is object:K8:27)
		$sheets:=$data.sheets
		If ($sheets.length>0)
			If ($sheets.length>0)
				$sheet:=$sheets[0]
			End if 
		End if 
		
		If ($sheet#Null:C1517)
			For each ($row; $sheet.rows; 3)
				$values:=$row.values
				This:C1470._createRecords($CLI; $values)
			End for each 
		End if 
		
		$CLI.CR().EL().print("records imported..."; "bold")
		$CLI.print(String:C10(This:C1470.getCount()); "82;bold").LF()
		
		This:C1470._resumeIndexes()
		
		cs:C1710.Package.new().setProperty("一般名処方"; $file.fullName)
		
	End if 
	
Function _createRecords($CLI : cs:C1710.CLI; $values : Collection)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.new()
	
	$e["項目"]:={}
	
	$e["項目"]["区分"]:=$values[0]
	$e["一般名コード"]:=$values[1]
	$e["一般名処方の標準的な記載"]:=$values[2]
	$e["項目"]["成分名"]:=$values[3]
	$e["項目"]["規格"]:=$values[4]
	$e["項目"]["一般名処方加算対象"]:=$values[5]
	$e["項目"]["例外コード"]:=$values[6]
	$e["項目"]["同一剤形・規格内の最低薬価"]:=Num:C11($values[7])
	$e["項目"]["備考"]:=$values[8]
	
	$e.save()
	
	$CLI.CR().EL().print($values[2]; "226")