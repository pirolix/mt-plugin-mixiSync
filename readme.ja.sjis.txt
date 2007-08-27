mixiSync 1.41
========================================================================
	mixiSync plugin for MovableType w/ BigPAPI
			Original Copyright (c) 2006 Piroli YUKARINOMIYA
			Open MagicVox.net - http://www.magicvox.net/
			@see http://www.magicvox.net/archive/2006/02041724.php
========================================================================

■ 動作環境
	MovableType 3.2ja2 以上、あるいは MovableType 3.16 以上
	かつ別途、BigPAPI 1.04 以上が正しく導入されていること
	または MovableType 3.3 以上
	perl 5.0x 以上

	note: BigPAPI - http://www.staggernation.com/mtplugins/BigPAPI/

	製作には MovableType3.2ja2 + Windows 2000 + Firefox 1.5 or IE 6.0 を使用
	MovableType3.31でも動作確認 


■ 導入方法

1.パッケージに含まれるファイルを MovableType の plugins にコピーします

2.プラグイン一覧に mixiSync プラグインが追加されていることを確認します

3."投稿者"リンクを開き、ユーザ毎にプラグインの初期設定を行います

	ユーザのプロフィール画面に新しく mixi の設定項目が追加されています

	a. mixi ユーザ ID 番号をあなたのユーザ ID に書き換えます

	note:	ユーザ ID 番号 は mixi の"プロフィール"ページに書いてあります
	note:	http://mixi.jp/show_friend.pl?id=XXXXXX の数字部分です

	b. mixi プレミアムユーザ登録をされている方は、チェックボックスをチェックします

5.エントリの編集画面の "保存" ボタンの隣に "mixi 新規投稿" ボタンが追加されています

	note:	Step.3 の初期設定を行わないとボタンが表示されません


■ 使い方

1.MovableType の編集画面で記事の編集作業を行います

2.編集が終わったら"mixi 新規投稿"ボタンを押します

3.mixi 日記の編集ページ(日記を書く)が新しいウィンドゥで開きます

	note:	mixi には事前にログインしておいてください
	note:	ログインしていない場合はログイン画面が表示されます

4.修正を加えたり、写真を追加でアップロードした後、"確認画面"ボタンを押します

5.内容を確認して"作成"ボタンを押します

	note:	このあたりは全く mixi 日記の使い方の通りです


■ 投稿フォーマットのカスタマイズについて
	mixiSync は標準で、MovableType の各エリアを mixi 日記の各フォームに割り当てます。
	
		MovableType：タイトル → mixi 日記：タイトル
		MovableType：エントリーの内容 (body) → mixi 日記：本文

	人によってはタイトルに飾り文字を入れたり、日記本文に追記 (more)の内容も含めるなど、
	mixi 日記の編集画面に流し込まれるフォーマットをカスタマイズすることができます。

1.MovableType の管理画面から[テンプレート]-[モジュール]と辿り、
　"mixiSync Entry Template" という名前でモジュールテンプレートを新規作成します

2.作成したモジュールテンプレートに編集画面のフォーマットを以下の様式で書き込みます

	diary_title : "<MTEntryTitle> 【本家ブログより】",
	diary_body : "<MTEntryBody>\n--------\n続きは<MTBlogName>で！\n<MTEntryPermalink>",

	モジュールテンプレートで使用できるタグは以下の通りです。

	<MTEntryTitle>
			MovableType 編集画面の"タイトル"です。

	<MTEntryBody>
			MovableType 編集画面の"本文(body)"です。

	<MTEntryMore>
			MovableType 編集画面の"追記(more)"です。

	<MTEntryExcerpt>
			MovableType 編集画面の"概要(excerpt)"です。

	<MTEntryKeywords>
			MovableType 編集画面の"キーワード"です。

	<MTBlogName>
			MovableType ブログの名前になります。

	<MTBlogURL>
			MovableType ブログのトップページ URL になります。

	<MTEntryPermalink>
		記事がパーマリンクを持つ場合、記事へのパーマリンクになります。
		記事が公開されていないなどの理由でパーマリンクを持たない場合、ブログURLと同じです。

	\n または <br>
			改行文字に変換されます。

	note:	MovableType のテンプレートタグに似せていますが、全くの別物です。
			そのため MovableType のフィルタやオプション指定はできません。

	note:	モジュールテンプレートの内容は JavaScript コードの一部として解釈されます。
			半角文字に注意し、特殊文字などはエスケープする必要があります。
			詳細な説明は適当な JavaScript の解説ページを参照してください。


