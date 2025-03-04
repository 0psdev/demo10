$Env:TF_VAR_tenant_id=(Get-AzTenant).id

$Env:TF_VAR_subscription_id=(Get-AzSubscription | where-object {$_.Name -eq "Main Subscription"}).id
