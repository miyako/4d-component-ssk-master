//%attributes = {}
If (Get application info:C1599.headless)
	
	var $CLI : cs:C1710._CLI
	$CLI:=cs:C1710._CLI.new().ES().XY(0; 0)
	$CLI.logo().version()  //.hideCursor()
	
	ON ERR CALL:C155(Formula:C1597(generic_error_handler).source)
	
	var $userParamValue : Text
	$param:=Get database parameter:C643(User param value:K37:94; $userParamValue)
	
	var $options : Collection
	$options:=Split string:C1554($userParamValue; ","; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	
	var $verbose; $regenerate; $export : Boolean
	$verbose:=$options.includes("verbose")
	$regenerate:=$options.includes("regenerate")
	$export:=$options.includes("export")
	
	$CLI.print("verbose..."; "bold")
	If ($verbose)
		$CLI.print("yes"; "39").LF()
	Else 
		$CLI.print("no"; "196;bold").LF()
	End if 
	
	$CLI.print("regenerate..."; "bold")
	If ($regenerate)
		$CLI.print("yes"; "39").LF()
	Else 
		$CLI.print("no"; "196;bold").LF()
	End if 
	
	$CLI.print("export..."; "bold")
	If ($export)
		$CLI.print("yes"; "39").LF()
	Else 
		$CLI.print("no"; "196;bold").LF()
	End if 
	
	If ($regenerate)
		
		//一般名処方,後発医薬品,医薬品がセット（医薬品に統合する）
		ds:C1482._一般名処方.regenerate($CLI; $verbose)
		ds:C1482._後発医薬品.regenerate($CLI; $verbose)
		ds:C1482._医薬品.regenerate($CLI; $verbose)
		
		ds:C1482._傷病名.regenerate($CLI; $verbose)
		ds:C1482._修飾語.regenerate($CLI; $verbose)
		
		//診療行為,特定器材,コメントがセット（記載事項等で参照する）
		ds:C1482._診療行為.regenerate($CLI; $verbose)
		ds:C1482._特定器材.regenerate($CLI; $verbose)
		ds:C1482._コメント.regenerate($CLI; $verbose)
		
		ds:C1482._地方公費.regenerate($CLI; $verbose)
		
		//TODO: 記載事項等をインポートする方法を考える
		
	End if 
	
	If ($export)
		cs:C1710.Rezept.new()
	End if 
	
	//$CLI.showCursor()
	
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