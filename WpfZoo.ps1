#■プログラムの説明
#・WPFの各コントロールを表示するデモプログラムです。
#・表示だけでなく、クリックしたボタンを画面の欄に表示する等の動作もあります。
#　・TabItem1：ボタン、リスト、テーブル等をクリックしてみてください。
#　・TabItem2：カレンダー、Expandertや、スライダーを試してみてください。
#　・Tab for DockPanel：MenuItemや、画面左のTreeViewで項目を選択してみてください。
#　・Tab for DocumentViewer：xpsのビューアーです、ズーム等ができます。
#　・Frames：画面上のボタンをクリックしてFrameを表示してみてください。
#　・Media：動画の再生、一時停止、再生ができます。
#　・RitchTextBox：表示内容の書換、文字属性や文節属性の変更ができます。
#　　ただし「下付き」「上付き」は、数字以外は上手く行きません。(原因不明）
#■実行方法
#・本ファイルがあるフォルダでコマンドプロンプトを開き下記を実行
#　powershell -sta -file WpfZoo.ps1
#■画面上の各WPFコントロールに対応するxamlの確認方法
#・Visual StudioでWPFプロジェクトを新規作成
#・画面下のxaml文字列の<Grid>以下の行を、下記のxamlの<Grid>以下の行で置換
#　・これにより、本プログラムと同様の画面が表示される
#　・ただし、下記xaml中の文字列PSScriptRootを、本スクリプトのパスで置換する必要あり
#・画面上のWPFコントロールをクリックして選択すると、xaml中で対応する部分が選択される
#■バージョン等
#・プログラム名：WpfZoo.ps1
#・バージョン　：V1.0
#・作成日　　　：2017/04/02
#・作成者　　　：Itsukara (Takayoshi Iitsuka)、iitt21-t@yahoo.co.jp、http://itsukara.hateblo.jp

$ErrorActionPreference = "stop"
Set-PSDebug -Strict

