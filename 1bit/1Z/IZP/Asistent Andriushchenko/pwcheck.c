#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define MAX_PASSWORD_LENGTH 102

typedef struct
{
    int MIN;
    int number_string;
    int number_character;
} Stats_count;

//funkce najde a vrátí délku řetězce
int my_strlen(char password_string[MAX_PASSWORD_LENGTH]);

//heslo obsahuje velká a malá písmena
bool lower_and_upper_case(char password_string[MAX_PASSWORD_LENGTH], int length);

//heslo obsahuje číslo
bool number(char password_string[MAX_PASSWORD_LENGTH], int length);

//heslo obsahuje speciální znak
bool special_characters(char password_string[MAX_PASSWORD_LENGTH], int length);

//funkce získá podřetězec
void get_substring(char password_string[MAX_PASSWORD_LENGTH], int j, long PARAM, char substring[PARAM + 1]);

//funkce porovnává dva řetězce
bool compare_strings(char first_string[], char second_string[]);
bool control_flag(int flag);

//funkce kontrolují úrovně
bool level_first(char password_string[MAX_PASSWORD_LENGTH], int length);
bool level_second(char password_string[MAX_PASSWORD_LENGTH], int length, long PARAM);
bool level_third(char password_string[MAX_PASSWORD_LENGTH], int length, long PARAM);
bool level_fourth(char password_string[MAX_PASSWORD_LENGTH], long PARAM);
void level_all(char password_string[MAX_PASSWORD_LENGTH], int LEVEL, long PARAM);

//funkce najde a vrátí minimální délku hesla
int min_length_string(int MIN, char password_string[MAX_PASSWORD_LENGTH]);

//statistika
void start_stats(char password_string[MAX_PASSWORD_LENGTH], Stats_count *stats_count, int ascii_array[]);
int check_stats(char *argv[]);
void stats(char *argv[], int number_character, int number_string, int MIN, int ascii_array[]);

//kontrola vstupních chyb
int error(int error_step, int argc, long PARAM, int LEVEL, char password_string[MAX_PASSWORD_LENGTH], char * argv[]);
int check_argc(int argc);
int check_argv(int LEVEL, long PARAM);
int check_password(char password_string[MAX_PASSWORD_LENGTH]);
bool check_argv_stats(char * argv[]);

int main(int argc, char *argv[])
{
    char password_string[MAX_PASSWORD_LENGTH];
    int ascii_array[128] = {0};
    int LEVEL = 0;
    long PARAM = 0;
    int error_step = 0;

    Stats_count stats_count;
    stats_count.MIN = 100;
    stats_count.number_string = 0;
    stats_count.number_character = 0;

    //pokud dojde k chybě vstupu, program se ukončí
    error_step = 1;
    if (!error(error_step, argc, PARAM, LEVEL, password_string, argv))
        return 1;

    LEVEL = atoi(argv[1]);
    PARAM = strtol(argv[2], NULL, 36);

    error_step = 2;
    if (!error(error_step, argc, PARAM, LEVEL, password_string, argv))
        return 1;

    //funkce fgets čte řetězec z stdin, dokud délka čteného řetězce nepřekročí limit argumentů
    while (fgets(password_string, MAX_PASSWORD_LENGTH, stdin))
    {
        level_all(password_string, LEVEL, PARAM);

        if (check_stats(argv))
            start_stats(password_string, &stats_count, ascii_array);
    }

    stats(argv, stats_count.number_character, stats_count.number_string, stats_count.MIN, ascii_array);

    return 0;
}

//funkce najde a vrátí délku řetězce
int my_strlen(char password_string[MAX_PASSWORD_LENGTH])
{
    int length = 0;
    while ((password_string[length] != '\n') && (password_string[length + 1] != '\0'))
        length++;
    return length;
}

//funkce vrátí 1, pokud heslo obsahuje velká a malá písmena
bool lower_and_upper_case(char password_string[MAX_PASSWORD_LENGTH], int length)
{
    int i = 0;
    while (i < length)
    {
        if ((password_string[i] >= 'A') && (password_string[i] <= 'Z'))
        {
            while (i < length)
            {
                if ((password_string[i] >= 'a') && (password_string[i] <= 'z'))
                {
                    return 1;
                }
                i++;
            }
        }
        i++;
    }
    return 0;
}

