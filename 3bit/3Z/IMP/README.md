# IMP (Mikroprocesorové a vestavěné systémy)

### Hodnocení

| Projekt  | Hodnocení | Maximální počet bodů |
|----|------|----------------|
| Watchdog Timer  | 10.2 | 14            |


# Aplikace modulu Watchdog Timer (WDOG)

## Úvod
Seznamte se s principem tvorby vestavných aplikací založených na mikrokontroléru Kinetis K60 (s jádrem ARM Cortex-M4) fy Freescale v prostředí Kinetis Design Studio (KDS) nebo MCUXpresso.

## Zadání projektu
Vytvořte projekt demonstrující možnosti modulu Watchdog Timer (WDOG) dostupného na mikrokontroléru Kinetis K60 z desky platformy FITkit 3.

1. Předpokládejte zdroj hodin LPO (Low-Power Oscillator).
2. V rámci jednoduché vestavné aplikace demonstrujte včasnou obsluhu WDOG v periodickém a okénkovém (windowed) režimu, každou s různými velikostmi periody/okna.
3. Aplikace musí interagovat (např. pomocí tlačítek, LED, piezzo bzučáku či terminálu) s uživatelem; přinejmenším musí (rozlišitelným způsobem) signalizovat pomocí LED a/nebo piezzo bzučáku:
    - Zahájení vestavné aplikace po resetu
    - Zahájení iterace cyklu v aplikaci
    - Zahájení obsluhy WDOG
4. Pomocí aplikace musí být možno demonstrovat dopad nevčasných obsluh WDOG na její chod a provést sběr statistik o počtech a příčinách resetu mikrokontroléru.

## Dokumentace
Vytvořte přehlednou dokumentaci k přípravě, způsobu realizace, k funkčnosti a vlastnostem řešení projektu. V případě použití (zadáním nezakázaných) podpůrných prostředků (např. knihoven či abstrakčních vrstev) dejte do souvislosti využité API, vlastnosti vestavné aplikace/platformy a stavové, řídicí aj. registry a bity platformy související (tj. ovládané, monitorované) s tímto API.