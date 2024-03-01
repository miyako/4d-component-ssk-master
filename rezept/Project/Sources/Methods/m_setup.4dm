//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $dataClassName)
C_OBJECT:C1216($2; $dataClass)
C_BOOLEAN:C305($3; $noHost)

C_BLOB:C604($data)
C_TEXT:C284($element)

C_COLLECTION:C1488($sharedCollection)

$dataClassName:=$1
$dataClass:=$2
$noHost:=$3

$sharedCollection:=This:C1470[$dataClassName]

Use ($sharedCollection)
	If ($noHost)
		//データ再構築
		For each ($entity; $dataClass.all())
			$sharedCollection.push(OB Copy:C1225($entity.toObject(); ck shared:K85:29; $sharedCollection))
		End for each 
		
		C_OBJECT:C1216($sharedObject)
		
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
		$file:=Folder:C1567("/RESOURCES/").file($dataClassName+".data")
		$file.setContent($data)
		
	Else 
		
		$file:=Folder:C1567("/RESOURCES/").file($dataClassName+".data")
		
		If ($file.exists)
			
			$data:=$file.getContent()
			
			C_OBJECT:C1216($object)
			BLOB TO VARIABLE:C533($data; $object)
			$object:=OB Copy:C1225($object; ck shared:K85:29; This:C1470)
			
			Use (This:C1470)
				This:C1470[$dataClassName]:=$object[$dataClassName]
				This:C1470["code"]:=$object["code"]
			End use 
			
		End if 
	End if 
End use 