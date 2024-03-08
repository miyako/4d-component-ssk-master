$event:=Form event code:C388

Case of 
	: ($event=On Data Change:K2:15)
		
		Form:C1466.記載事項:=Form:C1466.記載事項等.記載事項[Form:C1466.currentItem]
		
		$記載事項:=Form:C1466.記載事項
		
		$pCategory:=OBJECT Get pointer:C1124(Object named:K67:5; "category")
		$pList:=OBJECT Get pointer:C1124(Object named:K67:5; "list")
		
		$x:=($pCategory->)-1
		$y:=($pList->)-1
		
		If ($記載事項.steps[$x].length=0)
			
			//empty
			
		Else 
			
			$step:=$記載事項.steps[$x][$y]
			
			$コメントコード:=$step.コメントコード
			$pattern:=$コメントコード.パターン
			$コメント文:=$step.コメント文
			$text:=$コメント文.漢字名称
			
			Case of 
				: ($pattern="30")
					
					$記載事項.string:=Substring:C12(Form:C1466.comment; Length:C16($text)+1)
					Form:C1466.string:=$記載事項.string
					
			End case 
			
		End if 
		
	: ($event=On Clicked:K2:4)
		If (OBJECT Get enterable:C1067(*; OBJECT Get name:C1087)=False:C215)
			
			Form:C1466.記載事項:=Form:C1466.記載事項等.記載事項[Form:C1466.currentItem]
			
			$記載事項:=Form:C1466.記載事項
			
			$pattern:=Form:C1466.pattern_get()
			
			C_OBJECT:C1216($step)
			
			$pCategory:=OBJECT Get pointer:C1124(Object named:K67:5; "category")
			$pList:=OBJECT Get pointer:C1124(Object named:K67:5; "list")
			
			$x:=($pCategory->)-1
			$y:=($pList->)-1
			
			If ($記載事項.steps[$x].length=0)
				
				//empty
				
			Else 
				
				$step:=$記載事項.steps[$x][$y]
				
			End if 
			
			Case of 
				: ($pattern="10")
					//enterable
				: ($pattern="20")
					//fixed
				: ($pattern="30")
					//enterable
				: ($pattern="31")
					
/*
コメントコードに設定しているコメント文の後に、
保険医療機関が記録した診療行為コード(医科)の省略漢字名称を付加して出力紙レセプト等に出力する
*/
					
				: ($pattern="40")
					
					If ($step#Null:C1517)
						Form:C1466.pattern_num_i($記載事項; $step)
					End if 
					
				: ($pattern="42")
					
					Form:C1466.pattern_num_append_i($記載事項)
					
				: ($pattern="50")
					
					Form:C1466.pattern_date_i($記載事項)
					
				: ($pattern="51")
					
					Form:C1466.pattern_time_i($記載事項)
					
				: ($pattern="52")
					
					Form:C1466.pattern_duration_i($記載事項)
					
				: ($pattern="90")
					
/*
保険医療機関等が記録した修飾語マスターに収載する修飾語コード(複数記録可)を、
翻訳して出力紙レセプト等に出力する
*/
					
			End case 
			
		End if 
		
End case 