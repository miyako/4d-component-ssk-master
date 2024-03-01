//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($BuildApp : cs:C1710.BuildApp; $RuntimeFolder : 4D:C1709.Folder; $signal : 4D:C1709.Signal)

Case of 
	: (Count parameters:C259=2)
		
		$signal:=New signal:C1641
		
		CALL WORKER:C1389("signApp"; Current method name:C684; $BuildApp; $RuntimeFolder; $signal)
		
		$signal.wait()
		
	: (Count parameters:C259=3)
		
		var $SignApp : cs:C1710.SignApp
		
		$SignApp:=cs:C1710.SignApp.new(cs:C1710.SignApp_Controller; $signal)
		
		$SignApp.signAsync($RuntimeFolder; $BuildApp)
		
End case 