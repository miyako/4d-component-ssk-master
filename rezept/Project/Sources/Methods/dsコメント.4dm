//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
C_BOOLEAN:C305($1; $noHost)
C_OBJECT:C1216($0; $EXPORT)

If (Count parameters:C259#0)
	$noHost:=$1
Else 
	$noHost:=(Folder:C1567(fk database folder:K87:14).platformPath=Folder:C1567(fk database folder:K87:14; *).platformPath)
End if 

If (Storage:C1525.コメント=Null:C1517)
	
	$EXPORT:=New shared object:C1526("コメント"; New shared collection:C1527; "code"; New shared object:C1526)
	
	Formula:C1597(m_setup).call($EXPORT; "コメント"; ds:C1482.コメント; $noHost)
	
	Use (Storage:C1525)
		Storage:C1525.コメント:=$EXPORT
	End use 
	
	Use ($EXPORT)
		
		$EXPORT.params:=Formula:C1597(new_query_params)
		
	End use 
	
Else 
	$EXPORT:=Storage:C1525.コメント
End if 

$0:=$EXPORT