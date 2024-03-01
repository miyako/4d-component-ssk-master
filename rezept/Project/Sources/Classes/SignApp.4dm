property logFile : 4D:C1709.File

Class extends _CLI

Class constructor($controller : 4D:C1709.Class; $signal : 4D:C1709.Signal)
	
	Super:C1705("SignApp.sh"; $controller)
	
	If ($signal#Null:C1517) && (OB Instance of:C1731($signal; 4D:C1709.Signal))
		This:C1470.controller.signal:=$signal
	End if 
	
	This:C1470.logFile:=Null:C1517
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function _sign($application : 4D:C1709.Folder; $useLog : Boolean; $certificateName : Text)->$this : cs:C1710.SignApp
	
	$this:=This:C1470
	
	If ($application#Null:C1517) && (OB Instance of:C1731($application; 4D:C1709.Folder)) && ($application.exists)
		
		$command:=This:C1470.escape(This:C1470.executablePath)
		
		If ($certificateName="")
			$certificateName:="-"
		End if 
		
		var $entitlementsFile : 4D:C1709.File
		$entitlementsFile:=File:C1566(Folder:C1567(fk resources folder:K87:11).file("4D.entitlements").platformPath; fk platform path:K87:2)
		
		$timestamp:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
		$timestamp:=Replace string:C233($timestamp; Folder separator:K24:12; "-"; *)
		
		$command:=$command+\
			" "+This:C1470.escape($certificateName)+\
			" "+This:C1470.escape($application.path)+\
			" "+This:C1470.escape($entitlementsFile.path)
		
		If ($useLog)
			
			var $logFile : 4D:C1709.File
			
			$logFile:=File:C1566(File:C1566("/LOGS/SignApp-"+$timestamp+".log").platformPath; fk platform path:K87:2)
			
			$command:=$command+" "+This:C1470.escape($logFile.path)
			
			This:C1470.logFile:=$logFile
			
		Else 
			
			This:C1470.logFile:=Null:C1517
			
		End if 
		
		This:C1470.controller.execute($command; $logFile)
		
	End if 
	
Function _getCertificateName($BuildApp : cs:C1710.BuildApp)->$certificateName : Text
	
	If ($BuildApp.SignApplication.MacSignature#Null:C1517) && ($BuildApp.SignApplication.MacCertificate#Null:C1517)
		If (Bool:C1537($BuildApp.SignApplication.MacSignature))
			$certificateName:=$BuildApp.SignApplication.MacCertificate
		End if 
	End if 
	
Function signAsync($application : 4D:C1709.Folder; $BuildApp : cs:C1710.BuildApp) : cs:C1710.SignApp
	
	$certificateName:=This:C1470._getCertificateName($BuildApp)
	
	This:C1470._sign($application; False:C215; $certificateName)
	
	return This:C1470
	
Function sign($application : 4D:C1709.Folder; $BuildApp : cs:C1710.BuildApp) : cs:C1710.SignApp
	
	$certificateName:=This:C1470._getCertificateName($BuildApp)
	
	This:C1470._sign($application; True:C214; $certificateName)
	
	This:C1470.controller.worker.wait()
	
	return This:C1470