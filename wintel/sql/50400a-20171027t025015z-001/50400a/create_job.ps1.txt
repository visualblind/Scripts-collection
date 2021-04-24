$server=Get-Item \SQL\localhost\default
$job=New-Object Microsoft.SqlServer.Management.Smo.Agent.Job
$Job.parent=$server.JobServer
$job.Name="Backup System Database job"
$job.Create()

$masterstep=New-Object Microsoft.SqlServer.Management.Smo.Agent.JobStep
$masterstep.parent=$job
$masterstep.Name="backup master"
$masterstep.SubSystem="TransactSQL"
$masterstep.Command="BACKUP DATABASE master TO
DISK='D:\Labfiles\Mod01\master.bak'"
$masterstep.OnSuccessAction = "GoToNextStep"
$masterstep.Create()

$modelstep=New-Object Microsoft.SqlServer.Management.Smo.Agent.JobStep
$modelstep.parent=$job
$modelstep.Name="backup model"
$modelstep.SubSystem="TransactSQL"
$modelstep.Command="BACKUP DATABASE model TO
DISK='D:\Labfiles\Mod01\model.bak'"
$modelstep.OnSuccessAction = "GoToNextStep"
$modelstep.Create()