DROP TABLE Osoba CASCADE CONSTRAINTS;
DROP TABLE Zamestnanec CASCADE CONSTRAINTS;
DROP TABLE Zakaznik CASCADE CONSTRAINTS;
DROP TABLE Auto CASCADE CONSTRAINTS;
DROP TABLE Surovina CASCADE CONSTRAINTS;
DROP TABLE Pecivo CASCADE CONSTRAINTS;
DROP TABLE Objednavka CASCADE CONSTRAINTS;
DROP MATERIALIZED VIEW zamestnanec_info;

CREATE TABLE Osoba(
    id_osoby INT GENERATED ALWAYS AS IDENTITY,
    jmeno    VARCHAR(30) NOT NULL,
    prijmeni VARCHAR(30) NOT NULL,
    email    VARCHAR(60) NOT NULL UNIQUE,
    telefon  VARCHAR(30) NOT NULL UNIQUE,
    adresa   VARCHAR(255),
    cislo_bankovniho_uctu VARCHAR(22) NOT NULL UNIQUE,

    CHECK (REGEXP_LIKE(email, '^[a-z][a-z0-9_.-]*@[a-z0-9_.-]+\.[a-z]{2,}$')),
    CHECK (REGEXP_LIKE(cislo_bankovniho_uctu, '^(([0-9]{0,6})-)?([0-9]{2,10})/([0-9]{4})$'))
);

CREATE TABLE Zamestnanec(
    id_zamestnance NUMBER GENERATED ALWAYS AS IDENTITY ,
    id_osoby NUMBER NOT NULL,
    pozice VARCHAR(70) NOT NULL,
    mzda INT NOT NULL
);

CREATE TABLE Zakaznik(
    id_zakaznika NUMBER GENERATED ALWAYS AS IDENTITY  ,
    id_osoby NUMBER NOT NULL
);

CREATE TABLE Auto(
    id_auta VARCHAR(8) -- Státní poznávací značka

    CHECK (REGEXP_LIKE(id_auta, '^[1-9][A-CEHJ-MPS-UZ][1-9A-Z]:[0-9]{4}$'))
);

CREATE TABLE Surovina(
    id_suroviny INT GENERATED ALWAYS AS IDENTITY,
    typ VARCHAR(255) NOT NULL,
    cena NUMBER NOT NULL,
    mnozstvi VARCHAR(20) NOT NULL
);

CREATE TABLE Pecivo(
    id_peciva INT GENERATED ALWAYS AS IDENTITY,
    id_objednavky INT NOT NULL,
    nazev VARCHAR(50) NOT NULL,
    cena NUMBER NOT NULL,
    datum_vyroby DATE NOT NULL,
    datum_minimalni_trvanlivosti DATE NOT NULL,
    slozeni VARCHAR(255) NOT NULL,
    mnozstvi INT NOT NULL
);

CREATE TABLE Objednavka(
    id_objednavky INT GENERATED ALWAYS AS IDENTITY,
    id_zakaznika INT NOT NULL,
    stav VARCHAR(15) NOT NULL,
    datum_objednavky DATE NOT NULL,
    cena NUMBER NOT NULL,
    zpusob_platby VARCHAR(40) NOT NULL,
    zpusob_doruceni VARCHAR(20) NOT NULL,
    dorucovaci_adresa VARCHAR(255),
    datum_doruceni DATE NOT NULL
);

ALTER TABLE Osoba ADD CONSTRAINT PK_osoby PRIMARY KEY (id_osoby);
ALTER TABLE Zamestnanec ADD CONSTRAINT PK_zamestnanec PRIMARY KEY (id_zamestnance);
ALTER TABLE Zakaznik ADD CONSTRAINT PK_zakaznik PRIMARY KEY (id_zakaznika);

ALTER TABLE Auto ADD CONSTRAINT PK_auto PRIMARY KEY (id_auta);
ALTER TABLE Objednavka ADD CONSTRAINT PK_objednavka PRIMARY KEY (id_objednavky);
ALTER TABLE Surovina ADD CONSTRAINT PK_surovina PRIMARY KEY (id_suroviny);
ALTER TABLE Pecivo ADD CONSTRAINT PK_pecivo PRIMARY KEY (id_peciva);

ALTER TABLE Zakaznik ADD CONSTRAINT FK_zakaznik_osoba FOREIGN KEY(id_osoby) REFERENCES Osoba(id_osoby);
ALTER TABLE Zamestnanec ADD CONSTRAINT FK_zamestnanec_osoba FOREIGN KEY(id_osoby) REFERENCES Osoba(id_osoby);

