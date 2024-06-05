Class extends DataClass

Function _getTablePointer() : Pointer
	
	return Table:C252(This:C1470.getInfo().tableNumber)
	
Function _pauseIndexes() : cs:C1710._診療行為
	
	PAUSE INDEXES:C1293(This:C1470._getTablePointer()->)
	
	return This:C1470
	
Function _resumeIndexes() : cs:C1710._診療行為
	
	RESUME INDEXES:C1294(This:C1470._getTablePointer()->; *)
	
	return This:C1470
	
Function _truncateTable() : cs:C1710._診療行為
	
	var $pTable : Pointer
	$pTable:=This:C1470._getTablePointer()
	
	TRUNCATE TABLE:C1051($pTable->)
	SET DATABASE PARAMETER:C642($pTable->; Table sequence number:K37:31; 0)
	
	return This:C1470
	
Function _getDataFolder() : 4D:C1709.Folder
	
	return cs:C1710._Core.new()._getDataFolder()
	
Function _getFiles($names : Collection) : Collection
	
	$dataFiles:=[]
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder()
	
	$files:=$folder.files()
	$files:=$files.query("name in :1 and extension in :2"; $names; [".csv"; ".txt"; ".zip"])
	
	If ($files.length#0)
		var $file : 4D:C1709.File
		For each ($file; $files.orderBy("name asc"))
			
			If ($file.extension=".zip")
				$archive:=ZIP Read archive:C1637($file)
				$archiveFiles:=$archive.root.files()
				If ($archiveFiles.length#0)
					$dataFiles.push($archiveFiles[0])
				End if 
			Else 
				$dataFiles.push($file)
			End if 
		End for each 
	End if 
	
	return $dataFiles
	
Function _getFile($names : Collection) : 4D:C1709.File
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder()
	
	$files:=$folder.files()
	$files:=$files.query("name in :1 and extension in :2"; $names; [".csv"; ".txt"; ".zip"])
	
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
	
Function regenerate($CLI : cs:C1710._CLI; $verbose : Boolean)
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	var $i : Integer
	
	var $files1; $files2 : Collection
	$files1:=This:C1470._getFiles(["s@"; "医科診療行為@"])
	$files2:=This:C1470._getFiles(["rezept-master-01@"])
	
	If ($CLI=Null:C1517)
		$CLI:=cs:C1710._CLI.new()
	End if 
	
	$CLI.print("master for 診療行為..."; "bold")
	
	If ($files1.length#0) || ($files2.length#0)
		This:C1470._truncateTable()._pauseIndexes()
	End if 
	
	If ($files1.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		For each ($file1; $files1)
			$CLI.print($file1.path; "244").LF()
			$csv:=$file1.getText("windows-31j"; Document with LF:K24:22)
			$i:=1
			While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
				$i:=$pos{1}+$len{1}
				$line:=Substring:C12($csv; $pos{1}; $len{1})
				$values:=Split string:C1554($line; ",")
				This:C1470._trimDoubleQuotes($values)
				This:C1470._createRecords($CLI; $values; $verbose)
			End while 
			cs:C1710._Package.new().setProperty("診療行為"; $file1.fullName)
			$CLI.CR().print("records imported..."; "bold")
			$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		End for each 
	End if 
	
	$CLI.print("master for 労災診療行為..."; "bold")
	
	If ($files2.length=0)
		$CLI.print("not found"; "196;bold").LF()
	Else 
		$CLI.print("found"; "82;bold").LF()
		For each ($file2; $files2)
			$CLI.print("found"; "82;bold").LF()
			$CLI.print($file2.path; "244").LF()
			$csv:=$file2.getText("windows-31j"; Document with LF:K24:22)
			$i:=1
			While (Match regex:C1019("(.+)"; $csv; $i; $pos; $len))
				$i:=$pos{1}+$len{1}
				$line:=Substring:C12($csv; $pos{1}; $len{1})
				$values:=Split string:C1554($line; ",")
				This:C1470._trimDoubleQuotes($values)
				This:C1470._createRecords($CLI; $values; $verbose)
			End while 
			cs:C1710._Package.new().setProperty("労災診療行為"; $file2.fullName)
			$CLI.CR().print("records imported..."; "bold")
			$CLI.print(String:C10(This:C1470.getCount()); "82;bold").EL().LF()
		End for each 
	End if 
	
	If ($files1.length#0) || ($files2.length#0)
		This:C1470._resumeIndexes()
	End if 
	
Function _createRecords($CLI : cs:C1710._CLI; $values : Collection; $verbose : Boolean)
	
	var $e : 4D:C1709.Entity
	var $dataClass : 4D:C1709.DataClass
	
	$dataClass:=This:C1470
	
	$e:=$dataClass.query("診療行為コード == :1"; $values[2]).first()
	
	If ($e=Null:C1517) && ($values[0]#"9")
		$e:=$dataClass.new()
	End if 
	
	If ($e#Null:C1517)
		
		$e["項目"]:={}
		$e["項目"]["変更区分"]:=$values[0]
		
		If ($values[0]#"9")
			
			$e["項目"]["マスター種別"]:=$values[1]
			$e["診療行為コード"]:=$values[2]
			$e["診療行為省略名称"]:={}
			$e["診療行為省略名称"]["省略漢字有効桁数"]:=$values[3]
			$e["診療行為省略名称"]["省略漢字名称"]:=$values[4]
			$e["診療行為省略名称"]["省略カナ有効桁数"]:=$values[5]
			$e["診療行為省略名称"]["省略カナ名称"]:=$values[6]
			$e["項目"]["データ規格コード"]:=$values[7]
			$e["項目"]["データ規格名"]:={}
			$e["項目"]["データ規格名"]["漢字有効桁数"]:=$values[8]
			$e["項目"]["データ規格名"]["漢字名称"]:=$values[9]
			$e["新又は現点数"]:={}
			$e["新又は現点数"]["点数識別"]:=$values[10]
			$e["新又は現点数"]["新又は現点数"]:=$values[11]
			$e["項目"]["入外適用区分"]:=$values[12]
			$e["項目"]["後期高齢者医療適用区分"]:=$values[13]
			$e["項目"]["点数欄集計先識別(入院外)"]:=$values[14]
			$e["項目"]["包括対象検査"]:=$values[15]
			//予備
			$e["項目"]["DPC適用区分"]:=$values[17]
			$e["項目"]["病院・診療所区分"]:=$values[18]
			$e["項目"]["画像等手術支援加算"]:=$values[19]
			$e["項目"]["医療観察法対象区分"]:=$values[20]
			$e["項目"]["看護加算"]:=$values[21]
			$e["項目"]["麻酔識別区分"]:=$values[22]
			$e["項目"]["入院基本料加算区分"]:=$values[23]
			$e["項目"]["傷病名関連区分"]:=$values[24]
			$e["項目"]["医学管理料"]:=$values[25]
			$e["項目"]["実日数"]:=$values[26]
			$e["項目"]["日数・回数"]:=$values[27]
			$e["項目"]["医薬品関連区分"]:=$values[28]
			$e["項目"]["きざみ値"]:={}
			$e["項目"]["きざみ値"]["きざみ値計算識別"]:=$values[29]
			$e["項目"]["きざみ値"]["下限値"]:=$values[30]
			$e["項目"]["きざみ値"]["上限値"]:=$values[31]
			$e["項目"]["きざみ値"]["きざみ値"]:=$values[32]
			$e["項目"]["きざみ値"]["きざみ点数"]:=$values[33]
			$e["項目"]["きざみ値"]["上下限エラー処理"]:=$values[34]
			$e["項目"]["上限回数"]:={}
			$e["項目"]["上限回数"]["上限回数"]:=$values[35]
			$e["項目"]["上限回数"]["上限回数エラー処理"]:=$values[36]
			$e["項目"]["注加算"]:={}
			$e["項目"]["注加算"]["注加算コード"]:=$values[37]
			$e["項目"]["注加算"]["注加算通番"]:=$values[38]
			$e["項目"]["通則年齢"]:=$values[39]
			$e["項目"]["上下限年齢"]:={}
			$e["項目"]["上下限年齢"]["下限年齢"]:=$values[40]
			$e["項目"]["上下限年齢"]["上限年齢"]:=$values[41]
			$e["項目"]["時間加算区分"]:=$values[42]
			$e["項目"]["基準適合識別"]:={}
			$e["項目"]["基準適合識別"]["適合区分"]:=$values[43]
			$e["項目"]["基準適合識別"]["対象施設基準"]:=$values[44]
			$e["項目"]["処置乳幼児加算区分"]:=$values[45]
			$e["項目"]["極低出生体重児加算区分"]:=$values[46]
			$e["項目"]["入院基本料等減算対象識別"]:=$values[47]
			$e["項目"]["ドナー分集計区分"]:=$values[48]
			$e["項目"]["検査等実施判断区分"]:=$values[49]
			$e["項目"]["検査等実施判断グループ区分"]:=$values[50]
			$e["項目"]["逓減対象区分"]:=$values[51]
			$e["項目"]["脊髄誘発電位測定等加算区分"]:=$values[52]
			$e["項目"]["頸部郭清術併施加算区分"]:=$values[53]
			$e["項目"]["自動縫合器加算区分"]:=$values[54]
			$e["項目"]["外来管理加算区分"]:=$values[55]
			$e["旧点数"]:={}
			$e["旧点数"]["点数識別"]:=$values[56]
			$e["旧点数"]["旧点数"]:=$values[57]
			$e["項目"]["漢字名称変更区分"]:=$values[58]
			$e["項目"]["カナ名称変更区分"]:=$values[59]
			$e["項目"]["検体検査コメント"]:=$values[60]
			$e["項目"]["通則加算所定点数対象区分"]:=$values[61]
			$e["項目"]["包括逓減区分"]:=$values[62]
			$e["項目"]["超音波内視鏡加算区分"]:=$values[63]
			//予備
			$e["項目"]["点数欄集計先識別(入院)"]:=$values[65]
			$e["項目"]["自動吻合器加算区分"]:=$values[66]
			$e["項目"]["告示等識別区分(1)"]:=$values[67]
			$e["項目"]["告示等識別区分(2)"]:=$values[68]
			$e["項目"]["地域加算"]:=$values[69]
			$e["項目"]["病床数区分"]:=$values[70]
			$e["項目"]["施設基準"]:={}
			$e["項目"]["施設基準"]["施設基準コード1"]:=$values[71]
			$e["項目"]["施設基準"]["施設基準コード2"]:=$values[72]
			$e["項目"]["施設基準"]["施設基準コード3"]:=$values[73]
			$e["項目"]["施設基準"]["施設基準コード4"]:=$values[74]
			$e["項目"]["施設基準"]["施設基準コード5"]:=$values[75]
			$e["項目"]["施設基準"]["施設基準コード6"]:=$values[76]
			$e["項目"]["施設基準"]["施設基準コード7"]:=$values[77]
			$e["項目"]["施設基準"]["施設基準コード8"]:=$values[78]
			$e["項目"]["施設基準"]["施設基準コード9"]:=$values[79]
			$e["項目"]["施設基準"]["施設基準コード10"]:=$values[80]
			$e["項目"]["超音波凝固切開装置等加算区分"]:=$values[81]
			$e["項目"]["短期滞在手術"]:=$values[82]
			$e["項目"]["歯科適用区分"]:=$values[83]
			$e["項目"]["コード表用番号(アルファベット部)"]:=$values[84]
			$e["項目"]["告示・通知関連番号(アルファベット部)"]:=$values[85]
			$e["項目"]["変更年月日"]:=$values[86]
			$e["項目"]["廃止年月日"]:=$values[87]
			$e["項目"]["公表順序番号"]:=$values[88]
			$e["項目"]["コード表用番号(アルファベット部を除く)"]:={}
			$e["項目"]["コード表用番号(アルファベット部を除く)"]["章"]:=$values[89]
			$e["項目"]["コード表用番号(アルファベット部を除く)"]["部"]:=$values[90]
			$e["項目"]["コード表用番号(アルファベット部を除く)"]["区分番号"]:=$values[91]
			$e["項目"]["コード表用番号(アルファベット部を除く)"]["枝番"]:=$values[92]
			$e["項目"]["コード表用番号(アルファベット部を除く)"]["項番"]:=$values[93]
			$e["項目"]["告示・通知関連番号(アルファベット部を除く)"]:={}
			$e["項目"]["告示・通知関連番号(アルファベット部を除く)"]["章"]:=$values[94]
			$e["項目"]["告示・通知関連番号(アルファベット部を除く)"]["部"]:=$values[95]
			$e["項目"]["告示・通知関連番号(アルファベット部を除く)"]["区分番号"]:=$values[96]
			$e["項目"]["告示・通知関連番号(アルファベット部を除く)"]["枝番"]:=$values[97]
			$e["項目"]["告示・通知関連番号(アルファベット部を除く)"]["項番"]:=$values[98]
			$e["項目"]["年齢加算1"]:={}
			$e["項目"]["年齢加算1"]["下限年齢"]:=$values[99]
			$e["項目"]["年齢加算1"]["上限年齢"]:=$values[100]
			$e["項目"]["年齢加算1"]["注加算診療行為コード"]:=$values[101]
			$e["項目"]["年齢加算2"]:={}
			$e["項目"]["年齢加算2"]["下限年齢"]:=$values[102]
			$e["項目"]["年齢加算2"]["上限年齢"]:=$values[103]
			$e["項目"]["年齢加算2"]["注加算診療行為コード"]:=$values[104]
			$e["項目"]["年齢加算3"]:={}
			$e["項目"]["年齢加算3"]["下限年齢"]:=$values[105]
			$e["項目"]["年齢加算3"]["上限年齢"]:=$values[106]
			$e["項目"]["年齢加算3"]["注加算診療行為コード"]:=$values[107]
			$e["項目"]["年齢加算4"]:={}
			$e["項目"]["年齢加算4"]["下限年齢"]:=$values[108]
			$e["項目"]["年齢加算4"]["上限年齢"]:=$values[109]
			$e["項目"]["年齢加算4"]["注加算診療行為コード"]:=$values[110]
			$e["項目"]["異動関連"]:=$values[111]
			$e["基本漢字名称"]:=$values[112]
			$e["項目"]["副鼻腔手術用内視鏡加算"]:=$values[113]
			$e["項目"]["副鼻腔手術用骨軟部組織切除機器加算"]:=$values[114]
			$e["項目"]["長時間麻酔管理加算"]:=$values[115]
			$e["項目"]["点数表区分番号"]:=$values[116]
			$e["項目"]["非侵襲的血行動態モニタリング"]:=$values[117]
			$e["項目"]["凍結保存同種組織加算"]:=$values[118]
			$e["項目"]["悪性腫瘍病理組織標本加算"]:=$values[119]
			$e["項目"]["創外固定器加算"]:=$values[120]
			$e["項目"]["超音波切削機器加算"]:=$values[121]
			$e["項目"]["左心耳閉鎖術併施加算"]:=$values[122]
			$e["項目"]["外来感染対策向上加算等"]:=$values[123]
			$e["項目"]["耳鼻咽喉科乳幼児処置加算"]:=$values[124]
			$e["項目"]["耳鼻咽喉科小児抗菌薬適正使用支援加算"]:=$values[125]
			$e["項目"]["切開創局所陰圧閉鎖処置機器加算"]:=$values[126]
			
			$e["項目"]["看護処遇改善評価料等"]:=$values[127]
			$e["項目"]["外来・在宅ベースアップ評価料(1)"]:=$values[128]
			$e["項目"]["外来・在宅ベースアップ評価料(2)"]:=$values[129]
			$e["項目"]["再製造単回使用医療機器使用加算"]:=$values[130]
			
		End if 
		
		$e.save()
		
		If ($verbose)
			$CLI.CR().print($values[4]; "226").EL()
		End if 
		
	End if 
	
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