//funkce vrátí 1, pokud je v hesle číslo
bool number(char password_string[MAX_PASSWORD_LENGTH], int length)
{
    int i = 0;
    while (i < length)
    {
        if ((password_string[i] >= '0') && (password_string[i] <= '9'))
        {
            return 1;
        }
        i++;
    }
    return 0;
}

//funkce vrátí 1, pokud heslo obsahuje speciální znaky
bool special_characters(char password_string[MAX_PASSWORD_LENGTH], int length)
{
    int i = 0;
    while (i < length)
    {
        if ((password_string[i] >= 32 && password_string[i] <= 47) || (password_string[i] >= 58 && password_string[i] <= 64) || (password_string[i] >= 91 && password_string[i] <= 96) || (password_string[i] >= 123 && password_string[i] <= 126))
        {
            return 1;
        }
        i++;
    }
    return 0;
}

//funkce získá podřetězec
void get_substring(char password_string[MAX_PASSWORD_LENGTH], int j, long PARAM, char substring[PARAM + 1])
{
    for (int i = 0; i < PARAM; i++)
    {
        substring[i] = password_string[j + i];
    }
}

//funkce porovnává dva řetězce
bool compare_strings(char first_string[], char second_string[])
{
    int flag = 0, i = 0;                                        // integer variables declaration
    while (first_string[i] != '\0' || second_string[i] != '\0') // while loop
    {
        if (first_string[i] != second_string[i])
        {
            flag = 1;
            break;
        }
        i++;
    }
    //funkce vrátí 1, pokud jsou podřetězce stejné
    return control_flag(flag);
}

bool control_flag(int flag)
{
    if (flag == 0)
        return 1;
    else
        return 0;
}

//funkce kontroluje 1. úroveň, vratí 1, pokud heslo obsahuje velké a malé písmeno.
bool level_first(char password_string[MAX_PASSWORD_LENGTH], int length)
{
    if (lower_and_upper_case(password_string, length))
        return 1;
    else
        return 0;
}

//funkce kontroluje 2. úroveň, vratí 1, pokud heslo obsahuje znaky z alespoň PARAM skupin
bool level_second(char password_string[MAX_PASSWORD_LENGTH], int length, long PARAM)
{
    int ok = 2; //počet skupin
    if (number(password_string, length))
        ok++;
    if (special_characters(password_string, length))
        ok++;
    if ((ok >= PARAM) || (ok == 4))
        return 1;
    else
        return 0;
}
//funkce kontroluje 3. úroveň, vratí 1, pokud Heslo neobsahuje sekvenci stejných znaků délky alespoň PARAM
bool level_third(char password_string[MAX_PASSWORD_LENGTH], int length, long PARAM)
{
    int flag = 0;
    length = my_strlen(password_string);
    int ok = 1; //délka sekvence
    for (int i = 0; i <= length; i++)
    {
        if (password_string[i] == password_string[i + 1])
            ok++;
        else
            ok = 1;
        if (ok == PARAM)
            flag = 1;
    }
    return control_flag(flag);
}
//funkce kontroluje 4. úroveň, vratí 1,pokud  heslo neobsahuje dva stejné podřetězce délky alespoň PARAM
bool level_fourth(char password_string[MAX_PASSWORD_LENGTH], long PARAM)
{
    char substring[PARAM + 1];
    char substring_compare[PARAM + 1];
    int flag = 0;

    for (int i = 0; i < my_strlen(password_string); i++)
    {
        get_substring(password_string, i, PARAM, substring);

         for (int j = i + 1; j < my_strlen(password_string); j++)
        {
            get_substring(password_string, j, PARAM, substring_compare);

            if (compare_strings(substring, substring_compare))
            {
                flag = 1;
            }
        }
    }
    return control_flag(flag);
}

