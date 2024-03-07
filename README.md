社会保険診療報酬支払基金マスター

# 概要

GitHub Actionsと`tool4d`を活用し，マスターファイルを更新したら自動的にコンポーネントを再生成します。コンポーネントなので，データファイルはありません。代わりに共有オブジェクト（シングルトン）をファイルとしてエクスポートし，初回の参照でインポートします。

```4d
var $rezept : cs.ssk.Rezept
$rezept:=cs.ssk.Rezept.new()
```

* クエリ例

```4d
$診療行為:=$rezept.診療行為.query("基本漢字名称 == :1"; "@術中術後自己血回収術@")
$医薬品:=$rezept.医薬品.query("後発品.項目.同一剤形・規格の後発医薬品がある先発医薬品 == :1"; "○")
```

対象コレクション：`コメント` `医薬品` `修飾語` `傷病名` `診療行為` `地方公費` `特定器材`

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
