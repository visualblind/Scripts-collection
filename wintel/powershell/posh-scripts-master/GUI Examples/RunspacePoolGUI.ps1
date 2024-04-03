# load the required assemblies and get the XML document to build the GUI
Add-Type -AssemblyName 'PresentationCore', 'PresentationFramework'
[Xml]$WpfXml = Get-Content -Path 'RunspacePoolGUI.xaml'

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

# create the runspace pool and pass the $Sync variable through
$SessionVariable = New-Object 'Management.Automation.Runspaces.SessionStateVariableEntry' `
    -ArgumentList 'Sync', $Sync, ''
$SessionState = [Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$SessionState.Variables.Add($SessionVariable)
$MaxThreads = 3
$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $MaxThreads, $SessionState, $Host)
$RunspacePool.ApartmentState = [Threading.ApartmentState]::STA
$RunspacePool.Open()

# create a "Jobs" array to track the created runspaces
$Sync.Jobs = [System.Collections.ArrayList]@()

# handle the click event for the "Run" button
$Sync.Gui.RunButton.add_click({
    # create the extra Powershell session and add the script block to execute
    $Session = [PowerShell]::Create().AddScript({
        # to access objects owned by the parent Powershell session a Dispatcher must be used
        $Sync.Window.Dispatcher.Invoke([Action]{
            # make $Command available outside this Dispatcher call to the rest of the script block
            $script:Command = $Sync.Gui.CommandText.Text
        })

        # by executing the command in this session the GUI owned by the parent session will remain responsive
        $Output = (Invoke-Expression -Command $Command) | Out-String

        # display the output of the command in the text block
        $Sync.Window.Dispatcher.Invoke([Action]{
            $Sync.Gui.OutputText.AppendText($Output)
        })
    }, $true) # set the "useLocalScope" parameter for executing the script block

    # execute the code in this session
    $Session.RunspacePool = $RunspacePool
    $Handle = $Session.BeginInvoke()
    $Sync.Jobs.Add([PSCustomObject]@{
        'Session' = $Session
        'Handle' = $Handle
    })
})

# update the command queue count
$Sync.Gui.RefreshButton.add_click({
    $Queue = 0
    foreach($Job in $Sync.Jobs)
    {
        $Queue += if ($Job.Handle.IsCompleted -eq $false) { 1 } else { 0 }
    }
    $Sync.Gui.OutputQueueText.Content = $Queue
})

# check if a job is still running when exiting the GUI
$Sync.Window.add_closing({
    $Queue = 0
    foreach($Job in $Sync.Jobs)
    {
        $Queue += if ($Job.Handle.IsCompleted -eq $false) { 1 } else { 0 }
    }

    if ($Queue -gt 0)
    {
        [Windows.MessageBox]::Show('A command is still running.')
        # the event object is automatically passed through as $_
        $_.Cancel = $true
    }
})

# close the runspaces cleanly when exiting the GUI
$Sync.Window.add_closed({
    foreach($Job in $Sync.Jobs)
    {
        if ($Job.Session.IsCompleted -eq $true)
        {
            $Job.Session.EndInvoke($Job.Handle)
        }
        $RunspacePool.Close()
    } 
})

# display the GUI
$Sync.Window.ShowDialog() | Out-Null