Class extends _CLI_Controller

property _stdErrBuffer; _stdOutBuffer : Text
property CLI : cs:C1710.BuildApp_CLI
property logFile : 4D:C1709.File
property _itemCount : Integer

Class constructor
	
	Super:C1705()
	
Function _clear()
	
	This:C1470._itemCount:=0
	This:C1470._stdErrBuffer:=""
	This:C1470._stdOutBuffer:=""
	
Function execute($command : Variant; $logFile : 4D:C1709.File)
	
	This:C1470.CLI:=cs:C1710.BuildApp_CLI.new()
	
	This:C1470._clear()
	
	This:C1470.logFile:=$logFile
	
	var $commands : Collection
	
	Case of 
		: (Value type:C1509($command)=Is text:K8:3)
			$commands:=New collection:C1472($command)
		: (Value type:C1509($command)=Is collection:K8:32)
			$commands:=$command
	End case 
	
	If ($commands#Null:C1517) && ($commands.length#0)
		
		This:C1470._commands.combine($commands)
		
		If (This:C1470._worker=Null:C1517)
			This:C1470._onResponse:=This:C1470.onResponse
			This:C1470.onResponse:=This:C1470._onExecute
			This:C1470._onTerminate:=This:C1470.onTerminate
			This:C1470.onTerminate:=This:C1470._onComplete
			This:C1470._execute()
		End if 
		
	End if 
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	$CLI:=This:C1470.CLI
	
	Case of 
		: ($worker.dataType="text")
			
			This:C1470._stdOutBuffer+=$params.data
			
		: ($worker.dataType="blob")
			
			This:C1470._stdOutBuffer+=Convert to text:C1012($params.data; This:C1470.encoding)
			
	End case 
	
	$data:=This:C1470._stdOutBuffer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	$i:=1
	
	While (Match regex:C1019("^([^:]+):\\s*(.+)"; $data; $i; $pos; $len))
		$path:=Substring:C12($data; $pos{1}; $len{1})
		$message:=Substring:C12($data; $pos{2}; $len{2})
		$o:=Path to object:C1547($path; Path is POSIX:K24:26)
		$name:=$o.name+$o.extension
		
		Case of 
			: ($message="signed app bundle@")
				$CLI.print($message; "bold").LF()  //last line
			Else 
				This:C1470._itemCount+=1
				$CLI._printItem($name)
		End case 
		
		$i:=$i+$pos{2}+$len{2}
	End while 
	
	This:C1470._stdOutBuffer:=Substring:C12($data; $i)
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	$CLI:=This:C1470.CLI
	
	var $logFile : 4D:C1709.File
	
	$logFile:=This:C1470.logFile
	
	If ($logFile#Null:C1517) && ($logFile.exists)
		
		$lines:=Split string:C1554($logFile.getText("utf-8"; Document with CR:K24:21); "\r"; ck ignore null or empty:K85:5)
		
		var $status : Text
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		$files:=New collection:C1472
		
		$line:=$lines.pop()
		
		If (Match regex:C1019("^([^:]+):\\s*(.+)"; $line; 1; $pos; $len))
			$path:=Substring:C12($line; $pos{1}; $len{1})
			$message:=Substring:C12($line; $pos{2}; $len{2})
			$o:=Path to object:C1547($path; Path is POSIX:K24:26)
			$status:=$message
		End if 
		
		For each ($line; $lines)
			
			If (Match regex:C1019("^([^:]+):\\s*(.+)"; $line; 1; $pos; $len))
				$path:=Substring:C12($line; $pos{1}; $len{1})
				$message:=Substring:C12($line; $pos{2}; $len{2})
				$o:=Path to object:C1547($path; Path is POSIX:K24:26)
				$files.push($o.name+$o.extension)
			End if 
			
		End for each 
		
		$CLI._printList($files)
		$CLI.print($status).LF()
		
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If (This:C1470.signal#Null:C1517)
		This:C1470.signal.trigger()
	End if 
	
Function onError($worker : 4D:C1709.SystemWorker; $params : Object)