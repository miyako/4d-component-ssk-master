社会保険診療報酬支払基金マスター

# 概要

GitHub Actionsと`tool4d`を活用し，マスターファイルを更新したら自動的にコンポーネントを再生成します。

```4d
var $rezept : cs.ssk.Rezept
$rezept:=cs.ssk.Rezept.new()
```

### .{master}.query()

```4d
$診療行為:=$rezept.診療行為.query("基本漢字名称 == :1"; "@術中術後自己血回収術@")
$医薬品:=$rezept.医薬品.query("後発品.項目.同一剤形・規格の後発医薬品がある先発医薬品 == :1"; "○")
```

対象マスター: `コメント` `医薬品` `修飾語` `傷病名` `診療行為` `地方公費` `特定器材`

**注記**: 医薬品は「処方箋に記載する一般名処方の標準的な記載」および「薬価基準収載品目リスト及び後発医薬品に関する情報」のデータをそれぞれ`.一般名` `.後発品`で参照できます。

2024年3月5日の医薬品マスター（新レイアウト）は，令和6年度薬価改定及び診療報酬改定DX(医薬品マスターの拡充)に伴う項目が拡充されていますが，値が空です。`.項目.薬価基準収載年月日` `.一般名処方マスタ.一般名コード` `.一般名処方マスタ.一般名処方の標準的な記載` `.一般名処方マスタ.一般名処方加算対象区分` `.項目.抗HIV薬区分`は，マスター更新後に利用できます。

### .get("{master}";"{code}")

```4d
$診療行為:=$rezept.get("診療行為"; "150405210")
$医薬品:=$rezept.get("医薬品"; "610406079")
```

# [基本マスター](https://www.ssk.or.jp/seikyushiharai/tensuhyo/kihonmasta/index.html)

|ファイル|更新日|ファイル名|
|:-|:-|:-|
|厚生労働省<br />医療保険が適用される医薬品について<br />処方箋に記載する一般名処方の標準的な記載|2024年3月5日|ippanmeishohoumaster_______.xlsx|
|厚生労働省<br />医療保険が適用される医薬品について<br />薬価基準収載品目リスト及び後発医薬品に関する情報|2024年3月5日|tp________-01_01.xlsx<br />tp________-01_02.xlsx<br />tp________-01_03.xlsx|
|医薬品|2024年3月5日|y_ALL________.zip|
|医科診療行為|2024年3月6日|s_ALL________.zip|
|労災診療行為|2022年11月4日|ファイル名: rezept-master-01.csv|
|特定器材|2024年3月5日|t_ALL________.zip|
|労災特定器材|2021年1月29日|ファイル名: rezept-master-03.csv|
|コメント|2023年8月1日|c_ALL________.zip|
|労災コメント|2020年4月15日|ファイル名: rezept-master-06.csv|
|傷病名|2023年12月22日|b_ALL________.zip|
|修飾語|2023年12月22日|z_ALL________.zip|
|歯科診療行為||未対応|
|調剤行為||未対応|
|歯式||未対応|
|訪問看護療養費||未対応|

* 社会保険診療報酬支払基金のマスターは.zipのままインポートできます。テキストファイルでも構いません。なお，`修飾語` `傷病名`のマスターは拡張子が.txt，その他は.csvです。
* `薬価基準収載品目リスト及び後発医薬品に関する情報` `処方箋に記載する一般名処方の標準的な記載`は.xlsxのままインポートできます。

* [厚生労働省のマスター](https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/roudoukijun/rousai/rezeptsystem/index.html)は上記のとおりファイル名を変更してください。

* ローカルで実行する場合

```
tool4d.app/Contents/MacOS/tool4d \
 --project=rezept/Project/rezept.4DProject \
 --startup-method=regenerate \
 --skip-onstartup \
 --user-param="verbose,regenereate,export" \
 --create-data
```

GitHub Actionsで自動的にデータを生成する場合は`verbose`を省略してください。

# 記載事項等

`別表Ⅰ 診療報酬明細書の「摘要」欄への記載事項等一覧 （医科）`に階層情報を付与した.xlsx形式をインポートして基本マスターと関連づけたオブジェクトです。

# 公費

```4d
Form.parser:=cs.ssk.Rezept.new().公費()
```
`/DATA/地方公費/`フォルダーのエクセルファイルをインポートしたオブジェクトです。検証番号をチェックし，制度の詳細を返します。

<img src="https://github.com/miyako/4d-component-ssk-master/assets/1725068/086b25b8-084a-450a-8d7c-6ea2ceb06de7" style="height:120px;width:auto" />

