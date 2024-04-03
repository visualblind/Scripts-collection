$module = $MyInvocation.MyCommand.ScriptBlock.Module
$module.OnRemove = {Reset-IISServerManager -Confirm:$false}