$xamlString = @' 
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="WPF ZOO by presented by Itsukara" Height="467" Width="719">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="300"/>
            <RowDefinition Height="10"/>
            <RowDefinition Height="1*"/>
        </Grid.RowDefinitions>
        <TabControl x:Name="tabControl" Margin="0" Grid.Row="0">
            <TabItem Header="TabItem1">
                <Grid Margin="0,0,0,0" Background="#FFDDF0EC">
                    <Border BorderBrush="Black" BorderThickness="1" HorizontalAlignment="Left" Height="87" Margin="20,20,0,0" VerticalAlignment="Top" Width="132">
                        <Border.Background>
                            <RadialGradientBrush>
                                <GradientStop Color="Black" Offset="0"/>
                                <GradientStop Color="#FF5DD418" Offset="1"/>
                            </RadialGradientBrush>
                        </Border.Background>
                        <Image x:Name="image1" Source="PSScriptRoot\elephant.jpg" Width="124" Height="79" HorizontalAlignment="Left" VerticalAlignment="Top" RenderTransformOrigin="-0.184,-0.163" Margin="4,3,0,0"/>
                    </Border>

                    <Button x:Name="buttonCheck" Content="Check It" HorizontalAlignment="Left" Margin="57,112,0,0" VerticalAlignment="Top" Width="60" Height="20"/>

                    <ComboBox x:Name="comboBox" HorizontalAlignment="Left" Margin="180,20,0,0" VerticalAlignment="Top" Width="120">
                        <ComboBoxItem Content="ComboBoxItem0"/>
                        <ComboBoxItem Content="ComboBoxItem1"/>
                        <ComboBoxItem Content="ComboBoxItem2"/>
                    </ComboBox>

                    <Label x:Name="label" Content="This is a Label" HorizontalAlignment="Left" Margin="337,20,0,0" VerticalAlignment="Top" Width="120"/>

                    <Grid HorizontalAlignment="Left" Height="60" Margin="480,10,0,0" VerticalAlignment="Top" Width="200">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="10*"/>
                            <ColumnDefinition Width="10*"/>
                            <ColumnDefinition Width="10*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="30*"/>
                            <RowDefinition Height="30*"/>
                        </Grid.RowDefinitions>
                        <Button x:Name="button00" Content="Button00" Grid.Row="0" Grid.Column="0" />
                        <Button x:Name="button01" Content="Button01" Grid.Row="0" Grid.Column="1" />
                        <Button x:Name="button10" Content="Button10" Grid.Row="1" Grid.Column="0" />
                        <Button x:Name="button11" Content="Button11" Grid.Row="1" Grid.Column="1" />
                        <Label  Content="Label02" Grid.Row="0" Grid.Column="2"/>
                        <Label  Content="Label02" Grid.Row="1" Grid.Column="2"/>
                    </Grid>

                    <ListBox x:Name="listBox" HorizontalAlignment="Left" Margin="180,57,0,0" VerticalAlignment="Top" Width="100">
                        <ListBoxItem Content="ListBoxItem0"/>
                        <ListBoxItem Content="ListBoxItem1"/>
                        <ListBoxItem Content="ListBoxItem2"/>
                    </ListBox>

                    <GroupBox x:Name="groupBox1" Header="GroupBox1" HorizontalAlignment="Left" Margin="20,135,0,0" VerticalAlignment="Top" Height="86" Width="130" BorderBrush="#FF133447">
                        <StackPanel x:Name="checkBoxes" Margin="0,10,0,0" Width="100">
                            <CheckBox x:Name="checkBox1" Content="checkBox1"/>
                            <CheckBox x:Name="checkBox2" Content="checkBox2"/>
                            <CheckBox x:Name="checkBox3" Content="checkBox3"/>
                        </StackPanel>
                    </GroupBox>

                    <GroupBox x:Name="groupBox2" Header="GroupBox2" HorizontalAlignment="Left" Margin="180,135,0,0" VerticalAlignment="Top" Height="86" Width="130" BorderBrush="#FF133447">
                        <StackPanel x:Name="radioButtons" Margin="0,10,0,0" Width="100">
                            <RadioButton x:Name="radioButton1" Content="RadioButton1"/>
                            <RadioButton x:Name="radioButton2" Content="RadioButton2"/>
                            <RadioButton x:Name="radioButton3" Content="RadioButton3"/>
                        </StackPanel>
                    </GroupBox>

                    <TextBlock x:Name="textBlock" HorizontalAlignment="Left" Margin="20,225,0,0" TextWrapping="Wrap" Text="This is a TextBlock." VerticalAlignment="Top"/>
                    <TextBox x:Name="textBox" HorizontalAlignment="Left" Margin="180,225,0,0" TextWrapping="Wrap" Text="This is a TextBox" VerticalAlignment="Top" Width="120"/>

                    <DataGrid x:Name="datagrid" AutoGenerateColumns="False" HorizontalAlignment="Left" Margin="337,56,0,5" Width="120">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="i"         Binding="{Binding i }" Width="Auto"/>
                            <DataGridTextColumn Header="i * i"     Binding="{Binding i2}" Width="Auto"/>
                            <DataGridTextColumn Header="i * i * i" Binding="{Binding i3}" Width="Auto"/>
                        </DataGrid.Columns>
                    </DataGrid>

                    <ListView x:Name="listView" Margin="477,85,0,0">
                        <ListView.View>
                            <GridView>
                                <GridViewColumn Header="Name" DisplayMemberBinding="{Binding nameLV}" Width="120"/>
                                <GridViewColumn Header="Age" DisplayMemberBinding="{Binding ageLV}"/>
                                <GridViewColumn Header="Gender" DisplayMemberBinding="{Binding genderLV}"/>
                            </GridView>
                        </ListView.View>
                    </ListView>

                </Grid>

            </TabItem>

            <TabItem Header="TabItem2">
                <Grid Background="#FFFFF7C3" Margin="0,0,0,0">
                    <Calendar x:Name="calender" HorizontalAlignment="Left" VerticalAlignment="Top"/>

                    <DatePicker x:Name="datepicker" HorizontalAlignment="Left" Margin="0,180,0,0" VerticalAlignment="Top"/>

                    <StackPanel HorizontalAlignment="Left" Margin="195,0,0,0" VerticalAlignment="Top" Width="175">
                        <Expander x:Name="expander1" Header="Expander1">
                            <StackPanel>
                                <TextBlock Text="Hello World!"/>
                                <TextBlock Text="Good bye World!"/>
                                <TextBlock Text="Restart World!"/>
                            </StackPanel>
                        </Expander>
                        <Expander x:Name="expander2" Header="Expander2">
                            <StackPanel>
                                <TextBlock Text="Good morning Universe!"/>
                                <TextBlock Text="Good night Universe!"/>
                                <TextBlock Text="Restart Universe!"/>
                            </StackPanel>
                        </Expander>
                    </StackPanel>

                    <Canvas HorizontalAlignment="Left" Height="190" Margin="357,10,0,0" VerticalAlignment="Top" Width="200" Background="White">
                        <Path Stroke="DarkGoldenRod" StrokeThickness="3" 
                            Data="M 0,0 C 100,200   200,300   300,150 L 100,100 L 400,400" Height="190" Stretch="Uniform" Width="200" />
                        <Path Stroke="Black" StrokeThickness="1" 
                            Data="M 0,0 L 100,200 L 200,300 L 300,150 L 100,100 L 400,400" Height="190" Stretch="Uniform" Width="200" />
                    </Canvas>

                    <Rectangle HorizontalAlignment="Left" Height="25" Margin="202,90,0,0" Stroke="Black" VerticalAlignment="Top" Width="118">
                        <Rectangle.Fill>
                            <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                                <GradientStop Color="Black" Offset="0"/>
                                <GradientStop Color="#FFCF9090" Offset="1"/>
                            </LinearGradientBrush>
                        </Rectangle.Fill>
                    </Rectangle>

                    <Ellipse x:Name="ellipse" HorizontalAlignment="Left" Height="70" Margin="217,153,0,0" Stroke="Black" VerticalAlignment="Top" Width="75" Fill="#FF66B639"/>
                    <Slider x:Name="slider1" HorizontalAlignment="Left" Margin="202,130,0,0" VerticalAlignment="Top" Width="140" Maximum="20"/>
                    <Slider x:Name="slider2" HorizontalAlignment="Left" Margin="195,148,0,0" VerticalAlignment="Top" Orientation="Vertical" Height="111" RenderTransformOrigin="0.5,0.5">
                        <Slider.RenderTransform>
                            <TransformGroup>
                                <ScaleTransform ScaleY="-1" ScaleX="1"/>
                                <SkewTransform AngleY="0" AngleX="0"/>
                                <RotateTransform Angle="0"/>
                                <TranslateTransform/>
                            </TransformGroup>
                        </Slider.RenderTransform>
                    </Slider>
                    <Label Content="PasswordBox" HorizontalAlignment="Left" Margin="582,10,0,0" VerticalAlignment="Top"/>
                    <PasswordBox x:Name="passwordBox" HorizontalAlignment="Left" Margin="586,33,0,0" VerticalAlignment="Top" Width="109"/>
                    <Label Content="Viewbox" HorizontalAlignment="Left" Margin="582,162,0,0" VerticalAlignment="Top"/>
                    <Viewbox Stretch="Fill" Height="83" Margin="572,180,0,0" VerticalAlignment="Top">
                        <Calendar Width="165"/>
                    </Viewbox>
                </Grid>
            </TabItem>

            <TabItem Header="Tab for DockPanal" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="110" Margin="0,0,0,0">
                <DockPanel>
                    <!-- メニューやツールバー -->
                    <Button DockPanel.Dock="Top" >
                        <Menu x:Name="menu" Height="20">
                            <MenuItem Header="MenuItem1">
                                <MenuItem x:Name="MenuItem11" Header="MenuItem11"/>
                                <MenuItem x:Name="MenuItem12" Header="MenuItem12"/>
                                <MenuItem x:Name="MenuItem13" Header="MenuItem13"/>
                            </MenuItem>
                            <MenuItem Header="MenuItem2">
                                <MenuItem x:Name="MenuItem21" Header="MenuItem21"/>
                                <MenuItem x:Name="MenuItem22" Header="MenuItem22"/>
                                <MenuItem x:Name="MenuItem23" Header="MenuItem23"/>
                            </MenuItem>
                            <MenuItem Header="MenuItem3">
                                <MenuItem x:Name="MenuItem31" Header="MenuItem31"/>
                                <MenuItem x:Name="MenuItem32" Header="MenuItem32"/>
                                <Separator/>
                                <MenuItem x:Name="MenuItem33" Header="MenuItem33"/>
                                <MenuItem x:Name="MenuItem34" Header="MenuItem34"/>
                                <MenuItem x:Name="MenuItem35" Header="MenuItem35"/>
                            </MenuItem>
                        </Menu>
                    </Button>
                    <ToolBarTray DockPanel.Dock="Top">
                        <ToolBar x:Name="toolBar0" HorizontalAlignment="Left">
                            <Button x:Name="buttonTB00" Content="ButtonTB00"/>
                            <Button x:Name="buttonTB01" Content="ButtonTB01"/>
                            <Button x:Name="buttonTB02" Content="ButtonTB02"/>
                            <ComboBox x:Name="comboBox1" Width="120"/>
                        </ToolBar>
                        <ToolBar x:Name="toolBar1" HorizontalAlignment="Left">
                            <Button x:Name="buttonTB10" Content="ButtonTB10"/>
                            <Button x:Name="buttonTB11" Content="ButtonTB11"/>
                            <Button x:Name="buttonTB12" Content="ButtonTB12"/>
                            <Button x:Name="buttonTB13" Content="ButtonTB13"/>
                            <Button x:Name="buttonTB14" Content="ButtonTB14"/>
                        </ToolBar>
                    </ToolBarTray>
                    <!-- ステータスバー -->
                    <StatusBar DockPanel.Dock="Bottom">
                        <Button x:Name="buttonSB1" Content="ButtonSB1"/>
                        <Label x:Name="label1" Content="進行状況:"/>
                        <ProgressBar Maximum="100" Value="50" Height="20" Width="100" />
                    </StatusBar>
                    <!-- ツリーが表示される場所 最低限の幅確保のためMinWidthプロパティを指定 -->
                    <TreeView x:Name="treeView" DockPanel.Dock="Left" MinWidth="150">
                        <TreeViewItem Header="Item1">
                            <TreeViewItem Header="Item1-1">
                                <TreeViewItem Header="Item1-1-1" />
                                <TreeViewItem Header="Item1-1-2" />
                                <TreeViewItem Header="Item1-1-3" />
                            </TreeViewItem>
                            <TreeViewItem Header="Item1-2">
                                <TreeViewItem Header="Item1-2-1" />
                                <TreeViewItem Header="Item1-2-2" />
                            </TreeViewItem>
                        </TreeViewItem>
                        <TreeViewItem Header="Item2" IsExpanded="True">
                            <TreeViewItem Header="Item2-1" IsExpanded="True" IsSelected="True">
                                <TreeViewItem Header="Item2-1-1" />
                                <TreeViewItem Header="Item2-1-2" />
                                <TreeViewItem Header="Item2-1-3" />
                            </TreeViewItem>
                        </TreeViewItem>
                    </TreeView>
                    <!-- エクスプローラーの右側の領域 -->
                    <Button x:Name="buttonContent" Content="Content" FontSize="72" />
                </DockPanel>

            </TabItem>

            <TabItem Header="Tab for DocumentViewer" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="155" Margin="0,0,-100,0">
                <Grid>
                    <DocumentViewer x:Name="documentViewer"/>
                </Grid>
            </TabItem>

            <TabItem Header="Frames" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="55">
                <Grid Background="#FFE5E5E5">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="30"/>
                        <RowDefinition/>
                    </Grid.RowDefinitions>
                    <Button x:Name="buttonFrame1" Content="Frame1(yahoo)" HorizontalAlignment="Left" VerticalAlignment="Top" Width="100"/>
                    <Button x:Name="buttonFrame2" Content="Frame2(xaml)" HorizontalAlignment="Left" Margin="110,0,0,0" VerticalAlignment="Top" Width="100"/>
                    <Frame x:Name="frame" Grid.Row="1"/>
                </Grid>
            </TabItem>

            <TabItem Header="Media" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="54">
                <Grid Background="#FFE5E5E5">
                    <Grid Margin="0"/>
                    <Button x:Name="buttonPlay" Content="Play" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75"/>
                    <Button x:Name="buttonPause" Content="Pause" HorizontalAlignment="Left" Margin="0,25,0,0" VerticalAlignment="Top" Width="75"/>
                    <Button x:Name="buttonStop" Content="Stop" HorizontalAlignment="Left" Margin="0,50,0,0" VerticalAlignment="Top" Width="75"/>
                    <MediaElement x:Name="mediaElement" Margin="100,0,0,0"/>
                </Grid>
            </TabItem>

            <TabItem Header="RichTextBox" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top">
                <Grid Background="#FFE5E5E5">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>

                    <ToolBarTray HorizontalAlignment="Left" Height="30" VerticalAlignment="Top" Width="685" Margin="10,0,0,0">
                        <ToolBar x:Name="toolBarA" HorizontalAlignment="Left" Margin="0,0,-51,-22" VerticalAlignment="Top" Background="#FFA8CFFB">
                            <Button x:Name="buttonToggleBold" Content="太字" Background="White" />
                            <Button x:Name="buttonToggleItalic" Content="斜体" Background="White" />
                            <Button x:Name="buttonToggleUnderline" Content="下線" Background="White" />
                            <Button x:Name="buttonIncreaseFontSize" Content="大きく" Background="White" />
                            <Button x:Name="buttonDecreaseFontSize" Content="小さく" Background="White" />
                            <Button x:Name="buttonToggleSubscript" Content="下付き" Background="White" />
                            <Button x:Name="buttonToggleSuperscript" Content="上付き" Background="White" />
                        </ToolBar>
                        <ToolBar x:Name="toolBarB" HorizontalAlignment="Left" Margin="47,0,-98,-22" VerticalAlignment="Top" Background="#FFA8CFFB">
                            <Button x:Name="buttonToggleBullets" Content=" ・ " Background="White" />
                            <Button x:Name="buttonToggleNumbering" Content="1,2,…" Background="White" />
                            <Button x:Name="buttonAlignLeft" Content="左揃え" Background="White" />
                            <Button x:Name="buttonAlignCenter" Content="中央揃え" Background="White" />
                            <Button x:Name="buttonAlignRight" Content="右揃え" Background="White" />
                            <Button x:Name="buttonAlignJustify" Content="両端揃え" Background="White" />
                            <Button x:Name="buttonIncreaseIndentation" Content="⇒" Background="White" />
                            <Button x:Name="buttonDecreaseIndentation" Content="⇐" Background="White" />
                        </ToolBar>
                    </ToolBarTray>

                    <RichTextBox x:Name="richTextBox" Margin="10,34,0,0" AcceptsTab="True">
                        <FlowDocument LineHeight="8px">
                            <Paragraph>
                                <Run Text="利用可能なコマンドは下記参照"/>
                                <LineBreak/>
                                <Run Text="https://msdn.microsoft.com/ja-jp/library/system.windows.documents.editingcommands(v=vs.110).aspx"/>
                            </Paragraph>
                            <Paragraph>
                                <Run Text="[例文]" FontSize="15"/>
                                <LineBreak/>
                                <Run Text="X"/> <Run Text="2" Typography.Variants="Superscript"/>
                                <Run Text=" + Y"/> <Run Text="3" Typography.Variants="Superscript"/>
                                <Run Text=" = Z"/> <Run Text="4" Typography.Variants="Superscript"/>
                                <LineBreak/>
                                <Run Text="A"/> <Run Text="10" Typography.Variants="Subscript"/>
                                <Run Text=", B"/> <Run Text="20" Typography.Variants="Subscript"/>
                                <Run Text=", C"/> <Run Text="30" Typography.Variants="Subscript"/>
                                <LineBreak/>
                                <Run Text="The following figures AlignLeft (left one) to AlignJustify (right one)"/>
                                <LineBreak/>
                                <Image x:Name="image2" Source="PSScriptRoot\alignleft.jpeg" Height="75" Width="237"/>
                                <Image x:Name="image3" Source="PSScriptRoot\alignjustify.jpeg" Height="75" Width="237"/>
                            </Paragraph>
                            <Paragraph>
                                <Run Text="There is not necessarily an actual implementation that responds to this command on any given object; in many cases the implementation that responds to a command is the responsibility of the application writer."/>
                            </Paragraph>
                            <Paragraph>
                                <Run Text="This command is natively supported by RichTextBox."/>
                            </Paragraph>

                        </FlowDocument>
                    </RichTextBox>


                </Grid>
            </TabItem>
        </TabControl>

        <GridSplitter x:Name="gridSplitter1" HorizontalAlignment="Stretch" Height="5" Grid.Row="1"/>

        <ScrollViewer x:Name="scrollView" Margin="0,0,0,0" Grid.Row="2">
            <TextBlock x:Name="msg" TextWrapping="Wrap" Text="TextBlock"/>
        </ScrollViewer>
    </Grid>
</Window>
'@
$xaml = [xml]$xamlString.Replace("PSScriptRoot", $PSScriptRoot)
try { Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,System.Windows.Forms,ReachFramework  } 
catch { throw "Failed to load Windows Presentation Framework assemblies." }

$form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
# For each name in <xxx x:Name="name">, new variable $name is created and set value  
$xaml.SelectNodes("//*") | ? {$_.Attributes["x:Name"] -ne $null} | % {
    New-Variable  -Name $_.Name -Value $form.FindName($_.Name) -Force
}

### TabItem1

# Function to add text line to bottom TextBlock
$msg.Text = ""
Function println($line) {
    $msg.Inlines.Add($line + "`n")
    $scrollView.ScrollToBottom() 
}

# Function to add Click callback to all button
Function button_add_Click($button) {
    $btn = $form.FindName($button.Name)
    if ($btn.add_Click -ne $null) {
        $btn.add_Click({println ($this.Content + " Pushed")})
    }
}

# Add_Click to all button
$xaml.SelectNodes("//*") | ? {$_.Name -clike "button*"} | %  {button_add_Click $_}

# Function to add SelectionChanged callback
Function add_SelectionChanged($selection) {
    $selection.add_SelectionChanged({
        $selectedIndex = $this.SelectedIndex
        $selected = $this.SelectedValue.Content
        if ($selected -eq $null) {
            $selected = $this.Items.GetItemAt($selectedIndex)
        }
        println ("#" + $selectedIndex + ": " + $selected + " selected")
    })
}

