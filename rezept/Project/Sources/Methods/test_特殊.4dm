//%attributes = {"invisible":true,"preemptive":"incapable"}
cs:C1710._export.new().コメント("@"; New shared collection:C1527)




//$ds:=dsコメント

$comment:=$ds.code["840000082"]


$フリー:=New collection:C1472
$検査の実施日:=New collection:C1472
$算定日:=New collection:C1472

$dataFolder:=Folder:C1567("/RESOURCES")
$files:=$dataFolder.files()
$names:=New collection:C1472("摘要欄への記載事項等一覧@"; "記載事項等")
$files:=$files.query("name in :1 and extension == :2"; $names; ".xlsx")

If ($files.length#0)
	
	$file:=$files[0]
	//%W-533.4
	$json:=XLSX TO JSON($file.platformPath)
	//%W+533.4
	C_OBJECT:C1216($data)
	
	$data:=JSON Parse:C1218($json; Is object:K8:27)
	
	$sheets:=$data.sheets
	
	If ($sheets.length>0)
		
		For each ($row; $sheets[0].rows; 1)
			
			$values:=$row.values
			
			If ($values.join()#"")
				
				If ($values.length>4)
					$comment:=$values[4]
				Else 
					$comment:=""
				End if 
				
				Case of 
					: ($comment="算定日")
						$算定日.push()
					: ($comment="検査の実施日")
						$検査の実施日.push()
					: ($comment="フリー")
						$フリー.push()
				End case 
				
			End if 
			
		End for each 
		
	End if 
	
End if 


