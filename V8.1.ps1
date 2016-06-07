#Cette version est destinée pour les ordiateurs sous Windows 8.1 et ne MARCHE QUE SOUS CET OS.

# Retrieve main info
$User = $env:username                           # Gives the username
$Computer = $env:computername                   # Gives the computer name
$Current_Time = Get-Date                        # Gives the actual date

# Path's declaration
$log ="C:\TEMP\log.txt"	      # Path of "log.txt". Memorising the results.
$sql ="C:\TEMP\sql.txt"       # Path of "sql.txt". Keeping in memory state of eventID 4797
$valeur ="C:\TEMP\valeur.txt"	# Path of "valeur.txt". Kepping in memory the time of eventID 4797

# I. Get the time of the event "successful logon"

# Event ID:7001 in System, Winlogon
$filterXML = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Winlogon'] and (Level=4 or Level=0) and (EventID=7001)]]</Select>
  </Query>
</QueryList>
'@
# Retrieve the newest event filtered
$LogonDateTime=(Get-WinEvent -MaxEvents 1 -FilterXml $filterXML -ErrorAction SilentlyContinue).timecreated

# II. Retrieve the time of the event "Desktop ready"
# The informaton is retrieved from "valeur.txt". His path is defined with $valeur
$DesktopTime =Get-Content ($valeur)
$LogonDateTime = $LogonDateTime.Ticks

# III. Calculation of opening session's time
# Since it's in ticks (10 000 000 ticks = 1 second) we divide it by 10M
$LogonDuration = [math]::Round(($DesktopTime - $LogonDateTime)/10000000)

# IV. Reset status of "valeur.txt" and "sql.txt"
new-item $sql -type file -force                 # Reset state of event 4797
ADD-content -path $sql -value "0" 		        # Inserting 0 the file
new-item $valeur -type file -force              # Reset value of event 4797

# V.1 Enter the results in a log file
new-item $log -type file -force
ADD-content -path $log -value "`ntemps : $Current_Time" 			#Rentre dans le fichier log le résultat
ADD-content -path $log -value "`nutilisateur : $User" 				#Rentre dans le fichier log le résultat
ADD-content -path $log -value "`nordinateur : $Computer" 			#Rentre dans le fichier log le résultat
ADD-content -path $log -value "`nlogon duration in seconds : $LogonDuration" 	#Rentre dans le fichier log le résultat

# V.2 Enter the results in a sql base

#START SQL Injection Section
#[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

#$sqlServer = "SQLserver01"
#$dbName = "BootUpTimes"
#$tbl = "tblBootUpTimes"
#$srv = New-Object Microsoft.SqlServer.Management.Smo.Server $sqlServer
#$db = $srv.databases[$dbName]
#$conn = New-Object System.Data.SqlClient.SqlConnection("Data Source=$sqlServer;Initial Catalog=$dbName; Integrated Security=SSPI")
#$conn = New-Object System.Data.SqlClient.SqlConnection("server=$sqlServer;database=$dbName;Password=plaintext;User Id=BootUpTimes")
#$conn.Open()
#$cmd = $conn.CreateCommand()
#$cmd.CommandText = "INSERT INTO $tbl VALUES #('$Current_Time','$User','$Computer','$LogonDuration')"
#Try
#{
#$null = $cmd.ExecuteNonQuery()
#}
#Catch
#{
#}
#$conn.Close()