ALTER TABLE Objednavka ADD CONSTRAINT FK_zakaznik_objednavka FOREIGN KEY (id_zakaznika) REFERENCES Zakaznik(id_zakaznika);
ALTER TABLE Pecivo ADD CONSTRAINT FK_pecivo_objednavka FOREIGN KEY (id_objednavky) REFERENCES Objednavka(id_objednavky);



INSERT INTO Osoba (jmeno, prijmeni, email, telefon, adresa, cislo_bankovniho_uctu)
    VALUES ('Vlad', 'Kovalets', 'vlad.ren@icloud.com', '+420773511610', 'Kolejní 2, 612 00 Brno', '2133861216/2020');
INSERT INTO Zamestnanec (id_osoby, pozice, mzda) VALUES (1, 'Pekař', 32800);

INSERT INTO Osoba (jmeno, prijmeni, email, telefon, adresa, cislo_bankovniho_uctu)
    VALUES ('Evgeniya', 'Taipova', 'taipova@gmail.com', '+420753232263', 'Černopolní 45, 613 00 Brno', '2183146011/1030');
INSERT INTO Zamestnanec (id_osoby, pozice, mzda) VALUES (2, 'Prodavačka', 28400);

INSERT INTO Osoba (jmeno, prijmeni, email, telefon, adresa, cislo_bankovniho_uctu)
    VALUES ('Jakub', 'Svoboda', 'j_svoboda21r@mail.com', '+420751738867', 'Vondrákova 6, 635 00 Brno-Bystrc', '2183248516/3030');
INSERT INTO Zamestnanec (id_osoby, pozice, mzda) VALUES (3, 'Kurýr', 30240);


INSERT INTO Osoba (jmeno, prijmeni, email, telefon, cislo_bankovniho_uctu)
    VALUES ('Barbora', 'Horáková', 'barbora12horak@icloud.com', '+420753123987', '2183156713/1111');
INSERT INTO Zakaznik (id_osoby) VALUES (4);

INSERT INTO Osoba (jmeno, prijmeni, email, telefon, adresa, cislo_bankovniho_uctu)
    VALUES ('Tereza', 'Svoboda', 'tereza.svoboda@icloud.com', '+420753224682', 'Zelný trh 6, 659 37 Brno-střed', '2183884123/3000');
INSERT INTO Zakaznik (id_osoby) VALUES (5);

INSERT INTO Osoba (jmeno, prijmeni, email, telefon, cislo_bankovniho_uctu)
    VALUES ('Jan', 'Novák', 'nov.jan@gmail.com', '+420487654971', '2182261213/2222');
INSERT INTO Zakaznik (id_osoby) VALUES (6);

INSERT INTO Osoba (jmeno, prijmeni, email, telefon,cislo_bankovniho_uctu)
    VALUES ('Lucie', 'Procházka', 'lucie125@icloud.com', '+420766248077', '2183111051/1411');
INSERT INTO Zakaznik (id_osoby) VALUES (7);


INSERT INTO Auto (id_auta) VALUES ('2B3:4003');
INSERT INTO Auto (id_auta) VALUES ('9B6:2401');
INSERT INTO Auto (id_auta) VALUES ('1B3:9127');
INSERT INTO Auto (id_auta) VALUES ('5B9:2013');


INSERT INTO Objednavka (id_zakaznika, stav, datum_objednavky, cena, zpusob_platby, zpusob_doruceni, datum_doruceni)
VALUES (1, 'Zrušeno', '26-3-2022', 62.90, 'Hotově / kartou (při vyzvednutí)', 'Prodejna', '28-3-2022');
INSERT INTO Objednavka (id_zakaznika, stav, datum_objednavky, cena, zpusob_platby, zpusob_doruceni, dorucovaci_adresa, datum_doruceni)
VALUES (1, 'Doručeno', '29-3-2022', 340.00, 'Kartou online', 'Doručení na adresu', 'Kolejní 2, 612 00 Brno', '1-4-2022');
INSERT INTO Objednavka (id_zakaznika, stav, datum_objednavky, cena, zpusob_platby, zpusob_doruceni, datum_doruceni)
VALUES (4, 'Zpracovává se', '1-4-2022', 833.40, 'Kartou online', 'Prodejna', '3-4-2022');


