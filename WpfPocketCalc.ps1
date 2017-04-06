#■プログラムの説明
#・WPFを使った電卓です。
#■実行方法
#・本ファイルがあるフォルダでコマンドプロンプトを開き下記を実行
#　powershell -sta -file WpfPocketCalc.ps1
#■画面基本操作
#・非常に基本的な電卓と同じ操作方法です。
#・ただし、計算結果は全て整数です。
#・また、BSは最後に入力した数字を1文字削除します。
#■バージョン等
#・プログラム名：WpfPocketCalc.ps1
#・バージョン　：V1.0.0
#・作成日　　　：2017/04/05
#・最終更新日　：2017/04/05
#・作成者　　　：Itsukara (Takayoshi Iitsuka)、iitt21-t@yahoo.co.jp、http://itsukara.hateblo.jp

$ErrorActionPreference = "stop"
Set-PSDebug -Strict

try { Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,System.Windows.Forms } 
catch { throw "Failed to load Windows Presentation Framework assemblies." }

# For each name in <xxx x:Name="name">, create new variable and set value  
Function setVaviables ($xaml, $form) {
    $xaml.SelectNodes("//*") | ? {$_.Attributes["x:Name"] -ne $null} | % {
        New-Variable  -Name $_.Name -Value $form.FindName($_.Name) -Force -Scope Global
    }
}

# xaml設定
[xml]$xaml = @' 
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="WPF Pocket Calc presented by Itsukara" Height="300" Width="300" ResizeMode="NoResize">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="1*"/>
            <ColumnDefinition Width="1*"/>
            <ColumnDefinition Width="1*"/>
            <ColumnDefinition Width="1*"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="40"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
        </Grid.RowDefinitions>
        <TextBox x:Name="displayLine" Grid.ColumnSpan="4" TextWrapping="Wrap" Text="0" FontSize="26" TextAlignment="Right" Margin="10,0"/>
        <Button x:Name="buttonBS" Content="BS" Grid.Column="0"  Grid.Row="1" FontSize="30"/>
        <Button x:Name="buttonC" Content="C" Grid.Column="1"  Grid.Row="1" FontSize="30"/>
        <Button x:Name="buttonAC" Content="AC" Grid.Column="2"  Grid.Row="1" FontSize="30"/>
        <Button x:Name="buttonAdd" Content="＋" Grid.Column="3"  Grid.Row="1" FontSize="30" FontWeight="Bold"/>
        <Button x:Name="button7" Content="7" Grid.Column="0"  Grid.Row="2" FontSize="30"/>
        <Button x:Name="button8" Content="8" Grid.Column="1"  Grid.Row="2" FontSize="30"/>
        <Button x:Name="button9" Content="9" Grid.Column="2"  Grid.Row="2" FontSize="30"/>
        <Button x:Name="buttonSub" Content="－" Grid.Column="3"  Grid.Row="2" FontSize="30" FontWeight="Bold"/>
        <Button x:Name="button4" Content="4" Grid.Column="0"  Grid.Row="3" FontSize="30"/>
        <Button x:Name="button5" Content="5" Grid.Column="1"  Grid.Row="3" FontSize="30"/>
        <Button x:Name="button6" Content="6" Grid.Column="2"  Grid.Row="3" FontSize="30"/>
        <Button x:Name="buttonMul" Content="×" Grid.Column="3"  Grid.Row="3" FontSize="30" FontWeight="Bold"/>
        <Button x:Name="button1" Content="1" Grid.Column="0"  Grid.Row="4" FontSize="30"/>
        <Button x:Name="button2" Content="2" Grid.Column="1"  Grid.Row="4" FontSize="30"/>
        <Button x:Name="button3" Content="3" Grid.Column="2"  Grid.Row="4" FontSize="30"/>
        <Button x:Name="buttonDiv" Content="／" Grid.Column="3"  Grid.Row="4" FontSize="20" FontWeight="Bold"/>
        <Button x:Name="button0" Content="0" Grid.Column="0"  Grid.Row="5" FontSize="30"/>
        <Button x:Name="buttonEql" Content="＝" Grid.Column="1"  Grid.Row="5" FontSize="30" FontWeight="Bold"/>
        <Button x:Name="buttonSgn" Content="±" Grid.Column="2"  Grid.Row="5" FontSize="30" FontWeight="Bold"/>
        <Button x:Name="buttonMod" Content="％" Grid.Column="3"  Grid.Row="5" FontSize="30" FontWeight="Bold"/>
    </Grid>
