# Het installeren van Apache2, Mysql, PHP, Wordpress, nextcloud, Wireguard

## Deïnstalleren van mogelijke bestaande services:

Misschien heb je nog wat verdwaalde Apache2 (of andere) service draaien of geinstalleerd staan. Die kunnen we verwijderen door de uninstall script te gebruiken: 

### Het zal makkelijk zijn om alles te runnen als root:
#### Misschien moet je nog een root wachtwoord maken:

```
sudo passwd root
```

#### Switch User -> root

```
sudo su 
```

### Download de uninstall.sh script
#### Hier heb je de keuze om Curl of Wget te gebruiken, maakt nu niet uit welke je gebruikt. In dit voorbeeld gaan we voor Wget.

```
wget https://raw.githubusercontent.com/AlbertovanEckeveld/LAMP-WP-PMA-NC-WG-Installscript/main/uninstall.sh
```

#### Zet de rechten juist om hem te kunnen te kunnen uitvoeren:

```
chmod +x uninstall.sh
```

#### Hem vervolgens uitvoeren:

```
./uninstall.sh
```

## Installatie via script:

### Download de install.sh script
#### Hier heb je de keuze om Curl of Wget te gebruiken, maakt nu niet uit welke je gebruikt. In dit voorbeeld gaan we voor Wget.

```
wget https://raw.githubusercontent.com/AlbertovanEckeveld/LAMP-WP-PMA-NC-WG-Installscript/main/install.sh
```

#### Zet de rechten juist om hem te kunnen te kunnen uitvoeren:

```
chmod +x install.sh
```

#### Hem vervolgens uitvoeren:

```
./install.sh
```