INSERT INTO Surovina (typ, cena, mnozstvi) VALUES ('Droždí', 99.00, '500 g');
INSERT INTO Surovina (typ, cena, mnozstvi) VALUES ('Margarin', 835.00, '10 kg');
INSERT INTO Surovina (typ, cena, mnozstvi) VALUES ('Cukr', 985.50, '15 kg');
INSERT INTO Surovina (typ, cena, mnozstvi) VALUES ('Jedlý papír', 2064.00, '100 ks');
INSERT INTO Surovina (typ, cena, mnozstvi) VALUES ('Sušený fermentovaný kvas', 625.00, '4 kg');


INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (1, 'Rohlik', 2.5, '28-3-2022', '30-3-2022', 'Mouka, voda, olej, droždí, sůl, cukr', 10);
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (1, 'Bageta malá světlá', 3.90, '28-3-2022', '30-3-2022', 'Mouka, voda, olej, droždí, sůl', 2);
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (2, 'Crobliha borůvka', 79.90, '1-4-2022', '2-4-2022', 'Mouka, máslo, olej, droždí, voda, sůl, borůvková marmeláda, smetana, bílá čokoláda', 4);
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (3, 'Brioška máslová', 14.90, '3-4-2022', '5-4-2022', 'Mouka, máslo, droždí, voda, sůl, cukr, ovocná pasta s citronovou příchutí', 1);
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (3, 'Rohlik', 2.5, '3-4-2022', '5-4-2022', 'Mouka, voda, olej, droždí, sůl, cukr', 4);


-------------------------------------------UKOL №3----------------------------------------------

-- spojení dvou tabulek (vypíše zaměstnance a jejich mzdy)
SELECT Osoba.jmeno, Osoba.prijmeni, Zamestnanec.pozice, Zamestnanec.mzda FROM Osoba, Zamestnanec
WHERE Osoba.id_osoby = Zamestnanec.id_osoby;

-- spojení dvou tabulek (vypíše údaje kurýrů)
SELECT * FROM Osoba NATURAL JOIN Zamestnanec WHERE Zamestnanec.pozice = 'Kurýr';

-- spojení tří tabulek (vypíše objednávku a jmeno, prijmeni zakaznika)
SELECT Objednavka.id_objednavky, Osoba.jmeno , Osoba.prijmeni FROM Objednavka, Zakaznik, Osoba
WHERE Objednavka.id_zakaznika = Zakaznik.id_zakaznika AND Zakaznik.id_osoby = Osoba.id_osoby;

-- GROUP BY a agregační funkce (vypíše id zakaznika a počet jeho objednávek)
SELECT Zakaznik.id_zakaznika, COUNT(*) pocet_objednavek FROM Zakaznik, Objednavka
WHERE Objednavka.id_zakaznika = Zakaznik.id_zakaznika GROUP BY Zakaznik.id_zakaznika;

-- GROUP BY a agregační funkce (vypíše název pečiva a prodané množství)
SELECT Pecivo.nazev, SUM(Pecivo.mnozstvi) prodane_mnozstvi FROM Pecivo
GROUP BY Pecivo.nazev ORDER BY prodane_mnozstvi DESC;

-- obsahující predikát EXISTS (vypíše objednávky a zákazníky, které obsahují rohlik)
SELECT Objednavka.id_objednavky, Objednavka.id_zakaznika FROM Objednavka
WHERE EXISTS(SELECT * FROM Pecivo WHERE id_objednavky = Objednavka.id_objednavky AND nazev = 'Rohlik');

-- obsahující predikát IN s vnořeným selectem (vypíše informace o osobách, které jsou zaměstnanci)
SELECT * FROM Osoba WHERE id_osoby IN (SELECT id_osoby FROM Zamestnanec);

-------------------------------------------UKOL №4----------------------------------------------

