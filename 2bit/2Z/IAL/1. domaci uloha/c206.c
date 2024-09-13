
/* ******************************* c206.c *********************************** */
/*  Předmět: Algoritmy (IAL) - FIT VUT v Brně                                 */
/*  Úkol: c206 - Dvousměrně vázaný lineární seznam                            */
/*  Návrh a referenční implementace: Bohuslav Křena, říjen 2001               */
/*  Vytvořil: Martin Tuček, říjen 2004                                        */
/*  Upravil: Kamil Jeřábek, září 2020                                         */
/*           Daniel Dolejška, září 2021                                       */
/* ************************************************************************** */
/*
** Implementujte abstraktní datový typ dvousměrně vázaný lineární seznam.
** Užitečným obsahem prvku seznamu je hodnota typu int. Seznam bude jako datová
** abstrakce reprezentován proměnnou typu DLList (DL znamená Doubly-Linked
** a slouží pro odlišení jmen konstant, typů a funkcí od jmen u jednosměrně
** vázaného lineárního seznamu). Definici konstant a typů naleznete
** v hlavičkovém souboru c206.h.
**
** Vaším úkolem je implementovat následující operace, které spolu s výše
** uvedenou datovou částí abstrakce tvoří abstraktní datový typ obousměrně
** vázaný lineární seznam:
**
**      DLL_Init ........... inicializace seznamu před prvním použitím,
**      DLL_Dispose ........ zrušení všech prvků seznamu,
**      DLL_InsertFirst .... vložení prvku na začátek seznamu,
**      DLL_InsertLast ..... vložení prvku na konec seznamu,
**      DLL_First .......... nastavení aktivity na první prvek,
**      DLL_Last ........... nastavení aktivity na poslední prvek,
**      DLL_GetFirst ....... vrací hodnotu prvního prvku,
**      DLL_GetLast ........ vrací hodnotu posledního prvku,
**      DLL_DeleteFirst .... zruší první prvek seznamu,
**      DLL_DeleteLast ..... zruší poslední prvek seznamu,
**      DLL_DeleteAfter .... ruší prvek za aktivním prvkem,
**      DLL_DeleteBefore ... ruší prvek před aktivním prvkem,
**      DLL_InsertAfter .... vloží nový prvek za aktivní prvek seznamu,
**      DLL_InsertBefore ... vloží nový prvek před aktivní prvek seznamu,
**      DLL_GetValue ....... vrací hodnotu aktivního prvku,
**      DLL_SetValue ....... přepíše obsah aktivního prvku novou hodnotou,
**      DLL_Previous ....... posune aktivitu na předchozí prvek seznamu,
**      DLL_Next ........... posune aktivitu na další prvek seznamu,
**      DLL_IsActive ....... zjišťuje aktivitu seznamu.
**
** Při implementaci jednotlivých funkcí nevolejte žádnou z funkcí
** implementovaných v rámci tohoto příkladu, není-li u funkce explicitně
 * uvedeno něco jiného.
**
** Nemusíte ošetřovat situaci, kdy místo legálního ukazatele na seznam
** předá někdo jako parametr hodnotu NULL.
**
** Svou implementaci vhodně komentujte!
**
** Terminologická poznámka: Jazyk C nepoužívá pojem procedura.
** Proto zde používáme pojem funkce i pro operace, které by byly
** v algoritmickém jazyce Pascalovského typu implemenovány jako procedury
** (v jazyce C procedurám odpovídají funkce vracející typ void).
**
**/

#include "c206.h"

int error_flag;
int solved;

/**
 * Vytiskne upozornění na to, že došlo k chybě.
 * Tato funkce bude volána z některých dále implementovaných operací.
 */
void DLL_Error()
{
    printf("*ERROR* The program has performed an illegal operation.\n");
    error_flag = TRUE;
}

/**
 * Provede inicializaci seznamu list před jeho prvním použitím (tzn. žádná
 * z následujících funkcí nebude volána nad neinicializovaným seznamem).
 * Tato inicializace se nikdy nebude provádět nad již inicializovaným seznamem,
 * a proto tuto možnost neošetřujte.
 * Vždy předpokládejte, že neinicializované proměnné mají nedefinovanou hodnotu.
 *
 * @param list Ukazatel na strukturu dvousměrně vázaného seznamu
 */
void DLL_Init(DLList *list)
{
    list->firstElement = NULL;
    list->lastElement = NULL;
    list->activeElement = NULL;
}

/**
 * Zruší všechny prvky seznamu list a uvede seznam do stavu, v jakém se nacházel
 * po inicializaci.
 * Rušené prvky seznamu budou korektně uvolněny voláním operace free.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Dispose(DLList *list)
{
    while (list->firstElement != NULL)
    {
        //zrušíme prvek
        free(list->firstElement);
        //přejdeme k dalšímu prvku
        list->firstElement = list->firstElement->nextElement;
    }
    list->firstElement = list->lastElement = list->activeElement = NULL;
}

/**
 * Vloží nový prvek na začátek seznamu list.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení na začátek seznamu
 */
