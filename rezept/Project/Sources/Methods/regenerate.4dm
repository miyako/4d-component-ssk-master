//%attributes = {}
If (Get application info:C1599.headless)
	
	var $CLI : cs:C1710.CLI
	$CLI:=cs:C1710.CLI.new()
	$CLI.logo().version()
	
	ON ERR CALL:C155(Formula:C1597(generic_error_handler).source)
	
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
	
	ds:C1482.医薬品.regenerate($CLI)
	
	cs:C1710.Build.new().build()
	
	ON ERR CALL:C155("")
	
End if 