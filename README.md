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

Lees bij: Belangrijke Informatie wat er te doen is tijdens de installatie script bezig is.

## Belangrijke Informatie:

### Tijdens de installatie:

#### Goedkeuring vraag
In het begin zal er 1 keer om een goedkeuring gevraagd worden. Klik Enter en hij zal verder doen. Verder zal hij op alle installatie vragen: "Do you want to continue? [Y / n]" automatisch Accepteren.

#### Vragen voor Certificaat namen:

De volgende vraag zal zijn: "Naam voor certificaten .key & .crt opgeslagen in /etc/ssl" In de opdracht staat dat je je studentennummer moet gebruiken, ik zal dat lekker doen. 

De certificaten zijn opgeslagen in /etc/ssl/private/filename.key en /etc/ssl/certs/filename.crt

#### Check: Handmatige handelingen:

Ik kreeg nu niet even snel voor elkaar om de volgende configuratie te automatiseren.

## Handmatige handelingen:
### Apache2 laten weten waar onze ssl certs te vinden zijn:
```bash
Nano /etc/apache2/sites-available/default-ssl.conf
```
Edit daar de locatie van je certificaten:
```
/etc/ssl/private/filename.key
/etc/ssl/certs/filename.crt
```

#### Restart Apache2
```
systemctl restart apache2
```

### Automatisch een HTTP GET request door sturen naar HTTPS:

```bash
Nano /etc/apache2/sites-available/000-default.conf
```
Voeg ergens tussen de <VirtualHost *:80> en </VirtualHost>
```
Redirect "/" “https://SERVER-IP/”
```

#### Restart Apache2
```
systemctl restart apache2
```

### De Mysql inlog voor wordpress

```bash
Nano /var/www/html/wordpress/wp-config.php
```
Je kan dit 1 op 1 overnemen;
```
// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpressuser' );

/** Database password */
define( 'DB_PASSWORD', 'P@ssw0rd' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

```
#### Restart Apache2
```
systemctl restart apache2
```

### Inlog gegevens:

#### Wordpress:
```
Mysql:

DB: wordpress
US: wordpressuser   ==> 'wordpressuser'@'localhost'
WW: P@ssw0rd
```

#### Nextcloud:
```
Mysql:

DB: nextcloud
US: ncadmin         ==> 'wordpressuser'@'localhost'
WW: P@ssw0rd
```