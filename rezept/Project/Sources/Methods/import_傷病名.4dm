//%attributes = {"invisible":true,"preemptive":"incapable"}
TRUNCATE TABLE:C1051([傷病名:1])
SET DATABASE PARAMETER:C642([傷病名:1]; Table sequence number:K37:31; 0)

/*

ファイル名

b.zip

または

b_yyyymmdd.zip

*/

$valuesFolder:=Folder:C1567("/DATA/")
$names:=New collection:C1472("b@"; "傷病名@")
$files:=$valuesFolder.files()
$files:=$files.query("name in :1 and extension === :2"; $names; ".txt")  //".zip"

If ($files.length#0)
	
	//$file:=$files[0]
	//$archive:=ZIP Read archive($file)
	//$files:=$archive.root.files()
	
	If ($files.length#0)
		
		PAUSE INDEXES:C1293([傷病名:1])
		
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
			
			create_傷病名($values)
			
		End while 
		
		RESUME INDEXES:C1294([傷病名:1])
		
	End if 
End if 