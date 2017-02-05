# QKunst collectiebeheer

[![Build Status](https://travis-ci.org/qkunst/collectiebeheer.svg?branch=master)](https://travis-ci.org/qkunst/collectiebeheer)

Dit is de broncode van de QKunst Collectiebeheer applicatie, vrijgegeven onder een AGPL (GNU Affero General Public License v3.0) opensource licentie. Zie ook [LICENSE](LICENSE).
Deze web applicatie stelt u in staat om kunstwerken binnen uw collectie te bekijken en, afhankelijk van de u toegewezen rol, te beheren.

## Over QKunst Collectiebeheer

[QKunst](http://qkunst.nl) is gespecialiseerd in het inventariseren van grote bedrijfscollecties. Om deze inventarisaties
nog soepeler te laten verlopen ontwikkelden wij QKunst Collectiebeheer, een web applicatie voor collectiebeheer.
Hiermee worden grote hoeveelheden informatie over een collectie toegankelijk en kunnen we uitgebreide rapportages uitdraaien.
De applicatie wordt continu doorontwikkeld om de gebruiksvriendelijkheid ervan te vergroten.

## Functies

### Zoeken in de collectie

Voor het zoeken wordt onderliggend gebruik gemaakt van ElasticSearch. Deze kent een krachtig taaltje dat veel
queries mogelijk maakt. De belangrijkste zijn:

* *~*: fuzzy~ (ik weet de juiste spelling niet van dit woord, maar ik kan een paar letters verkeerd )
* ***: hottentottente* (het woord begint zo, maar verder…; hotten*tentoonstelling (het woord begint en eindigd zo…; *tentoonstelling (woord dat eindigt op tentoonstelling)
* *?*: l?tter (als je een letter niet meer weet)
* *OR*: Als een van de woorden er in moet voorkomen ("schretlen paard", levert 13 werken op (impliciet wordt "schretlen AND paard" uitgevoerd), "schretlen OR paard” levert 53 werken op).
* *()*: "(schretlen OR paard) AND direct inzetbaar” (iets met schretlen of met een paard én direct inzetbaar).

Wanneer geen van dit soort tekens / commando's worden gebruikt wordt getracht de applicatie 'fuzzy' te doorzoeken; hetgeen betekend dat de zoekmachine iets vergevingsgezinder is t.a.v. typfouten/spelfouten.

### Langere teksten

Vele van de langere teksten in de applicatie kunnen worden opgemaakt middels MarkDown

## Installatie

De meest actuele versie van deze handleiding zal altijd terug te vinden zijn in
de source code (README.md). Deze handleiding verondersteld basiskennis Linux.
Wanneer je reeds ervaring hebt met Capistrano voor de uitrol van applicaties zal
deze handleiding grotendeels overbodig zijn.

### Server

Zorg voor een server die in staat is om Rails applicaties te draaien. De QKunst Collectiedatabase draait op moment van schrijven op een Debian Jessie server met voorgeïnstalleerd de volgende zaken:

* postgresql
* nginx
* imagemagick
* elasticsearch
* passenger
* Ruby 2.3.3 (geïnstalleerd via rbenv)

Ruby wordt geïnstalleerd via rbenv, dit is een systeem om verschillende ruby-versies te kunnen ondersteunen. Installatie instructies hiervoor zijn te vinden op de [rbenv-soursecode pagina](https://github.com/rbenv/rbenv).

Op het moment van schrijven worden de volgende repositories hiervoor geraadpleegd:

    deb http://debian.directvps.nl/debian jessie main
    deb http://debian.directvps.nl/security jessie/updates main
    deb http://packages.elastic.co/elasticsearch/1.7/debian stable main
    deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main

Op ElasticSearch en Passenger na worden dus de standaard door Debian geleverde versies gehanteerd en alle server pakketten worden dagelijks automatisch voorzien van veiligheidsupdates. Voor een basis inrichting kan het volgende artikel worden geraadpleegd:

* [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano)

### Over versies & OTAP

Er is een ontwikkelstraat, een teststraat, een acceptatie-straat en een productiestraat.

De code zelf staat in een git-repository. Deze kent twee branches, develop en master, en waar nodig tijdelijke feature branches. De code op de develop branch wordt geïnstalleerd op de staging server, de master branch wordt na goedkeuring van de werking door QKunst geïnstalleerd op de applicatie server voor productie.

De code in develop wordt ook gebruikt om actief in te ontwikkelen. Deze wordt ook uitgerold op de acceptatie-server. Automatische tests vinden op beide branches plaats, en zijn ingeregeld op travisci.

Er worden geen versienummers toegekend, de applicatie is in principe continue in ontwikkeling. Er kan gecommuniceerd worden over de geïnstalleerde versie dmv commit ids, een lange string die op basis van datum en tijd en omgeving gemakkelijk teruggevonden kan worden in het deployment logboek dat automatisch door de deployment-tool wordt bijgehouden.

Updates van de applicatie worden door de leverancier van de software uitgevoerd middels Capistrano, maar een ander update mechanisme kan gebruikt worden. Door gebruik te maken van Capistrano kunnen updates op de acceptatie en productie omgevingen bijna onmerkbaar uitgevoerd worden.

### Inrichting ontwikkelomgeving

Verondersteld dat git en alle andere eerder genoemde server software aanwezig is op het ontwikkelsysteem (op nginx en passenger na).
Op macOS kunnen deze pakketten eventueel ook via homebrew worden geinstalleerd.
Of de applicatie op Windows zou kunnen draaien is onduidelijk. Een *nix-achtig systeem wordt (eigenlijk altijd) aanbevolen.

Clone de repository:

    git clone https://github.com/qkunst/collectiebeheer.git

De commando's die volgen worden allemaal uitgevoerd in de project folder, dus
navigeer hier naartoe (`cd collectiebeheer`)

#### Installatie afhankelijkheden

De QKunst collectiedatabase is gebaseerd op het Ruby On Rails framework en andere opensource libraries, zogenaamde gems. Deze zijn gemakkelijk te installeren middels het bundler commando:

    bundle install

Is het commando `bundle` niet aanwezig op het systeem, typ dan eerst `gem install bundler`.

#### Inrichting van de database

Het Ruby on Rails framework komt met een ingebouwd migratiesysteem om een volledige database in te richten. Hiervoor dient de connectie met de database server geconfigureerd worden. Dit kan in het bestand database.yml.
Na configuratie dient het volgende commando uitgevoerd te worden:

    RAILS_ENV=production rails db:migrate

Het bestand [db/schema.rb](db/schema.rb) kan geraadpleegt worden om een indruk te krijgen van alle tabellen.

#### Applicatie starten

De applicatie kan nu gestart worden middels het commando

    rails s

#### Aanmaken van een eerste admin gebruiker

Om gebruikers rechten te kunnen geven is een administrator-account nodig. Een administrator kan ook andere gebruikers tot administrator benoemen, maar
de eerste gebruiker dient handmatig tot administrator worden benoemd. Doorloop de reguliere registratie methode, en open de console:

    rails c [environment_name]

(de environment_name is standaard 'development' (voor lokale ontwikkeling, op server typ hier 'production' (zonder aanhalingstekens))

Type vervolgens de volgende commando's:

    u = User.where(email: jouw_email).first
    u.admin = true
    u.save

De gebruiker met 'jouw_email' als e-mailadres kan vervolgens andere gebruikers administrator rechten geven etc.

### Installatie van de applicatie op een server voor acceptatie en productie

Zorg dat de server gereed is voor gebruik: [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano).

We gebruiken Capistrano wat de uitrol vergemakkelijkt. Hiervoor is het noodzakelijk dat
capistrano goed wordt geconfigureerd. Zie voor een voorbeeld bestand config/deploy/production.rb.example.
('.example' moet vanzelfsprekend verwijderd worden na het correct hebben geconfigureerd van de server).

Draai nu:

    cap production deploy

De eerste keer zal deze falen, maar door het eenmaal te draaien worden veel van de standaard
directories klaargezet op de server.

Vervolgens is het zaak om de `database.yml` en `secrets.yml` configuratie voor productie gereed te zetten.
Dit is een eenmalige operatie die plaats vind op de server. De structuur is gelijk aan de config/database.yml en config/secrets.yml files, maar
de files in deze repository bevatten (om veiligheidsredenen) geen productiegegevens.

Kopieer deze bestanden naar de server in de `shared/config` folder (de folder `shared` zal na `cap production deploy` al aangemaakt zijn)

Meer over het configureren van Rails applicaties, zoals deze, raadpleeg de Rails documentatie: [Configuring Rails Applications](http://guides.rubyonrails.org/configuring.html).

### De applicatie draaien op andere omgevingen.

Rails bied ook ondersteuning voor andere databases, en draait ook op diverse servers-typen.
We testen echter niet actief in andere omgevingen dan de hierboven beschreven omgeving.
De applicatie wordt echter wel ontwikkeld op een macOS systeem.

## Backup

### Herstellen met een databasebackup

Er wordt dagelijks een pg_dump gedaan van alle informatie in de database. Deze wordt beveiligd opgeslagen en verstuurd op de server en bij QKunst en bij de leverancier. Deze backups zijn niet te gebruiken door een enkele afnemer van de QKunst collectiedatabase omdat deze informatie bevat van alle klanten. Wel is deze backup te gebruiken om een backup terug te halen.

### Herstellen met een export

Eigenaren van een collectie kunnen een export maken (een excel bestand en een zip bestand met alle foto's). Deze export kan vervolgens gebruikt worden om collectie opnieuw te importeren middels de standaard import functie.
Toegangsrechten dienen wel opnieuw ingesteld te worden.

## Bijdragen aan de applicatie

1. Clone deze repository
2. Maak nieuwe functionaliteit in een feature branch
3. Vraag een pull request aan en beschrijf wat je hebt aangepast
4. Wees behulpzaam en vriendelijk bij evt. vragen van de maintainer (QKunst)

## API

### Token based authentication

To authenticate the user has to send a token-header with every request, a token that is a bcrypted string representing
the external ip, the url and the secret api key:

    data = "#{self.externalip}#{url}#{method}#{request_body}"
    user_id # known user id; send as header HTTP_API_USER_ID
    api_key # shared key

    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data) # send as HTTP_HMAC_TOKEN

To make the full request in ruby:

    data = "#{external_ip}#{url}"
    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['api_user_id'] = user_id
    req['hmac_token'] = hmac_token
    res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req) }
    response_data = JSON.parse(res.body)