# Add SelectionChanged callback
add_SelectionChanged $comboBox
add_SelectionChanged $comboBox1
add_SelectionChanged $listBox
add_SelectionChanged $datagrid
add_SelectionChanged $listView

# Function to add Click callback to selection item
Function item_add_Click($item) {
    $item.add_Click({
        $line = $this.Content + " is "
        if (-not $this.isChecked) {
            $line += "Un"
        }
        $line += "Checked"
        println $line
    })
}

item_add_Click $radioButton1
item_add_Click $radioButton2
item_add_Click $radioButton3
item_add_Click $checkBox1
item_add_Click $checkBox2
item_add_Click $checkBox3

$textBlock.text = "This is a TextBlock.`nYou can't change me"
$textBox.text = "This is a TextBox.`nYou CAN change me"

# Fill DataGrid
$gridrows = @()
for ($i = 1; $i -lt 100; $i += 10) {
    $gridrow = {} | Select i, i2, i3
    $gridrow.i  = $i
    $gridrow.i2 = $i * $i
    $gridrow.i3 = $i * $i * $i
    $gridrows += $gridrow
}

$datagrid.ItemsSource = @($gridrows)

# Fill ListView
$listitems = @()
for ($i = 1; $i -lt 10; $i += 1) {
    $item = {} | Select nameLV,ageLV,genderLV
    if ((Get-Random 2) -lt 1) {
        $item.nameLV = "Sato Taro #" + $i
        $item.genderLV = "Male"
    } else {
        $item.nameLV = "Sato Hanako #" + $i
        $item.genderLV = "Female"
    }
    $item.ageLV = 20 + (Get-Random 10)
    $listitems += $item
}
$listView.ItemsSource = @($listitems)


