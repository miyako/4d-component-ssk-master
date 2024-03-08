Class extends DataClass

Function search($薬価基準コード : Text)->$一般名 : Object
	
	$params:=cs:C1710._Params.new()
	
	$params.attributes.例外コード:="項目.例外コード"
	$params.attributes.一般名コード:="一般名コード"
	$params.parameters.例外コード:="例外コード"
	$params.parameters.検索値:=Substring:C12($薬価基準コード; 1; 9)+"@"
	
	var $es : cs:C1710._一般名処方Selection
	$es:=This:C1470.query(":例外コード !== :例外コード and :一般名コード == :検索値"; $params)
	
	If ($es.length#0)
		$一般名:=$es[0]
	Else 
		
		$params.attributes.医薬品コード:="項目.薬価基準収載医薬品コード"
		$params.parameters.検索値:=$薬価基準コード
		
		$es:=ds:C1482.一般名処方例外.query(":医薬品コード === :検索値"; $params)
		
		If ($es.length#0)
			$一般名:=$es[0]
		End if 
		
	End if 
	
Function _getTablePointer1() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _getTablePointer2() : Pointer
	
	return Table:C252(ds:C1482.一般名処方例外.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710._一般名処方
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer1()->)
	PAUSE INDEXES:C1293(This:C1470._getTablePointer2()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710._一般名処方
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer1()->; *)
	RESUME INDEXES:C1294(This:C1470._getTablePointer2()->; *)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710._一般名処方
	
	var $pTable : Pointer
	$pTable:=This:C1470._getTablePointer1()
	
	TRUNCATE TABLE:C1051($pTable->)
	SET DATABASE PARAMETER:C642($pTable->; Table sequence number:K37:31; 0)
	
	$pTable:=This:C1470._getTablePointer2()
	
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
	
Function regenerate($CLI : cs:C1710._CLI; $verbose : Boolean)
	
	var $file : 4D:C1709.File
	$file:=This:C1470._getFile(["ippanmeishohoumaster_@"; "一般名処方@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710._CLI.new()
	End if 
	
	$CLI.print("master for 一般名処方..."; "bold")
	
	If ($file=Null:C1517)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		
		This:C1470._truncateTable()._pauseIndexes()
		
		//%W-533.4
		$json:=XLSX TO JSON($file.platformPath)
		//%W+533.4
		$data:=JSON Parse:C1218($json; Is object:K8:27)
		$sheets:=$data.sheets
		
		If ($sheets.length>0)
			
			This:C1470._pauseIndexes()
			
			For each ($row; $sheets[0].rows; 3)
				
				$values:=$row.values
				
				This:C1470._createRecords($CLI; $values; $verbose)
				
			End for each 
			
			$CLI.CR().print("records imported..."; "bold")
			$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
			
			If ($sheets.length>1)
				
				For each ($row; $sheets[1].rows; 3)
					
					$values:=$row.values
					
					var $e : 4D:C1709.Entity
					var $dataClass : 4D:C1709.DataClass
					
					$dataClass:=This:C1470
					
					$e:=$dataClass.new()
					
					C_TEXT:C284($区分; $一般名コード; $一般名処方の標準的な記載; $成分名; $規格)
					
					$e:=ds:C1482.一般名処方例外.new()
					
					$e["項目"]:={}
					
					If ($values[0]="")
						$values[0]:=$区分
					End if 
					If ($values[1]="")
						$values[1]:=$一般名コード
					End if 
					If ($values[2]="")
						$values[2]:=$一般名処方の標準的な記載
					End if 
					If ($values[3]="")
						$values[3]:=$成分名
					End if 
					If ($values[4]="")
						$values[4]:=$規格
					End if 
					
					$e["項目"]["区分"]:=$values[0]
					$e["一般名コード"]:=$values[1]
					$e["一般名処方の標準的な記載"]:=$values[2]
					$e["項目"]["成分名"]:=$values[3]
					$e["項目"]["規格"]:=$values[4]
					$e["項目"]["薬価基準収載医薬品コード"]:=$values[5]
					$e["項目"]["品名"]:=$values[9]
					$e["項目"]["メーカー名"]:=$values[10]
					$e["項目"]["診療報酬において加算等の算定対象となる後発医薬品"]:=$values[11]
					$e["項目"]["先発医薬品"]:=$values[12]
					$e["項目"]["同一剤形・規格の後発医薬品がある先発医薬品"]:=$values[13]
					$e["項目"]["薬価"]:=Num:C11($values[14])
					$e["項目"]["経過措置による使用期限"]:=$values[15]
					$e["項目"]["備考"]:=$values[16]
					
					$e.save()
					
					$区分:=$values[0]
					$一般名コード:=$values[1]
					$一般名処方の標準的な記載:=$values[2]
					$成分名:=$values[3]
					$規格:=$values[4]
					
					If ($verbose)
						$CLI.CR().print($values[2]; "226").EL()
					End if 
					
				End for each 
				
				$CLI.CR().print("records imported..."; "bold")
				$CLI.print(String:C10(ds:C1482.一般名処方例外.getCount()); "82;bold").EL().LF()
				
			End if 
			
			This:C1470._resumeIndexes()
			
		End if 
		
		cs:C1710._Package.new().setProperty("一般名処方"; $file.fullName)
		
	End if 
	
Function _createRecords($CLI : cs:C1710._CLI; $values : Collection; $verbose : Boolean)
	
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
	
	If ($verbose)
		$CLI.CR().print($values[2]; "226").EL()
	End if 