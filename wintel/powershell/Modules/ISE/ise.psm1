# .Link
# https://go.microsoft.com/fwlink/?LinkID=225298
# .ExternalHelp ISE.psm1-help.xml
function New-IseSnippet
{
    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$true, Position=0)]
        [String]
        $Title,
        
        [Parameter(Mandatory=$true, Position=1)]
        [String]
        $Description,
        
        [Parameter(Mandatory=$true, Position=2)]
        [String]
        $Text,

        [String]
        $Author,

        [Int32]
        [ValidateRange(0, [Int32]::MaxValue)]
        $CaretOffset = 0,

        [Switch]
        $Force
    )

    Begin
    {
        $snippetPath = Join-Path (Split-Path $profile.CurrentUserCurrentHost) "Snippets"
        
        if($Text.IndexOf("]]>") -ne -1)
        {
            throw [Microsoft.PowerShell.Host.ISE.SnippetStrings]::SnippetsNoCloseCData -f "Text","]]>"
        }

        if (-not (Test-Path $snippetPath))
        {
            $null = mkdir $snippetPath
        }
    }

    End
    {
        $snippet = @"
<?xml version='1.0' encoding='utf-8' ?>
    <Snippets  xmlns='http://schemas.microsoft.com/PowerShell/Snippets'>
        <Snippet Version='1.0.0'>
            <Header>
                <Title>$([System.Security.SecurityElement]::Escape($Title))</Title>
                <Description>$([System.Security.SecurityElement]::Escape($Description))</Description>
                <Author>$([System.Security.SecurityElement]::Escape($Author))</Author>
                <SnippetTypes>
                    <SnippetType>Expansion</SnippetType>
                </SnippetTypes>
            </Header>

            <Code>
                <Script Language='PowerShell' CaretOffset='$CaretOffset'>
                    <![CDATA[$Text]]>
                </Script>
            </Code>

    </Snippet>
</Snippets>

"@

        $pathCharacters = '/\`*?[]:><"|.';
        $fileName=new-object text.stringBuilder
        for($ix=0; $ix -lt $Title.Length; $ix++)
        {
            $titleChar=$Title[$ix]
            if($pathCharacters.IndexOf($titleChar) -ne -1)
            {
                $titleChar = "_"
            }

            $null = $fileName.Append($titleChar)
        }

        $params = @{
            FilePath = "$snippetPath\$fileName.snippets.ps1xml";
            Encoding = "UTF8"
        }

        if ($Force)
        {
            $params["Force"] = $true
        }
        else
        {
            $params["NoClobber"] = $true
        }

        $snippet | Out-File @params

        $psise.CurrentPowerShellTab.Snippets.Load($params["FilePath"])
    }
}

# .Link
# https://go.microsoft.com/fwlink/?LinkId=242050
# .ExternalHelp ISE.psm1-help.xml
function Import-IseSnippet
{
    [CmdletBinding(DefaultParameterSetName="FromFolder")]
    param(
    
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="FromFolder")]
        [String]
        $Path,

        [Parameter()]
        [Switch]
        $Recurse,
        
        [Parameter(Mandatory=$true, ParameterSetName="FromModule")]
        [String]
        $Module,

        [Parameter(ParameterSetName="FromModule")]
        [Switch]
        $ListAvailable
    )

    End
    {
        if ($Path)
        {
            dir "$Path\*.snippets.ps1xml" -Recurse:$Recurse | 
                    % {$psise.CurrentPowerShellTab.Snippets.Load($_)}
        }
        elseif ($Module)
        {
            if($ListAvailable)
            {
                $m = Get-Module $module -ListAvailable
            }
            else
            {
                $m = Get-Module $module
            }

            if (-not $m)
            {
                Write-Error ([Microsoft.PowerShell.Host.ISE.SnippetStrings]::ModuleNotFound)
            }

            foreach ($x in $m)
            {
                # Get the module path and validate that there is a Snippets folder
                $snipPath = Split-Path ($x.Path) -Parent
                if (Test-Path "$snipPath\Snippets")
                {
                    dir "$snipPath\Snippets\*.snippets.ps1xml" -Recurse:$Recurse | 
                            % {$psise.CurrentPowerShellTab.Snippets.Load($_)}
                }
                else
                {
                    Write-Verbose ([Microsoft.PowerShell.Host.ISE.SnippetStrings]::NoSnippetsInModule -f $x.Name,"Snippets")
                }
            }
        }
    }
}

# .Link
# https://go.microsoft.com/fwlink/?LinkID=238787
# .ExternalHelp ISE.psm1-help.xml
function Get-IseSnippet
{
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param()
    $snippetPath = Join-Path (Split-Path $profile.CurrentUserCurrentHost) "Snippets"
    if (Test-Path $snippetPath)
    {
        dir $snippetPath
    }
}
