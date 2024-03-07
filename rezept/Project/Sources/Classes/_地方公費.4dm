Class extends DataClass

Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710._地方公費
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710._地方公費
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->; *)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710._地方公費
	
	var $pTable : Pointer
	$pTable:=This:C1470._getTablePointer()
	
	TRUNCATE TABLE:C1051($pTable->)
	SET DATABASE PARAMETER:C642($pTable->; Table sequence number:K37:31; 0)
	
	return This:C1470
	
Function _getDataFolder() : 4D:C1709.Folder
	
	return Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent.folder("DATA")
	
Function _getFiles() : Collection
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder().folder("地方公費")
	
	$files:=$folder.files()
	return $files.query("extension in :1"; [".xlsx"])
	
Function regenerate($CLI : cs:C1710.CLI; $verbose : Boolean)
	
	$files:=This:C1470._getFiles()
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710.CLI.new()
	End if 
	
	$CLI.print("master for 地方公費..."; "bold")
	
	If ($files.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		For each ($file; $files)
			$CLI.print($file.path; "244").LF()
		End for each 
		
		var $番号 : cs:C1710._番号
		$番号:=cs:C1710._番号.new()
		
		This:C1470._truncateTable()._pauseIndexes()
		
		$values:=[]
		
		For each ($file; $files)
			//%W-533.4
			$json:=XLSX TO JSON($file.platformPath)
			//%W+533.4
			C_OBJECT:C1216($data)
			
			$data:=JSON Parse:C1218($json; Is object:K8:27)
			
			$name:=$file.name
			
			ARRAY LONGINT:C221($pos; 0)
			ARRAY LONGINT:C221($len; 0)
			
			If (Match regex:C1019("^(\\d*)(?:[\\.\\s]*)(.+)$"; $name; 1; $pos; $len))
				$code:=String:C10(Num:C11(Substring:C12($name; $pos{1}; $len{1})); "00")
				$name:=Substring:C12($name; $pos{2}; $len{2})
				$name:=$番号._都道府県($code)
				
				$sheets:=$data.sheets
				
				If ($sheets.length>0)
					
					$sheet:=$sheets[0]
					
					$rows:=$sheet.rows
					
					If ($rows.length>33)
						For ($x; 1; $rows[0].values.length-1)
							$value:={}
							$node:=$value
							$mode:=""
							For ($y; 0; 32)
								$row:=$rows[$y]
								$attribute:=$row.values[0]
								
								If ($row.values.length>$x)
									$stringValue:=$row.values[$x]
								Else 
									$stringValue:=""
								End if 
								
								Case of 
									: ($attribute="※所得情報")
										$node["所得情報"]:=$stringValue
									: ($attribute="レセプト請求（印刷）")
										$node["レセプト請求"]:=Num:C11($stringValue)
									: ($attribute="年齢（開始－終了）")
										If (Match regex:C1019("(\\d+)-(\\d+)"; $stringValue; 1; $pos; $len))
											$node.年齢開始:=Num:C11(Substring:C12($stringValue; $pos{1}; $len{1}))
											$node.年齢終了:=Num:C11(Substring:C12($stringValue; $pos{2}; $len{2}))
										End if 
									: ($attribute="外来負担区分") | ($attribute="入院負担区分")
										$mode:=$attribute
										$node:={}
										$value[$attribute]:=$node
										$node[$attribute]:=Num:C11($stringValue)
									: ($attribute="短縮制度名")
										$node[$attribute]:=$stringValue
									: ($attribute="法別番号")
										$node[$attribute]:=String:C10(Num:C11($stringValue); "00")
									: ($attribute="保険番号")
										$node[$attribute]:=String:C10(Num:C11($stringValue); "000")
									Else 
										$node[$attribute]:=Num:C11($stringValue)
								End case 
								
							End for 
							
							If ($rows.length>34)
								$row:=$rows[34]
								$attribute:=$row.values[0]
								If ($row.values.length>$x)
									$stringValue:=$row.values[$x]
									$value[$attribute]:=Split string:C1554($stringValue; "\n"; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
								End if 
							End if 
							
							$value.都道府県コード:=$code
							
							$values.push($value)
						End for 
					End if 
				End if 
				
			End if 
			
		End for each 
		
		For each ($value; $values)
			This:C1470._createRecords($CLI; $value; $verbose)
		End for each 
		
		$CLI.CR().print("records imported..."; "bold")
		$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		
		This:C1470._resumeIndexes()
		
		cs:C1710._Package.new().setProperty("地方公費"; $files.extract("fullName"))
		
	End if 
	
Function _createRecords($CLI : cs:C1710.CLI; $value : Object; $verbose : Boolean)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.new()
	
	$e.法別番号:=$value.法別番号
	$e.都道府県コード:=$value.都道府県コード
	$e.短縮制度名:=$value.短縮制度名
	
	OB REMOVE:C1226($value; "公費負担者番号")
	OB REMOVE:C1226($value; "短縮制度名")
	OB REMOVE:C1226($value; "都道府県名")
	
	$e.項目:=$value
	
	$e.save()
	
	If ($verbose)
		$CLI.CR().print($values[2]; "226").EL()
	End if 