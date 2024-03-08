Class constructor($menu : Text)
	
	If (Count parameters:C259#0)
		This:C1470.menu:=$menu
	Else 
		This:C1470.menu:=1
	End if 
	
	This:C1470.記載事項等:=ds記載事項等
	This:C1470.診療行為:=ds診療行為
	
Function _getKind($item : Object)->$kind : Text
	
	var $名称 : Text
	
	$名称:=$item.名称
	
	Case of 
		: ($item.名称="*#@")  //約束
			
			$kind:="約束"
			
		: ($item.名称="*@")  //登録
			
			$kind:="登録"
			
		Else 
			
			$kind:="診療"
			
	End case 
	
Function query($item : Object)->$記載事項等 : Collection
	
	var $kind : Text
	
	$kind:=This:C1470._getKind($item)
	
	Case of 
		: ($kind="診療")
			
			If ($item.診療コード#"")
				Case of 
					: (Length:C16($item.診療コード)=9)
						$記載事項等:=This:C1470.記載事項等.診療行為コード[$item.診療コード]
					: (Length:C16($item.厚労省マスター)=9)
						$記載事項等:=This:C1470.記載事項等.診療行為コード[$item.厚労省マスター]
				End case 
			End if 
			
		: ($kind="約束")
			
		: ($kind="登録")
			
	End case 
	
Function str_trim($src : Text)->$dst : Text
	
	$dst:=$src
	
	//trim
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	If (Match regex:C1019("^\\s*(.*?)\\s*$"; $src; 1; $pos; $len))
		$dst:=Substring:C12($src; $pos{1}; $len{1})
	End if 
	
	$dst:=Replace string:C233($dst; Char:C90(0x002C); ""; *)
	$dst:=Replace string:C233($dst; Char:C90(0x000D); ""; *)
	
	//Function 日付入力($ctx : Object)->$日付入力 : Boolean
	
	//$ctx.firstDayOf:=Formula(Add to date(!00-00-00!; Year of($1); Month of($1); 1))
	//$ctx.hasPrevious:=Formula(This.range.startDate<This.firstDayOf(This.range.date))
	
	//$ctx.lastDayOf:=Formula(Add to date(!00-00-00!; Year of($1); Month of($1)+1; 1)-1)
	//$ctx.hasNext:=Formula(This.range.endDate>This.lastDayOf(This.range.date))
	
	//$ctx.previous:=Formula(This.range.date:=Add to date(!00-00-00!; Year of(This.range.date); Month of(This.range.date); 1)-1)
	//$ctx.next:=Formula(This.range.date:=Add to date(!00-00-00!; Year of(This.range.date); Month of(This.range.date)+1; 1))
	
	//$ctx.hasPreviousYear:=Formula(This.range.startDate<Add to date(!00-00-00!; Year of(This.range.date)-1; Month of(This.range.date); Day of(This.range.date)))
	//$ctx.hasNextYear:=Formula(This.range.endDate>Add to date(!00-00-00!; Year of(This.range.date)+1; Month of(This.range.date); Day of(This.range.date)))
	
	//$ctx.previousYear:=Formula(This.range.date:=Add to date(!00-00-00!; Year of(This.range.date)-1; Month of(This.range.date); Day of(This.range.date)))
	//$ctx.nextYear:=Formula(This.range.date:=Add to date(!00-00-00!; Year of(This.range.date)+1; Month of(This.range.date); Day of(This.range.date)))
	
	//$ctx.hasPreviousDecade:=Formula(This.range.startDate<Add to date(!00-00-00!; Year of(This.range.date)-10; Month of(This.range.date); Day of(This.range.date)))
	//$ctx.hasNextDecade:=Formula(This.range.endDate>Add to date(!00-00-00!; Year of(This.range.date)+10; Month of(This.range.date); Day of(This.range.date)))
	
	//$ctx.previousDecade:=Formula(This.range.date:=Add to date(!00-00-00!; Year of(This.range.date)-10; Month of(This.range.date); Day of(This.range.date)))
	//$ctx.nextDecade:=Formula(This.range.date:=Add to date(!00-00-00!; Year of(This.range.date)+10; Month of(This.range.date); Day of(This.range.date)))
	
	//$ctx.range.Gregorian:=True
	//$ctx.range.Era:=False
	
	//$window:=Open form window("日付入力"; Sheet form window)
	//DELAY PROCESS(Current process; 10)  //need this for smoothe animation in main process 
	//DIALOG("日付入力"; $ctx)
	//$OK:=OK
	
	//CLOSE WINDOW($window)
	
	//$日付入力:=($OK=1)
	
Function pattern_date_i($記載事項 : Object)
	
	$ctx:=New object:C1471("range"; New object:C1471)
	
	$ctx.range.date:=$記載事項.date
	$ctx.range.startDate:=!00-00-00!
	$ctx.range.endDate:=!2100-12-31!
	$ctx.range.disabled:=Formula:C1597(False:C215)
	
	If (Form:C1466.日付入力($ctx))
		
		$記載事項.date:=$ctx.range.date
		
		C_TEXT:C284($text; $wareki)
		C_LONGINT:C283($era; $year; $month; $day)
		$wareki:=ERA_Convert_from_date($記載事項.date; ->$era; ->$year; ->$month; ->$day)
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		$comment:=Form:C1466.comment
		
		If (Match regex:C1019("([^；]+)；"; $comment; 1; $pos; $len))
			$text:=Substring:C12($comment; $pos{1}; $len{1})
			$記載事項.comment:=$text+"；"+$wareki
		Else 
			$記載事項.comment:=$wareki
		End if 
		
		$記載事項.dateString:=String:C10($era; "00")+String:C10($year; "00")+String:C10($month; "00")+String:C10($day; "00")
		
		Form:C1466.comment:=$記載事項.comment
		Form:C1466.string:=$記載事項.dateString
		
	End if 
	
Function pattern_duration_i($記載事項 : Object)
	
	$ctx:=New object:C1471
	$ctx.message:="数字のコメント"
	$ctx.OK:="OK"
	$ctx.cancel:="キャンセル"
	$ctx.match:="\\d*"
	$ctx.filter:="&\"0-9\""
	$ctx.request:=String:C10(Form:C1466.value)
	
	$window:=Open form window:C675("Request"; Sheet form window:K39:12)
	DELAY PROCESS:C323(Current process:C322; 10)
	DIALOG:C40("Request"; $ctx)
	CLOSE WINDOW:C154($window)
	
	If (OK=1)
		
		$value:="00000"+String:C10($ctx.request)
		$value:=Substring:C12($value; Length:C16($value)-4)
		$記載事項.value:=$value
		
		$value:=Form:C1466.文字列変換($value; "半角->全角")
		Form:C1466.string:=$value
		
		$value:=Form:C1466.文字列変換(String:C10($記載事項.value); "半角->全角")+"分"
		
		$記載事項.comment:=$text+"；"+$value
		
		Form:C1466.comment:=$記載事項.comment
		
	End if 
	
Function pattern_num_append_i($記載事項 : Object)
	
	$ctx:=New object:C1471
	$ctx.message:="数字のコメント"
	$ctx.OK:="OK"
	$ctx.cancel:="キャンセル"
	$ctx.match:="\\d+"
	$ctx.filter:="&\"0-9\""
	$ctx.request:=String:C10($記載事項.value)
	
	$window:=Open form window:C675("Request"; Sheet form window:K39:12)
	DELAY PROCESS:C323(Current process:C322; 10)
	DIALOG:C40("Request"; $ctx)
	CLOSE WINDOW:C154($window)
	
	If (OK=1)
		
		$記載事項.value:=Num:C11($ctx.request)
		$記載事項.string:=Form:C1466.文字列変換($ctx.request; "半角->全角")
		Form:C1466.string:=$記載事項.string
		
		$記載事項.comment:=$text+"；"+$記載事項.string
		
		Form:C1466.comment:=$記載事項.comment
		
		OBJECT SET ENTERABLE:C238(*; "コメント"; True:C214)
		GOTO OBJECT:C206(*; "コメント")
		
		//HIGHLIGHT TEXT(*; "コメント"; Length($text)+2; Length($記載事項.comment)+1)
		
	End if 
	
Function pattern_num_i($記載事項 : Object; $step : Object)
	
	$コメントコード:=$step.コメントコード
	$pattern:=$コメントコード.パターン
	$コメント文:=$step.コメント文
	$text:=$コメント文.漢字名称
	
	$ctx:=New object:C1471
	
	$項目:=$step.項目
	
	$ctx.レセプト編集情報1:=$項目.レセプト編集情報1
	$ctx.レセプト編集情報2:=$項目.レセプト編集情報2
	$ctx.レセプト編集情報3:=$項目.レセプト編集情報3
	$ctx.レセプト編集情報4:=$項目.レセプト編集情報4
	
	$ctx.カラム位置1:=$ctx.レセプト編集情報1.カラム位置
	$ctx.カラム位置2:=$ctx.レセプト編集情報2.カラム位置
	$ctx.カラム位置3:=$ctx.レセプト編集情報3.カラム位置
	$ctx.カラム位置4:=$ctx.レセプト編集情報4.カラム位置
	
	$ctx.桁数1:=$ctx.レセプト編集情報1.桁数
	$ctx.桁数2:=$ctx.レセプト編集情報2.桁数
	$ctx.桁数3:=$ctx.レセプト編集情報3.桁数
	$ctx.桁数4:=$ctx.レセプト編集情報4.桁数
	
	$ctx.message:="数字のコメント"
	$ctx.OK:="OK"
	$ctx.cancel:="キャンセル"
	$ctx.match1:="\\d{"+$ctx.桁数1+"}"
	$ctx.match2:="\\d{"+$ctx.桁数2+"}"
	$ctx.match3:="\\d{"+$ctx.桁数3+"}"
	$ctx.match4:="\\d{"+$ctx.桁数4+"}"
	
	$ctx.filter:="&\"0-9\""
	$ctx.request1:=String:C10(Form:C1466.value1; "0"*Num:C11($ctx.桁数1))
	$ctx.request2:=String:C10(Form:C1466.value2; "0"*Num:C11($ctx.桁数2))
	$ctx.request3:=String:C10(Form:C1466.value3; "0"*Num:C11($ctx.桁数3))
	$ctx.request4:=String:C10(Form:C1466.value4; "0"*Num:C11($ctx.桁数4))
	
	$window:=Open form window:C675("Request_4_nums"; Sheet form window:K39:12)
	DELAY PROCESS:C323(Current process:C322; 10)
	DIALOG:C40("Request_4_nums"; $ctx)
	CLOSE WINDOW:C154($window)
	
	If (OK=1)
		
		$記載事項.value1:=Num:C11($ctx.request1)
		$記載事項.value2:=Num:C11($ctx.request2)
		$記載事項.value3:=Num:C11($ctx.request3)
		$記載事項.value4:=Num:C11($ctx.request4)
		
		Form:C1466.value1:=$記載事項.value1
		Form:C1466.value2:=$記載事項.value2
		Form:C1466.value3:=$記載事項.value3
		Form:C1466.value4:=$記載事項.value4
		
		$value1:=Form:C1466.文字列変換(String:C10(Form:C1466.value1; "0"*Num:C11($ctx.桁数1)); "半角->全角")
		$value2:=Form:C1466.文字列変換(String:C10(Form:C1466.value2; "0"*Num:C11($ctx.桁数2)); "半角->全角")
		$value3:=Form:C1466.文字列変換(String:C10(Form:C1466.value3; "0"*Num:C11($ctx.桁数3)); "半角->全角")
		$value4:=Form:C1466.文字列変換(String:C10(Form:C1466.value4; "0"*Num:C11($ctx.桁数4)); "半角->全角")
		
		$text:=Change string:C234($text; $value1; Num:C11($ctx.カラム位置1))
		$text:=Change string:C234($text; $value2; Num:C11($ctx.カラム位置2))
		$text:=Change string:C234($text; $value3; Num:C11($ctx.カラム位置3))
		$text:=Change string:C234($text; $value4; Num:C11($ctx.カラム位置4))
		
		$記載事項.comment:=$text+"；"+$記載事項.string
		
		Form:C1466.comment:=$記載事項.comment
		
		OBJECT SET ENTERABLE:C238(*; "コメント"; True:C214)
		GOTO OBJECT:C206(*; "コメント")
		
		HIGHLIGHT TEXT:C210(*; "コメント"; Length:C16($text)+2; Length:C16($text)+2)
		
	End if 
	
Function pattern_time_i($記載事項 : Object)
	
	$ctx:=New object:C1471
	$ctx.message:="数字のコメント"
	$ctx.OK:="OK"
	$ctx.cancel:="キャンセル"
	$ctx.match:="\\d{2}:\\d{2}"
	$ctx.filter:="&\"0-9\"##:##"
	$ctx.request:=String:C10(Form:C1466.time; HH MM:K7:2)
	
	$window:=Open form window:C675("Request"; Sheet form window:K39:12)
	DELAY PROCESS:C323(Current process:C322; 10)
	DIALOG:C40("Request"; $ctx)
	CLOSE WINDOW:C154($window)
	
	If (OK=1)
		
		$time:=Time string:C180($ctx.request)
		
		$hh:=Substring:C12($time; 1; 2)
		$mm:=Substring:C12($time; 4; 2)
		
		$hh:=Form:C1466.文字列変換($hh; "半角->全角")
		$mm:=Form:C1466.文字列変換($mm; "半角->全角")
		
		$time:=$hh+"時"+$mm+"分"
		$記載事項.comment:=$text+"；"+$time
		
		Form:C1466.comment:=$記載事項.comment
		Form:C1466.string:=$hh+$mm
		
	End if 
	
Function update()
	
	$記載事項等:=Form:C1466.記載事項等
	$記載事項:=$記載事項等.記載事項[Form:C1466.currentItem]
	
	Form:C1466.記載事項:=$記載事項
	
	Form:C1466.診療行為名称等:=$記載事項.診療行為名称等
	Form:C1466.項番:=$記載事項.項番
	Form:C1466.区分:=$記載事項.区分
	
	If ($記載事項.qualifier#Null:C1517)
		Form:C1466.条件:=$記載事項.qualifier+"場合"
	Else 
		Form:C1466.条件:=$記載事項.診療行為名称等
	End if 
	Form:C1466.指示:=$記載事項.message
	
	OBJECT GET COORDINATES:C663(*; "条件"; $left; $top; $right; $bottom)
	
	C_OBJECT:C1216($条件; $指示)
	OBJECT GET BEST SIZE:C717(*; "条件"; $width; $height; $right-$left)
	$条件:=New object:C1471("x"; $left; "y"; $top; "right"; $right; "bottom"; $top+$height)
	$top:=($top+$height)+10  //gap between the 2
	OBJECT GET BEST SIZE:C717(*; "指示"; $width; $height; $right-$left)
	$指示:=New object:C1471("x"; $left; "y"; $top; "right"; $right; "bottom"; $top+$height)
	
	OBJECT SET COORDINATES:C1248(*; "条件"; $条件.x; $条件.y; $条件.right; $条件.bottom)
	OBJECT SET COORDINATES:C1248(*; "指示"; $指示.x; $指示.y; $指示.right; $指示.bottom)
	
	OBJECT SET ENABLED:C1123(*; "<"; (Form:C1466.currentItem>0))
	OBJECT SET ENABLED:C1123(*; ">"; (Form:C1466.currentItem<Form:C1466.lastItem))
	
	$pCategory:=OBJECT Get pointer:C1124(Object named:K67:5; "category")
	ARRAY TEXT:C222($pCategory->; 0)
	$pCategory->:=0
	
	OBJECT SET ENABLED:C1123(*; "category"; False:C215)
	
	$ds:=ds記載事項等
	
	$messages:=$ds.メッセージ
	
	$項番:=Form:C1466.記載事項等.項番
	$removeMessage:=False:C215
	
	Case of 
		: ($記載事項.steps.length=0)
			
			//
			
		: ($記載事項.steps.length=1)  //1 category
			
			APPEND TO ARRAY:C911($pCategory->; "")
			$pCategory->:=1
			
		: ($記載事項.steps.length>1)  //several mandatory categories
			
			For each ($steps; $記載事項.steps)
				
				If ($steps.length#0)
					
					$step:=$steps[0]
					$コメントコード:=$step.コメントコード
					$pattern:=$コメントコード.パターン
					$コメント文:=$step.コメント文
					$text:=$コメント文.漢字名称
					
					ARRAY LONGINT:C221($pos; 0)
					ARRAY LONGINT:C221($len; 0)
					
					If (Match regex:C1019("([^；（]+)"; $text; 1; $pos; $len))
						$text:=Substring:C12($text; $pos{1}; $len{1})
					End if 
					
					APPEND TO ARRAY:C911($pCategory->; $text)
					$pCategory->:=1
					OBJECT SET ENABLED:C1123(*; "category"; True:C214)
					
				Else 
					
					If ($messages.indexOf($項番)#-1)
						//message line, ignore it
						$removeMessage:=True:C214
					End if 
					
				End if 
				
			End for each 
			
	End case 
	
	If ($removeMessage)
		$記載事項.steps.shift()
	End if 
	
	Form:C1466.update_list($記載事項; $pCategory->)
	
Function update_list($記載事項 : Object)
	
	$pList:=OBJECT Get pointer:C1124(Object named:K67:5; "list")
	ARRAY TEXT:C222($pList->; 0)
	$pList->:=0
	
	OBJECT SET ENABLED:C1123(*; "list"; False:C215)
	
	$idx:=$2
	
	If ($idx#0)
		
		$steps:=$記載事項.steps[$idx-1]
		
		Case of 
			: ($steps.length=1)
				
				APPEND TO ARRAY:C911($pList->; "")
				$pList->:=1
				
				Form:C1466.update_pattern($記載事項; $steps; $pList->)
				
			: ($steps.length>1)
				
				For each ($step; $steps)
					
					Case of 
						: ($step.コメントコード#Null:C1517)
							
							$コメントコード:=$step.コメントコード
							$コメント文:=$step.コメント文
							$text:=$コメント文.漢字名称
							
							
							APPEND TO ARRAY:C911($pList->; $text)
							$pList->:=1
							OBJECT SET ENABLED:C1123(*; "list"; True:C214)
							
						: ($step.診療行為コード#Null:C1517)
							$text:=$step.診療行為省略名称.省略漢字名称
							APPEND TO ARRAY:C911($pList->; $text)
							$pList->:=1
							OBJECT SET ENABLED:C1123(*; "list"; True:C214)
					End case 
					
				End for each 
				
				Form:C1466.update_pattern($記載事項; $steps; $pList->)
				
			: ($steps.length=0)
				
				APPEND TO ARRAY:C911($pList->; "")
				$pList->:=1
				
				Form:C1466.update_pattern($記載事項; $steps; $pList->)
				
		End case 
		
	End if 
	
Function update_pattern($記載事項 : Object; $steps : Collection; $idx : Integer)
	
	Form:C1466.comment:=""
	OBJECT SET ENABLED:C1123(*; "登録"; False:C215)
	OBJECT SET ENABLED:C1123(*; "コメント"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "コメント"; False:C215)
	
	Form:C1466.pattern_set()
	
	$項番:=Form:C1466.記載事項等.項番
	
	$ds:=ds記載事項等
	
	//$freeComments:=$ds.フリー
	//$dateComments:=$ds.検査の実施日
	//$dateComments2:=$ds.算定日
	
	If ($steps.length=0)
		
		//Case of 
		//: ($freeComments.indexOf($項番)#-1)
		
		//$step:=Form.フリーコメント
		//$コメントコード:=$step.コメントコード
		//$pattern:=$コメントコード.パターン
		//$コメント文:=$step.コメント文
		//$text:=$コメント文.漢字名称
		
		//Form.厚労省マスター:="810000001"
		
		//Form.pattern_free($記載事項; $text)
		
		//Form.pattern_set($pattern)
		
		//: ($dateComments.indexOf($項番)#-1)
		
		//$pattern:="50"
		//$text:="検査の実施日"
		
		//Form.厚労省マスター:="810000001"
		
		//Form.pattern_date($記載事項; $text)
		
		//Form.pattern_set($pattern)
		
		//: ($dateComments2.indexOf($項番)#-1)
		
		//$pattern:="50"
		//$text:="算定日"
		
		//Form.厚労省マスター:="810000001"
		
		//Form.pattern_date($記載事項; $text)
		
		//Form.pattern_set($pattern)
		
		//Else 
		
		Form:C1466.厚労省マスター:=""  //メッセージを表示するだけ
		
		//End case 
		
	Else 
		
		$step:=$steps[$idx-1]
		
		Form:C1466.診療行為:=New collection:C1472
		
		Case of 
			: ($step.コメントコード#Null:C1517)
				
				$コメントコード:=$step.コメントコード
				$pattern:=$コメントコード.パターン
				$コメント文:=$step.コメント文
				$text:=$コメント文.漢字名称
				
				Form:C1466.厚労省マスター:=$コメントコード.区分+$コメントコード.パターン+String:C10(Num:C11($コメントコード.番号); "000000")
				
				Form:C1466.pattern_set($pattern)
				
				Case of 
					: ($pattern="10")
						
						Form:C1466.pattern_free($記載事項; $text)
						
					: ($pattern="20")
						
						Form:C1466.pattern_fixed($記載事項; $text)
						
					: ($pattern="30")
						
						Form:C1466.pattern_append($記載事項; $text)
						
					: ($pattern="31")
						
						Form:C1466.pattern_code($記載事項; $text)
						
					: ($pattern="40")
						
						Form:C1466.pattern_num($記載事項; $text)
						
					: ($pattern="42")
						
						Form:C1466.pattern_num_append($記載事項; $text)
						
					: ($pattern="50")
						
						Form:C1466.pattern_date($記載事項; $text)
						
					: ($pattern="51")
						
						Form:C1466.pattern_time($記載事項; $text)
						
					: ($pattern="52")
						
						Form:C1466.pattern_duration($記載事項; $text)
						
					: ($pattern="90")
						
						Form:C1466.pattern_part($記載事項; $text)
						
				End case 
				
			: ($step.診療行為コード#Null:C1517)
				
				Form:C1466.診療行為.push($step)
				Form:C1466.厚労省マスター:=$step.診療行為コード
				
		End case 
		
	End if 
	
	Form:C1466.comment:=$記載事項.comment
	
	If (Form:C1466.厚労省マスター="")
		OBJECT SET ENABLED:C1123(*; "登録"; False:C215)
	Else 
		OBJECT SET ENABLED:C1123(*; "登録"; True:C214)
	End if 
	
Function pattern_get()->$pattern : Text
	
	$pattern:=Form:C1466.pattern
	
Function pattern_set()
	
	C_TEXT:C284($1; $pattern)
	
	If (Count parameters:C259#0)
		
		$pattern:=$1
		
	End if 
	
	Form:C1466.pattern:=$pattern
	
	OBJECT SET RGB COLORS:C628(*; "p.@"; "#cccccc")
	
	If ($pattern#"")
		
		OBJECT SET RGB COLORS:C628(*; "p."+$pattern; selected_fill_dark_red)
		
	End if 
	
Function pattern_free($記載事項 : Object; $text : Text)
	
	Form:C1466.string:=$記載事項.comment
	
	OBJECT SET ENTERABLE:C238(*; "コメント"; True:C214)
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	GOTO OBJECT:C206(*; "コメント")
	
Function pattern_date($記載事項 : Object; $text : Text)
	
	C_TEXT:C284($wareki)
	C_LONGINT:C283($era; $year; $month; $day)
	$wareki:=ERA_Convert_from_date($記載事項.date; ->$era; ->$year; ->$month; ->$day)
	$記載事項.comment:=$text+"；"+$wareki
	$記載事項.dateString:=String:C10($era; "00")+String:C10($year; "00")+String:C10($month; "00")+String:C10($day; "00")
	
	Form:C1466.string:=$記載事項.dateString
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function pattern_fixed($記載事項 : Object; $text : Text)
	
	$記載事項.comment:=$text
	Form:C1466.string:=$記載事項.string
	
Function pattern_append($記載事項 : Object; $text : Text)
	
	$記載事項.comment:=$text
	Form:C1466.string:=$記載事項.string
	
	OBJECT SET ENTERABLE:C238(*; "コメント"; True:C214)
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	GOTO OBJECT:C206(*; "コメント")
	
	HIGHLIGHT TEXT:C210(*; "コメント"; Length:C16($text)+1; Length:C16($記載事項.comment)+1)
	
Function pattern_code($記載事項 : Object; $text : Text)
	
	$記載事項.comment:=$text
	Form:C1466.string:=$記載事項.string
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function pattern_num($記載事項 : Object; $text : Text)
	
	$記載事項.comment:=$text+"；"+$記載事項.string
	
	Form:C1466.string:=$記載事項.comment
	
	Form:C1466.value1:=$記載事項.value1
	Form:C1466.value2:=$記載事項.value2
	Form:C1466.value3:=$記載事項.value3
	Form:C1466.value4:=$記載事項.value4
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function pattern_num_append($記載事項 : Object; $text : Text)
	
	$記載事項.comment:=$text+"；"+$記載事項.string
	
	Form:C1466.string:=$記載事項.comment
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function pattern_time($記載事項 : Object; $text : Text)
	
	$time:=Time string:C180($記載事項.time)
	
	$hh:=Substring:C12($time; 1; 2)
	$mm:=Substring:C12($time; 4; 2)
	
	$hh:=Form:C1466.文字列変換($hh; "半角->全角")
	$mm:=Form:C1466.文字列変換($mm; "半角->全角")
	
	$time:=$hh+"時"+$mm+"分"
	$記載事項.comment:=$text+"；"+$time
	
	Form:C1466.string:=$hh+$mm
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function pattern_duration($記載事項 : Object; $text : Text)
	
	$value:="00000"+String:C10($記載事項.value)
	$value:=Substring:C12($value; Length:C16($value)-4)
	
	$value:=Form:C1466.文字列変換($value; "半角->全角")
	Form:C1466.string:=$value
	
	$value:=Form:C1466.文字列変換(String:C10($記載事項.value); "半角->全角")+"分"
	
	$記載事項.comment:=$text+"；"+$value
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function pattern_part($記載事項 : Object; $text : Text)
	
	$記載事項.comment:=$text
	Form:C1466.string:=$記載事項.string
	
	OBJECT SET ENABLED:C1123(*; "コメント"; True:C214)
	
Function 完全一致($in : Text; $in2 : Text)->$完全一致 : Boolean
	
	$完全一致:=False:C215
	
	If (Length:C16($in)=Length:C16($in2))
		$完全一致:=(Position:C15($in; $in2; *)=1)
	End if 
	
Function 文字列変換($in : Text; $rule : Text)->$out : Text
	
	Case of 
		: (Form:C1466.完全一致($rule; "かな->英数,全角->半角"))
			
			$error:=ICU Transform text("-Latin;Fullwidth-Halfwidth"; ""; ICU Transform Forward; $in; $out)
			$out:=Replace string:C233($out; "'"; "")
			
		: (Form:C1466.完全一致($rule; "かな->カナ,全角->半角"))
			
			$error:=ICU Transform text("Hiragana-Katakana;Fullwidth-Halfwidth"; ""; ICU Transform Forward; $in; $out)
			
		: (Form:C1466.完全一致($rule; "半角->全角,かな->カナ"))
			
			$error:=ICU Transform text("Halfwidth-Fullwidth;Hiragana-Katakana"; ""; ICU Transform Forward; $in; $out)
			
		: (Form:C1466.完全一致($rule; "全角->半角"))
			
			$error:=ICU Transform text("Fullwidth-Halfwidth"; ""; ICU Transform Forward; $in; $out)
			
		: (Form:C1466.完全一致($rule; "半角->全角"))
			
			$error:=ICU Transform text("Halfwidth-Fullwidth"; ""; ICU Transform Forward; $in; $out)
			
		: (Form:C1466.完全一致($rule; "全角->半角,数字"))
			
			$error:=ICU Transform text(""; "[:^Number:] > ; # 数字だけを抜き取るぞ"; ICU Transform Forward; $in; $out)
			$in2:=$out
			$error:=ICU Transform text("Fullwidth-Halfwidth"; ""; ICU Transform Forward; $in2; $out)
			
	End case 
	