Class constructor
	
	This:C1470.endpoint:="https://api.github.com/repos/miyako/4d-component-ssk-master/releases"
	
	$options:=OB Copy:C1225(This:C1470)
	
	$options.dataType:="text"
	$options.automaticRedirections:=True:C214
	
	If (Application type:C494=4D Remote mode:K5:5)
		new_github_s
	Else 
		CALL WORKER:C1389(Application type:C494=4D Server:K5:6 ? "rezept" : 1; This:C1470._fetch; $options)
	End if 
	
	//MARK:private
	
Function _download($options : Object)
	
	For each ($asset; $options.release.assets)
		Case of 
			: ($asset.name="data.@.zip")
				
				$options:=OB Copy:C1225($options)
				$options.asset:=$asset
				
				Case of 
					: ($asset.name="data.1.zip")
						$options.name:="コメント"
					: ($asset.name="data.2.zip")
						$options.name:="医薬品"
					: ($asset.name="data.3.zip")
						$options.name:="記載事項等"
					: ($asset.name="data.4.zip")
						$options.name:="修飾語"
					: ($asset.name="data.5.zip")
						$options.name:="傷病名"
					: ($asset.name="data.6.zip")
						$options.name:="診療行為"
					: ($asset.name="data.7.zip")
						$options.name:="単位"
					: ($asset.name="data.8.zip")
						$options.name:="地方公費"
					: ($asset.name="data.9.zip")
						$options.name:="特定器材"
					Else 
						continue
				End case 
				
				$request:=4D:C1709.HTTPRequest.new($asset.browser_download_url; $options)
				
		End case 
	End for each 
	
Function _fetch($options : Object)
	
	$request:=4D:C1709.HTTPRequest.new($options.endpoint; $options)
	
Function _get($release : Object)
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470._getDataFolder($release.tag)
	If (Not:C34($folder.exists))
		$folder.create()
		$options:=OB Copy:C1225(This:C1470)
		$options.folder:=$folder
		$options.release:=$release
		$options.dataType:="blob"
		$options.automaticRedirections:=True:C214
		CALL WORKER:C1389(Application type:C494=4D Server:K5:6 ? "rezept" : 1; This:C1470._download; $options)
	End if 
	
Function _getDataFolder($tag : Text)
	
	return cs:C1710._Export.new()._getDataFolder().folder($tag)
	
	//MARK:HTTP
	
Function onData($request : 4D:C1709.HTTPRequest; $event : Object)
	
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
Function onHeaders($request : 4D:C1709.HTTPRequest; $event : Object)
	
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	If ($request.response.status=200)
		
		Case of 
			: ($request.dataType="text")
				
				var $bodyText : Text
				$bodyText:=$request.response.body
				
				var $releases : Collection
				$releases:=JSON Parse:C1218($bodyText; Is collection:K8:32)
				$releases:=$releases.extract("tag_name"; "tag"; "name"; "name"; "assets"; "assets"; "published_at"; "published_at").orderBy("published_at desc")
				
				For each ($release; $releases)
					This:C1470._get($release)
				End for each 
				
			: ($request.dataType="blob")
				
				var $body : 4D:C1709.Blob
				$body:=$request.response.body
				$folder:=This:C1470.asset.folder
				$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
				$tempFolder.create()
				$file:=$tempFolder.file(This:C1470.name+".zip")
				$file.setContent($body)
				
				$zip:=ZIP Read archive:C1637($file)
				$files:=$zip.root.files()
				
				If ($files.length#0)
					
					$files[0].copyTo(This:C1470.folder; This:C1470.name+".data")
					$names:=["記載事項等"; "単位"; "医薬品"; "傷病名"; "地方公費"; "特定器材"; "修飾語"; "診療行為"; "コメント"]
					$files:=This:C1470.folder.files(fk ignore invisible:K87:22).query("extension == :1 and name in :2"; ".data"; $names)
					
					If ($files.length=$names.length)
						
						$manifest:={name: This:C1470.release.name; tag: This:C1470.release.tag; published_at: This:C1470.release.published_at; active: False:C215}
						
						cs:C1710._Export.new().setManifest(This:C1470.folder; $manifest)
						
					End if 
				End if 
				
		End case 
		
	End if 
	
Function onTerminate($request : 4D:C1709.HTTPRequest; $event : Object)
	