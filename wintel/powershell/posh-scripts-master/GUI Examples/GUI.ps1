# load the required assemblies and get the XML document to build the GUI
Add-Type -AssemblyName 'PresentationCore', 'PresentationFramework'
[Xml]$WpfXml = Get-Content -Path 'GUI.xaml'

# remove attributes from XML that cause problems with initializing the XAML object in Powershell
$WpfXml.Window.RemoveAttribute('x:Class')
$WpfXml.Window.RemoveAttribute('mc:Ignorable')
# initialize the XML Namespaces so they can be used later if required
$WpfNs = New-Object -TypeName Xml.XmlNamespaceManager -ArgumentList $WpfXml.NameTable
$WpfNs.AddNamespace('x', $WpfXml.DocumentElement.x)
$WpfNs.AddNamespace('d', $WpfXml.DocumentElement.d)
$WpfNs.AddNamespace('mc', $WpfXml.DocumentElement.mc)

# initialize the main window object from the XAML file
$Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $WpfXml))

$Gui = @{}
foreach($Node in $WpfXml.SelectNodes('//*[@x:Name]', $WpfNs))
{
    # get all the XML elements that have an x:Name attribute, these will be controls we want to interact with
    $Gui.Add($Node.Name, $Window.FindName($Node.Name))
}

# set an example value for the "Command" text box
$Gui.CommandText.Text = 'Test-Connection -ComputerName 8.8.8.8 -Count 5'

# handle the click event for the "Run" button
$Gui.RunButton.add_click({
    # get the string from the "Command" text box, this will be the command that is run
    $Command = $Gui.CommandText.Text
    $Output = (Invoke-Expression -Command $Command) | Out-String
    # display the output of the command by updating the output text box 
    $Gui.OutputText.AppendText($Output)
})

# display the GUI
$Window.ShowDialog() | Out-Null