### TabItem2

# Add callback to Calender
$calender.add_SelectedDatesChanged({
    $selected = $calender.SelectedDate
    println ("" + $selected + " selected")
})

# Add callback to Datapicker
$datepicker.add_SelectedDateChanged({
    $selected = $datepicker.SelectedDate
    println ("" + $selected + " selected")
})


$slider1.Maximum = $ellipse.Width * 3
$slider1.Value = $ellipse.Width
# Add callback to Slider2
$slider1.add_ValueChanged({
    $ellipse.Width = $slider1.Value
})

$slider2.Maximum = $ellipse.Height * 2
$slider2.Value = $ellipse.Height
# Add callback to Slider1
$slider2.add_ValueChanged({
    $ellipse.Height = $slider2.Value
})

### Tab for DockPanel

# Add callback to all MenuItem
$xaml.SelectNodes("//*") | ? {$_.LocalName -eq "MenuItem"} | % {
    $menuItem = $form.FindName($_.Name)
    if ($menuItem.add_click -ne $null) {
        $menuItem.add_Click({println ($this.Name + " Selected")})
    }
}

# Add callback to TreeView items
$treeView.add_SelectedItemChanged({
    println ("" + $treeView.SelectedItem.Header + " Selected")
    $buttonContent.Content = $treeView.SelectedItem.Header
})