</Window>
'@

# 変数初期化
$maxKeta = 15;
$maxDouble = 999999999999999.0;
$OVERFLOW  = "OVERFLOW (Push AC)";
$ZERODIV   = "DIV BY 0 (Push AC)";
$operand1  = "";
$operator  = "";
$firstNum  = $true;


# form作成
$form       = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))

# $displayLineの値として、form中のdisplayLine Nodeを設定
$displayLine = $form.FindName("displayLine")

# callback設定

## Function for button action
Function button_action($buttonStr) {
	$display = $displayLine.Text
	if ($display -eq $OVERFLOW -or $display -eq $ZERODIV) {
	    if ($buttonStr -ne "AC") {
	        return
	    }
	}

	switch -regex ($buttonStr) {
	    "0|1|2|3|4|5|6|7|8|9" {
	        if ($global:firstNum) {
	            if ($global:operator -ne "") {
	                $global:operand1 = $display
	            }
	            $display = "0"
	            $global:firstNum = $false
	        }
	        if ($display.Length -ge $maxKeta) {
	            $displayLine.Text = $OVERFLOW
	        } else {
		        $displayNum = +$display
		        $buttonNum = +$buttonStr
		        $displayNum = $displayNum * 10 + $buttonNum
		        $displayLine.Text = $displayNum
	        }
	    }
	    
	    "＋|－|×|／|＝|％" {
	        if ($global:operator -ne "" -and $global:operand1 -ne "" -and !$global:firstNum) {
	            $operand1Num = +$global:operand1
	            $operand2Num = +$display
	            switch ($global:operator) {
	                "＋" {
	                    if ([Math]::Abs($operand1Num + $operand2Num) -gt $maxDouble) {
	                        $displayLine.Text = $OVERFLOW
	                    } else {
	                        $displayLine.Text = $operand1Num + $operand2Num
	                    }
	                }
	                
	                "－" {
	                    if ([Math]::Abs($operand1Num - $operand2Num) -gt $maxDouble) {
	                        $displayLine.Text = $OVERFLOW
	                    } else {
	                        $displayLine.Text = $operand1Num - $operand2Num
	                    }
	                }
	                
	                "×" {
	                    if ([Math]::Abs($operand1Num * $operand2Num) -gt $maxDouble) {
	                        $displayLine.Text = $OVERFLOW
	                    } else {
	                        $displayLine.Text = $operand1Num * $operand2Num
	                    }
	                }
	                
	                "／" {
	                    if ($operand2Num -eq 0) {
	                        $displayLine.Text = $ZERODIV
	                    } else {
	                        $displayLine.Text = [Math]::Floor($operand1Num / $operand2Num)
	                    }
	                }
	                
	                "％" {
	                    if ($operand2Num -eq 0) {
	                        $displayLine.Text = $ZERODIV
	                    } else {
	                        $displayLine.Text = $operand1Num % $operand2Num
	                    }
	                }
	            }
	        }
	        if ($buttonStr -eq "=") {
	            $global:operator = ""
	        } else {
	            $global:operator = $buttonStr
	        }
	        $global:firstNum = $true
	    }
	    
	    "BS" {
	        $displayNum = +$display
	        $displayNum = [Math]::Floor($displayNum / 10)
	        $displayLine.Text = $displayNum
	     }
	     
	    "±" {
	        $displayNum = +$display
	        $displayNum = -$displayNum
	        $displayLine.Text = $displayNum
	     }
	     
	    "C" {
	        $displayLine.Text = "0"
	     }
	     
	    "AC" {
	        $displayLine.Text = "0"
	        $global:operand1 = ""
	        $global:operator = ""
	     }
	}
}

## Function to add Click callback
Function button_add_Click($button) {
    $btn = $form.FindName($button.Name)
    if ($btn.add_Click -ne $null) {
        $btn.add_Click({button_action $this.content})
    }
}

## Add_Click to all button
$xaml.SelectNodes("//*") | ? {$_.Name -clike "button*"} | %  {button_add_Click $_}

# 全体
$result = $form.ShowDialog()
