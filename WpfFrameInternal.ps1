#■プログラムの説明
#・WPFのFrameを使ったデモプログラムです。
#・1つ画面内で、画面構成を切り替えながら、表示します。
#・氏名などの基本情報入力後、好きなフルーツを登録するという想定です。
#・いくつか実装例があり、本プログラムはxamlをプログラム内に記述した版です。
#■実行方法
#・本ファイルがあるフォルダでコマンドプロンプトを開き下記を実行
#　powershell -sta -file WpfFrameInternal.ps1
#■画面基本操作
#・表示された画面左上の「スタート」をクリック
#・名前等の入力画面が出るので、入力後、「次へ」をクリック
#・好きなフルーツの選択画面が出るので、適当に選択後、「次へ」をクリック
#・登録情報確認画面が出るので、「上記内容を確認しました」をチェックし、「登録」をクリック
#・登録完了画面が出る（単に表示されるだけで、登録処理等は行っていません）
#・この後、更に「スタート」をクリックすると、次の登録画面になる
#■色々な操作
#・登録した情報の履歴が、画面下のピンクの欄に表示される（この欄はスクロール可能）
#・画面左上の「←」と「→」によって、画面を戻ったり、進めたりできる
#　・この際に、既に入力した情報は保存される
#・「上記内容を確認しました」をチェックせずに「登録」をクリックすると、
#　赤字で「【エラー】下記チェックボックスが未チェックです」が表示され、
#　チェックされるまで、登録完了画面に進めない
#■バージョン等
#・プログラム名：WpfFrameInternal.ps1
#・バージョン　：V1.0
#・作成日　　　：2017/04/02
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

# xaml設定
## Main page
[xml]$xaml = @' 
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MainWindow" Height="400" Width="500">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="30"/>
            <RowDefinition Height="250*"/>
            <RowDefinition Height="100"/>
        </Grid.RowDefinitions>
        <ToolBarTray>
            <ToolBar x:Name="toolBar" VerticalAlignment="Top">
                <Button x:Name="buttonPage1" Content="スタート"/>
            </ToolBar>
        </ToolBarTray>
        <Frame x:Name="frame" Grid.Row="1"  Background="#FFEAF9F0"/>
        <ScrollViewer x:Name="scrollView" Grid.Row="2">
            <TextBlock x:Name="msg" Background="#FFF7E4F5" TextWrapping="Wrap"/>
        </ScrollViewer>
    </Grid>
</Window>
'@

## Page1
[xml]$page1_xaml = @' 
<Page 
      xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      Height="200" Width="300"
      Title="Page1">

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="80"/>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Label Content="名前" Margin="0" VerticalAlignment="Center" HorizontalAlignment="Right"/>
        <TextBox x:Name="name" Grid.Column="1" Margin="5,5,5,5" VerticalAlignment="Center"/>

        <Label Content="ふりがな" Margin="0" VerticalAlignment="Center" HorizontalAlignment="Right" Grid.Row="1"/>
        <TextBox x:Name="furigana" Grid.Column="1" Grid.Row="1" Margin="5,5,5,5" VerticalAlignment="Center"/>

        <Label Content="性別" Margin="0" VerticalAlignment="Center" HorizontalAlignment="Right" Grid.Row="2"/>
        <StackPanel x:Name="gender" VerticalAlignment="Center" Orientation="Horizontal" Grid.Column="1" Grid.Row="2">
            <RadioButton x:Name="male" Content="男性" Margin="10,0,10,0"/>
            <RadioButton x:Name="female" Content="女性"/>
        </StackPanel>

        <Label Content="年齢" VerticalAlignment="Center" HorizontalAlignment="Right" Grid.Row="3"/>
        <TextBox x:Name="age" Grid.Column="1" Grid.Row="3" Width="80" TextAlignment="Right"  HorizontalAlignment="Left" Margin="5,5,5,5" VerticalAlignment="Center"/>

        <Button x:Name="regist1" Content="次へ" Grid.Column="0" Grid.ColumnSpan="2" Grid.Row="6" HorizontalAlignment="Center" VerticalAlignment="Center" Width="100" Height="30" />
    </Grid>

</Page>
'@

## Page2
[xml]$page2_xaml = @' 
<Page 
      xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      Height="200" Width="400"
      Title="Page2">

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition/>

        </Grid.RowDefinitions>
        <TextBlock x:Name="question" Text="question" Grid.Row="0" Margin="5,5,5,5" HorizontalAlignment="Center" VerticalAlignment="Center" TextWrapping="Wrap"/>

        <WrapPanel x:Name="selection" Grid.Row="1" Grid.RowSpan="3" HorizontalAlignment="Center" Orientation="Vertical" ItemWidth="120" >
            <CheckBox Content="1位:バナナ"/>
            <CheckBox Content="2位:パイナップル"/>
            <CheckBox Content="3位:グレープフルーツ"/>
            <CheckBox Content="4位:オレンジ"/>
            <CheckBox Content="5位:キウイフルーツ"/>
            <CheckBox Content="6位:アボカド"/>
            <CheckBox Content="7位:レモン"/>
            <CheckBox Content="8位:メロン"/>
            <CheckBox Content="9位:ブドウ"/>
            <CheckBox Content="10位:マンダリン"/>
            <CheckBox Content="11位:クリ"/>
            <CheckBox Content="12位:マンゴー"/>
            <CheckBox Content="13位:サクランボ"/>
            <CheckBox Content="14位:イチゴ"/>
            <CheckBox Content="15位:ライム"/>
            <CheckBox Content="16位:ブルーベリー"/>
            <CheckBox Content="17位:パパイア"/>
            <CheckBox Content="18位:リンゴ"/>
            <CheckBox Content="19位:ラズベリー"/>
            <CheckBox Content="20位:ブラックベリー"/>
            <CheckBox Content="21位:ライチ"/>
        </WrapPanel>

        <Button x:Name="regist2" Content="次へ" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Center" Width="100" Height="30" Margin="0" />

    </Grid>
</Page>
'@

## Page3
[xml]$page3_xaml = @' 
<Page 
      xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      Height="200" Width="450"
      Title="Page3">

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="1.5*"/>
            <RowDefinition Height="1.5*"/>
            <RowDefinition Height="0.5*"/>
            <RowDefinition Height="0.5*"/>
            <RowDefinition/>

        </Grid.RowDefinitions>
        <TextBox x:Name="info" Grid.Row="0" Grid.RowSpan="2" Margin="5,5,5,5" TextWrapping="Wrap"/>

        <TextBlock x:Name="err" Grid.Row="2" FontWeight="Bold" Foreground="#FFF50B0B" Text="【エラー】下記チェックボックスが未チェックです" HorizontalAlignment="Center" VerticalAlignment="Center" Visibility="Hidden"/>
        <CheckBox x:Name="confirm" Content="上記内容を確認しました" Grid.Row="3" HorizontalAlignment="Center" VerticalAlignment="Center"></CheckBox>

        <Button x:Name="regist3" Content="登録" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Center" Width="100" Height="30" Margin="0" />

    </Grid>
</Page>
'@

## Page4
[xml]$page4_xaml = @' 
<Page 
      xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      Title="Page4" Height="200" Width="300">
    <Grid>
        <Label x:Name="thankyou" Content="ご登録ありがとうございました" FontSize="22" VerticalAlignment="Center" HorizontalAlignment="Center"></Label>
    </Grid>
</Page>
'@

# form作成
$form       = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$page1_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page1_xaml))
$page2_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page2_xaml))
$page3_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page3_xaml))
$page4_form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $page4_xaml))

# form中のName属性に対して変数を作成し、forn中のNodeを設定
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