void DLL_InsertFirst(DLList *list, int data)
{
    //alokaсe paměti
    DLLElementPtr newElement = malloc(sizeof(struct DLLElement));
    if (!newElement)
    {
        //selhaní alokace
        DLL_Error();
        return;
    }
    //vložíme data
    newElement->data = data;
    //přiřadíme další prvek jako první a předchozí jako NULL
    newElement->nextElement = list->firstElement;
    newElement->previousElement = NULL;
    //změníme předchozí první prvek na nový
    if (list->firstElement)
        list->firstElement->previousElement = newElement;
    else
        list->lastElement = newElement;
    list->firstElement = newElement;
}

/**
 * Vloží nový prvek na konec seznamu list (symetrická operace k DLL_InsertFirst).
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení na konec seznamu
 */
void DLL_InsertLast(DLList *list, int data)
{
    //alokaсe paměti
    DLLElementPtr newElement = malloc(sizeof(struct DLLElement));
    if (!newElement)
    {
        //selhaní alokace
        DLL_Error();
        return;
    }
    newElement->data = data;
    //přiřadíme předchozí prvek jako poslední a další jako NULL
    newElement->previousElement = list->lastElement;
    newElement->nextElement = NULL;
    //změníme předchozí poslední prvek na nový
    if (list->lastElement)
        list->lastElement->nextElement = newElement;
    else
        list->firstElement = newElement;
    list->lastElement = newElement;
}

/**
 * Nastaví první prvek seznamu list jako aktivní.
 * Funkci implementujte jako jediný příkaz (nepočítáme-li return),
 * aniž byste testovali, zda je seznam list prázdný.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_First(DLList *list)
{
    //nastavíme první prvek seznamu jako aktivní
    list->activeElement = list->firstElement;
}

/**
 * Nastaví poslední prvek seznamu list jako aktivní.
 * Funkci implementujte jako jediný příkaz (nepočítáme-li return),
 * aniž byste testovali, zda je seznam list prázdný.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Last(DLList *list)
{
    //nastavíme poslední prvek seznamu jako aktivní
    list->activeElement = list->lastElement;
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu prvního prvku seznamu list.
 * Pokud je seznam list prázdný, volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void DLL_GetFirst(DLList *list, int *dataPtr)
{
    if (list->firstElement == NULL)
    {
        //pokud je seznam prázdný, voláme funkci DLL_Error() a funkce skončí
        DLL_Error();
        return;
    }
    //vrátíme dataPtr hodnotu prvního prvku seznamu
    *dataPtr = list->firstElement->data;
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu posledního prvku seznamu list.
 * Pokud je seznam list prázdný, volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void DLL_GetLast(DLList *list, int *dataPtr)
{
    if (list->lastElement == NULL)
    {
        //pokud je seznam prázdný, voláme funkci DLL_Error() a funkce skončí
        DLL_Error();
        return;
    }
    //vrátíme dataPtr hodnotu posledního prvku seznamu
    *dataPtr = list->lastElement->data;
}

/**
 * Zruší první prvek seznamu list.
 * Pokud byl první prvek aktivní, aktivita se ztrácí.
 * Pokud byl seznam list prázdný, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteFirst(DLList *list)
{
    DLLElementPtr elemPtr = list->firstElement;
    if (list->firstElement != NULL)
    {
        //pokud není seznam prázdný
        if (list->activeElement == list->firstElement)
            //pokud je první aktivní, ruší se aktivita
            list->activeElement = NULL;
        if (list->firstElement == list->lastElement)
        {
            //pokud má seznam jediný prvek, zruší se
            list->firstElement = NULL;
            list->lastElement = NULL;
        }
        else
        {
            //aktualizace začátku seznamu
            list->firstElement = list->firstElement->nextElement;
            //ukazatel prvního doleva na NULL
            list->firstElement->previousElement = NULL;
        }
        free(elemPtr);
    }
}

/**
 * Zruší poslední prvek seznamu list.
 * Pokud byl poslední prvek aktivní, aktivita seznamu se ztrácí.
 * Pokud byl seznam list prázdný, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteLast(DLList *list)
{

    DLLElementPtr elemPtr = list->lastElement;
    if (list->firstElement != NULL)
    {
        //pokud není seznam prázdný
        if (list->activeElement == list->lastElement)
            //pokud poslední je aktivní, ruší se aktivita
            list->activeElement = NULL;
        if (list->lastElement == list->firstElement)
        {
            //pokud seznam má jediný prvek, zruší se
            list->lastElement = NULL;
            list->firstElement = NULL;
        }
        else
        {
            list->lastElement = list->lastElement->previousElement;
            list->lastElement->nextElement = NULL;
        }
        free(elemPtr);
    }
}

/**
 * Zruší prvek seznamu list za aktivním prvkem.
 * Pokud je seznam list neaktivní nebo pokud je aktivní prvek
 * posledním prvkem seznamu, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteAfter(DLList *list)
{

    if (list->activeElement != NULL)
    {
        if (list->activeElement->nextElement != NULL)
        {
            //ukazatel na rušený
            DLLElementPtr elemPtr = list->activeElement->nextElement;
            //překlenutí rušeného
            list->activeElement->nextElement = elemPtr->nextElement;
            if (elemPtr == list->lastElement)
                //posledním bude aktivní
                list->lastElement = list->activeElement;
            else
                //prvek za zrušeným ukazuje doleva na activní element
                elemPtr->nextElement->previousElement = list->activeElement;
            free(elemPtr);
        }
    }
}

/**
 * Zruší prvek před aktivním prvkem seznamu list .
 * Pokud je seznam list neaktivní nebo pokud je aktivní prvek
 * prvním prvkem seznamu, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteBefore(DLList *list)
{
    if (list->activeElement != NULL)
    {
        if (list->activeElement->previousElement != NULL)
        {
            //ukazatel na rušený
            DLLElementPtr elemPtr = list->activeElement->previousElement;
            //překlenutí rušeného
            list->activeElement->previousElement = elemPtr->previousElement;
            if (elemPtr == list->firstElement)
                //prvním bude aktivní
                list->firstElement = list->activeElement;
            else
                elemPtr->previousElement->nextElement = list->activeElement;
            free(elemPtr);
        }
    }
}

/**
 * Vloží prvek za aktivní prvek seznamu list.
 * Pokud nebyl seznam list aktivní, nic se neděje.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení do seznamu za právě aktivní prvek
 */
