# load the required assemblies and get the XML document to build the GUI
Add-Type -AssemblyName 'PresentationCore', 'PresentationFramework'
[Xml]$WpfXml = Get-Content -Path 'RunspaceGUI.xaml'

# remove attributes from XML that cause problems with initializing the XAML object in Powershell
$WpfXml.Window.RemoveAttribute('x:Class')
$WpfXml.Window.RemoveAttribute('mc:Ignorable')
# initialize the XML Namespaces so they can be used later if required
$WpfNs = New-Object -TypeName Xml.XmlNamespaceManager -ArgumentList $WpfXml.NameTable
$WpfNs.AddNamespace('x', $WpfXml.DocumentElement.x)
$WpfNs.AddNamespace('d', $WpfXml.DocumentElement.d)
$WpfNs.AddNamespace('mc', $WpfXml.DocumentElement.mc)

# create a thread-safe Hashtable to pass data between the Powershell sessions/threads
$Sync = [Hashtable]::Synchronized(@{})
$Sync.Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $WpfXml))

# add a "sync" item to reference the GUI control objects to make accessing them easier
$Sync.Gui = @{}
foreach($Node in $WpfXml.SelectNodes('//*[@x:Name]', $WpfNs))
{
    # get all the XML elements that have an x:Name attribute, these will be controls we want to interact with
    $Sync.Gui.Add($Node.Name, $Sync.Window.FindName($Node.Name))
}

# set an example value for the "Command" text box
$Sync.Gui.CommandText.Text = 'Test-Connection -ComputerName 8.8.8.8 -Count 5'

# create the runspace and pass the $Sync variable through
$Runspace = [RunspaceFactory]::CreateRunspace()
$Runspace.ApartmentState = [Threading.ApartmentState]::STA
$Runspace.Open()
$Runspace.SessionStateProxy.SetVariable('Sync',$Sync)

# handle the click event for the "Run" button
$Sync.Gui.RunButton.add_click({
    # create the extra Powershell session and add the script block to execute
    $global:Session = [PowerShell]::Create().AddScript({
        # make the $Error variable available to the parent Powershell session for debugging
        $Sync.Error = $Error
        # to access objects owned by the parent Powershell session a Dispatcher must be used
        $Sync.Window.Dispatcher.Invoke([Action]{
            # make $Command available outside this Dispatcher call to the rest of the script block
            $script:Command = $Sync.Gui.CommandText.Text
            $Sync.Gui.RunButton.IsEnabled = $false
            $Sync.Gui.OutputStatusText.Content = 'Running'
        })
        # by executing the command in this session the GUI owned by the parent session will remain responsive
        $Output = (Invoke-Expression -Command $Command) | Out-String

        # now the command has executed the GUI can be updated again 
        $Sync.Window.Dispatcher.Invoke([Action]{
            $Sync.Gui.OutputText.Text = $Output
            $Sync.Gui.OutputStatusText.Content = 'Waiting'
            $Sync.Gui.RunButton.IsEnabled = $true
        })
    }, $true) # set the "useLocalScope" parameter for executing the script block

    # execute the code in this session
    $Session.Runspace = $Runspace
    $global:Handle = $Session.BeginInvoke()
})

# check if a command is still running when exiting the GUI
$Sync.Window.add_closing({
    if ($Session -ne $null -and $Handle.IsCompleted -eq $false)
    {
        [Windows.MessageBox]::Show('A command is still running.')
        # the event object is automatically passed through as $_
        $_.Cancel = $true
    }
})

# close the runspace cleanly when exiting the GUI
$Sync.Window.add_closed({
    if ($Session -ne $null) {$Session.EndInvoke($Handle)}
    $Runspace.Close()
})

# display the GUI
$Sync.Window.ShowDialog() | Out-Null