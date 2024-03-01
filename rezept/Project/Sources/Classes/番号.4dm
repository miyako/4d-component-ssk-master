Class constructor
	
	
	
Function _都道府県($code : Text)->$name : Text
	
	Case of 
		: ($code="01")
			$name:="北海道"
		: ($code="02")
			$name:="青森"
		: ($code="03")
			$name:="岩手"
		: ($code="04")
			$name:="宮城"
		: ($code="05")
			$name:="秋田"
		: ($code="06")
			$name:="山形"
		: ($code="07")
			$name:="福島"
		: ($code="08")
			$name:="茨城"
		: ($code="09")
			$name:="栃木"
		: ($code="10")
			$name:="群馬"
		: ($code="11")
			$name:="埼玉"
		: ($code="12")
			$name:="千葉"
		: ($code="13")
			$name:="東京"
		: ($code="14")
			$name:="神奈川"
		: ($code="15")
			$name:="新潟"
		: ($code="16")
			$name:="富山"
		: ($code="17")
			$name:="石川"
		: ($code="18")
			$name:="福井"
		: ($code="19")
			$name:="山梨"
		: ($code="20")
			$name:="長野"
		: ($code="21")
			$name:="岐阜"
		: ($code="22")
			$name:="静岡"
		: ($code="23")
			$name:="愛知"
		: ($code="24")
			$name:="三重"
		: ($code="25")
			$name:="滋賀"
		: ($code="26")
			$name:="京都"
		: ($code="27")
			$name:="大阪"
		: ($code="28")
			$name:="兵庫"
		: ($code="29")
			$name:="奈良"
		: ($code="30")
			$name:="和歌山"
		: ($code="31")
			$name:="鳥取"
		: ($code="32")
			$name:="島根"
		: ($code="33")
			$name:="岡山"
		: ($code="34")
			$name:="広島"
		: ($code="35")
			$name:="山口"
		: ($code="36")
			$name:="徳島"
		: ($code="37")
			$name:="香川"
		: ($code="38")
			$name:="愛媛"
		: ($code="39")
			$name:="高知"
		: ($code="40")
			$name:="福岡"
		: ($code="41")
			$name:="佐賀"
		: ($code="42")
			$name:="長崎"
		: ($code="43")
			$name:="熊本"
		: ($code="44")
			$name:="大分"
		: ($code="45")
			$name:="宮崎"
		: ($code="46")
			$name:="鹿児島"
		: ($code="47")
			$name:="沖縄"
	End case 
	
Function _検証番号($code : Text)->$status : Object
	
	$status:=New object:C1471("match"; False:C215)
	
	$digits:=Split string:C1554($code; ""; sk trim spaces:K86:2 | sk ignore empty strings:K86:1).reverse()
	
	If ($digits.length>2)
		
		$status.digit:=$digits.shift()
		
		$multiplier:=2
		
		$values:=New collection:C1472
		
		For each ($digit; $digits)
			
			$value:=Num:C11($digit)*$multiplier
			
			If ($value>9)
				$value:=1+($value-10)
			End if 
			
			$values.push($value)
			$multiplier:=Choose:C955($multiplier=2; 1; 2)
		End for each 
		
		$value:=$values.sum()
		
		$mod:=($value%10)
		
		If ($mod=0)
			$status.value:="0"
		Else 
			$status.value:=String:C10(10-$mod)
		End if 
		
		$status.match:=($status.digit=$status.value)
		
	End if 
	
Function _半角数字($code : Text)->$半角数字 : Text
	
	For ($i; 1; Length:C16($code))
		
		$char:=Character code:C91(Substring:C12($code; $i; 1))
		
		Case of 
			: ($char=0xFF10)
				$半角数字:=$半角数字+"0"
			: ($char=0xFF11)
				$半角数字:=$半角数字+"1"
			: ($char=0xFF12)
				$半角数字:=$半角数字+"2"
			: ($char=0xFF13)
				$半角数字:=$半角数字+"3"
			: ($char=0xFF14)
				$半角数字:=$半角数字+"4"
			: ($char=0xFF15)
				$半角数字:=$半角数字+"5"
			: ($char=0xFF16)
				$半角数字:=$半角数字+"6"
			: ($char=0xFF17)
				$半角数字:=$半角数字+"7"
			: ($char=0xFF18)
				$半角数字:=$半角数字+"8"
			: ($char=0xFF19)
				$半角数字:=$半角数字+"9"
			: ($char=0xFF0E)
				$半角数字:=$半角数字+"."
			Else 
				$半角数字:=$半角数字+String:C10(Num:C11(Substring:C12($code; $i; 1)))
		End case 
		
	End for 
	
	