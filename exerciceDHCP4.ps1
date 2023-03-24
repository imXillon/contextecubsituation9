##############################
# exerciceDHCP4.ps1          #
# Antoine Ribeiro            #
##############################
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
# Demander à l'utilisateur le nombre d'étendues à créer

$nombreEtendues = [Microsoft.VisualBasic.Interaction]::InputBox("Nombre d'étendues à créer","Entrez le nombre d'étendues à créer","")

# Boucle pour créer chaque étendue
for ($i=1; $i -le $nombreEtendues; $i++) {

    # Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP

    $nomEtendue = [Microsoft.VisualBasic.Interaction]::InputBox("Nom de l'étendue DHCP","Entrez le nom de l'étendue DHCP","")
    $adresseReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse réseau de l'étendue DHCP : ","")
    $masqueSousReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Masque de sous-réseau de l'étendue : ","")
    $premiereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Première adresse à distribuer : ","")
    $derniereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Dernière adresse à distribuer : ","")
    $passerelle = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse de la passerelle à diffuser : ","")
    $domaine = [Microsoft.VisualBasic.Interaction]::InputBox("Nom de domaine à diffuser : ","")
    $serveurDNS = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse dns à diffuser : ","")

    # Afficher les informations saisies
    Write-Host "Voici les informations saisies :"
    Write-Host "Nom de l'étendue : $nomEtendue"
    Write-Host "Adresse réseau de l'étendue DHCP : $adresseReseau"
    Write-Host "Masque de sous-réseau de l'étendue : $masqueSousReseau"
    Write-Host "Première adresse à distribuer : $premiereAdresse"
    Write-Host "Dernière adresse à distribuer : $derniereAdresse"
    Write-Host "Adresse de la passerelle à diffuser : $passerelle"
    Write-Host "Nom de domaine à diffuser : $domaine"
    Write-Host "Adresse dns à diffuser : $serveurDNS"

    $messageConfirmation = "Êtes-vous sûr de vouloir créer l'étendue DHCP suivante ?`n`n" +
                          "Nom de l'étendue DHCP : $nomEtendue`n" +
                          "Adresse réseau : $adresseReseau`n" +
                          "Masque de sous-réseau : $masqueSousReseau`n" +
                          "Première adresse à attribuer : $premiereAdresse`n" +
                          "Dernière adresse à attribuer : $derniereAdresse`n" +
                          "Adresse de passerelle à diffuser : $passerelle`n" +
                          "Nom du domaine : $domaine`n" +
                          "Adresse du domaine : $serveurDNS"

    # Demander confirmation à l'utilisateur
    $confirmation = [System.Windows.Forms.MessageBox]::Show($messageConfirmation, "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YESNO)


    # Si l'utilisateur confirme, créer l'étendue DHCP
    if ($confirmation -eq "YES") {
        Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse `
            -SubnetMask $masqueSousReseau -Description "Etendue DHCP créée par script PowerShell"
    
        # Spécifier l'adresse de la passerelle
        Set-DhcpServerv4OptionValue -ScopeID $adresseReseau -Router $passerelle
        Set-DhcpServerv4OptionValue -ScopeID $adresseReseau -DnsDomain $domaine
        Set-DhcpServerv4OptionValue -ScopeID $adresseReseau -DnsServer $serveurDNS
    
        # Afficher le résultat de la commande
        Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize
    } else {
        Write-Host "Annulation de la création de l'étendue DHCP."
    }
 }