# load the required assemblies and get the XML document to build the GUI
Add-Type -AssemblyName 'PresentationCore', 'PresentationFramework'
[Xml]$WpfXml = Get-Content -Path 'LogGUI.xaml'

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

# create an ObservableCollection for the log window, when the contents change LogTextBox will be notified
$Sync.LogDataContext = New-Object -TypeName System.Collections.ObjectModel.ObservableCollection[string]
$Sync.LogDataContext.Add('')
$Sync.Gui.LogTextBox.DataContext = $Sync.LogDataContext

Function Write-Log ([string]$Message, [string]$Type = 'Information')
{
    $Prefix = ''
    if ($Type -eq 'Information') {$Prefix = 'INFO: '}
    if ($Type -eq 'Error') {$Prefix = 'ERROR: '}
    $Message = $Prefix + $Message + "`r`n"
    # append to the first item of the ObservableCollection
    $Sync.LogDataContext[0] += $Message
}

# prepare session state for Runspace
$SyncVariable = New-Object 'Management.Automation.Runspaces.SessionStateVariableEntry' `
    -ArgumentList 'Sync', $Sync, ''
$WriteLogDefinition = Get-Content -Path 'function:\Write-Log'
$WriteLogFunction = New-Object 'Management.Automation.Runspaces.SessionStateFunctionEntry' `
    -ArgumentList 'Write-Log', $WriteLogDefinition
$global:SessionState = [Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$SessionState.Variables.Add($SyncVariable)
$SessionState.Commands.Add($WriteLogFunction)

# save the state of $AutoScroll outside the event context so it is not reset on every event
$global:AutoScroll = $true
$Sync.Gui.LogScrollViewer.add_ScrollChanged({
    if ($_.ExtentHeightChange -eq 0)
    {
        if ($Sync.Gui.LogScrollViewer.VerticalOffset -eq $Sync.Gui.LogScrollViewer.ScrollableHeight)
        {
            # if the ScrollViewer is scrolled to the end/bottom enable "auto-scroll"
            $global:AutoScroll = $true
        }
        else
        {
            $global:AutoScroll = $false
        }
    }

    if ($AutoScroll -eq $true -and $_.ExtentHeightChange -ne 0)
    {
        # scroll the ScrollViewer to the end/bottom
        $Sync.Gui.LogScrollViewer.ScrollToVerticalOffset($Sync.Gui.LogScrollViewer.ExtentHeight)
    }
})

# set an example value for the "Command" text box
$Sync.Gui.CommandTextBox.Text = 'Test-Connection -ComputerName 8.8.8.8 -Count 5'

# handle the click event for the "Run" button
$Sync.Gui.RunButton.add_click({
    # create the extra Powershell session and add the script block to execute
    $global:Session = [PowerShell]::Create().AddScript({
        $ErrorActionPreference = 'Stop'
        # make the $Error variable available to the parent Powershell session for debugging
        $Sync.Error = $Error

        # to access objects owned by the parent Powershell session a Dispatcher must be used
        $Sync.Window.Dispatcher.Invoke([Action]{
            # make $Command available outside this Dispatcher call to the rest of the script block
            $script:Command = $Sync.Gui.CommandTextBox.Text
            $Sync.Gui.RunButton.IsEnabled = $false
            $Sync.Gui.CommandStatusText.Content = 'Running'
        })

        try
        {
            # by executing the command in this session the GUI owned by the parent session will remain responsive
            Write-Log "Executing $Command"
            $CommandOutput = (Invoke-Expression -Command $Command) | Out-String
        }
        catch
        {
            $ErrorText = $_.ToString()
            Write-Log $ErrorText -Type 'Error'
        }
        finally
        {
            # now the command has executed the GUI can be updated again 
            $Sync.Window.Dispatcher.Invoke([Action]{
                $Sync.Gui.CommandOutputTextBox.Text = $CommandOutput
                $Sync.Gui.CommandStatusText.Content = 'Waiting'
                $Sync.Gui.RunButton.IsEnabled = $true
            })
        }

    }, $true) # set the "useLocalScope" parameter for executing the script block

    # execute the code in this session
    $Session.Runspace = $Runspace
    $global:Handle = $Session.BeginInvoke()
})

$Sync.Window.add_Loaded({
    # code here will be run at startup and be able to write to the log window if there is an error

    # initalise Runspace
    $global:Runspace = [RunspaceFactory]::CreateRunspace($SessionState)
    $Runspace.ApartmentState = [Threading.ApartmentState]::STA
    $Runspace.Open()

    Write-Log "GUI initialized." 
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