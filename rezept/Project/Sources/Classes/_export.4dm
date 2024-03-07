Class constructor($dataClassName : Text)
	
	This:C1470.dataClassName:=$dataClassName
	This:C1470[$dataClassName]:=[]
	This:C1470.code:={}
	This:C1470.file:=Null:C1517
	
Function _getDataFolder() : 4D:C1709.Folder
	
	var $folder : 4D:C1709.Folder
	$folder:=Folder:C1567(fk user preferences folder:K87:10).parent
	$folder:=$folder.folder("com.4d.rezept")
	$folder.create()
	
	return $folder
	
Function _isComponent() : Boolean
	
	return (Folder:C1567(fk database folder:K87:14).platformPath#Folder:C1567(fk database folder:K87:14; *).platformPath)
	
Function 診療行為($code : Text; $collection : Collection)
	
	var $rezept : cs:C1710.rezept
	$rezept:=cs:C1710.rezept.new()
	
	var $c診療行為 : Collection
	$c診療行為:=$rezept.診療行為.query("診療行為コード === :1"; $code)
	
	If ($c診療行為.length=1)
		var $診療行為 : Object
		$診療行為:=$c診療行為[0]
		Use ($collection)
			$collection.push(OB Copy:C1225($診療行為; ck shared:K85:29; $collection))
		End use 
	End if 
	
Function コメント($code : Text; $collection : Collection)->$isComment : Boolean
	
	var $rezept : cs:C1710.rezept
	$rezept:=cs:C1710.rezept.new()
	
	var $コメント : Object
	$コメント:=$rezept.get("コメント")[$code]
	
	If ($コメント#Null:C1517)
		Use ($collection)
			$collection.push(OB Copy:C1225($コメント; ck shared:K85:29; $collection))
		End use 
		$isComment:=True:C214
	Else 
		TRACE:C157
	End if 
	
Function setup()
	
	$dataClassName:=This:C1470.dataClassName
	$dataClass:=ds:C1482["_"+$dataClassName]
	$noHost:=Not:C34(This:C1470._isComponent())
	
	var $data : Blob
	var $object : Object
	var $sharedObject : Object
	var $element : Text
	var $file : 4D:C1709.File
	var $sharedCollection : Collection
	$sharedCollection:=This:C1470[$dataClassName]
	
	If ($noHost)
		
		For each ($entity; $dataClass.all())
			$instance:=OB Copy:C1225($entity.toObject(); ck shared:K85:29; $sharedCollection)
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
		$file.setContent($data)
		This:C1470.file:=$file
		
	Else 
		
		$file:=This:C1470._getDataFolder().file($dataClassName+".data")
		
		If ($file#Null:C1517) && ($file.exists)
			
			$data:=$file.getContent()
			BLOB TO VARIABLE:C533($data; $object)
			
			This:C1470[$dataClassName]:=$object[$dataClassName]
			This:C1470.code:=$object.code
			This:C1470.file:=$file
			
		End if 
	End if 