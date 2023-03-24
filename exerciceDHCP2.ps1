##############################
# exerciceDHCP2.ps1          #
# Antoine Ribeiro            #
##############################

# Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP
$nomEtendue = Read-Host "Nom de l'étendue : "
$adresseReseau = Read-Host "Adresse réseau de l'étendue DHCP : "
$masqueSousReseau = Read-Host "Masque de sous-réseau de l'étendue : "
$premiereAdresse = Read-Host "Première adresse à distribuer : "
$derniereAdresse = Read-Host "Dernière adresse à distribuer : "
$passerelle = Read-Host "Adresse de la passerelle à diffuser : "
$domaine = Read-Host "Nom de domaine à diffuser : "
$serveurDNS = Read-Host "Adresse dns à diffuser : "

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

# Demander confirmation à l'utilisateur
$confirmation = Read-Host "Voulez-vous créer cette étendue DHCP ? (Oui/Non)"

# Si l'utilisateur confirme, créer l'étendue DHCP
if ($confirmation -eq "O") {
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