--Trigger 1.
--Zkontroluje, zda jsou zadaná data výroby a data minimální trvanlivosti správná (datum výroby musí být před datem spotřeby).
-- Kontroluje také datum spotřeby pro konkrétní peciva (v našem případě má rohlik expirační dobu dva dny).
CREATE OR REPLACE TRIGGER zkontroluj_data_peciva
	BEFORE INSERT OR UPDATE ON Pecivo
	FOR EACH ROW
    DECLARE
        datumVyroby Pecivo.datum_vyroby%TYPE;
        datumMinimalniTrvanlivosti Pecivo.datum_minimalni_trvanlivosti%TYPE;
        Nazev Pecivo.nazev%TYPE;
	BEGIN
        datumVyroby := :NEW.datum_vyroby;
        datumMinimalniTrvanlivosti := :NEW.datum_minimalni_trvanlivosti;
        Nazev := :NEW.nazev;
        IF (datumVyroby > datumMinimalniTrvanlivosti) THEN
            Raise_Application_Error(-20312, 'Chyba: Datum výroby a minimální datum trvanlivosti jsou nesprávné.');
        END IF;

        IF (Nazev = 'Rohlik') THEN
            IF NOT ((datumMinimalniTrvanlivosti - datumVyroby) = 2) THEN
                Raise_Application_Error(-20313, 'Chyba (Rohlik): Datum výroby a minimální datum trvanlivosti jsou nesprávné.');
            END IF;
        END IF;
END;
/

--Testy pro trigger 1.
-- Dojde k chybě, protože datum výroby je pozdější než datum spotřeby.
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (3, 'Bageta malá světlá', 3.90, '28-03-2023', '30-03-2022', 'Mouka, voda, olej, droždí, sůl', 4);

-- Dojde k chybě, protože u rohlíku by měl být rozdíl mezi daty roven dvěma.
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (3, 'Rohlik', 2.5, '24-3-2022', '29-03-2022', 'Mouka, voda, olej, droždí, sůl, cukr', 2);





-- Trigger 2.
-- Zobrazuje informace o mzdě zaměstnance.
CREATE OR REPLACE TRIGGER informace_mzda
    AFTER INSERT OR DELETE OR UPDATE ON Zamestnanec
    FOR EACH ROW
    DECLARE
        rozdil NUMBER;
        procentualni_rozdil NUMBER;
    BEGIN
        CASE
            -- Při odebrání zaměstnance se vydá stará mzda.
            WHEN DELETING THEN
            dbms_output.put_line('Stará mzda: ' || :OLD.mzda);

            -- Při přidání nového zaměstnance se vydá nová mzda.
            WHEN INSERTING THEN
            dbms_output.put_line('Nová mzda: ' || :NEW.mzda);

            -- Při změně mzdy zaměstnance se zobrazí stará mzda, nová mzda a rozdíl(a také procentuální) mezi nimi.
            WHEN UPDATING THEN
            rozdil := :NEW.mzda - :OLD.mzda;
            procentualni_rozdil := (:NEW.mzda / :OLD.mzda -1) * 100;
            dbms_output.put_line('Stará mzda: ' || :OLD.mzda);
            dbms_output.put_line('Nová mzda: ' || :NEW.mzda);
            dbms_output.put_line('Rozdil: ' || rozdil || ' (' || ROUND(procentualni_rozdil, 2) || '%)');
        END CASE;
END;
/

-- Testy pro trigger 2.

-- Přidání nového zaměstnance. Očekávaný výstup: "Nová mzda: 30240".
INSERT INTO Osoba (jmeno, prijmeni, email, telefon, adresa, cislo_bankovniho_uctu)
    VALUES ('Jakub', 'Svoboda', 'j_svoboda2S1r@mail.com', '+420751748867', 'Vondrákova 8, 635 00 Brno-Bystrc', '2183243516/3030');
INSERT INTO Zamestnanec (id_osoby, pozice, mzda) VALUES (8, 'Kurýr', 30240);

-- Odebrání zaměstnance. Očekávaný výstup: "Stará mzda: 28400".
DELETE Zamestnanec WHERE id_zamestnance = 2;

-- Změna mzdy zaměstnance. Očekávaný výstup:
-- "Stará mzda: 32800
--  Nová mzda: 33300
--  Rozdil: 500 (1,52%)".
UPDATE Zamestnanec SET mzda = mzda + 500 WHERE id_zamestnance = 1;




