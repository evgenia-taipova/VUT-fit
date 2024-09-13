# Mobilní aplikace pro správu financí

Cílem projektu je vytvořit efektivní nástroj schopný poskytnout koncovým uživatelům jednoduchou
a srozumitelnou správu osobních financí. Hlavním cílem je vytvořit aplikaci, která nebude přeplněna
zbytečnými funkcemi, ale bude obsahovat ty nejzákladnější funkce.

## Instalace projektů

Pro spuštění tohoto projektu budete potřebovat Flutter a Android Studio. Postupujte podle níže uvedených instrukcí pro instalaci a spuštění aplikace.

### Krok 1: Instalace Flutter

Nainstalujte Flutter podle [oficiální dokumentace Flutter](https://flutter.dev/docs/get-started/install).

### Krok 2: Instalace Android Studio

Nainstalujte Android Studio podle [oficiální dokumentace Android Studio](https://developer.android.com/studio).

### Krok 3: Vytvořte projekt

Vytvořte nový projekt Flutter a pojmenujte jej itu_de

### Krok 4: Zkopírujte potřebné soubory

Zkopírujte složku lib, fonty a obrázky a soubor pubspec.yaml do projektu.

### Krok 5: Stažení závislostí

Spusťte příkaz flutter pub get pro stažení závislostí:

```bash
flutter pub get
```
### Krok 6: Spuštění aplikace

Použijte Android Studio k spuštění aplikace na emulátoru nebo reálném zařízení. Nebo spusťte následující příkaz v terminálu:

```bash
flutter run
```
### Pozor

Řada konfiguračních souborů se nachází ve složce build, tuto složku jsme nemohli přidat kvůli omezení velikosti archivu. 
Proto je nejlepším způsobem instalace aplikace nainstalovat soubor app-release.apk do svého mobilu. 
Rád bych také upozornil, že testy na iPhonech nebyly prováděny z důvodu existence takového mobilu u žadného z členů týmu.

## Instalace mobilní aplikaci

Přeneste soubor app-release.apk do telefonu a spusťte aplikaci.

## Struktura projektu

Projekt je uspořádán do následujících adresářů a souborů:

- `lib/`: Hlavní adresář pro zdrojové soubory programu Dart.
    - `Api/`
        - `NotificationApi.dart`: Zpracovává volání API související s oznámeními.
    - `Controllers/`: Obsahuje kontroléry pro správu stavu a obchodní logiky.
        - `BalancePageController.dart`
        - `BottomNavigationBarWidgetController.dart`
        - `DebtPageController.dart`
        - `ExpensesPageController.dart`
        - `GoalsPageController.dart`
        - `IncomesPageController.dart`
        - `MainPageController.dart`
        - `NotificationPageController.dart`
        - `SpecificWalletPageController.dart`
        - `TipsPageController.dart`
    - `Models/`: Datové modely, které reprezentují strukturu objektů.
        - `BalancePageModel.dart`
        - `DebtPageModel.dart`
        - `ExpensesPageModel.dart`
        - `GoalsPageModel.dart`
        - `IncomesPageModel.dart`
        - `NotificationPageModel.dart`
        - `SpecificWalletPageModel.dart`
        - `TipsPageModel.dart`
    - `Views/`: Obsahuje reprezentaci struktury MVC v uživatelském rozhraní.
        - `BalanceAddPageView.dart`
        - `BalancePageView.dart`
        - `BottomNavigationBarWidgetView.dart`
        - `DebtAddPageView.dart`
        - `DebtEditDeletePage.dart`
        - `DebtEditPageView.dart`
        - `DebtPageView.dart`
        - `DepositIncomePageView.dart`
        - `DepositPageView.dart`
        - `EditExpensePageView.dart`
        - `EditIncomePageView.dart`
        - `expense_item_widget.dart`
        - `ExpenseDetailPageView.dart`
        - `ExpensesPageView.dart`
        - `GoalMinusPageView.dart`
        - `GoalPlusPageView.dart`
        - `GoalsAddPageView.dart`
        - `GoalsEditDeletePage.dart`
        - `GoalsEditPageView.dart`
        - `GoalsPageView.dart`
        - `income_item_widget.dart`
        - `IncomeDetailPageView.dart`
        - `IncomesPageView.dart`
        - `MainPageView.dart`
        - `NewExpensePageView.dart`
        - `NewIncomePageView.dart`
        - `NotificationsPageView.dart`
        - `SpecificWalletView.dart`
        - `TipsPageView.dart`
        - `TipsTextPageView.dart`
        - `WithdrawIncomePageView.dart`
        - `WithdrawPageView.dart`
    - `main.dart`: Vstupní bod aplikace.
- `fonts` : Obsahuje vlastní soubory písem, které lze použít v celé aplikaci pro konzistentní typografii.
- `images` : Obsahuje obrazové soubory, jako jsou ikony, loga a pozadí, které se používají v uživatelském rozhraní aplikace.


## Závislosti

Seznam závislostí a jejich licencí:

* __flutter__: Framework Flutter.
* __cupertino_icons__: Ikony pro iOS.
* __mvc_pattern__: Návrhový vzor MVC pro Flutter.
* __sqflite__: Plugin pro práci s SQLite databází v Flutter.
* __flutter_local_notifications__: Plugin pro lokální oznámení v Flutter.
* __intl__: Knihovna pro mezinárodní lokalizaci v Flutter.
* __shared_preferences__: Plugin pro ukládání jednoduchých dat na zařízení.
* __fl_chart__: Knihovna pro vytváření grafů v Flutter.
* __path_provider__: Plugin pro získávání cest k souborovému systému.

## Licence

Popisy licencí pro použité knihovny:

- [Flutter License](https://flutter.dev/docs/get-started/install)
- [cupertino_icons License](https://github.com/flutter/cupertino_icons/blob/main/LICENSE)
- [mvc_pattern License](https://pub.dev/packages/mvc_pattern/license)
- [sqflite License](https://github.com/tekartik/sqflite/blob/master/LICENSE)
- [flutter_local_notifications License](https://github.com/dexterxdev/flutter_local_notifications/blob/main/LICENSE)
- [intl License](https://github.com/dart-lang/intl/blob/master/LICENSE)
- [shared_preferences License](https://github.com/flutter/plugins/blob/master/packages/shared_preferences/shared_preferences/LICENSE)
- [fl_chart License](https://github.com/imaNNeoFighT/fl_chart/blob/master/LICENSE)
- [path_provider License](https://github.com/flutter/plugins/blob/master/packages/path_provider/path_provider/LICENSE)