■ MovableType 記事中の HTML タグの扱い　(New! v1.10-)
	mixiSync は mixi 日記に記事内容をコピーする時に、記事中の HTML タグを修正します。

	プレミアム会員の場合
		<br>, <p> は改行文字に置き換えられます
		<hr> は ---------------------------------------- に置き換えられます
		使用できる HTML タグは以下の通りです。これら以外の HTML タグは削除されます
			a,strong,em,u,blockquote,del

	非プレミアム会員の場合
		<br>, <p> は改行文字に置き換えられます
		<hr> は ---------------------------------------- に置き換えられます
		<a href="http://www.yahoo.co.jp/">Yahoo!</a> は Yahoo!(http://www.yahoo.co.jp/) に置き換えられます
		他の HTML タグは全て削除されます


■ 使用許諾条件
	このソフトウェアパッケージの内容については完全に無保証です。
	このソフトウェアパッケージの配布や改変に関する条件は
	The Artistic License (http://www.opensource.jp/artistic/ja/Artistic-ja.html)
	に準じるものとし、これに従う限り自由にすることができます。

	This code is released under the Artistic License.
	The terms of the Artistic License are described at
	http://www.perl.com/language/misc/Artistic.html


■ 謝辞
	Realtime Preview プラグインの作成にあたっては次のページを参考にさせて頂きました。
		BigPAPI (c)Kevin Shay
			http://www.staggernation.com/mtplugins/BigPAPI/

	このプラグイン作成のきっかけを下さった Dakiny さんの一言に感謝します(笑

	バグ報告や要望を頂いたユーザの皆様、そして貴方。


■ 舞台裏な話

0.XSSにやられる
	開発中のバージョンはもっとJavaScriptの比率が高かったんですが、
	大体できたところでCrossSiteScriptingの罠に引っかかって作り直す羽目に！

1.mixi からの刺客!?　<input name="submit" value="main">
	当初の予定では"mixi新規投稿"ボタンを押した段階で、投稿確認画面に飛ばしたかったところ、
	document.form_name.submit (); がどうしてもエラーになる orz
	当初原因が良くわからず頭を抱えていたところ、原因は入力フォームの一つ
		<input name="submit" value="main">
	だった。function submit が submit という名前の HTMLInputElement で上書きされていたのでした…
	色々試してみたんだけど断念。結果、日記の編集ページに飛ばされてしまうことに。
	// でも今のままのが便利かな？

2.文字コード万歳
	mixi は EUC-JP に対し、MovableType 側のそれは人それぞれ。form の accept-charset 属性で解決！
	…のハズだったんだけど IE 専用に別処理が必要でした。ぐんにょり。

3.作者もビックリ
	mixi日記には<MTEntryBody>だけ掲載して記事の概要を示し、
	記事本体に<MTEntryPermalink>でリンク貼ってあげれば
	外部ブログ云々のワンクッションを置かずに飛べてハッピーな感じ。
	案外イイかも(･∀･)b


■ 更新履歴
'06/12/05	1.41	MT3.3 の Transformer に対応。3.3 では BigPAPI が無くても動作します。
'06/08/29	1.40	MT3.3 で動作しなかった不具合修正
			複数の投稿者が存在する場合、投稿者毎にユーザIDを設定できるようにした
'06/04/12	1.31	一部環境で動作しない不具合修正
					tenu さん(http://tenu.vis.ne.jp/)、ありがとうございました！
'06/04/10	1.30	ファイルを一本化
					MT の設定スタブを使用して設定を行えるようにした
'06/02/27	1.21	整形されたリンクにゴミが付く不具合修正　'$2($1)' → '$2( $1 )'
'06/02/09	1.20	mixi 仕様変更にいたちゴッコ感満載に対応
'06/02/07	1.11	プレミアム会員で使用できるHTMLタグには触らないように
'06/02/05	1.10	HTMLタグのサニタイズ
					プレミアム会員/非会員で処理内容がチョット違う(^^)
'06/02/04	1.00	初版公開
