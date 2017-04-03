#■プログラムの説明
#・WPFのFrameを使ったデモプログラムです。
#・Frameを使って、1つの画面内で画面構成を切り替えながら、表示します。
#・氏名などの基本情報入力後、好きなフルーツを登録するウィザード風の構成です。
#・いくつか実装例があり、本プログラムは画面切替時にxamlを外部からLoadする版です。
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

# xamlファイル設定・読込
$PageFolder = $PSScriptRoot + "\"
$page0_path = $PageFolder + "Page0.xaml"
$page1_path = $PageFolder + "Page1.xaml"
$page2_path = $PageFolder + "Page2.xaml"
$page3_path = $PageFolder + "Page3.xaml"
$page4_path = $PageFolder + "Page4.xaml"
[xml]$xaml       = Get-Content -Encoding UTF8 $page0_path
[xml]$page1_xaml = Get-Content -Encoding UTF8 $page1_path
[xml]$page2_xaml = Get-Content -Encoding UTF8 $page2_path
[xml]$page3_xaml = Get-Content -Encoding UTF8 $page3_path
[xml]$page4_xaml = Get-Content -Encoding UTF8 $page4_path

# form初期化
$form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$page1_form = $null
$page2_form = $null
$page3_form = $null
$page4_form = $null

# 各ページの処理
## Main Page
setVaviables $xaml $form

# Function to add text line to bottom TextBlock
$msg.Text = ""
Function println($line) {
    $msg.Inlines.Add($line + "`n")
    $scrollView.ScrollToBottom() 
}
Function clearMsg() {
    $msg.Text = ""
}

$buttonPage1.add_Click({
    $uri = New-Object System.Uri($page1_path, [System.UriKind]::Absolute)
    $frame.Navigate($uri)
})

## Page1
Function process_page1($page) {
    if ($page1_form -eq $null) {
        $page1_form = $page
        setVaviables $page1_xaml $page1_form

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
                $uri = New-Object System.Uri($page2_path, [System.UriKind]::Absolute)
                $frame.Navigate($uri)
            }
        })
    }
}

## page2
Function process_page2($page) {
    if ($page2_form -eq $null) {
        $page2_form = $page
        setVaviables $page2_xaml $page2_form

        $page2_form.add_Loaded({
            $question.text = "以下の果物輸出入ランキングから" + $name.Text + "様" + "が好きなフルーツをチェックしてください"
        })

        $regist2.add_Click({
            if ($frame.CanGoForward) {
                $frame.GoForward()
            } else {
                $uri = New-Object System.Uri($page3_path, [System.UriKind]::Absolute)
                $frame.Navigate($uri)
            }
        })
    }
}

## page3
### Function to get Checked children items
Function getChecked($parent) {
    $checked = @()
    foreach ($child in $parent.Children) {
        if ($child.isChecked) {
            $checked += $child.Content
        }
    }
    return $checked -join "、"
}

Function process_page3($page) {
    if ($page3_form -eq $null) {
        $page3_form = $page
        setVaviables $page3_xaml $page3_form
        $page3_form.add_Loaded({
            $gender= getChecked $gender
            $global:registered_info = @"
■ご登録情報
プロフィール】$($name.Text)（$($furigana.Text)）様、$gender、$($age.Text)歳
好きなフルーツ】$(getChecked $selection)
"@
            $info.Text = $registered_info
        })

        $regist3.add_Click({
            if (-not $confirm.IsChecked) {
                $err.Visibility = "visible"
            } else {
                $uri = New-Object System.Uri($page4_path, [System.UriKind]::Absolute)
                $frame.Navigate($uri)
            }
        })
   }
}

## page4
Function process_page4($page) {
    if ($page4_form -eq $null) {
        $page4_form = $page
        setVaviables $page4_xaml $page4_form
        $page4_form.add_Loaded({
            $thankyou.content = $name.Text + "様`n" + "ご登録ありがとうございました" 
            # 履歴削除
            while ($frame.CanGoBack) {
                $frame.RemoveBackEntry()
            }
            println $registered_info
            reset
        })
    }
}

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


$frame.add_LoadCompleted({
    if ($frame.CurrentSource.LocalPath -eq $page1_path) {
        process_page1 $frame.Content
    }
    if ($frame.CurrentSource.LocalPath -eq $page2_path) {
        process_page2 $frame.Content
    }
    if ($frame.CurrentSource.LocalPath -eq $page3_path) {
        process_page3 $frame.Content
    }
    if ($frame.CurrentSource.LocalPath -eq $page4_path) {
        process_page4 $frame.Content
    }
})

$result = $form.ShowDialog()
