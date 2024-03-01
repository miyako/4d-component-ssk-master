//%attributes = {}
If (Get application info:C1599.headless)
	
	var $CLI : cs:C1710.CLI
	$CLI:=cs:C1710.CLI.new()
	$CLI.logo().version()
	
	ON ERR CALL:C155(Formula:C1597(generic_error_handler).source)
	
	var $userParamValue : Text
	$param:=Get database parameter:C643(User param value:K37:94; $userParamValue)
	
	var $userParamValues : Collection
	If ($userParamValue#"")
		$userParamValues:=Split string:C1554($userParamValue; ",")
	Else 
		$userParamValues:=[]
	End if 
	
	Case of 
		: ($userParamValues.indexOf("export")#-1)
			
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
			
			ds特定器材
			
			$dataFile:=Folder:C1567("/RESOURCES/").file("特定器材.data")
			$CLI.print("generate data file..."; "bold")
			If ($dataFile.exists)
				$CLI.print("success"; "82;bold").LF()
				$CLI.print($dataFile.path; "244").LF()
				$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
			Else 
				$CLI.print("failure"; "196;bold").LF()
			End if 
			
			ds修飾語
			
			$dataFile:=Folder:C1567("/RESOURCES/").file("修飾語.data")
			$CLI.print("generate data file..."; "bold")
			If ($dataFile.exists)
				$CLI.print("success"; "82;bold").LF()
				$CLI.print($dataFile.path; "244").LF()
				$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
			Else 
				$CLI.print("failure"; "196;bold").LF()
			End if 
			
			ds診療行為
			
			$dataFile:=Folder:C1567("/RESOURCES/").file("診療行為.data")
			$CLI.print("generate data file..."; "bold")
			If ($dataFile.exists)
				$CLI.print("success"; "82;bold").LF()
				$CLI.print($dataFile.path; "244").LF()
				$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
			Else 
				$CLI.print("failure"; "196;bold").LF()
			End if 
			
			ds傷病名
			
			$dataFile:=Folder:C1567("/RESOURCES/").file("傷病名.data")
			$CLI.print("generate data file..."; "bold")
			If ($dataFile.exists)
				$CLI.print("success"; "82;bold").LF()
				$CLI.print($dataFile.path; "244").LF()
				$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
			Else 
				$CLI.print("failure"; "196;bold").LF()
			End if 
			
			dsコメント
			
			$dataFile:=Folder:C1567("/RESOURCES/").file("コメント.data")
			$CLI.print("generate data file..."; "bold")
			If ($dataFile.exists)
				$CLI.print("success"; "82;bold").LF()
				$CLI.print($dataFile.path; "244").LF()
				$CLI.print("size: "; "bold").print(String:C10($dataFile.size); "39").LF()
			Else 
				$CLI.print("failure"; "196;bold").LF()
			End if 
			
			cs:C1710.Build.new().build()
			
		Else 
			ds:C1482.医薬品.regenerate($CLI)
			ds:C1482.一般名処方.regenerate($CLI)
			ds:C1482.後発医薬品.regenerate($CLI)
			ds:C1482.特定器材.regenerate($CLI)
			ds:C1482.修飾語.regenerate()
			ds:C1482.コメント.regenerate()
			ds:C1482.傷病名.regenerate()
			ds:C1482.診療行為.regenerate()
			SET DATABASE PARAMETER:C642(User param value:K37:94; "export")
			RESTART 4D:C1292
	End case 
	
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