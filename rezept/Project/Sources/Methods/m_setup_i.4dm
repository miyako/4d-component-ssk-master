//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $dataClassName)
C_OBJECT:C1216($2; $dataClass)
C_BOOLEAN:C305($3; $noHost)

C_TEXT:C284($薬価基準コード)

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
			
			$object:=OB Copy:C1225($entity.toObject(); ck shared:K85:29; $sharedCollection)
			$sharedCollection.push($object)
			
			$薬価基準コード:=$entity.項目.薬価基準コード
			If ($薬価基準コード#"")
				$e一般名:=ds一般名検索($薬価基準コード)
				If ($e一般名#Null:C1517)
					$object.一般名:=OB Copy:C1225($e一般名.toObject(); ck shared:K85:29; $sharedCollection)
				Else 
					$object.一般名:=Null:C1517  //一般名なし
				End if 
				
				$e後発医薬品:=ds後発品検索($薬価基準コード)
				If ($e後発医薬品#Null:C1517)
					$object.後発品:=OB Copy:C1225($e後発医薬品.toObject(); ck shared:K85:29; $sharedCollection)
				Else 
					$object.後発品:=Null:C1517  //一般名なし
				End if 
				
			End if 
		End for each 
		
		C_OBJECT:C1216($sharedObject)
		
		$o:=This:C1470["code"]
		
		For each ($sharedObject; $sharedCollection)
			
			$o[$sharedObject.医薬品コード]:=$sharedObject
			
		End for each 
		
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