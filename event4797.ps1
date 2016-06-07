$sql ="C:\Users\thibault\Desktop\sql.txt"	#chemin d'accès du fichier log
$valeur ="C:\Users\thibault\Desktop\valeur.txt"	#chemin d'accès du fichier log
$etat = Get-Content ($sql)
if ($etat -eq 0){

   $filterXML = @'
    <QueryList>
        <Query Id="0" Path="Security">
            <Select Path="Security">*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and (EventID=4797)]]</Select>
        </Query>
    </QueryList>
'@

    $DesktopTime=(Get-WinEvent -MaxEvents 1 -FilterXml $filterXML -ErrorAction SilentlyContinue).timecreated
    $DesktopTime = $DesktopTime.Ticks
    new-item $sql -type file -force
    new-item $valeur -type file -force
    ADD-content -path $sql -value "1" 		#Rentre dans le fichier SQL le résultat
    ADD-content -path $valeur -value "$DesktopTime" 		#Rentre dans le fichier SQL le résultat
    }