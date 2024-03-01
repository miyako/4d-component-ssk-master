//%attributes = {"invisible":true,"preemptive":"incapable"}
TRUNCATE TABLE:C1051([地方公費:9])
SET DATABASE PARAMETER:C642([地方公費:9]; Table sequence number:K37:31; 0)

$valuesFolder:=Folder:C1567("/DATA/").folder("地方公費")
$files:=$valuesFolder.files(fk ignore invisible:K87:22)
$files:=$files.query("extension === :1"; ".xlsx")

$番号:=cs:C1710.番号.new()

$values:=New collection:C1472

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
	
	$e地方公費:=ds:C1482.地方公費.new()
	
	$e地方公費.法別番号:=$value.法別番号
	$e地方公費.都道府県コード:=$value.都道府県コード
	$e地方公費.短縮制度名:=$value.短縮制度名
	
	OB REMOVE:C1226($value; "公費負担者番号")
	OB REMOVE:C1226($value; "短縮制度名")
	OB REMOVE:C1226($value; "都道府県名")
	
	$e地方公費.項目:=$value
	$e地方公費.save()
	
End for each 