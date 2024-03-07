社会保険診療報酬支払基金マスター

# 概要

GitHub Actionsと`tool4d`を活用し，マスターファイルを更新したら自動的にコンポーネントを再生成します。コンポーネントなので，データファイルはありません。代わりに共有オブジェクト（シングルトン）をファイルとしてエクスポートし，初回の参照でインポートします。

# [基本マスター](https://www.ssk.or.jp/seikyushiharai/tensuhyo/kihonmasta/index.html)

|ファイル|更新日|注記|
|:-|:-|:-|
|医科診療行為|2024年3月6日||
|労災診療行為|2022年11月4日|ファイル名: rezept-master-01.csv|
|医薬品|2024年3月5日||
|特定器材|2024年3月5日||
|労災特定器材|2021年1月29日|ファイル名: rezept-master-03.csv|
|コメント|2023年8月1日||
|労災コメント|2020年4月15日|ファイル名: rezept-master-06.csv|
|傷病名|2023年12月22日||
|修飾語|2023年12月22日||
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
