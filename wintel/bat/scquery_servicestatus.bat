for /f "tokens=2" %s in ('sc query state^= all ^| find "SERVICE_NAME"') do
    @(for /f "tokens=4" %t in ('sc query %s ^| find "STATE     "') do @echo %s is %t)