```json
[
	{
		"年齢開始": 0,
		"年齢終了": 999,
		"点数単価": 10,
		"短縮制度名": "自立支援",
		"所得情報": "本人",
		"レセプト請求区分": 3,
		"レセプト請求": "印刷しない",
		"保険公費種別区分": 7,
		"保険公費種別": "一般公費",
		"外来負担区分": 1,
		"外来負担": "患者負担あり",
		"薬剤負担区分": 0,
		"薬剤負担": "使用しない",
		"レセプト負担金額区分": 2,
		"レセプト負担金額": "10円未満を四捨五入しない",
		"レセプト記載区分": 0,
		"レセプト記載": "",
		"外来": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 10,
			"1月院外上限額": 0,
			"1月院内上限額": 0,
			"1月上限回数": 2,
			"1日上限回数": 0,
			"1日上限額": 600
		},
		"入院": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 10,
			"1月上限回数": 0,
			"1月上限額": 2400,
			"1日上限回数": 0,
			"1日上限額": 0,
			"1日食事助成額": 0
		},
		"限定公費": [
			{
				"法別番号": "21",
				"区分": "障害者自立支援法による精神通院医療",
				"制度の略称": "精神通院"
			},
			{
				"法別番号": "15",
				"区分": "障害者自立支援法による更生医療"
			},
			{
				"法別番号": "16",
				"区分": "障害者自立支援法による育成医療"
			}
		],
		"限定地方公費": []
	},
	{
		"年齢開始": 0,
		"年齢終了": 999,
		"点数単価": 10,
		"短縮制度名": "自立支援",
		"所得情報": "低所得",
		"レセプト請求区分": 3,
		"レセプト請求": "印刷しない",
		"保険公費種別区分": 7,
		"保険公費種別": "一般公費",
		"外来負担区分": 1,
		"外来負担": "患者負担あり",
		"薬剤負担区分": 0,
		"薬剤負担": "使用しない",
		"レセプト負担金額区分": 2,
		"レセプト負担金額": "10円未満を四捨五入しない",
		"レセプト記載区分": 0,
		"レセプト記載": "",
		"外来": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 10,
			"1月院外上限額": 0,
			"1月院内上限額": 0,
			"1月上限回数": 2,
			"1日上限回数": 0,
			"1日上限額": 600
		},
		"入院": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 10,
			"1月上限回数": 0,
			"1月上限額": 2400,
			"1日上限回数": 0,
			"1日上限額": 0,
			"1日食事助成額": 0
		},
		"限定公費": [],
		"限定地方公費": []
	},
	{
		"年齢開始": 0,
		"年齢終了": 999,
		"点数単価": 10,
		"短縮制度名": "自立支援",
		"所得情報": "低年金",
		"レセプト請求区分": 3,
		"レセプト請求": "印刷しない",
		"保険公費種別区分": 7,
		"保険公費種別": "一般公費",
		"外来負担区分": 1,
		"外来負担": "患者負担あり",
		"薬剤負担区分": 0,
		"薬剤負担": "使用しない",
		"レセプト負担金額区分": 2,
		"レセプト負担金額": "10円未満を四捨五入しない",
		"レセプト記載区分": 0,
		"レセプト記載": "",
		"外来": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 10,
			"1月院外上限額": 0,
			"1月院内上限額": 0,
			"1月上限回数": 2,
			"1日上限回数": 0,
			"1日上限額": 600
		},
		"入院": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 10,
			"1月上限回数": 0,
			"1月上限額": 1600,
			"1日上限回数": 0,
			"1日上限額": 0,
			"1日食事助成額": 0
		},
		"限定公費": [],
		"限定地方公費": []
	},
	{
		"年齢開始": 0,
		"年齢終了": 999,
		"点数単価": 10,
		"短縮制度名": "重度障害",
		"所得情報": "",
		"レセプト請求区分": 3,
		"レセプト請求": "印刷しない",
		"保険公費種別区分": 7,
		"保険公費種別": "一般公費",
		"外来負担区分": 2,
		"外来負担": "患者負担なし",
		"薬剤負担区分": 0,
		"薬剤負担": "使用しない",
		"レセプト負担金額区分": 1,
		"レセプト負担金額": "10円未満を四捨五入する",
		"レセプト記載区分": 0,
		"レセプト記載": "",
		"外来": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 0,
			"1月院外上限額": 0,
			"1月院内上限額": 0,
			"1月上限回数": 0,
			"1日上限回数": 0,
			"1日上限額": 0
		},
		"入院": {
			"1回固定額": 0,
			"1回上限額": 0,
			"1回負担割合": 0,
			"1月上限回数": 0,
			"1月上限額": 0,
			"1日上限回数": 0,
			"1日上限額": 0,
			"1日食事助成額": 0
		},
		"限定公費": [
			{
				"法別番号": "21",
				"区分": "障害者自立支援法による精神通院医療",
				"制度の略称": "精神通院"
			},
			{
				"法別番号": "15",
				"区分": "障害者自立支援法による更生医療"
			},
			{
				"法別番号": "16",
				"区分": "障害者自立支援法による育成医療"
			}
		],
		"限定地方公費": []
	}
]
```
