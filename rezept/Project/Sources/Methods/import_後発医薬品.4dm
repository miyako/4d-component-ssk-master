//%attributes = {"invisible":true,"preemptive":"incapable"}
TRUNCATE TABLE:C1051([後発医薬品:10])
SET DATABASE PARAMETER:C642([後発医薬品:10]; Table sequence number:K37:31; 0)

$dataFolder:=Folder:C1567("/DATA/")
$files:=$dataFolder.files()
$names:=New collection:C1472("tp@"; "後発医薬品@")
$files:=$files.query("name in :1"; $names).distinct("platformPath")

If ($files.length#0)
	
	For each ($file; $files)
		
		$json:=XLSX TO JSON($file)
		
		$data:=JSON Parse:C1218($json; Is object:K8:27)
		
		$sheets:=$data.sheets
		
		If ($sheets.length>0)
			
			PAUSE INDEXES:C1293([後発医薬品:10])
			
			For each ($row; $sheets[0].rows; 1)
				
				$values:=$row.values
				
				$後発医薬品:=ds:C1482.後発医薬品.new()
				$後発医薬品["項目"]:=New object:C1471
				$後発医薬品["項目"]["区分"]:=$values[0]
				$後発医薬品["薬価基準収載医薬品コード"]:=$values[1]
				$後発医薬品["項目"]["成分名"]:=$values[2]
				$後発医薬品["項目"]["規格"]:=$values[3]
				//$後発医薬品["項目"]["局"]:=$values[4]
				//$後発医薬品["項目"]["麻"]:=$values[5]
				//$後発医薬品["項目"]["※"]:=$values[6]
				$後発医薬品["品名"]:=$values[7]
				$後発医薬品["メーカー名"]:=$values[8]
				$後発医薬品["項目"]["診療報酬において加算等の算定対象となる後発医薬品"]:=$values[9]
				$後発医薬品["項目"]["先発医薬品"]:=$values[10]
				$後発医薬品["項目"]["同一剤形・規格の後発医薬品がある先発医薬品"]:=$values[11]
				$後発医薬品["項目"]["薬価"]:=Num:C11($values[12])
				$後発医薬品["項目"]["経過措置による使用期限"]:=$values[13]
				$後発医薬品["項目"]["備考"]:=$values[14]
				$後発医薬品.save()
			End for each 
			
			RESUME INDEXES:C1294([後発医薬品:10])
			
		End if 
		
	End for each 
	
End if 