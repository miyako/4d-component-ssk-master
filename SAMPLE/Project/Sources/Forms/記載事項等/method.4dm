$event:=Form event code:C388

Case of 
	: ($event=On Load:K2:1)
		
		$記載事項等:=Form:C1466.記載事項等
		
		Form:C1466.厚労省マスター:=""
		Form:C1466.currentItem:=0
		Form:C1466.lastItem:=$記載事項等.記載事項.length-1
		
		$buttonTop:=Form:C1466.buttonTop
		
		OBJECT GET COORDINATES:C663(*; "category"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "category"; $left; $buttonTop; $right; $buttonTop+21)
		
		$buttonTop:=$buttonTop+21+5
		
		OBJECT GET COORDINATES:C663(*; "list"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "list"; $left; $buttonTop; $right; $buttonTop+21)
		
		$buttonTop:=$buttonTop+21+7
		
		OBJECT GET COORDINATES:C663(*; "コメント"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "コメント"; $left; $buttonTop; $right; $buttonTop+17)
		
		$buttonTop:=$buttonTop+17+5
		
		OBJECT GET COORDINATES:C663(*; "厚労省マスター"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "厚労省マスター"; $left; $buttonTop; $right; $buttonTop+17)
		
		OBJECT GET COORDINATES:C663(*; "p.10"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.10"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.20"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.20"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.30"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.30"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.31"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.31"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.40"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.40"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.42"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.42"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.50"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.50"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.51"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.51"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.52"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.52"; $left; $buttonTop; $right; $buttonTop+17)
		OBJECT GET COORDINATES:C663(*; "p.90"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "p.90"; $left; $buttonTop; $right; $buttonTop+17)
		
		$buttonTop:=$buttonTop+17+10
		
		OBJECT GET COORDINATES:C663(*; "<"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "<"; $left; $buttonTop; $right; $buttonTop+22)
		OBJECT GET COORDINATES:C663(*; ">"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; ">"; $left; $buttonTop; $right; $buttonTop+22)
		OBJECT GET COORDINATES:C663(*; "キャンセル"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "キャンセル"; $left; $buttonTop; $right; $buttonTop+22)
		OBJECT GET COORDINATES:C663(*; "登録"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "登録"; $left; $buttonTop; $right; $buttonTop+22)
		
		FORM SET VERTICAL RESIZING:C893(True:C214; $buttonTop+22+7)
		
		Form:C1466.update()
		
	: ($event=On Close Box:K2:21)
		
		CANCEL:C270
		
	: ($event=On Unload:K2:2)
		
		
End case 