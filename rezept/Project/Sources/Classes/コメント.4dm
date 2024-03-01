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
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	var $i : Integer
	
	var $file1; $file2 : 4D:C1709.File
	$file1:=This:C1470._getFile(["c@"; "コメント@"])
	$file2:=This:C1470._getFile(["rezept-master-06"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710.CLI.new()
	End if 
	
	$CLI.print("master for コメント..."; "bold")
	
	If ($file1#Null:C1517) || ($file2#Null:C1517)
		This:C1470._truncateTable()._pauseIndexes()
	End if 
	
	If ($file1=Null:C1517)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		$CLI.print($file1.path; "244").LF()
		
		$csv:=$file.getText("windows-31j"; Document with LF:K24:22)
		
		$i:=1
		
		While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
			
			$i:=$pos{1}+$len{1}
			$line:=Substring:C12($csv; $pos{1}; $len{1})
			$values:=Split string:C1554($line; ",")
			
			This:C1470._trimDoubleQuotes($values)
			This:C1470._createRecords($CLI; $values)
			
		End while 
		
		cs:C1710.Package.new().setProperty("コメント"; $file1.fullName)
		
	End if 
	
	$CLI.print("master for 労災コメント..."; "bold")
	
	If ($file2=Null:C1517)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		$CLI.print($file2.path; "244").LF()
		
		$csv:=$file.getText("windows-31j"; Document with LF:K24:22)
		
		$i:=1
		
		While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
			
			$i:=$pos{1}+$len{1}
			$line:=Substring:C12($csv; $pos{1}; $len{1})
			$values:=Split string:C1554($line; ",")
			
			This:C1470._trimDoubleQuotes($values)
			This:C1470._createRecords($CLI; $values)
			
		End while 
		
		cs:C1710.Package.new().setProperty("労災コメント"; $file2.fullName)
		
	End if 
	
	If ($file1#Null:C1517) || ($file2#Null:C1517)
		$CLI.CR().EL().print("records imported..."; "bold")
		$CLI.print(String:C10(This:C1470.getCount()); "82;bold").LF()
		This:C1470._resumeIndexes()
	End if 
	
Function _createRecords($CLI : cs:C1710.CLI; $values : Collection)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.new()
	
	$e["項目"]:=New object:C1471
	$e["項目"]["変更区分"]:=$values[0]
	$e["項目"]["マスター種別"]:=$values[1]
	$e["コメントコード"]:=New object:C1471
	$e["コメントコード"]["区分"]:=$values[2]
	$e["コメントコード"]["パターン"]:=$values[3]
	$e["コメントコード"]["番号"]:=$values[4]
	
	$e["コメント文"]:=New object:C1471
	$e["コメント文"]["漢字有効桁数"]:=$values[5]
	$e["コメント文"]["漢字名称"]:=$values[6]
	$e["コメント文"]["カナ有効桁数"]:=$values[7]
	$e["コメント文"]["カナ名称"]:=$values[8]
	
	$e["項目"]["レセプト編集情報1"]:=New object:C1471
	$e["項目"]["レセプト編集情報1"]["カラム位置"]:=$values[9]
	$e["項目"]["レセプト編集情報1"]["桁数"]:=$values[10]
	
	$e["項目"]["レセプト編集情報2"]:=New object:C1471
	$e["項目"]["レセプト編集情報2"]["カラム位置"]:=$values[11]
	$e["項目"]["レセプト編集情報2"]["桁数"]:=$values[12]
	
	$e["項目"]["レセプト編集情報3"]:=New object:C1471
	$e["項目"]["レセプト編集情報3"]["カラム位置"]:=$values[13]
	$e["項目"]["レセプト編集情報3"]["桁数"]:=$values[14]
	
	$e["項目"]["レセプト編集情報4"]:=New object:C1471
	$e["項目"]["レセプト編集情報4"]["カラム位置"]:=$values[15]
	$e["項目"]["レセプト編集情報4"]["桁数"]:=$values[16]
	
	$e["項目"]["漢字名称変更区分"]:=$values[17]
	$e["項目"]["カナ名称変更区分"]:=$values[18]
	
	$e.save()
	
	$CLI.CR().EL().print($values[6]; "226")
	
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
	