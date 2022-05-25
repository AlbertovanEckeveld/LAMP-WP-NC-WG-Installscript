# Installatie script

Bij het uitvoeren van de onderstaande commando's installeer je: LAMP, Nextcloud, Wordpress, WireGuard 

## Deïnstalleren van mogelijke bestaande services:

Misschien heb je nog wat verdwaalde Apache2 (of andere) service draaien of geinstalleerd staan. Die kunnen we verwijderen door de uninstall script te gebruiken: 

### Het zal makkelijk zijn om alles te runnen als root:
#### Misschien moet je nog een root wachtwoord maken:

```bash
sudo passwd root
```

#### Switch User -> root

```bash
sudo su 
```

### Download de uninstall.sh script
#### Hier heb je de keuze om Curl of Wget te gebruiken, maakt nu niet uit welke je gebruikt. In dit voorbeeld gaan we voor Wget.

```bash
wget https://raw.githubusercontent.com/AlbertovanEckeveld/LAMP-WP-PMA-NC-WG-Installscript/main/uninstall.sh
```

#### Zet de rechten juist om hem te kunnen te kunnen uitvoeren:

```bash
chmod +x uninstall.sh
```

#### Hem vervolgens uitvoeren:

```bash
./uninstall.sh
```

## Installatie via script:

### Download de install.sh script
#### Hier heb je de keuze om Curl of Wget te gebruiken, maakt nu niet uit welke je gebruikt. In dit voorbeeld gaan we voor Wget.

```bash
wget https://raw.githubusercontent.com/AlbertovanEckeveld/LAMP-WP-PMA-NC-WG-Installscript/main/install.sh
```

#### Zet de rechten juist om hem te kunnen te kunnen uitvoeren:

```bash
chmod +x install.sh
```

#### Hem vervolgens uitvoeren:

```bash
./install.sh
```

## Handmatige handelingen:

```

```

## Belangrijke Informatie:

