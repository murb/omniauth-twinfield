# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

object_categories = ["Audiovisueel", "Fotografie","Gebouwgebonden", "Grafiek", "Schilderkunst","Sculptuur (binnen)","Sculptuur (buiten)","Uniek werk op papier","Vormgeving"]
object_categories.each {|name| ObjectCategory.where({name: name}).first_or_create }

techniques = ["Acrylverf", "Assemblage", "Aquarel", "Blinddruk", "Brons", "Collage", "Ets", "Aquatint", "Droge naald, aquatint", "Glas", "Gouache", "Gemengde techniek", "Houtsnede", "Installatie", "Keramiek", "Linoleumsnede", "Lithografie", "Monoprint", "Object", "Olieverf", "Readymade", "Reliëf", "Tekening", "Houtskool", "Krijt", "Pastel", "Pen", "Potlood", "Stift", "Tempera", "Textiel", "Wandschildering", "Zeefdruk"]
techniques.each {|name| Technique.where({name: name}).first_or_create }


media = ["Doek", "Karton", "Paneel", "Papier"]
media.each {|name| Medium.where({name: name}).first_or_create }

conditions = ["Goed (++)","Redelijk/Voldoende (+)","Matig (-)","Slecht (--)"]
conditions.each_with_index {|name, index| Condition.where({name: name, order: index}).first_or_create }

damage_types = ["Buts(en)", "Craquelé", "Kreukel(s)", "Scheur(en)", "Schimmel", "Verfschade", "Vergeling", "Vocht", "Vouw(en)", "Vuil", "Waas", "Winkelha(a)k(en)", "Zilvervisje(s)"]
damage_types.each {|name| DamageType.where({name: name}).first_or_create }

frame_damage_types = ["Buts(en)", "Glasbreuk", "Kras(sen)", "Schimmel", "Verfverlies", "Vermissing glas", "Vermissing lat", "Vocht", "Vuil", "Wijkende hoek(en)"]
frame_damage_types.each {|name| FrameDamageType.where({name: name}).first_or_create }

sources = ["BKR", "Schenking", "Relatiegeschenk", "Bruikleen", "Aankoop", "Opdracht"]
sources.each {|name| Source.where({name: name}).first_or_create }

styles = ["Cubistisch", "Expressionistisch", "Geometrisch", "Conceptueel", "Impressionistisch", "Fotorealistisch", "Surrealistisch"]
styles.each {|name| Style.where({name: name}).first_or_create }

themes = ["Landschap", "Stedelijk landschap", "Mens", "Dier", "Stilleven"]
themes.each {|name| Theme.where({name: name}).first_or_create }

subsets = ["Cartografie", "Documentatie", "Hedendaagse kunst", "Historische collectie", "Moderne kunst", "Toegepaste kunst", "Poster"]
subsets.each {|name| Subset.where({name: name}).first_or_create }

placeabilities = ["Direct inzetbaar", "Naar lijstenmaker", "Restauratie nodig", "Total loss"]
placeabilities.each_with_index {|name, index| Placeability.where({name: name, order: index}).first_or_create }

currencies = {"EUR"=>"€", "USD"=>"$", "NLG"=>"𝑓"}
currencies.each{|k,v| Currency.where({iso_4217_code: k, symbol: v}).first_or_create}