-- Procedura 1.
-- Procedura obdrží jako vstup ID zákazníka a vypíše informace o něm a jeho dokončených objednávkách.
CREATE OR REPLACE PROCEDURE kupni_sila_zakaznika (zakaznik_id INT) AS
BEGIN
    DECLARE CURSOR kursor is
    SELECT Objednavka.cena, Zakaznik.id_zakaznika, Osoba.jmeno, Osoba.prijmeni, Osoba.id_osoby, Zakaznik.id_osoby, Osoba.telefon, Osoba.email
    FROM Objednavka, Zakaznik, Osoba
    WHERE zakaznik_id = Zakaznik.id_zakaznika AND Osoba.id_osoby = Zakaznik.id_osoby
      AND Zakaznik.id_zakaznika = Objednavka.id_zakaznika AND Objednavka.stav IN('Doručeno');
        id_zakaznika Zakaznik.id_zakaznika%TYPE;
        cena_objednavky Objednavka.cena%TYPE;
        jmeno Osoba.jmeno%TYPE;
        prijmeni Osoba.jmeno%TYPE;
        id_osoby Osoba.id_osoby%TYPE;
        id_osoby_zak Zakaznik.id_osoby%TYPE;
        telefon Osoba.telefon%TYPE;
        email Osoba.email%TYPE;
        celkem NUMBER;
        prumer NUMBER;
        objednavky NUMBER;
        BEGIN
            celkem := 0;
            prumer := 0;
            objednavky := 0;
            OPEN kursor;
            LOOP
                FETCH kursor INTO cena_objednavky, id_zakaznika, jmeno, prijmeni, id_osoby, id_osoby_zak, telefon, email;
                EXIT WHEN kursor%NOTFOUND;
                celkem := celkem + cena_objednavky;
                objednavky := objednavky + 1;
            END LOOP;
            CLOSE kursor;
            -- Pokud má zákazník nulové objednávky, pak přejde na výjimku.
            prumer := ROUND(celkem / objednavky, 2);
            DBMS_OUTPUT.put_line('Zákazník: ' || jmeno || ' ' || prijmeni);
            DBMS_OUTPUT.put_line('Telefon: ' || telefon);
            DBMS_OUTPUT.put_line('E-mail: ' || email);
            DBMS_OUTPUT.put_line('Počet dokončených objednávek: ' || objednavky);
            DBMS_OUTPUT.put_line('Průměrná cena objednávky: ' || prumer);
            DBMS_OUTPUT.put_line('Celkem zaplaceno: ' || celkem);
            EXCEPTION WHEN ZERO_DIVIDE THEN
                BEGIN
                    DBMS_OUTPUT.put_line('Zákazník má nulové zaplacené objednávky');
                END;
        END;
END;
/

-- Testy pro proceduru 1.

-- Zákazník nemá žádné dokončené objednávky.
CALL kupni_sila_zakaznika(2);

-- Přidejme objednávky a zavolejme proceduru znovu.
INSERT INTO Objednavka (id_zakaznika, stav, datum_objednavky, cena, zpusob_platby, zpusob_doruceni, dorucovaci_adresa, datum_doruceni)
VALUES (2, 'Doručeno', '20-4-2022', 600.00, 'Kartou online', 'Doručení na adresu', 'Kolejní 2, 612 00 Brno', '22-4-2022');
INSERT INTO Objednavka (id_zakaznika, stav, datum_objednavky, cena, zpusob_platby, zpusob_doruceni, dorucovaci_adresa, datum_doruceni)
VALUES (2, 'Doručeno', '30-4-2022', 1000.00, 'Kartou online', 'Doručení na adresu', 'Kolejní 2, 612 00 Brno', '2-5-2022');
CALL kupni_sila_zakaznika(2);




-- Procedura 2.
-- Procedura vypíše nazev a množství pečiva, které je potřeba připravit pro objednávky.
CREATE OR REPLACE PROCEDURE pozadovane_pecivo AS pozadovane_mnozstvi NUMBER;
    BEGIN
        DECLARE CURSOR kursor is
        SELECT Pecivo.nazev, Pecivo.mnozstvi FROM Pecivo, Objednavka
        -- Berou se v úvahu pouze objednávky ve stavu 'Zpracovává se'.
        WHERE Pecivo.id_objednavky = Objednavka.id_objednavky AND Objednavka.stav IN ('Zpracovává se');
        nazev Pecivo.nazev%TYPE;
        mnozstvi Pecivo.mnozstvi%TYPE;
        BEGIN
            pozadovane_mnozstvi := 0;
            OPEN kursor;
            LOOP
                FETCH kursor INTO nazev , mnozstvi;
                EXIT WHEN kursor%NOTFOUND;
                pozadovane_mnozstvi := pozadovane_mnozstvi + mnozstvi;
                DBMS_OUTPUT.put_line('Potřebujeme připravit '|| pozadovane_mnozstvi || ' ' || nazev );
                pozadovane_mnozstvi := 0;
            END LOOP;
            CLOSE kursor;
        END;
    END;
