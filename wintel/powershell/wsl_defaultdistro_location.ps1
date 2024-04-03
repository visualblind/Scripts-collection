# obtain the value of the ID of the default Linux distribution (and store it in a variable to avoid escaping characters issues):
$DEFAULT_LXSS_ID = (Get-ItemPropertyValue -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\ -name DefaultDistribution)

# which will have a value like:
echo  $DEFAULT_LXSS_ID
{bde539d6-0c87-4e12-9599-1dcd623fbf07}

# display the directory containing the rootfs Windows directory (mapped to the / Linux directory)
Get-ItemPropertyValue -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\$DEFAULT_LXSS_ID -name BasePath | Format-List -property "BasePath"
%LocalAppData%\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState