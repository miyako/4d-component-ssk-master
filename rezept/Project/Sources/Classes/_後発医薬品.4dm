Class extends DataClass

Function search($薬価基準コード : Text)->$後発医薬品 : Object
	
	$params:=cs:C1710._Params.new()
	
	$params.attributes.医薬品コード:="薬価基準収載医薬品コード"
	$params.parameters.検索値:=$薬価基準コード
	
	var $es : cs:C1710._後発医薬品Selection
	$es:=This:C1470.query(":医薬品コード === :検索値"; $params)
	
	If ($es.length#0)
		$後発医薬品:=$es[0]
	End if 
	
Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710._後発医薬品
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710._後発医薬品
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710._後発医薬品
	
	var $pTable : Pointer
	$pTable:=This:C1470._getTablePointer()
	
	TRUNCATE TABLE:C1051($pTable->)
	SET DATABASE PARAMETER:C642($pTable->; Table sequence number:K37:31; 0)
	
	return This:C1470
	
Function _getDataFolder() : 4D:C1709.Folder
	
	return cs:C1710._Core.new()._getDataFolder()
	
Function _getFiles($names : Collection) : Collection
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder()
	
	$files:=$folder.files()
	return $files.query("name in :1 and extension in :2"; $names; [".xlsx"])
	
Function regenerate($CLI : cs:C1710._CLI; $verbose : Boolean)
	
	var $files : Collection
	$files:=This:C1470._getFiles(["tp@"; "後発医薬品@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710._CLI.new()
	End if 
	
	$CLI.print("master for 後発医薬品..."; "bold")
	
	If ($files.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		For each ($file; $files)
			$CLI.print($file.path; "244").LF()
		End for each 
		
		This:C1470._truncateTable()._pauseIndexes()
		
		For each ($file; $files)
			
			var $sheet : Object
			//%W-533.4
			$json:=XLSX TO JSON($file.platformPath)
			//%W+533.4
			$data:=JSON Parse:C1218($json; Is object:K8:27)
			$sheets:=$data.sheets
			
			If ($sheets.length>0)
				$sheet:=$sheets[0]
				For each ($row; $sheet.rows; 1)
					$values:=$row.values
					This:C1470._createRecords($CLI; $values; $verbose)
				End for each 
				
			End if 
			
		End for each 
		
		$CLI.CR().print("records imported..."; "bold")
		$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		
		This:C1470._resumeIndexes()
		
		cs:C1710._Package.new().setProperty("後発医薬品"; $files.extract("fullName"))
		
	End if 
	
Function _createRecords($CLI : cs:C1710._CLI; $values : Collection; $verbose : Boolean)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.new()
	
	$e["項目"]:={}
	
	$e["項目"]["区分"]:=$values[0]
	$e["薬価基準収載医薬品コード"]:=$values[1]
	$e["項目"]["成分名"]:=$values[2]
	$e["項目"]["規格"]:=$values[3]
	//$e["項目"]["局"]:=$values[4]
	//$e["項目"]["麻"]:=$values[5]
	//$e["項目"]["※"]:=$values[6]
	$e["品名"]:=$values[7]
	$e["メーカー名"]:=$values[8]
	$e["項目"]["診療報酬において加算等の算定対象となる後発医薬品"]:=$values[9]
	$e["項目"]["先発医薬品"]:=$values[10]
	$e["項目"]["同一剤形・規格の後発医薬品がある先発医薬品"]:=$values[11]
	$e["項目"]["薬価"]:=Num:C11($values[12])
	$e["項目"]["経過措置による使用期限"]:=$values[13]
	$e["項目"]["備考"]:=$values[14]
	
	$e.save()
	
	If ($verbose)
		$CLI.CR().print(This:C1470._truncateString($values[7]; 40); "226").EL()
	End if 
	
Function _truncateString($value : Text; $length : Integer) : Text
	
	If (Length:C16($value)>$length)
		return Substring:C12($value; 1; $length-1)+"..."
	Else 
		return $value
	End if 
	