void DLL_InsertAfter(DLList *list, int data)
{
    //alokaсe paměti
    DLLElementPtr newElement = malloc(sizeof(struct DLLElement));
    if (!newElement)
    {
        //selhaní alokace
        DLL_Error();
        return;
    }
    //vložíme data
    newElement->data = data;
    newElement->nextElement = list->activeElement->nextElement;
    //přiřadíme předchozí jako activní
    newElement->previousElement = list->activeElement;
    if (list->activeElement == list->lastElement)
        //pokud je activní prvek poslední, poslední bude nový
        list->lastElement = newElement;
    else
        newElement->nextElement->previousElement = newElement;
}

/**
 * Vloží prvek před aktivní prvek seznamu list.
 * Pokud nebyl seznam list aktivní, nic se neděje.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení do seznamu před právě aktivní prvek
 */
void DLL_InsertBefore(DLList *list, int data)
{
    //alokace paměti
    DLLElementPtr newElement = malloc(sizeof(struct DLLElement));
    if (newElement == NULL)
    {
        //selhaní alokace
        DLL_Error();
        return;
    }
    //vložíme data
    newElement->data = data;
    //přiřadíme další jako activní
    newElement->nextElement = list->activeElement;
    newElement->previousElement = list->activeElement->previousElement;
    if (list->activeElement == list->firstElement)
        //pokud je activní prvek první, první bude nový
        list->firstElement = newElement;
    else
        newElement->previousElement->nextElement = newElement;
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu aktivního prvku seznamu list.
 * Pokud seznam list není aktivní, volá funkci DLL_Error ().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void DLL_GetValue(DLList *list, int *dataPtr)
{
    if (list->activeElement == NULL)
    {
        DLL_Error();
        return;
    }
    *dataPtr = list->activeElement->data;
}

/**
 * Přepíše obsah aktivního prvku seznamu list.
 * Pokud seznam list není aktivní, nedělá nic.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Nová hodnota právě aktivního prvku
 */
void DLL_SetValue(DLList *list, int data)
{
    if (list->activeElement)
        //pokud seznam je aktivní, přepsání dat aktivního prvku
        list->activeElement->data = data;
}

/**
 * Posune aktivitu na následující prvek seznamu list.
 * Není-li seznam aktivní, nedělá nic.
 * Všimněte si, že při aktivitě na posledním prvku se seznam stane neaktivním.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Next(DLList *list)
{
    if (list->activeElement)
        list->activeElement = list->activeElement->nextElement;
}

/**
 * Posune aktivitu na předchozí prvek seznamu list.
 * Není-li seznam aktivní, nedělá nic.
 * Všimněte si, že při aktivitě na prvním prvku se seznam stane neaktivním.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Previous(DLList *list)
{
    if (list->activeElement)
        list->activeElement = list->activeElement->previousElement;
}

/**
 * Je-li seznam list aktivní, vrací nenulovou hodnotu, jinak vrací 0.
 * Funkci je vhodné implementovat jedním příkazem return.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 *
 * @returns Nenulovou hodnotu v případě aktivity prvku seznamu, jinak nulu
 */
int DLL_IsActive(DLList *list)
{
    return (list->activeElement != NULL);
}

/* Konec c206.c */
