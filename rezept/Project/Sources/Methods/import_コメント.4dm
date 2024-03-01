//%attributes = {"invisible":true,"preemptive":"incapable"}
TRUNCATE TABLE:C1051([コメント:2])
SET DATABASE PARAMETER:C642([コメント:2]; Table sequence number:K37:31; 0)

/*

ファイル名

c.zip

または

c_ALLyyyymmdd.zip

*/

$valuesFolder:=Folder:C1567("/DATA/")
$files:=$valuesFolder.files()
$names:=New collection:C1472("c@"; "コメント@")
$files:=$files.query("name in :1 and extension === :2"; $names; ".csv")  //".zip"

If ($files.length#0)
	
	//$file:=$files[0]
	//$archive:=ZIP Read archive($file)
	//$files:=$archive.root.files()
	
	If ($files.length#0)
		
		PAUSE INDEXES:C1293([コメント:2])
		
		$csv:=$files[0].getText("windows-31j"; Document with LF:K24:22)
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		C_LONGINT:C283($i)
		$i:=1
		
		While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
			
			$i:=$pos{1}+$len{1}
			$line:=Substring:C12($csv; $pos{1}; $len{1})
			$values:=Split string:C1554($line; ",")
			
			trim_double_quotes($values)
			
			create_コメント($values)
			
		End while 
		
/*
		
ファイル名
		
nnnnnnnnn.csv
		
*/
		
		$valuesFolder:=Folder:C1567("/DATA/")
		$files:=$valuesFolder.files()
		$names:=New collection:C1472("000506006")
		$files:=$files.query("name in :1 and extension === :2"; $names; ".csv")
		
		If ($files.length#0)
			
			$csv:=$files[0].getText("windows-31j"; Document with LF:K24:22)
			
			ARRAY LONGINT:C221($pos; 0)
			ARRAY LONGINT:C221($len; 0)
			
			C_LONGINT:C283($i)
			$i:=1
			
			While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
				
				$i:=$pos{1}+$len{1}
				$line:=Substring:C12($csv; $pos{1}; $len{1})
				$values:=Split string:C1554($line; ",")
				
				trim_double_quotes($values)
				
				create_コメント($values)
				
			End while 
			
		End if 
		
		RESUME INDEXES:C1294([コメント:2])
		
	End if 
End if 