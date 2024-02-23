# IPK - Projekt 1
**Author: Taipova Evgeniya - xtaipo00**

**Datum: 10.3.2022**

## Popis
Server v jazyce C komunikující prostřednictvím protokolu HTTP a poskytuje různé informace o systému. Server naslouchá na zadaném portu a podle url vrací požadované informace. Server správně pracovává hlavičky HTTP a generuje správné HTTP odpovědi. Server je spustitelný v prostředí Linux Ubuntu 20.04 LTS.

## Spuštění
```./hinfosvc PORT```

## Použití
Server umí zpracovat následující tři typy dotazů, které jsou na server zaslané příkazem GET ve formátu ```server:port/pozadavek```

| Požadavek   | Odpověď              		   |
| ---------   | -------------------------------|
| `\hostname` | Doménové jméno                 |
| `\cpu-name` | Název procesoru                |
| `\load`     | Aktuální informace o zátěži    |
|`něco jiného`| Chyba                          |

## Funkce     
-  funkce **void control_port(int argc, char const \*argv[]);**
- - kontroluje správný počet argumentů
-  funkce **void get_hostname(char \*http, int new_socket);**
- - zpracuje a vydá odpověď na doménové jméno
-  funkce **void get_cpu_name(char \*http, int new_socket);**
- - zpracuje a vydá odpověď o názvu procesoru
-  funkce **void get_load(char \*http, int new_socket);**
- - zpracuje a vydá odpověď na aktuální informace o zátěži
-  funkce **void control_request(int new_socket, char buffer[]);**
- - funkce kontroluje požadavek a vydá správnou odpověď