void level_all(char password_string[MAX_PASSWORD_LENGTH], int LEVEL, long PARAM)
{
    int length = my_strlen(password_string);
    switch (LEVEL)
    {
    case 1:
        if (level_first(password_string, length))
            printf("%s", password_string);
        break;

    case 2:
        if (level_second(password_string, length, PARAM) && level_first(password_string, length))
            printf("%s", password_string);
        break;
    case 3:
        if (level_second(password_string, length, PARAM) && level_first(password_string, length) && level_third(password_string, length, PARAM))
            printf("%s", password_string);
        break;
    case 4:
        if (level_second(password_string, length, PARAM) && level_first(password_string, length) && level_third(password_string, length, PARAM) && level_fourth(password_string, PARAM))
            printf("%s", password_string);
        break;
    }
}

//funkce najde a vrátí minimální délku hesla
int min_length_string(int MIN, char password_string[MAX_PASSWORD_LENGTH])
{
    int length = my_strlen(password_string);
    if (MIN > length)
        MIN = length;
    return MIN;
}

//funkce porovnává třetí argument s "--stats", vratí 1, pokud jsou stejné
int check_stats(char *argv[])
{
    int i = 3;
    char argv_stats[] = "--stats";
    if (argv[i] != 0)
    {
        if (compare_strings(argv_stats, argv[i]))
            return 1;
    }
    return 0;
}

//funkce vyhledá data potřebná pro statistiku
void start_stats(char password_string[MAX_PASSWORD_LENGTH], Stats_count *stats_count, int ascii_array[])
{
    stats_count->MIN = min_length_string(stats_count->MIN, password_string);
    stats_count->number_string++;
    stats_count->number_character += my_strlen(password_string);
    for (int i = 0; i < my_strlen(password_string); i++)
        ascii_array[(int)password_string[i]] = 1;
}

//funkce vyhledá prumernu delku a zobrazí statistiku
void stats(char *argv[], int number_character, int number_string, int MIN, int ascii_array[])
{
    float AVG;
    int NCHARS = 0;
    if (check_stats(argv))
    {
        for (int i = 0; i < 128; i++)
            NCHARS += ascii_array[i];
        AVG = (float)number_character / number_string;
        printf("Statistika:\n");
        printf("Ruznych znaku: %d\n", NCHARS);
        printf("Minimalni delka: %d\n", MIN);
        printf("Prumerna delka: %.1f\n", AVG);
    }
}

//kontrola argumentu stats
bool check_argv_stats(char * argv[]){
    
    if (argv[3] == NULL)
        return 1;
    if (check_stats(argv) == 0)
    {
        fprintf(stderr, "Invalid argument --stats\n");
        return 0;
    }
    return 1;
}

//kontrola vstupních chyb, vrátí 1, pokud nejsou žádné chyby
int error(int error_step, int argc, long PARAM, int LEVEL, char password_string[MAX_PASSWORD_LENGTH], char * argv[])
{
    if (error_step == 1){
        if (check_argc(argc))
            return 1;
    }
    else if (error_step == 2)
    {
        if (check_argc(argc) && check_argv(LEVEL, PARAM) && check_password(password_string) && check_argv_stats(argv))
            return 1;
    }
    return 0;
}

//funkce kontroluje počet argumentů argc, pokud argc není 3 nebo 4, funkce vypíše chybu a vrátí 0
int check_argc(int argc)
{
    if (argc < 3 || argc > 4)
    {
        fprintf(stderr, "Invalid number of arguments\n ");
        return 0;
    }
    return 1;
}

//funkce kontroluje argv
int check_argv(int LEVEL, long PARAM)
{
    //pokud LEVEL není 1, 2, 3 nebo 4, funkce vypíše chybu a vrátí 0
    if (LEVEL < 1 || LEVEL > 4)
    {
        fprintf(stderr, "Invalid level number\n ");
        return 0;
    }
    //pokud PARAM nméně než 1, funkce vypíše chybu a vrátí 0
    if (PARAM < 1)
    {
        fprintf(stderr, "Invalid parameter number\n");
        return 0;
    }
    return 1;
}

//pokud je délka hesla větší než 100, funkce vypíše chybu a vrátí 0
int check_password(char password_string[MAX_PASSWORD_LENGTH])
{
    int length = my_strlen(password_string);
    if (length > 100)
    {
        fprintf(stderr, "Invalid password length\n ");
        return 0;
    }
    return 1;
}
