#■プログラムの説明
#・WPFのFrameを使ったデモプログラムです。
#・Frameを使って、1つの画面内で画面構成を切り替えながら、表示します。
#・氏名などの基本情報入力後、好きなフルーツを登録するウィザード風の構成です。
#・いくつか実装例があり、本プログラムはxamlを外部からPreLoadする版です。
#■実行方法
#・本ファイルがあるフォルダでコマンドプロンプトを開き下記を実行
#　powershell -sta -file WpfFrameInternal.ps1
#■画面基本操作
#・表示された画面左上の「スタート」をクリック
#・名前等の入力画面が出るので、入力後、「次へ」をクリック
#・好きなフルーツの選択画面が出るので、選択後、「次へ」をクリック
#・登録情報確認画面が出るので、「上記内容を確認しました」をチェックし、「登録」をクリック
#・登録完了画面が表示される（単に表示されるだけで、登録処理等は行っていません）
#・この後、更に「スタート」をクリックすると、次の登録画面になる
#■補足情報
#・登録した情報の履歴が、画面下のピンクの欄に表示される（この欄はスクロール可能）
#・画面左上の「←」と「→」によって、画面を戻ったり、進めたりできる
#　・この際に、既に入力した情報は保存される
#・「上記内容を確認しました」をチェックせずに「登録」をクリックすると、
#　赤字で「【エラー】下記チェックボックスが未チェックです」が表示され、
#　チェックされるまで、登録完了画面に進めない
#■バージョン等
#・プログラム名：WpfFrameInternal.ps1
#・バージョン　：V1.0.1
#・作成日　　　：2017/04/02
#・最終更新日　：2017/04/04
#・作成者　　　：Itsukara (Takayoshi Iitsuka)、iitt21-t@yahoo.co.jp、http://itsukara.hateblo.jp

$ErrorActionPreference = "stop"
Set-PSDebug -Strict

try { Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,System.Windows.Forms,ReachFramework  } 
catch { throw "Failed to load Windows Presentation Framework assemblies." }

# For each name in <xxx x:Name="name">, new variable $name is created and set value  
Function setVaviables ($xaml, $form) {
    $xaml.SelectNodes("//*") | ? {$_.Attributes["x:Name"] -ne $null} | % {
        New-Variable  -Name $_.Name -Value $form.FindName($_.Name) -Force -Scope Global
    }
}

# xamlファイル読込
$PageFolder = $PSScriptRoot + "\"
[xml]$xaml       = Get-Content -Encoding UTF8 ($PageFolder + "Page0.xaml")
[xml]$page1_xaml = Get-Content -Encoding UTF8 ($PageFolder + "Page1.xaml")
[xml]$page2_xaml = Get-Content -Encoding UTF8 ($PageFolder + "Page2.xaml")
[xml]$page3_xaml = Get-Content -Encoding UTF8 ($PageFolder + "Page3.xaml")
[xml]$page4_xaml = Get-Content -Encoding UTF8 ($PageFolder + "Page4.xaml")

# form作成
$form       = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$page1_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page1_xaml))
$page2_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page2_xaml))
$page3_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page3_xaml))
$page4_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page4_xaml))

# form中のName属性に対して変数を作成し、変数の値として、form中のNodeを設定
setVaviables $xaml $form
setVaviables $page1_xaml $page1_form
setVaviables $page2_xaml $page2_form
setVaviables $page3_xaml $page3_form
setVaviables $page4_xaml $page4_form

# callback設定
## Main page
$buttonPage1.add_Click({
    $frame.Navigate($page1_form)
})

### Function to add text line to bottom TextBlock
$msg.Text = ""
Function println($line) {
    $msg.Inlines.Add($line + "`n")
    $scrollView.ScrollToBottom() 
}
Function clearMsg() {
    $msg.Text = ""
}

## Page1
$page1_form.add_Loaded({
    # 履歴削除
    while ($frame.CanGoBack) {
        $frame.RemoveBackEntry()
    }
})

$regist1.add_Click({
    if ($frame.CanGoForward) {
        $frame.GoForward()
    } else {
        $frame.Navigate($page2_form)
    }
})

## Page2
$page2_form.add_Loaded({
    $question.text = "以下の果物輸出入ランキングから" + $name.Text + "様" + "が好きなフルーツをチェックしてください"
})

$regist2.add_Click({
    if ($frame.CanGoForward) {
        $frame.GoForward()
    } else {
        $frame.Navigate($page3_form)
    }
})

## Page3
### Function to get Checked children items
function getChecked($parent) {
    $checked = @()
    foreach ($child in $parent.Children) {
        if ($child.isChecked) {
            $checked += $child.Content
        }
    }
    return $checked -join "、"
}

$page3_form.add_Loaded({
    $gender= getChecked $gender
    $global:registered_info = @"
 ■ご登録情報
【プロフィール】$($name.Text)（$($furigana.Text)）様、$gender、$($age.Text)歳
【好きなフルーツ】$(getChecked $selection)
"@
    $info.Text = $registered_info
})

$regist3.add_Click({
    if (-not $confirm.IsChecked) {
        $err.Visibility = "visible"
    } else {
        $frame.Navigate($page4_form)
    }
})

## Page4
$page4_form.add_Loaded({
    $thankyou.content = $name.Text + "様`n" + "ご登録ありがとうございました" 
    # 履歴削除
    while ($frame.CanGoBack) {
        $frame.RemoveBackEntry()
    }
    println $registered_info
    reset
})

### Reset Variables for next use 
Function reset {
    # Page1
    $name.Text = ""
    $furigana.Text = ""
    $male.IsChecked = $false
    $female.IsChecked = $false
    $age.Text = ""

    # Page2
    clearIsChecked $selection

    # Page3
    $confirm.IsChecked = $false
    $err.Visibility = "Hidden"

    # Page4

}

### Function to clear IsChecked of children items
function clearIsChecked($parent) {
    foreach ($child in $parent.Children) {
        $child.IsChecked = $false
    }
}

# 全体
$result = $form.ShowDialog()