/

-- Testy pro proceduru 2.

-- Očekávaný výstup:
-- "Potřebujeme připravit 1 Brioška máslová
--  Potřebujeme připravit 4 Rohlik"
CALL pozadovane_pecivo();

-- Přidáme k objednávce pečivo.
INSERT INTO Pecivo (id_objednavky, nazev, cena, datum_vyroby, datum_minimalni_trvanlivosti, slozeni, mnozstvi)
    VALUES (3, 'Bageta malá světlá', 3.90, '28-03-2022', '30-03-2022', 'Mouka, voda, olej, droždí, sůl', 10);

-- Očekávaný výstup:
-- "Potřebujeme připravit 1 Brioška máslová
--  Potřebujeme připravit 4 Rohlik
--  Potřebujeme připravit 10 Bageta malá světlá"
CALL pozadovane_pecivo();




-- Explain plan a index.

-- Vypíše id zákazníka, jeho jméno a příjmení, počet objednávek a celkovou cenu těchto objednávek.
EXPLAIN PLAN FOR
SELECT Zakaznik.id_zakaznika, Osoba.jmeno, Osoba.prijmeni, COUNT(*) pocet_objednavek, SUM(Objednavka.cena) celkova_cena
FROM Zakaznik, Osoba, Objednavka
WHERE Objednavka.id_zakaznika = Zakaznik.id_zakaznika AND Osoba.id_osoby = Zakaznik.id_osoby
GROUP BY Zakaznik.id_zakaznika, Osoba.jmeno, Osoba.prijmeni;

-- Test.
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Přidáváme indexy.
CREATE INDEX osoba_info ON Osoba (id_osoby, jmeno, prijmeni);
CREATE INDEX objednavka_info ON Objednavka(id_zakaznika, cena);

-- Zopakujeme EXPLAIN PLAN a otestujeme.
EXPLAIN PLAN FOR
SELECT Zakaznik.id_zakaznika, Osoba.jmeno, Osoba.prijmeni, COUNT(*) pocet_objednavek, SUM(Objednavka.cena) celkova_cena
FROM Zakaznik, Osoba, Objednavka
WHERE Objednavka.id_zakaznika = Zakaznik.id_zakaznika AND Osoba.id_osoby = Zakaznik.id_osoby
GROUP BY Zakaznik.id_zakaznika, Osoba.jmeno, Osoba.prijmeni;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);




-- Definici přístupových práv k databázovým objektům pro druhého člena týmu.

GRANT ALL ON Osoba TO XTAIPO00;
GRANT ALL ON Zamestnanec TO XTAIPO00;
GRANT ALL ON Zakaznik TO XTAIPO00;
GRANT ALL ON Auto TO XTAIPO00;
GRANT ALL ON Objednavka TO XTAIPO00;
GRANT ALL ON Pecivo TO XTAIPO00;
GRANT ALL ON Surovina TO XTAIPO00;

GRANT EXECUTE ON kupni_sila_zakaznika TO XTAIPO00;
GRANT EXECUTE ON pozadovane_pecivo TO XTAIPO00;



-- Materializovaný pohled, který obsahuje údaje o zaměstnanci (jeho jméno a příjmení, ID, pozici a mzdu)

CREATE MATERIALIZED VIEW zamestnanec_info AS
    SELECT Zamestnanec.id_zamestnance,  Osoba.jmeno, Osoba.prijmeni, Zamestnanec.mzda, Zamestnanec.pozice
    FROM Zamestnanec,  Osoba
    WHERE Osoba.id_osoby = Zamestnanec.id_osoby
    GROUP BY  Zamestnanec.id_zamestnance, Osoba.jmeno, Osoba.prijmeni, Zamestnanec.mzda, Zamestnanec.pozice;

-- Otestujeme přístup k uloženým datům.
SELECT * FROM zamestnanec_info;

-- Přidame zaměstnance.
INSERT INTO Osoba (jmeno, prijmeni, email, telefon, adresa, cislo_bankovniho_uctu)
    VALUES ('Anna', 'Swan', 'anna_swan@mail.com', '+420751275988', 'Dominikánské nám., 601 67 Brno', '2137951686/3030');
INSERT INTO Zamestnanec (id_osoby, pozice, mzda) VALUES (9, 'Kurýr', 25240);

-- Otestujeme zas přístup k uloženým datům (nebylo nic přidáno).
SELECT * FROM zamestnanec_info;