### Tab for DocumentViewer

# Fill DocumentView
$xpsDocument = New-Object System.Windows.Xps.Packaging.XpsDocument("$PSScriptRoot\SampleXPS.xps", [System.IO.FileAccess]::Read)
$fds = $xpsDocument.GetFixedDocumentSequence();
$documentViewer.Document = $fds


### Frames tab

# Add callback to Frame1 button
$buttonFrame1.add_Click({
    $uri = New-Object System.Uri("http://www.yahoo.co.jp", [System.UriKind]::Absolute)
    $frame.Navigate($uri)
})

# Add callback to Frame2 button
$buttonFrame2.add_Click({
    $uri = New-Object System.Uri("$PSScriptRoot\Page1.xaml", [System.UriKind]::Absolute)
    $frame.Navigate($uri)
})


### Media tab

# Fill MediaElement
$mediaUri = New-Object System.Uri("$PSScriptRoot\AI-NET-01.avi", [System.UriKind]::Absolute)
$mediaElement.LoadedBehavior = [System.Windows.Controls.MediaState]::Manual
$mediaElement.Source = $mediaUri

# Add callback to each button
$buttonPlay.add_Click({$mediaElement.Play()})
$buttonPause.add_Click({$mediaElement.Pause()})
$buttonStop.add_Click({$mediaElement.Stop()})


