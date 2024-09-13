# INP (Návrh počítačových systémů)

## Přehled bodů

| Číslo projektu | Hodnocení | Maximální počet bodů |
|----------------|-----------|----------------------|
| 1.             | 15        | 23                   |

## Odevzdané (validní) soubory

- **cpu.vhd:** ano
- **login.b:** ano
- **inp.png:** ano
- **inp.srp:** ano

## Ověření činnosti kódu CPU

| #  | Testovaný program (kód)      | Výsledek |
|----|------------------------------|----------|
| 1. | ++++++++++                   | ok       |
| 2. | ----------                   | ok       |
| 3. | +>++>+++                     | ok       |
| 4. | <+<++<+++                    | ok       |
| 5. | .+.+.+.                      | ok       |
| 6. | ,+,+,+,                      | chyba    |
| 7. | [........]noLCD[.........]   | chyba    |
| 8. | +++[.-]                      | ok       |
| 9. | +++++[>++[>+.<-]<-]          | ok       |
| 10.| +[+~.------------]+          | chyba    |

- **Podpora jednoduchých cyklů:** ano
- **Podpora vnořených cyklů:** ano

## Poznámky k implementaci

- Při zpracování smyčky s neplatnou podmínkou dojde k zacyklení.
- Data z klávesnice jsou korektně načtena, ale chybně zapsána do RAM (zpoždění jeden takt).

**Celkem bodů za CPU implementaci:** 12 (z 17)
