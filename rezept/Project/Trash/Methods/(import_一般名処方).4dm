//%attributes = {"invisible":true,"preemptive":"incapable"}
TRUNCATE TABLE:C1051([一般名処方:7])
SET DATABASE PARAMETER:C642([一般名処方:7]; Table sequence number:K37:31; 0)

TRUNCATE TABLE:C1051([一般名処方例外:8])
SET DATABASE PARAMETER:C642([一般名処方例外:8]; Table sequence number:K37:31; 0)

$dataFolder:=Folder:C1567("/DATA/")
$files:=$dataFolder.files()
$names:=New collection:C1472("ippanmeishohoumaster_@"; "一般名処方@")
$files:=$files.query("name in :1"; $names)

If ($files.length#0)
	
	$file:=$files[0]
	$json:=XLSX TO JSON($file.platformPath)
	
	$data:=JSON Parse:C1218($json; Is object:K8:27)
	
	$sheets:=$data.sheets
	
	If ($sheets.length>0)
		
		PAUSE INDEXES:C1293([一般名処方:7])
		
		For each ($row; $sheets[0].rows; 3)
			
			$values:=$row.values
			
			$一般名処方:=ds:C1482.一般名処方.new()
			
			$一般名処方["項目"]:=New object:C1471
			
			$一般名処方["項目"]["区分"]:=$values[0]
			$一般名処方["一般名コード"]:=$values[1]
			$一般名処方["一般名処方の標準的な記載"]:=$values[2]
			$一般名処方["項目"]["成分名"]:=$values[3]
			$一般名処方["項目"]["規格"]:=$values[4]
			$一般名処方["項目"]["一般名処方加算対象"]:=$values[5]
			$一般名処方["項目"]["例外コード"]:=$values[6]
			$一般名処方["項目"]["同一剤形・規格内の最低薬価"]:=Num:C11($values[7])
			$一般名処方["項目"]["備考"]:=$values[8]
			$一般名処方.save()
			
		End for each 
		
		RESUME INDEXES:C1294([一般名処方:7])
		
	End if 
	
	If ($sheets.length>1)
		
		PAUSE INDEXES:C1293([一般名処方例外:8])
		
		For each ($row; $sheets[1].rows; 3)
			
			$values:=$row.values
			
			C_TEXT:C284($区分; $一般名コード; $一般名処方の標準的な記載; $成分名; $規格)
			
			$一般名処方例外:=ds:C1482.一般名処方例外.new()
			
			$一般名処方例外["項目"]:=New object:C1471
			
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
			
			$一般名処方例外["項目"]["区分"]:=$values[0]
			$一般名処方例外["一般名コード"]:=$values[1]
			$一般名処方例外["一般名処方の標準的な記載"]:=$values[2]
			$一般名処方例外["項目"]["成分名"]:=$values[3]
			$一般名処方例外["項目"]["規格"]:=$values[4]
			$一般名処方例外["項目"]["薬価基準収載医薬品コード"]:=$values[5]
			$一般名処方例外["項目"]["品名"]:=$values[9]
			$一般名処方例外["項目"]["メーカー名"]:=$values[10]
			$一般名処方例外["項目"]["診療報酬において加算等の算定対象となる後発医薬品"]:=$values[11]
			$一般名処方例外["項目"]["先発医薬品"]:=$values[12]
			$一般名処方例外["項目"]["同一剤形・規格の後発医薬品がある先発医薬品"]:=$values[13]
			$一般名処方例外["項目"]["薬価"]:=Num:C11($values[14])
			$一般名処方例外["項目"]["経過措置による使用期限"]:=$values[15]
			$一般名処方例外["項目"]["備考"]:=$values[16]
			$一般名処方例外.save()
			
			$区分:=$values[0]
			$一般名コード:=$values[1]
			$一般名処方の標準的な記載:=$values[2]
			$成分名:=$values[3]
			$規格:=$values[4]
			
		End for each 
		
		RESUME INDEXES:C1294([一般名処方例外:8])
		
	End if 
	
End if 