# Function to get Checked children items
function getChecked($parent) {
    $checked = @()
    foreach ($child in $parent.Children) {
        if ($child.isChecked) {
            $checked += $child.Content
        }
    }
    return $checked -join ","
}


### ItemTab7

## ToolBarA
$buttonToggleBold.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleBold.Execute($null, $richTextBox)
})
$buttonToggleItalic.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleItalic.Execute($null, $richTextBox)
})
$buttonToggleUnderline.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleUnderline.Execute($null, $richTextBox)
})
$buttonIncreaseFontSize.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::IncreaseFontSize.Execute($null, $richTextBox)
})
$buttonDecreaseFontSize.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::DecreaseFontSize.Execute($null, $richTextBox)
})
$buttonToggleSubscript.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleSubscript.Execute($null, $richTextBox)
})
$buttonToggleSuperscript.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleSuperscript.Execute($null, $richTextBox)
})

## ToolBarB
$buttonToggleBullets.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleBullets.Execute($null, $richTextBox)
})
$buttonToggleNumbering.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::ToggleNumbering.Execute($null, $richTextBox)
})
$buttonAlignLeft.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::AlignLeft.Execute($null, $richTextBox)
})
$buttonAlignCenter.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::AlignCenter.Execute($null, $richTextBox)
})
$buttonAlignRight.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::AlignRight.Execute($null, $richTextBox)
})
$buttonAlignJustify.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::AlignJustify.Execute($null, $richTextBox)
})
$buttonIncreaseIndentation.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::IncreaseIndentation.Execute($null, $richTextBox)
})
$buttonDecreaseIndentation.add_Click({
    $selection = $richTextBox.Selection
    [System.Windows.Documents.EditingCommands]::DecreaseIndentation.Execute($null, $richTextBox)
})


###
# Add callback to buttonCheck to display checked CheckBoxes
$buttonCheck.add_Click({
    $selected_checkBoxes = getChecked($checkBoxes)
    println ("CheckBoxes: " + $selected_checkBoxes + " selected")
})

$result = $form.ShowDialog()
