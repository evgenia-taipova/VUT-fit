# Projekt ISA: DNS Resolver (xtaipo00)

### Hodnocení

| Hodnocení | Maximální počet bodů |
|------|----------------|
| 15.5 | 20           |

## Popis 
Napište program dns, který bude umět zasílat dotazy na DNS servery a v čitelné podobě vypisovat přijaté odpovědi na standardní výstup. Sestavení a analýza DNS paketů musí být implementována přímo v programu dns. Stačí uvažovat pouze komunikaci pomocí UDP.

## Překlad 

Pro sestavení programu použijte příkaz ```make```.

## Použití 

```./dns [-r] [-x] [-6] -s server [-p port] adresa```

-r: Požadována rekurze (Recursion Desired = 1), jinak bez rekurze.

-x: Provést reverzní dotaz místo přímého.

-6: Dotaz typu AAAA místo výchozího A.

-s: IP adresa nebo doménové jméno DNS serveru pro odeslání dotazu.

-p: Číslo portu pro odeslání dotazu (výchozí je 53).

adresa: Dotazovaná adresa.

Pořadí parametrů je libovolné.

### Příklady spuštění a výstupu
```
./dns -r -s kazi.fit.vutbr.cz example.com
Authoritative: No, Recursive: Yes, Truncated: No
Question section (1)
  example.com.,   A, IN
Answer section (1)
  example.com., A, IN, 83319, 93.184.216.34     
Authority section (0)
Additional section (0)
```
```
./dns -r -6 -s kazi.fit.vutbr.cz www.fit.vut.cz
Authoritative: Yes, Recursive: Yes, Truncated: No
Question section (1)
  www.fit.vut.cz.,   AAAA, IN
Answer section (1)
  www.fit.vut.cz., AAAA, IN, 14400, 2001:67c:1220:809::93e5:91a
Authority section (0)
Additional section (0)
```
## Testování
Tento program DNS Resolveru je testován pomocí skriptu v jazyce Python (test_dns_resolver.py), který simuluje různé scénáře. 
Testy pokrývají jak IPv4, tak IPv6 dotazy, stejně jako dotazy na reverzní DNS.

### Spuštění
Pro spuštění testů použijte následující příkaz:
```make test```


