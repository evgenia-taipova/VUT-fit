### Hodnocení

| Projekt  | Hodnocení | Maximální počet bodů |
|----|------|----------------|
| Studentské turnaje  | 27 | 30 |

## Autoři

- **Vladyslav Kovalets** - [GitHub](https://github.com/kbadrat)
- **Evgeniya Taipova** - [GitHub](https://github.com/evgenia-taipova)

# Zadání projektu - Studentské turnaje

## Popis

Úkolem zadání je vytvořit jednoduchý informační systém pro pořádání sportovních turnajů ve studentském klubu (šachy, šipky, PC hry, konzumace piva, apod…) mezi jednotlivci nebo týmy vyřazovacím herním stylem pavouk. Každý turnaj má nějaké označení, pomocí kterého ho uživatelé systému budou moci vhodně odlišit a další atributy (např. datum, popis, výherní cena, apod.). Dále stanovuje podmínky, za jakých podmínek se mohou turnajů účastnit jednotlivci nebo týmy - např. počet týmů, počet hráčů týmu apod. Každý tým má vlastní název a volitelně logo (např. vlajku). Uživatelé budou moci informační systém použít jak pro registraci na turnaj, tak tvorbu a správu turnajů nových, správu týmů a účastníků turnaje - a to následujícím způsobem:

### Administrátor
- spravuje uživatele
- schvaluje turnaje

### Registrovaný uživatel
- edituje svůj profil
- zakládá týmy - stává se správcem týmu
    - přidává uživatele do týmu, kteří stávají se členy týmu
    - registruje svůj tým na turnaj
- zakládá turnaj - stává se správcem turnaje
    - zadává parametry turnaje
    - schvaluje hráče turnaje (jednotlivce/týmy dle typu turnaje)
    - spouští turnaj, generuje harmonogram turnaje (ručně nebo automaticky - rozlosování)
    - zadává výsledky zápasů (výsledek zápasu uvažujte jako dvojici (počet bodů týmu/hráče 1, počet bodů týmu/hráče 2))
- účastní se turnaje (registruje se jako jednotlivec nebo je členem registrovaného týmu) - stává se hráčem turnaje
    - vidí svůj program (harmonogram zápasů)
    - přednostně vidí výsledky svých zápasů

### Neregistrovaný uživatel
- prochází profily a statistiky hráčů, týmů a turnajů s výsledky

## Náměty na možná rozšíření

- pořadatel má možnost specifikovat herní systém (není omezeno pouze na vyřazovací systém)
- podrobný popis statistik a událostí zápasu, jednoduché zadávání těchto událostí správcem turnaje
- dle vlastní fantazie, popište v dokumentaci…

Dále postupujte dle všeobecného zadání:

### 1. Cíle projektu

Cílem projektu je navrhnout a implementovat informační systém s webovým rozhraním pro zvolené zadání jedné z variant. Postup řešení by měl být následující:

1. Analýza a návrh informačního systému (analýza požadavků, tvorba diagramu případů užití, modelu relační databáze)
2. Volba implementačního prostředí - databázového serveru a aplikační platformy
3. Implementace navrženého databázového schématu ve zvoleném DB systému
4. Návrh webového uživatelského rozhraní aplikace
5. Implementace vlastní aplikace

### 2. Rozsah implementace

Implementovaný systém by měl být prakticky použitelný pro účel daný zadáním. Mimo jiné to znamená:

- Musí umožňovat vložení odpovídajících vstupů.
- Musí poskytovat výstupy ve formě, která je v dané oblasti využitelná. Tedy nezobrazovat obsah tabulek databáze, ale prezentovat uložená data tak, aby byla pro danou roli uživatele a danou činnost užitečná (např. spojit data z více tabulek, je-li to vhodné, poskytnout odkazy na související data, apod).
- Uživatelské rozhraní musí umožňovat snadno realizovat operace pro každou roli vyplývající z diagramu případů použití (use-case). Je-li cílem např. prodej zboží, musí systém implementovat odpovídající operaci, aby uživatel nemusel při každém prodeji ručně upravovat počty zboží na skladě, pamatovat si identifikátory položek a přepisovat je do objednávky a podobně.

Kromě vlastní funkcionality musí být implementovány následující funkce:

- Správa uživatelů a jejich rolí (podle povahy aplikace, např. obchodník, zákazník, administrátor). Tím se rozumí přidávání nových uživatelů u jednotlivých rolí, stejně tak možnost editace a mazání nebo deaktivace účtů. Musí být k dispozici alespoň dvě různé role uživatelů.
- Ošetření všech uživatelských vstupů tak, aby nebylo možno zadat nesmyslná nebo nekonzistentní data.
  - Povinná pole formulářů musí být odlišena od nepovinných.
  - Hodnoty ve formulářích, které nejsou pro fungování aplikace nezbytné, neoznačujte jako povinné (např. adresy, telefonní čísla apod.). Nenuťte uživatele (opravujícího) vyplňovat desítky zbytečných řádků.
  - Při odeslání formuláře s chybou by správně vyplněná pole měla zůstat zachována (uživatel by neměl být nucen vyplňovat vše znovu).
  - Pokud je vyžadován konkrétní formát vstupu (např. datum), měl by být u daného pole naznačen.
  - Pokud to v daném případě dává smysl, pole obsahující datum by měla být předvyplněna aktuálním datem.
  - Nemělo by být vyžadováno zapamatování a zadávání generovaných identifikátorů (cizích klíčů), jako např. ID položky na skladě. To je lépe nahradit výběrem ze seznamu. Výjimku tvoří případy, kdy se zadáním ID simuluje např. čtečka čipových karet v knihovně. V takovém případě prosím ušetřete opravujícímu práci nápovědou několika ID, která lze použít pro testování.
  - Žádné zadání nesmí způsobit nekonzistentní stav databáze (např. přiřazení objednávky neexistujícímu uživateli).
- Přihlašování a odhlašování uživatelů přes uživatelské jméno (případně e-mail) a heslo. Automatické odhlášení po určité době nečinnosti.

### 3. Implementační prostředky

#### 3.1 Uživatelské rozhraní (front-end)

- HTML5 + CSS, s využitím JavaScriptu, pokud je to vhodné.
- Je povoleno využití libovolných volně šířených JavaScriptových a CSS frameworků (jQuery, Bootstrap, atd.)
- Případně lze využít i AJAX či pokročilejší klientské frameworky (Angular, React, Vue, apod.), není to ale vyžadováno.

Rozhraní musí být funkční přinejmenším v prohlížečích Chrome a Firefox (uvažujte aktuálně dostupné verze).

#### 3.2 Implementační prostředí (back-end)

- implicitně jazyk PHP (případně volitelně libovolný PHP framework - Nette, Laravel, Symfony, apod.) - na serveru eva máte dostupný prostor pro studentské stránky:
  - stránky zprovozněte dle návodu v FAQ - bod 13 (nezapomeňte, že adresář WWW musí obsahovat platný dokument index.html nebo index.php a soubory musí mít správně nastavená přístupová práva)
  - používejte kódování UTF-8 - nastavte si soubor .htaccess - dle návodu v FAQ - bod 14
  - problém s nutností použití jiné verze php než 8.1 (např. kvůli zvolenému frameworku) řešte dle návodu v FAQ - bod 15, případně zvolte nějaký vhodný hosting (např. Endora)
- alternativně můžete použít jinou serverovou technologii (např. Python, Javascript/Node.js, Java, C#, Go, Ruby, apod.) a vhodný framework (Django, Flask, Express, Spring, ASP.NET, apod.):
  - podmínkou #1 je, aby byl informační systém dostupný - ověřte si předem, že máte k dispozici vhodný hosting/cloud, na kterém bude schopni IS zprovoznit (např. Heroku, Google Cloud, RedHat Openshift, MS Azure, apod.)
  - podmínkou #2 je, abyste nepoužili hotový redakční systém, administrační stránky umožňující spravovat obsah apod. (např. při použití Frameworku Django se žádný uživatel nebude přihlašovat do administrační stránky)
  - v případě použití exotických platforem, které nebudete schopni zprovoznit jinak než lokálně, je nutné se předem domluvit do 8. 10. 2023 (viz kontakt níže) - bude vyžadováno spuštění v Dockeru a musí být schváleno
  - volba složitější architektury řešení je rozhodnutím řešitelů a neznamená automaticky lepší hodnocení - týká se zejména případů, kdy se z důvodu značné složitosti architektury nepovedlo informační systém dokončit do funkční podoby

#### 3.3 Databázový systém

- implicitně MySQL: lze využít server eva (ve WISu si vytvořte uživatele: Ostatní -> Hesla)
- alternativně můžete použít jiný relační databázový systém - PostgreSQL, apod. (který bude dostupný na Vámi zvoleném serveru)
- lze použít dostupné knihovny pro ORM
- použití SQLite není povoleno
- použití nerelační databáze (MongoDB apod.) není povoleno (případně po domluvě u vlastních zadání)

### 4. Dokumentace

Součástí projektu je stručná dokumentace k implementaci, která popisuje, které PHP skripty (případně kontrolery, presentery apod. podle zvoleného frameworku) implementují jednotlivé případy použití. Tato dokumentace je součástí dokumentu doc.html, viz níže.

