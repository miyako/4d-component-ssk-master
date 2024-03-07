//%attributes = {}
If (Get application info:C1599.headless)
	
	var $CLI : cs:C1710.CLI
	$CLI:=cs:C1710.CLI.new().ES().XY(0; 0)
	$CLI.logo().version().hideCursor()
	
	ON ERR CALL:C155(Formula:C1597(generic_error_handler).source)
	
	var $userParamValue : Text
	$param:=Get database parameter:C643(User param value:K37:94; $userParamValue)
	
	var $options : Collection
	$options:=Split string:C1554($userParamValue; ","; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	
	var $verbose; $regenerate : Boolean
	$verbose:=$options.includes("verbose")
	$regenerate:=$options.includes("verbose")
	
	$CLI.print("verbose..."; "bold")
	If ($verbose)
		$CLI.print("yes"; "39").LF()
	Else 
		$CLI.print("yes"; "196;bold").LF()
	End if 
	
	$CLI.print("regenerate..."; "bold")
	If ($regenerate)
		$CLI.print("yes"; "39").LF()
	Else 
		$CLI.print("yes"; "196;bold").LF()
	End if 
	
	If ($regenerate)
		ds:C1482.医薬品.regenerate($CLI; $verbose)
		ds:C1482.一般名処方.regenerate($CLI; $verbose)
		ds:C1482.後発医薬品.regenerate($CLI; $verbose)
		
		ds:C1482._特定器材.regenerate($CLI; $verbose)
		ds:C1482._修飾語.regenerate($CLI; $verbose)
		ds:C1482._コメント.regenerate($CLI; $verbose)
		ds:C1482._傷病名.regenerate($CLI; $verbose)
		ds:C1482._診療行為.regenerate($CLI; $verbose)
	End if 
	
	If ($options.includes("export"))
		
		ds医薬品
		
		var $dataFile : 4D:C1709.File
		
		$dataFile:=Folder:C1567("/RESOURCES/").file("医薬品.data")
		$CLI.print("generate data file..."; "bold")
		If ($dataFile.exists)
			$CLI.print("success"; "82;bold").LF()
			$CLI.print($dataFile.path; "244").LF()
			$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
		Else 
			$CLI.print("failure"; "196;bold").LF()
		End if 
		
		$dataFile:=Folder:C1567("/RESOURCES/").file("特定器材.data")
		$CLI.print("generate data file..."; "bold")
		If ($dataFile.exists)
			$CLI.print("success"; "82;bold").LF()
			$CLI.print($dataFile.path; "244").LF()
			$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
		Else 
			$CLI.print("failure"; "196;bold").LF()
		End if 
		
		$dataFile:=Folder:C1567("/RESOURCES/").file("修飾語.data")
		$CLI.print("generate data file..."; "bold")
		If ($dataFile.exists)
			$CLI.print("success"; "82;bold").LF()
			$CLI.print($dataFile.path; "244").LF()
			$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
		Else 
			$CLI.print("failure"; "196;bold").LF()
		End if 
		
		$dataFile:=Folder:C1567("/RESOURCES/").file("診療行為.data")
		$CLI.print("generate data file..."; "bold")
		If ($dataFile.exists)
			$CLI.print("success"; "82;bold").LF()
			$CLI.print($dataFile.path; "244").LF()
			$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
		Else 
			$CLI.print("failure"; "196;bold").LF()
		End if 
		
		$dataFile:=Folder:C1567("/RESOURCES/").file("傷病名.data")
		$CLI.print("generate data file..."; "bold")
		If ($dataFile.exists)
			$CLI.print("success"; "82;bold").LF()
			$CLI.print($dataFile.path; "244").LF()
			$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
		Else 
			$CLI.print("failure"; "196;bold").LF()
		End if 
		
		$dataFile:=Folder:C1567("/RESOURCES/").file("コメント.data")
		$CLI.print("generate data file..."; "bold")
		If ($dataFile.exists)
			$CLI.print("success"; "82;bold").LF()
			$CLI.print($dataFile.path; "244").LF()
			$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
		Else 
			$CLI.print("failure"; "196;bold").LF()
		End if 
		
	End if 
	
	$CLI.showCursor()
	
	If (False:C215)
		$CLI.print("白"; "bold")
		$CLI.print("緑"; "82;bold")
		$CLI.print("赤"; "196;bold")
		$CLI.print("紫"; "177;bold")
		$CLI.print("灰"; "244")
		$CLI.print("青"; "39")
		$CLI.print("黄"; "226")
		$CLI.print("橙"; "166")
	End if 
	
	ON ERR CALL:C155("")
	
End if 