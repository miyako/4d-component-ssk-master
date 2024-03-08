Class constructor($dataClassName : Text)
	
	This:C1470.dataClassName:=$dataClassName
	This:C1470[$dataClassName]:=[]
	This:C1470.code:={}
	This:C1470.file:=Null:C1517
	
	$folder:=This:C1470._getDataFolder()
	
	This:C1470._dataFolder:=Folder:C1567("/RESOURCES/")
	
	var $manifest : Object
	$manifest:=This:C1470.getManifest()
	If ($manifest#Null:C1517) && ($manifest.file.exists)
		This:C1470._dataFolder:=$manifest.file.parent
	End if 
	
Function getInfo() : Object
	
	var $manifests; $manifest : Collection
	$manifests:=This:C1470._scanDataFolder()
	
	$info:={data: $manifests}
	
	$manifest:=$manifests.query("active == true")
	If ($manifest.length#0)
		$info.active:=$manifest[0]
	End if 
	
	return $info
	
Function getManifest() : Object
	
	$manifests:=This:C1470._scanDataFolder().query("active == true")
	
	If ($manifests.length#0)
		return $manifests[0]
	End if 
	
Function setManifest($folder : 4D:C1709.Folder; $manifest : Object) : cs:C1710._Export
	
	This:C1470._unsetManifest()
	
	$manifest.active:=True:C214
	
	$folder.file("manifest.json").setText(JSON Stringify:C1217($manifest; *))
	
	return This:C1470
	
Function _unsetManifest() : cs:C1710._Export
	
	$manifests:=This:C1470._getManifests()
	
	For each ($file; $manifests)
		$manifest:=$file.getText()
		$json:=JSON Parse:C1218($manifest)
		$json.active:=False:C215
		$manifest:=JSON Stringify:C1217($json)
		$file.setText($manifest)
	End for each 
	
	return This:C1470
	
Function _getManifests() : Collection
	
	return This:C1470._getDataFolder().files(fk ignore invisible:K87:22 | fk recursive:K87:7).query("fullName == :1"; "manifest.json")
	
Function _scanDataFolder() : Collection
	
	$manifests:=[]
	
	For each ($file; This:C1470._getManifests())
		$manifest:=JSON Parse:C1218($file.getText())
		$manifest.file:=$file
		$manifests.push($manifest)
	End for each 
	
	return $manifests
	
Function _getDataFolder() : 4D:C1709.Folder
	
	var $folder : 4D:C1709.Folder
	$folder:=Folder:C1567(fk user preferences folder:K87:10).parent
	$folder:=$folder.folder("com.4d.rezept")
	$folder.create()
	
	return $folder
	
Function _isComponent() : Boolean
	
	return (Folder:C1567(fk database folder:K87:14).platformPath#Folder:C1567(fk database folder:K87:14; *).platformPath)
	
Function _link($dataClassName : Text; $code : Text; $collection : Collection; $data : Collection) : Boolean
	
	var $elements : Collection
	var $element : Object
	
	Case of 
		: ($dataClassName="診療行為")
			
			$elements:=$data.query("診療行為コード === :1"; $code)
			
			If ($elements.length=1)
				$element:=$elements[0]
				$collection.push(OB Copy:C1225($element))
				return True:C214
			End if 
			
		: ($dataClassName="コメント")
			
			$elements:=$data.query("コメントコード.区分 === :1 and コメントコード.パターン === :2 and コメントコード.番号 === :3"; Substring:C12($code; 1; 1); Substring:C12($code; 2; 2); String:C10(Num:C11(Substring:C12($code; 4))))
			
			If ($elements.length=1)
				$element:=$elements[0]
				$collection.push(OB Copy:C1225($element))
				return True:C214
			End if 
			
	End case 
	
Function _loadCollection($folder : 4D:C1709.Folder; $name : Text) : Collection
	
	$json:=$folder.file($name+".json").getText("utf-8"; Document with LF:K24:22)
	
	$col:=JSON Parse:C1218($json; Is collection:K8:32)
	
	return $col
	
Function _trim($src : Text) : Text
	
	$dst:=$src
	
	//trim
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	If (Match regex:C1019("^\\s*(.*?)\\s*$"; $src; 1; $pos; $len))
		$dst:=Substring:C12($src; $pos{1}; $len{1})
	End if 
	
	$dst:=Replace string:C233($dst; Char:C90(0x002C); ""; *)
	$dst:=Replace string:C233($dst; Char:C90(0x000D); ""; *)
	
	return $dst
	
	//MARK:setup
	
Function setup_k($診療行為 : Collection; $特定器材 : Collection; $コメント : Collection)
	
	$dataClassName:=This:C1470.dataClassName
	$noHost:=Not:C34(This:C1470._isComponent())
	
	var $object : Object
	var $sharedObject : Object
	var $file : 4D:C1709.File
	var $blob : Blob
	var $data : Object
	
	If ($noHost)
		
		$names:=New collection:C1472("アルブミン定量（尿）"; "トランスフェリン（尿）"; "ミオイノシトール（尿）"; "内服・点滴誘発試験"; "４型コラーゲン（尿）"; "免疫関連遺伝子再構成"; "リポ蛋白（ａ）"; "ペントシジン"; \
			"イヌリン"; "シスタチンＣ"; "レムナント様リポ蛋白コレステロール（ＲＬＰ−Ｃ）"; "イヌリンクリアランス測定"; "網膜機能精密電気生理検査（多局所網膜電位図）"; "終夜睡眠ポリグラフィー（携帯用装置を使用した場合）"; \
			"骨塩定量検査@"; "肝硬度測定"; "ＨＩＶジェノタイプ薬剤耐性"; "抗シトルリン化ペプチド抗体@"; "抗ＲＮＡポリメラーゼ３抗体"; "前立腺特異抗原（ＰＳＡ）"; "デオキシピリジノリン（ＤＰＤ）（尿）"; \
			"１型コラーゲン架橋Ｃ−テロペプチド−β異性体（β−ＣＴＸ）@"; "低カルボキシル化オステオカルシン（ｕｃＯＣ）"; "１型コラーゲン架橋Ｃ−テロペプチド@"; "１．２５−ジヒドロキシビタミンＤ３"; \
			"酒石酸抵抗性酸ホスファターゼ（ＴＲＡＣＰ−５ｂ）"; "Ｌ型脂肪酸結合蛋白（Ｌ−ＦＡＢＰ）（尿）"; "マンガン（Ｍｎ）"; "マロンジアルデヒド修飾ＬＤＬ（ＭＤＡ−ＬＤＬ）")
		
		var $c診療行為 : Collection
		$c診療行為:=$診療行為.query("基本漢字名称 in :1"; $names)
		
		var $算定回数が複数月に１回のみとされている検査 : Collection
		$算定回数が複数月に１回のみとされている検査:=$c診療行為.extract("基本漢字名称")
		
		$DEBUG_DIRECT_LINK:=False:C215
		$DEBUG_CREATE_DATA:=True:C214
		
		$診療行為コード:={}
		$診療行為名:={}
		$記載事項等:=[]
		
		//$フリー:=[]
		//$検査の実施日:=[]
		//$算定日:=[]
		//$メッセージ:=[]
		
		This:C1470[$dataClassName]:=$記載事項等
		This:C1470.診療行為コード:=$診療行為コード
		
		If ($DEBUG_DIRECT_LINK)
			This:C1470.診療行為名:=$診療行為名
		End if 
		
		//This.フリー:=$フリー
		//This.検査の実施日:=$検査の実施日
		//This.算定日:=$算定日
		//This.メッセージ:=$メッセージ
		
		var $export : cs:C1710._Export
		$export:=cs:C1710._Export.new()
		
		$folder:=Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent.folder("DATA/記載事項等")
		$files:=$folder.files()
		$names:=["摘要欄への記載事項等一覧@"; "記載事項等@"]
		$files:=$files.query("name in :1 and extension == :2"; $names; ".xlsx")
		
		If ($files.length#0)
			
			$file:=$files[0]
			//%W-533.4
			$json:=XLSX TO JSON($file.platformPath)
			//%W+533.4
			
			$data:=JSON Parse:C1218($json; Is object:K8:27)
			
			$sheets:=$data.sheets
			
			If ($sheets.length>0)
				
				$悪性腫瘍組織検査１:=$export._loadCollection($folder; "悪性腫瘍組織検査１")
				$悪性腫瘍遺伝子検査:=$export._loadCollection($folder; "悪性腫瘍遺伝子検査")
				$障害者施設等入院基本料:=$export._loadCollection($folder; "障害者施設等入院基本料")
				$一般病棟入院基本料:=$export._loadCollection($folder; "一般病棟入院基本料")
				$精神病棟入院基本料:=$export._loadCollection($folder; "精神病棟入院基本料")
				$特定機能病院入院基本料:=$export._loadCollection($folder; "特定機能病院入院基本料")
				
				$codes:=[]
				
				C_LONGINT:C283($index; $subIndex)
				
				For each ($row; $sheets[0].rows; 1)
					
					C_OBJECT:C1216($記載事項)
					
					$values:=$row.values
					
					If ($values.join()#"")
						
						ARRAY LONGINT:C221($pos; 0)
						ARRAY LONGINT:C221($len; 0)
						
						If ($values.length>5)
							$meta:=$values[5]  //F
						Else 
							$meta:=""
						End if 
						
						Case of 
							: ($meta="@*@")  //前の事項の条件のつづき（$記載事項をインクリメントしない）
								$index:=0
							Else 
								$index:=1
						End case 
						
						If ($values.length>6)
							$meta:=$values[6]  //G
						Else 
							$meta:=""
						End if 
						
						Case of 
							: ($meta="@*@")  //前のコメントのつづき
								$subIndex:=0
								$index:=0
							Else 
								$subIndex:=1
						End case 
						
						C_OBJECT:C1216($o)
						
						If ($index=1)
							
							$o:={}
							$o.項番:=$values[0]  //A
							$o.区分:=$values[1]  //B
							$o.診療行為名称等:=$values[2]  //C
							
							$診療行為名称等:=$o.診療行為名称等
							
							//マスターに合わせる
							Case of 
								: ($診療行為名称等="薬剤管理指導料@")
									$診療行為名称等:="薬剤管理指導料"
								: ($診療行為名称等="コンピューター断層撮影診断料@")
									$診療行為名称等:="コンピューター断層撮影診断"
								: ($診療行為名称等="点滴注射の血漿成分製剤加算@")
									$診療行為名称等:="血漿成分製剤加算（点滴注射）"
								: ($診療行為名称等="注入器用注射針加算の１@")
									$診療行為名称等:="注入器用注射針加算（１型糖尿病、血友病患者又はこれらの患者に準ずる状態にある患者）"
								: ($診療行為名称等="SARS-CoV-2抗原検出（定性）")
									$診療行為名称等:="ＳＡＲＳ−ＣｏＶ−２抗原定性"
								: ($診療行為名称等="SARS-CoV-2抗原検出（定量）")
									$診療行為名称等:="ＳＡＲＳ−ＣｏＶ−２抗原定量"
								: ($診療行為名称等="SARS-CoV-2・インフルエンザウイルス抗原同時検出（定性）")
									$診療行為名称等:="ＳＡＲＳ−ＣｏＶ−２・インフルエンザウイルス抗原同時検出定性"
								: ($診療行為名称等="SARS-CoV-2核酸検出")
									$診療行為名称等:="ＳＡＲＳ−ＣｏＶ−２核酸検出（検査委託"
								: ($診療行為名称等="SARS-CoV-2・インフルエンザ核酸同時検出")
									$診療行為名称等:="ＳＡＲＳ−ＣｏＶ−２・インフルエンザ核酸同時検出（検査委託"
								: ($診療行為名称等="インターロイキン－６（ＩＬ－６）")
									$診療行為名称等:="インターロイキン−６（ＩＬ−６）"
								: ($診療行為名称等="ｓＦｌｔ－１／ＰｌＧＦ比")
									$診療行為名称等:="ｓＦｌｔ−１／ＰｌＧＦ比"
								: ($診療行為名称等="ＲＯＳ１融合遺伝子検査")
									$診療行為名称等:="悪性腫瘍組織検査（処理が容易なもの）（医薬品の適応判定の補助等に用いるもの）（肺癌におけるＲＯＳ１融合遺伝子検査）"
								: ($診療行為名称等="ＡＬＫ融合遺伝子検査")
									$診療行為名称等:="悪性腫瘍組織検査（処理が容易なもの）（医薬品の適応判定の補助等に用いるもの）（肺癌におけるＡＬＫ融合遺伝子検査）"
								: ($診療行為名称等="ＮＴＲＫ融合遺伝子検査")
									$診療行為名称等:="悪性腫瘍組織検査（処理が複雑なもの）（固形癌におけるＮＴＲＫ融合遺伝子検査）"
								: ($診療行為名称等="遠隔連携診療料１")
									$診療行為名称等:="遠隔連携診療料（診断を目的とする場合）"
								: ($診療行為名称等="遠隔連携診療料２")
									$診療行為名称等:="遠隔連携診療料（その他の場合）"
								: ($診療行為名称等="肝エラストグラフィー加算")
									$診療行為名称等:="肝エラストグラフィ加算"
								: ($診療行為名称等="胚凍結保存管理料（導入時）")
									$診療行為名称等:="胚凍結保存管理料（胚凍結保存管理料（導入時））（"
								: ($診療行為名称等="胚凍結保存維持管理料")
									$診療行為名称等:="胚凍結保存管理料（胚凍結保存維持管理料）"
								: ($診療行為名称等="受精卵・胚培養管理料（注：胚盤胞の作成目的）")
									$診療行為名称等:="受精卵・胚培養管理料（"
								: ($診療行為名称等="高濃度ヒアルロン酸含有培養液を用いた前処置")
									$診療行為名称等:="高濃度ヒアルロン酸含有培養液加算"
								: ($診療行為名称等="精巣内精子採取術１単純なもの")
									$診療行為名称等:="精巣内精子採取術（単純なもの）"
								: ($診療行為名称等="精巣内精子採取術２顕微鏡を用いたもの")
									$診療行為名称等:="精巣内精子採取術（顕微鏡を用いたもの）"
								: ($診療行為名称等="移植後抗体関連型拒絶反応治療における血漿交換療法")
									$診療行為名称等:="血漿交換療法（１日につき）（移植後抗体関連型拒絶反応治療）"
								: ($診療行為名称等="感染症法による公費負担申請に係る診断書料及び協力料")
									$診療行為名称等:="感染症法による公費負担申請診断書交付・申請手続代行料"
								: ($診療行為名称等="在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料の夜間・早朝訪問看護加算")
									$診療行為名称等:="夜間・早朝訪問看護加算（在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料）"
								: ($診療行為名称等="在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料の深夜訪問看護加算")
									$診療行為名称等:="深夜訪問看護加算（在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料）"
								: ($診療行為名称等="在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料の在宅移行管理加算")
									$診療行為名称等:="在宅移行管理加算（在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料）"
								: ($診療行為名称等="在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料の在宅移行管理重症者加算")
									$診療行為名称等:="在宅移行管理重症者加算（在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料）"
								: ($診療行為名称等="在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料の看護・介護職員連携強化加算")
									$診療行為名称等:="看護・介護職員連携強化加算（在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料）"
								: ($診療行為名称等="在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料の特別地域訪問看護加算")
									$診療行為名称等:="特別地域訪問看護加算（在宅患者訪問看護・指導料、同一建物居住者訪問看護・指導料）"
							End case 
							
							While (Match regex:C1019("(の注\\d+.*)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							Case of 
								: ($診療行為名称等="1,500グラム未満の乳幼児加算")
								: ($診療行為名称等="1,500グラム未満の新生児加算")
								: ($診療行為名称等="1,500グラム未満の小児加算")
								Else 
									While (Match regex:C1019("(の.*加算(の[イロハニホヘト])?)"; $診療行為名称等; 1; $pos; $len))
										$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
									End while 
							End case 
							
							While (Match regex:C1019("(「\\d+」.*)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(「通則\\d+」.*)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(（(.*)場合）)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(「注\\d+」の場合)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(を算定している患者について.+場合)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(（(.*)使用）)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(の[イロハニホヘト])"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							While (Match regex:C1019("(（入院外?）)"; $診療行為名称等; 1; $pos; $len))
								$診療行為名称等:=Delete string:C232($診療行為名称等; $pos{1}; $len{1})
							End while 
							
							$診療行為名称等:=This:C1470._trim($診療行為名称等)
							
							$o.診療行為名称:=$診療行為名称等
							
							$記載事項:={}
							
							$記載事項等.push($記載事項)
							
							$記載事項.項番:=$o.項番
							$記載事項.区分:=$o.区分
							
							$記載事項.診療行為名称等:=$o.診療行為名称等
							$記載事項.診療行為名称:=$o.診療行為名称  //検索用
							$記載事項.記載事項:=[]
							
							Case of 
								: ($診療行為名称等="")
									TRACE:C157  //XLSXにエラー（継続なし）
									$q:=""
								: ($診療行為名称等="薬剤等〈入院外分〉処方箋料")
									$q:="@処方箋料@"
								: ($診療行為名称等="薬剤等（入院外分）処方箋料")
									$q:="@処方箋料@"
								: ($診療行為名称等="往診料等")
									$q:="@往診料@"
								: ($診療行為名称等="外来栄養食事指導料")
									$q:="外来栄養食事指導料@"
								: ($診療行為名称等="腹腔鏡下胃縮小術（スリーブ状切除術によるもの）")
									$q:="腹腔鏡下胃縮小術（スリーブ状切除によるもの）@"
								: ($診療行為名称等="脳磁図１自発活動を測定するもの")
									$q:="@脳磁図（自発活動を測定するもの）@"
								: ($診療行為名称等="脳磁図２その他のもの")
									$q:="@脳磁図（その他のもの）@"
								: ($診療行為名称等="Ｌ型脂肪酸結合蛋白（ＬＦＡＢＰ）（尿）")
									$q:="@Ｌ型脂肪酸結合蛋白（Ｌ−ＦＡＢＰ）（尿）@"
								: ($診療行為名称等="筋電図検査２（誘発筋電図）")
									$q:="@誘発筋電図（神経伝導速度測定を含む）（１神経につき）@"
								: ($診療行為名称等="小腸内視鏡検査２（カプセル型内視鏡によるもの）")
									$q:="@小腸内視鏡検査（カプセル型内視鏡によるもの）@"
								: ($診療行為名称等="終夜睡眠ポリグラフィー３（１及び２以外の場合イ安全精度管理下で行うもの） ")
									$q:="@終夜睡眠ポリグラフィー（１及び２以外の場合）（安全精度管理下で行うもの）@"
								: ($診療行為名称等="呼吸心拍監視")
									$q:="@呼吸心拍監視@"
								: ($診療行為名称等="新生児心拍・呼吸監視")
									$q:="@新生児心拍・呼吸監視@"
								: ($診療行為名称等="カルジオスコープ（ハートスコープ）")
									$q:="@カルジオスコープ（ハートスコープ）@"
								: ($診療行為名称等="カルジオタコスコープ")
									$q:="@カルジオタコスコープ@"
								: ($診療行為名称等="光トポグラフィー２（抑うつ症状の鑑別診断の補助に使用するもの）")
									$q:="@光トポグラフィー（抑うつ症状の鑑別診断の補助に使用するもの）@"
								: ($診療行為名称等="光トポグラフィー１（脳外科手術の術前検査に使用するもの）")
									$q:="@光トポグラフィー（脳外科手術の術前検査に使用するもの）@"
								: ($診療行為名称等="肝硬度測定超音波エラストグラフィー")
									$q:="@超音波エラストグラフィー@"
								: ($診療行為名称等="認知機能検査その他の心理検査１（操作が容易なもの）（簡易なもの）")
									$q:="@認知機能検査その他の心理検査（操作が容易なもの）（簡易なもの）@"
								: ($診療行為名称等="検体検査判断料")
									$q:="@基本的検体検査判断料@"
								: ($診療行為名称等="乳腺腫瘍画像下ガイド下吸引術")
									$q:="@乳腺腫瘍画像ガイド下吸引術@"
								: ($診療行為名称等="排泄物、滲出物又は分泌物の細菌顕微鏡検査")
									$q:="@細菌顕微鏡検査@"
								: ($診療行為名称等="超音波検査２（断層撮影法（心臓超音波検査を除く。））（その他の場合）（胸腹部）")
									$q:="@超音波検査（断層撮影法（心臓超音波検査を除く。））（その他の場合）（胸腹部）@"
								: ($診療行為名称等="時間外加算１（手術）")
									$q:="@時間外加算１（手術）@"
								: ($診療行為名称等="放射線治療料")
									$q:="放射線治療管理料@"
								: ($診療行為名称等="神経ブロック加算")
									$q:="神経ブロック併施加算@"
								: ($診療行為名称等="染色体検査１")
									$q:="染色体検査（全ての費用を含む。）（ＦＩＳＨ法を用いた場合）@"
								: ($診療行為名称等="ウイルス・細菌核酸多項目同時検出（SARS-CoV-2を含む。）")
									$q:="ウイルス・細菌核酸多項目同時検出（ＳＡＲＳ−ＣｏＶ−２核酸検出・検査@"
								: ($診療行為名称等="超音波検査２（胸腹部）")
									$q:="超音波検査（断層撮影法（心臓超音波検査を除く。））（その他の場合）（胸腹部）@"
								: ($診療行為名称等="終夜睡眠ポリグラフィー３（１及び２以外の場合イ安全精度管理下で行うもの）")
									$q:="終夜睡眠ポリグラフィー（１及び２以外の場合）（安全精度管理下で行うもの）@"
								: ($診療行為名称等="小腸内視鏡検査３（カプセル型内視鏡によるもの）")
									$q:="小腸内視鏡検査（カプセル型内視鏡によるもの）@"
								: ($診療行為名称等="大腸内視鏡検査２（カプセル型内視鏡によるもの）")
									$q:="大腸内視鏡検査（カプセル型内視鏡によるもの）@"
								: ($診療行為名称等="低体温療法")
									$q:="マスク又は気管内挿管による閉鎖循環式全身麻酔１（人工心肺を用い低体温で行う心臓手術等）（@"
								: ($診療行為名称等="1,500グラム未満の乳幼児加算")
									$q:="@乳幼児加算@"
								: ($診療行為名称等="1,500グラム未満の新生児加算")
									$q:="@新生児加算@"
								: ($診療行為名称等="1,500グラム未満の小児加算")
									$q:="@小児加算@"
								: ($診療行為名称等="単心室症又は三尖弁閉鎖症手術")
									$q:="人工血管等再置換術加算（単心室症又は三尖弁閉鎖症手術）"
								Else 
									$q:=$診療行為名称等+"@"
							End case 
							
							Case of 
								: ($診療行為名称等="悪性腫瘍組織検査１")
									$c診療行為:=$診療行為.query("診療行為コード in :1"; $悪性腫瘍組織検査１)
									
								: ($診療行為名称等="悪性腫瘍遺伝子検査")
									$c診療行為:=$診療行為.query("診療行為コード in :1"; $悪性腫瘍遺伝子検査)
									
								: ($診療行為名称等="障害者施設等入院基本料")
									$c診療行為:=$診療行為.query("診療行為コード in :1"; $障害者施設等入院基本料)
									
								: ($診療行為名称等="一般病棟入院基本料")
									$c診療行為:=$診療行為.query("診療行為コード in :1"; $一般病棟入院基本料)
									
								: ($診療行為名称等="精神病棟入院基本料")
									$c診療行為:=$診療行為.query("診療行為コード in :1"; $精神病棟入院基本料)
									
								: ($診療行為名称等="特定機能病院入院基本料")
									$c診療行為:=$診療行為.query("診療行為コード in :1"; $特定機能病院入院基本料)
									
								: ($診療行為名称等="病理診断料")
									$c診療行為:=$診療行為.query("基本漢字名称 == :1 or 基本漢字名称 == :2"; "組織診断料@"; "細胞診断料@")
									
								: ($診療行為名称等="特定保険医療材料")
									
									$c特定器材:=$特定器材.query("項目.告示番号.区分番号 >= :1 and 項目.告示番号.区分番号 <= :2"; "1"; "209")
									$c診療行為:=$c特定器材.extract("特定器材コード"; "診療行為コード")
									
								: ($診療行為名称等="算定回数が複数月に１回のみとされている検査")
									$c診療行為:=$診療行為.query("基本漢字名称 in :1"; $算定回数が複数月に１回のみとされている検査)
									
								: ($診療行為名称等="ＭＥＴｅｘ14遺伝子検査")
									$c診療行為:=$診療行為.query("基本漢字名称 == :1 or 基本漢字名称 == :2"; "悪性腫瘍組織検査（処理が容易）（医薬品適応判定の補助等）（肺癌におけるＭＥＴｅｘ１４遺伝子検査（次世代シーケンシングを除く。））"; "悪性腫瘍組織検査（処理が複雑なもの）（肺癌におけるＭＥＴｅｘ１４遺伝子検査（次世代シーケンシング））")
									
								: ($診療行為名称等="在宅患者診療・指導料")
									$c診療行為:=$診療行為.query("基本漢字名称 == :1 or 基本漢字名称 == :2"; "在宅患者訪問診療料@"; "在宅患者訪問看護・指導料@")
								Else 
									$c診療行為:=$診療行為.query("基本漢字名称 == :1"; $q)
							End case 
							
							Case of 
								: ($c診療行為.length=0)
									
									//診療行為名で特定できない場合
									
									Case of 
										: ($診療行為名称等="ヘリコバクター・ピロリ感染の診断及び治療に関する取扱い")
										: ($診療行為名称等="特定保険医療材料")
										: ($診療行為名称等="「制限回数を超えて行う診療」に係るリハビリテーションを実施した場合")
										: ($診療行為名称等="写真診断")
										: ($診療行為名称等="コンピューター断層撮影診断")
										: ($診療行為名称等="施設入所者自己腹膜灌流薬剤料")
										: ($診療行為名称等="臨床研修病院入院診療加算")
										: ($診療行為名称等="がん拠点病院加算")
										: ($診療行為名称等="薬剤〈入院分〉")
										: ($診療行為名称等="回復期リハリビリテーション病棟入院料")
										: ($診療行為名称等=("救急患者として受け入れた患者が、処置室、手術室等において死亡した場合で、当該保険医療機関が救急医療を担う施設として確保することとされている専用病床（救急医療管理加算又"+"は救命救急入院料を算定する病床に限る。）に入院したものとみなす場合"))
										: ($診療行為名称等="在宅療養支援診療所、在宅療養支援病院から患者の紹介を受けて在宅療養指導管理を行う場合")
										: ($診療行為名称等="在宅植込型補助人工心臓􏰝非拍動流型の指導管理料")
										: ($診療行為名称等="在宅療養指導管理料のいずれかの所定点数に併せて特定保険医療材料のうち「皮膚欠損用創傷被覆材」又は「非固着性シリコンガーゼ」を支給した場合")
										: ($診療行為名称等="180日を超える期間通算対象入院料を算定する場合")
										: ($診療行為名称等="180日を超える期間通算対象入院料を算定している患者")
										: ($診療行為名称等="退院した患者に対して、当該退院月に、退院日に在宅療養指導管理料を算定した保険医療機関以外の保険医療機関において在宅療養指導管理料を算定した場合")
										: ($診療行為名称等="「制限回数を超えて行う診療」に係る精神科専門療法を実施した場合")
										: ($診療行為名称等="「制限回数を超えて行う診療」に係る検査を実施した場合")
										: ($診療行為名称等=("初診、再診又は在宅医療において、患者の診療を担う保険医の指示に基づき、当該保険医の診療日以外の日に訪問看護ステーション等の看護師等が、当該患者に対して点滴又は処置等を"+"実施した場合"))
										: ($診療行為名称等=("初診、再診又は在宅医療において、患者の診療を担う保険医の指示に基づき、当該保険医の診療日以外の日に訪問看護ステーション等の看護師等が、当該患者に対し、検査のための検体"+"採取等を実施した場合"))
										: ($診療行為名称等="1500グラム未満の小児加算")
										: ($診療行為名称等="1500グラム未満の乳幼児加算")
										: ($診療行為名称等="1500グラム未満の新生児加算")
											
											
										Else 
											TRACE:C157
									End case 
									
/*
										
*/
									
									If ($index=1)
										$記載事項等.pop($記載事項)
									End if 
									
								Else 
									
									$記載事項_診療行為コード:=$c診療行為.extract("診療行為コード")
									
									If ($DEBUG_DIRECT_LINK)
										For each ($code; $記載事項_診療行為コード)
											$診療行為コード[$code]:=$記載事項
										End for each 
										$診療行為名[$診療行為名称等]:=$記載事項
									End if 
									
									$codes:=$codes.combine($記載事項_診療行為コード)
									
									If ($subIndex=1)
										
										$i:=0x0001
										
										$事項:=$values[3]
										
										If (Match regex:C1019("(?m)^（(.*)場合等?）$\\s*(?s)(.*)"; $事項; $i; $pos; $len))
											$qualifier:=Substring:C12($事項; $pos{1}; $len{1})
											$directive:=Substring:C12($事項; $pos{2}; $len{2})
											$指示:={qualifier: $qualifier; message: $directive}
										Else 
											$指示:={message: $事項}
										End if 
										
										$記載事項.記載事項.push($指示)
										$記載事項.診療行為コード:=$記載事項_診療行為コード.join(",")
										
										$steps:=[]
										
										$指示.steps:=$steps
										
									End if 
									
									
									$collection:=[]
									$steps.push($collection)
									
									$comment:=""
									
									$skip:=False:C215
									
									If ($values.length>4)
										
										Case of 
											: ($values[4]="算定日")
												//$算定日.push($記載事項.項番)
												$記載事項.記載事項.pop($指示)
												$skip:=True:C214
											: ($values[4]="メッセージ")
												//$メッセージ.push($記載事項.項番)
												$skip:=True:C214
												
												//: ($values[4]="検査の実施日")
												//$検査の実施日.push($記載事項.項番)
												
												//: ($values[4]="フリー")
												//$フリー.push($記載事項.項番)
												
											Else 
												$comment:=$values[4]
										End case 
										
									End if 
									
									If ($comment="")  //コメントコードなし
										$comment:="810000001"
									End if 
									
									If (Not:C34($skip))
										
										$i:=0x0001
										
										While (Match regex:C1019("(\\d+)"; $comment; $i; $pos; $len))
											$code:=Substring:C12($comment; $pos{1}; $len{1})
											$i:=$pos{1}+$len{1}
											
											Case of 
												: ($export._link("コメント"; $code; $collection; $コメント))
													//コメントコード 
												: ($export._link("診療行為"; $code; $collection; $診療行為))
													//診療行為コード
												Else 
													TRACE:C157
											End case 
											
										End while 
										
									End if 
									
							End case 
							
						End if 
						
					End if 
					
				End for each 
				
				If (Not:C34($DEBUG_DIRECT_LINK))
					
					$記載事項_診療行為コード:=$codes.distinct()
					
					For each ($code; $記載事項_診療行為コード)
						
						$records:=$記載事項等.query("診療行為コード == :1"; "@"+$code+"@")
						
						$count:=0
						
						For each ($record; $records)
							$count:=$count+$record.記載事項.sum("steps.length")
						End for each 
						
						If ($count#0)
							$診療行為コード[$code]:=$records
						Else   //算定日のみ
							
						End if 
						
					End for each 
					
				End if 
				
				If ($DEBUG_CREATE_DATA)
					
					$sharedObject:=This:C1470
					
					VARIABLE TO BLOB:C532($sharedObject; $blob)
					
					$file:=This:C1470._getDataFolder().file($dataClassName+".data")
					$asset:=cs:C1710._Core.new()._getDataExportFolder().file($dataClassName+".zip")
					$file.setContent($blob)
					
					var $zip : Object
					$zip:={}
					$zip.files:=[$file]
					$zip.compression:=ZIP Compression LZMA:K91:9
					
					$error:=ZIP Create archive:C1640($zip; $asset)
					
					This:C1470.file:=$file
					
					var $CLI : cs:C1710._CLI
					$CLI:=cs:C1710._CLI.new()
					
					$CLI.print("generate data file for "+$dataClassName+"..."; "bold")
					$CLI.print("success"; "82;bold").LF()
					$CLI.print($file.path; "244").LF()
					$CLI.print($asset.path; "244").LF()
					$CLI.print("size: "; "bold").print(String:C10($file.size); "39").LF()
					
					$file.copyTo(Folder:C1567("/RESOURCES/"); fk overwrite:K87:5)
					
				End if 
			End if 
			
		End if 
		
	Else 
		
		$file:=This:C1470._dataFolder.file($dataClassName+".data")
		
		If ($file#Null:C1517) && ($file.exists)
			
			$blob:=$file.getContent()
			
			BLOB TO VARIABLE:C533($blob; $object)
			
			This:C1470[$dataClassName]:=$object[$dataClassName]
			This:C1470.code:=$object.code
			This:C1470.file:=$file
			
			This:C1470.診療行為コード:=$object.診療行為コード
			
			If ($object.診療行為名#Null:C1517)
				This:C1470.診療行為名:=$object.診療行為名
			End if 
			
			This:C1470.記載事項等:=$object.記載事項等
			//This.フリー:=$object.フリー
			//This.検査の実施日:=$object.検査の実施日
			//This.算定日:=$object.算定日
			//This.メッセージ:=$object.メッセージ
			
		End if 
		
	End if 
	
Function setup_t()
	
	$dataClassName:=This:C1470.dataClassName
	$noHost:=Not:C34(This:C1470._isComponent())
	
	var $data : Blob
	var $object : Object
	var $sharedObject : Object
	var $file : 4D:C1709.File
	
	var $sharedCollection : Collection
	$sharedCollection:=This:C1470[$dataClassName]
	
	If ($noHost)
		
		$sharedCollection.push(New object:C1471("単位コード"; "1"; "内容"; "分"))
		$sharedCollection.push(New object:C1471("単位コード"; "2"; "内容"; "回"))
		$sharedCollection.push(New object:C1471("単位コード"; "3"; "内容"; "種"))
		$sharedCollection.push(New object:C1471("単位コード"; "4"; "内容"; "箱"))
		$sharedCollection.push(New object:C1471("単位コード"; "5"; "内容"; "巻"))
		$sharedCollection.push(New object:C1471("単位コード"; "6"; "内容"; "枚"))
		$sharedCollection.push(New object:C1471("単位コード"; "7"; "内容"; "本"))
		$sharedCollection.push(New object:C1471("単位コード"; "8"; "内容"; "組"))
		$sharedCollection.push(New object:C1471("単位コード"; "9"; "内容"; "セット"))
		$sharedCollection.push(New object:C1471("単位コード"; "10"; "内容"; "個"))
		$sharedCollection.push(New object:C1471("単位コード"; "11"; "内容"; "裂"))
		$sharedCollection.push(New object:C1471("単位コード"; "12"; "内容"; "方向"))
		$sharedCollection.push(New object:C1471("単位コード"; "13"; "内容"; "トローチ"))
		$sharedCollection.push(New object:C1471("単位コード"; "14"; "内容"; "アンプル"))
		$sharedCollection.push(New object:C1471("単位コード"; "15"; "内容"; "カプセル"))
		$sharedCollection.push(New object:C1471("単位コード"; "16"; "内容"; "錠"))
		$sharedCollection.push(New object:C1471("単位コード"; "17"; "内容"; "丸"))
		$sharedCollection.push(New object:C1471("単位コード"; "18"; "内容"; "包"))
		$sharedCollection.push(New object:C1471("単位コード"; "19"; "内容"; "瓶"))
		$sharedCollection.push(New object:C1471("単位コード"; "20"; "内容"; "袋"))
		$sharedCollection.push(New object:C1471("単位コード"; "21"; "内容"; "瓶（袋）"))
		$sharedCollection.push(New object:C1471("単位コード"; "22"; "内容"; "管"))
		$sharedCollection.push(New object:C1471("単位コード"; "23"; "内容"; "シリンジ"))
		$sharedCollection.push(New object:C1471("単位コード"; "24"; "内容"; "回分"))
		$sharedCollection.push(New object:C1471("単位コード"; "25"; "内容"; "テスト分"))
		$sharedCollection.push(New object:C1471("単位コード"; "26"; "内容"; "ガラス筒"))
		$sharedCollection.push(New object:C1471("単位コード"; "27"; "内容"; "桿錠"))
		$sharedCollection.push(New object:C1471("単位コード"; "28"; "内容"; "単位"))
		$sharedCollection.push(New object:C1471("単位コード"; "29"; "内容"; "万単位"))
		$sharedCollection.push(New object:C1471("単位コード"; "30"; "内容"; "フィート"))
		$sharedCollection.push(New object:C1471("単位コード"; "31"; "内容"; "滴"))
		$sharedCollection.push(New object:C1471("単位コード"; "32"; "内容"; "ｍｇ"))
		$sharedCollection.push(New object:C1471("単位コード"; "33"; "内容"; "ｇ"))
		$sharedCollection.push(New object:C1471("単位コード"; "34"; "内容"; "Ｋｇ"))
		$sharedCollection.push(New object:C1471("単位コード"; "35"; "内容"; "ｃｃ"))
		$sharedCollection.push(New object:C1471("単位コード"; "36"; "内容"; "ｍＬ"))
		$sharedCollection.push(New object:C1471("単位コード"; "37"; "内容"; "Ｌ"))
		$sharedCollection.push(New object:C1471("単位コード"; "38"; "内容"; "ｍＬＶ"))
		$sharedCollection.push(New object:C1471("単位コード"; "39"; "内容"; "バイアル"))
		$sharedCollection.push(New object:C1471("単位コード"; "40"; "内容"; "ｃｍ"))
		$sharedCollection.push(New object:C1471("単位コード"; "41"; "内容"; "ｃｍ２"))
		$sharedCollection.push(New object:C1471("単位コード"; "42"; "内容"; "ｍ"))
		$sharedCollection.push(New object:C1471("単位コード"; "43"; "内容"; "μＣｉ"))
		$sharedCollection.push(New object:C1471("単位コード"; "44"; "内容"; "ｍＣｉ"))
		$sharedCollection.push(New object:C1471("単位コード"; "45"; "内容"; "μｇ"))
		$sharedCollection.push(New object:C1471("単位コード"; "46"; "内容"; "管（瓶）"))
		$sharedCollection.push(New object:C1471("単位コード"; "47"; "内容"; "筒"))
		$sharedCollection.push(New object:C1471("単位コード"; "48"; "内容"; "ＧＢｑ"))
		$sharedCollection.push(New object:C1471("単位コード"; "49"; "内容"; "ＭＢｑ"))
		$sharedCollection.push(New object:C1471("単位コード"; "50"; "内容"; "ＫＢｑ"))
		$sharedCollection.push(New object:C1471("単位コード"; "51"; "内容"; "キット"))
		$sharedCollection.push(New object:C1471("単位コード"; "52"; "内容"; "国際単位"))
		$sharedCollection.push(New object:C1471("単位コード"; "53"; "内容"; "患者当り"))
		$sharedCollection.push(New object:C1471("単位コード"; "54"; "内容"; "気圧"))
		$sharedCollection.push(New object:C1471("単位コード"; "55"; "内容"; "缶"))
		$sharedCollection.push(New object:C1471("単位コード"; "56"; "内容"; "手術当り"))
		$sharedCollection.push(New object:C1471("単位コード"; "57"; "内容"; "容器"))
		$sharedCollection.push(New object:C1471("単位コード"; "58"; "内容"; "ｍＬ（ｇ）"))
		$sharedCollection.push(New object:C1471("単位コード"; "59"; "内容"; "ブリスター"))
		$sharedCollection.push(New object:C1471("単位コード"; "60"; "内容"; "シート"))
		$sharedCollection.push(New object:C1471("単位コード"; "61"; "内容"; "カセット"))
		$sharedCollection.push(New object:C1471("単位コード"; "101"; "内容"; "分画"))
		$sharedCollection.push(New object:C1471("単位コード"; "102"; "内容"; "染色"))
		$sharedCollection.push(New object:C1471("単位コード"; "103"; "内容"; "種類"))
		$sharedCollection.push(New object:C1471("単位コード"; "104"; "内容"; "株"))
		$sharedCollection.push(New object:C1471("単位コード"; "105"; "内容"; "菌株"))
		$sharedCollection.push(New object:C1471("単位コード"; "106"; "内容"; "照射"))
		$sharedCollection.push(New object:C1471("単位コード"; "107"; "内容"; "臓器"))
		$sharedCollection.push(New object:C1471("単位コード"; "108"; "内容"; "件"))
		$sharedCollection.push(New object:C1471("単位コード"; "109"; "内容"; "部位"))
		$sharedCollection.push(New object:C1471("単位コード"; "110"; "内容"; "肢"))
		$sharedCollection.push(New object:C1471("単位コード"; "111"; "内容"; "局所"))
		$sharedCollection.push(New object:C1471("単位コード"; "112"; "内容"; "種目"))
		$sharedCollection.push(New object:C1471("単位コード"; "113"; "内容"; "スキャン"))
		$sharedCollection.push(New object:C1471("単位コード"; "114"; "内容"; "コマ"))
		$sharedCollection.push(New object:C1471("単位コード"; "115"; "内容"; "処理"))
		$sharedCollection.push(New object:C1471("単位コード"; "116"; "内容"; "指"))
		$sharedCollection.push(New object:C1471("単位コード"; "117"; "内容"; "歯"))
		$sharedCollection.push(New object:C1471("単位コード"; "118"; "内容"; "面"))
		$sharedCollection.push(New object:C1471("単位コード"; "119"; "内容"; "側"))
		$sharedCollection.push(New object:C1471("単位コード"; "120"; "内容"; "個所"))
		$sharedCollection.push(New object:C1471("単位コード"; "121"; "内容"; "日"))
		$sharedCollection.push(New object:C1471("単位コード"; "122"; "内容"; "椎間"))
		$sharedCollection.push(New object:C1471("単位コード"; "123"; "内容"; "筋"))
		$sharedCollection.push(New object:C1471("単位コード"; "124"; "内容"; "菌種"))
		$sharedCollection.push(New object:C1471("単位コード"; "125"; "内容"; "項目"))
		$sharedCollection.push(New object:C1471("単位コード"; "126"; "内容"; "箇所"))
		$sharedCollection.push(New object:C1471("単位コード"; "127"; "内容"; "椎弓"))
		$sharedCollection.push(New object:C1471("単位コード"; "128"; "内容"; "食"))
		$sharedCollection.push(New object:C1471("単位コード"; "129"; "内容"; "根管"))
		$sharedCollection.push(New object:C1471("単位コード"; "130"; "内容"; "３分の１顎"))
		$sharedCollection.push(New object:C1471("単位コード"; "131"; "内容"; "月"))
		$sharedCollection.push(New object:C1471("単位コード"; "132"; "内容"; "入院初日"))
		$sharedCollection.push(New object:C1471("単位コード"; "133"; "内容"; "入院中"))
		$sharedCollection.push(New object:C1471("単位コード"; "134"; "内容"; "退院時"))
		$sharedCollection.push(New object:C1471("単位コード"; "135"; "内容"; "初回"))
		$sharedCollection.push(New object:C1471("単位コード"; "136"; "内容"; "口腔"))
		$sharedCollection.push(New object:C1471("単位コード"; "137"; "内容"; "顎"))
		$sharedCollection.push(New object:C1471("単位コード"; "138"; "内容"; "週"))
		$sharedCollection.push(New object:C1471("単位コード"; "139"; "内容"; "窩洞"))
		$sharedCollection.push(New object:C1471("単位コード"; "140"; "内容"; "神経"))
		$sharedCollection.push(New object:C1471("単位コード"; "141"; "内容"; "一連"))
		$sharedCollection.push(New object:C1471("単位コード"; "142"; "内容"; "２週"))
		$sharedCollection.push(New object:C1471("単位コード"; "143"; "内容"; "２月"))
		$sharedCollection.push(New object:C1471("単位コード"; "144"; "内容"; "３月"))
		$sharedCollection.push(New object:C1471("単位コード"; "145"; "内容"; "４月"))
		$sharedCollection.push(New object:C1471("単位コード"; "146"; "内容"; "６月"))
		$sharedCollection.push(New object:C1471("単位コード"; "147"; "内容"; "１２月"))
		$sharedCollection.push(New object:C1471("単位コード"; "148"; "内容"; "５年"))
		$sharedCollection.push(New object:C1471("単位コード"; "149"; "内容"; "妊娠中"))
		$sharedCollection.push(New object:C1471("単位コード"; "150"; "内容"; "検査当り"))
		$sharedCollection.push(New object:C1471("単位コード"; "151"; "内容"; "１疾患当り"))
		//
		$sharedCollection.push(New object:C1471("単位コード"; "153"; "内容"; "装置"))
		$sharedCollection.push(New object:C1471("単位コード"; "154"; "内容"; "１歯１回"))
		$sharedCollection.push(New object:C1471("単位コード"; "155"; "内容"; "１口腔１回"))
		$sharedCollection.push(New object:C1471("単位コード"; "156"; "内容"; "床"))
		$sharedCollection.push(New object:C1471("単位コード"; "157"; "内容"; "１顎１回"))
		$sharedCollection.push(New object:C1471("単位コード"; "158"; "内容"; "椎体"))
		$sharedCollection.push(New object:C1471("単位コード"; "159"; "内容"; "初診時"))
		$sharedCollection.push(New object:C1471("単位コード"; "160"; "内容"; "１分娩当り"))
		
		$o:=This:C1470["code"]
		
		For each ($sharedObject; $sharedCollection)
			$code:=$sharedObject[$dataClassName+"コード"]
			$o[$code]:=$sharedObject
		End for each 
		
		$sharedObject:=This:C1470
		
		VARIABLE TO BLOB:C532($sharedObject; $data)
		
		$file:=This:C1470._getDataFolder().file($dataClassName+".data")
		$asset:=cs:C1710._Core.new()._getDataExportFolder().file($dataClassName+".zip")
		$file.setContent($data)
		
		var $zip : Object
		$zip:={}
		$zip.files:=[$file]
		$zip.compression:=ZIP Compression LZMA:K91:9
		
		$error:=ZIP Create archive:C1640($zip; $asset)
		
		This:C1470.file:=$file
		
		var $CLI : cs:C1710._CLI
		$CLI:=cs:C1710._CLI.new()
		
		$CLI.print("generate data file for "+$dataClassName+"..."; "bold")
		$CLI.print("success"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		$CLI.print($asset.path; "244").LF()
		$CLI.print("size: "; "bold").print(String:C10($file.size); "39").LF()
		
		$file.copyTo(Folder:C1567("/RESOURCES/"); fk overwrite:K87:5)
		
	Else 
		
		$file:=This:C1470._dataFolder.file($dataClassName+".data")
		
		If ($file#Null:C1517) && ($file.exists)
			
			$data:=$file.getContent()
			
			BLOB TO VARIABLE:C533($data; $object)
			
			This:C1470[$dataClassName]:=$object[$dataClassName]
			This:C1470.code:=$object.code
			This:C1470.file:=$file
			
		End if 
		
	End if 
	
Function setup_i()
	
	$dataClassName:=This:C1470.dataClassName
	$dataClass:=ds:C1482["_"+$dataClassName]
	$noHost:=Not:C34(This:C1470._isComponent())
	
	var $data : Blob
	var $object : Object
	var $sharedObject : Object
	var $file : 4D:C1709.File
	var $sharedCollection : Collection
	$sharedCollection:=This:C1470[$dataClassName]
	
	If ($noHost)
		
		For each ($entity; $dataClass.all())
			
			$instance:=$entity.toObject()
			$sharedCollection.push($instance)
			
			$薬価基準コード:=$entity.項目.薬価基準コード
			If ($薬価基準コード#"")
				$e一般名:=ds:C1482._一般名処方.search($薬価基準コード)
				If ($e一般名#Null:C1517)
					$instance.一般名:=OB Copy:C1225($e一般名.toObject(); ck shared:K85:29; $sharedCollection)
				Else 
					$instance.一般名:=Null:C1517  //一般名なし
				End if 
				
				$e後発医薬品:=ds:C1482._後発医薬品.search($薬価基準コード)
				If ($e後発医薬品#Null:C1517)
					$instance.後発品:=OB Copy:C1225($e後発医薬品.toObject(); ck shared:K85:29; $sharedCollection)
				Else 
					$instance.後発品:=Null:C1517  //一般名なし
				End if 
				
			End if 
		End for each 
		
		$o:=This:C1470["code"]
		
		For each ($sharedObject; $sharedCollection)
			
			$o[$sharedObject.医薬品コード]:=$sharedObject
			
		End for each 
		
		$sharedObject:=This:C1470
		
		VARIABLE TO BLOB:C532($sharedObject; $data)
		
		$file:=This:C1470._getDataFolder().file($dataClassName+".data")
		$asset:=cs:C1710._Core.new()._getDataExportFolder().file($dataClassName+".zip")
		$file.setContent($data)
		
		var $zip : Object
		$zip:={}
		$zip.files:=[$file]
		$zip.compression:=ZIP Compression LZMA:K91:9
		
		$error:=ZIP Create archive:C1640($zip; $asset)
		
		This:C1470.file:=$file
		
		var $CLI : cs:C1710._CLI
		$CLI:=cs:C1710._CLI.new()
		
		$CLI.print("generate data file for "+$dataClassName+"..."; "bold")
		$CLI.print("success"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		$CLI.print($asset.path; "244").LF()
		$CLI.print("size: "; "bold").print(String:C10($file.size); "39").LF()
		
		$file.copyTo(Folder:C1567("/RESOURCES/"); fk overwrite:K87:5)
		
	Else 
		
		$file:=This:C1470._dataFolder.file($dataClassName+".data")
		
		If ($file#Null:C1517) && ($file.exists)
			
			$data:=$file.getContent()
			
			BLOB TO VARIABLE:C533($data; $object)
			
			$object:=OB Copy:C1225($object; ck shared:K85:29; This:C1470)
			
			This:C1470[$dataClassName]:=$object[$dataClassName]
			This:C1470.code:=$object.code
			This:C1470.file:=$file
			
		End if 
		
	End if 
	
Function setup()
	
	$dataClassName:=This:C1470.dataClassName
	$dataClass:=ds:C1482["_"+$dataClassName]
	$noHost:=Not:C34(This:C1470._isComponent())
	
	var $data : Blob
	var $object : Object
	var $sharedObject : Object
	var $file : 4D:C1709.File
	var $sharedCollection : Collection
	$sharedCollection:=This:C1470[$dataClassName]
	
	If ($noHost)
		
		For each ($entity; $dataClass.all())
			$instance:=$entity.toObject()
			$sharedCollection.push($instance)
		End for each 
		
		$o:=This:C1470["code"]
		
		Case of 
			: ($dataClassName="地方公費")
				
				For each ($sharedObject; $sharedCollection)
					$code:=$sharedObject["法別番号"]+$sharedObject["都道府県コード"]
					$o[$code]:=$sharedObject
				End for each 
				
			: ($dataClassName="コメント")
				
				C_OBJECT:C1216($コメント)
				
				For each ($コメント; $sharedCollection)
					
					$区分:=$コメント.コメントコード.区分
					$パターン:=String:C10(Num:C11($コメント.コメントコード.パターン); "00")
					$番号:=String:C10(Num:C11($コメント.コメントコード.番号); "000000")
					$漢字名称:=$コメント.コメント文.漢字名称
					
					$value_pos1:=Num:C11($コメント.項目["レセプト編集情報1"].カラム位置)
					$value_len1:=Num:C11($コメント.項目["レセプト編集情報1"].桁数)
					$value_pos2:=Num:C11($コメント.項目["レセプト編集情報2"].カラム位置)
					$value_len2:=Num:C11($コメント.項目["レセプト編集情報2"].桁数)
					$value_pos3:=Num:C11($コメント.項目["レセプト編集情報3"].カラム位置)
					$value_len3:=Num:C11($コメント.項目["レセプト編集情報3"].桁数)
					$value_pos4:=Num:C11($コメント.項目["レセプト編集情報4"].カラム位置)
					$value_len4:=Num:C11($コメント.項目["レセプト編集情報4"].桁数)
					
					$code:=$区分+$パターン+$番号
					
					$o[$code]:=$コメント
				End for each 
				
			Else 
				For each ($sharedObject; $sharedCollection)
					$code:=$sharedObject[$dataClassName+"コード"]
					$o[$code]:=$sharedObject
				End for each 
		End case 
		
		$sharedObject:=This:C1470
		
		VARIABLE TO BLOB:C532($sharedObject; $data)
		
		$file:=This:C1470._getDataFolder().file($dataClassName+".data")
		$asset:=cs:C1710._Core.new()._getDataExportFolder().file($dataClassName+".zip")
		$file.setContent($data)
		
		var $zip : Object
		$zip:={}
		$zip.files:=[$file]
		$zip.compression:=ZIP Compression LZMA:K91:9
		
		$error:=ZIP Create archive:C1640($zip; $asset)
		
		This:C1470.file:=$file
		
		var $CLI : cs:C1710._CLI
		$CLI:=cs:C1710._CLI.new()
		
		$CLI.print("generate data file for "+$dataClassName+"..."; "bold")
		$CLI.print("success"; "82;bold").LF()
		$CLI.print($file.path; "244").LF()
		$CLI.print($asset.path; "244").LF()
		$CLI.print("size: "; "bold").print(String:C10($file.size); "39").LF()
		
		$file.copyTo(Folder:C1567("/RESOURCES/"); fk overwrite:K87:5)
		
	Else 
		
		$file:=This:C1470._dataFolder.file($dataClassName+".data")
		
		If ($file#Null:C1517) && ($file.exists)
			
			$data:=$file.getContent()
			
			BLOB TO VARIABLE:C533($data; $object)
			
			This:C1470[$dataClassName]:=$object[$dataClassName]
			This:C1470.code:=$object.code
			This:C1470.file:=$file
			
		End if 
	End if 
