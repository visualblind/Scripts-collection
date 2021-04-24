Get-AppxPackage -AllUsers | Select PackageFullName
Get-AppxPackage | Select PackageFullName

(Get-AppxPackage -Name "*Microsoft*" | Get-AppxPackageManifest).package.applications.application.id

Get-AppxPackage -AllUsers PackageFullName | Remove-AppxPackage

Get-AppxPackage | ? {$_.name –notlike "*store*"} | ? {$_.name –notlike "*communicationsapps*"} | ? {$_.name –notlike "*people*"} | ? {$_.name –notlike "*Edge*"} | ? {$_.name –notlike "*Microsoft.NET*"} | ? {$_.name –notlike "*Microsoft.VCLibs*"} | ? {$_.name –notlike "*ShellExperienceHost*"} | ? {$_.name –notlike "*Photos*"} | ? {$_.name –notlike "*Calc*"} | Remove-AppxPackage
Get-AppxPackage -AllUsers | ? {$_.name –notlike "*store*"} | ? {$_.name –notlike "*communicationsapps*"} | ? {$_.name –notlike "*people*"} | ? {$_.name –notlike "*Edge*"} | ? {$_.name –notlike "*Microsoft.NET*"} | ? {$_.name –notlike "*Microsoft.VCLibs*"} | ? {$_.name –notlike "*ShellExperienceHost*"} | ? {$_.name –notlike "*Photos*"} | ? {$_.name –notlike "*Calc*"} | Remove-AppxPackage

#Restore Apps
Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

Get-AppXProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online


echo "Uninstalling default apps"
$apps = @(
# default Windows 10 apps
"Microsoft.BingWeather"
"Microsoft.Getstarted"
"Microsoft.ZuneMusic"
"Microsoft.3DBuilder"
"Microsoft.MicrosoftSolitaireCollection"
"Microsoft.Office.OneNote"
"Microsoft.MicrosoftOfficeHub"
"Microsoft.People"
"Microsoft.OneConnect"
"Microsoft.WindowsMaps"
"Microsoft.ZuneVideo"
"Microsoft.SkypeApp"
"Microsoft.Messaging"
"AdobeSystemsIncorporated.AdobePhotoshopExpress"
"*PicsArt*"
"*BingTranslator*"
"*ZuneMusic*"
"*BingWeather*"
"*Duolingo*"
"*Flipboard*"
"*Microsoft.NetworkSpeedTest*"
"*Wunderlist*"
"*EclipseManager*"
"*FreshPaint*"
"*Advertising*"
"*windowscommunicationsapps*"
"*feedbackhub*"
# apps which cannot be removed using Remove-AppxPackage
#"Microsoft.BioEnrollment"
#"Microsoft.AAD.BrokerPlugin"
#"Microsoft.MicrosoftEdge"
#"Microsoft.Windows.Cortana"
#"Microsoft.WindowsFeedback"
#"Microsoft.XboxGameCallableUI"
#"Microsoft.XboxIdentityProvider"
#"Windows.ContactSupport"
)

foreach ($app in $apps) {
echo "Trying to remove $app"

Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage

Get-AppxPackage $app -AllUsers | Remove-AppxPackage

Get-AppXProvisionedPackage -Online |
? DisplayName -EQ $app |
Remove-AppxProvisionedPackage -Online

Get-AppXProvisionedPackage -Online |
? {$_.packagename –like $app} |
Remove-AppxProvisionedPackage -Online
}