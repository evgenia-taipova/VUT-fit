// xsulta01
// xkrupe00 
// xtaipo00
// xkoval21
// xvinog00
//no time....

#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

// ПЕРЕМЕННЫЕ CAMELCASE
// НАЗВАНИЯ ФУНКЦИЙ SNAKECASE

// gcc -std=c99 -Wall -Wextra -Werror setcal.c -o setcal

#define MAX_ARG_COUNT 2
#define MAX_ROWS_COUNT 1000
#define MAX_WORD_LEN 30
#define WHITESPACE 32
#define FORBIDDEN_LIST_COUNT 19
#define POS_START_OF_LINE 2

// #define MAX_ROW_LEN 100

typedef struct {
    char *str;
    char **univerzum;
    int sizeForAllocation;
    unsigned number;
    unsigned wordsCount;
    unsigned univerzumWordsCount;
    size_t maxWordLen;
} lines_t;

// Set struct
typedef struct {
    char **set;
    int elementCount;

} set_t;

// Relation struct

typedef struct {
    char **relation;
    int elementCount;
} relation_t;

// TODO: перезаписывать элементы из U в отдельный массив слов-элементов юниверзума

// TODO: universum, set and relationship detection
//          universum - a definition of all words that will be further used in all existing sets:
//          - max len of a word is 30, cannot use 

char *my_strdup(const char *s) {
    char *p = malloc(strlen(s) + 1);
    if(p) 
        strcpy(p, s); 
    return p;
}

char *read_line(FILE *input){
    char *str = malloc(1 * sizeof(char));
    if (str == NULL){
        return NULL;
    }
    size_t len = 0;
    int c = fgetc(input);
    while (c != '\n'){
        ++len;
        char *strNew = realloc(str, (len+1) * sizeof(char));
        if (strNew == NULL){
            free(str);
            return NULL;
        }
        str = strNew;
        str[len-1] = c;
        c = fgetc(input);
        if (c == EOF){
            free(str);
            return NULL;
        }
    }
    str[len] = '\0';
    return str;
}



char** split_lines(lines_t *s){
    // const char delimeter[2] = " ";
    // s->wordsCount = 0;
    // char *word = NULL;
    // char *p;
    // //printf("line number: %d\n", s->number);
    // p = strdup(s->str);
    // word = strtok(p, delimeter); // получаем первое слово строки (U, S, R, C)
    // s->maxWordLen = strlen(word); // теоретическая максимальная длина слова
    // while (word != NULL){
    //     if(strlen(word) > s->maxWordLen){
    //         s->maxWordLen = strlen(word);
    //     }
    //     ++s->wordsCount;
    //     word = strtok(NULL, delimeter);
    // }
    // // цикл даёт нам максимальную длину слова в строке и количество слов в строке
    // // не учитывая первый символ, который не считается словом!
    // int i = 0;
    // char **wordLine = malloc(sizeof(char*) * s->maxWordLen * s->wordsCount * 2);
    // if (wordLine == NULL) return NULL;
    // for (word = strtok(s->str, delimeter); i <= s->wordsCount && word != NULL; word = strtok(NULL, delimeter)){
    //     ++i;
    //     wordLine[i] = word;
    // }
    // return wordLine;

    const char delimeter[2] = " "; 
    s->wordsCount = 0; 
    char *p = my_strdup(s->str); 
    char *tmpWord = strtok(p, delimeter); 
    int tmpWordLen = strlen(tmpWord); 
    (void) tmpWordLen; 
    while (tmpWord != NULL){ 
        if(strlen(tmpWord) > s->maxWordLen){
            s->maxWordLen = strlen(tmpWord);
        }
        ++s->wordsCount;
        tmpWord = strtok(NULL, delimeter);
    }
    free(p); 
    char **buffer; 
    buffer = malloc(sizeof(*buffer) * s->wordsCount); 
                                                      
    if(buffer == NULL) return NULL; 
    int wordsCount = 0; 
    char *word = strtok(s->str, delimeter); 
    int wordLen = strlen(word); 
    while (word != NULL){ 
        ++wordsCount;
        char **buffer_new = realloc(buffer, sizeof(char*) * (wordLen+1)); 

        if (buffer_new == NULL){
            free(buffer);
            return NULL;
        }
        buffer = buffer_new; 
        buffer[wordsCount-1] = word;
        word = strtok(NULL, delimeter);
        if (word != NULL) wordLen += strlen(word); 
    
    }
    s->sizeForAllocation = sizeof(char*) * (wordLen+1); 
    return buffer;
}

bool check_set(lines_t *s, char **line){
    // s->univerzum[0] is the very first character ("U")
    // same as line[0] is "S"
    // means that we have to always check arrays from pos=1
    
    bool isThere;
    for (size_t i = 1; i < s->wordsCount; i++){
        isThere = false;
        for (size_t j = 1; j < s->univerzumWordsCount; j++){
            if (strcmp(s->univerzum[j], line[i]) == 0) isThere = true;
        }
        if (!isThere) return isThere;
    }
    return isThere;
}

void read_file(FILE *file, char **lines, lines_t *s){
    s->str = read_line(file);
    while(s->str != NULL){
        ++s->number; 
        lines = split_lines(s);
        if(s->number == 1){
            s->univerzum = malloc(s->sizeForAllocation);
            memcpy(s->univerzum, lines, s->sizeForAllocation);
            s->univerzumWordsCount = s->wordsCount;
            printf("%s", s->univerzum[0]);
            for (size_t i = 1; i < s->wordsCount; i++) printf(" %s", s->univerzum[i]);
        } else {
            // if (strcmp(lines[0], "S") == 0){
            //     if (check_set(s, lines)){
            //         printf("OK\n");
            //     } else printf("NOT OK\n");
            // }
            printf("%s", lines[0]);
            for (size_t i = 1; i < s->wordsCount; i++) printf(" %s", lines[i]);
            s->str = read_line(file);
            printf("\n");
        }
    }
    free(lines);
}

bool empty_set(set_t *A)
{
    if(A->elementCount == 0)
        return false;

    return true;
}

unsigned long long card_set(set_t *A)
{
    return A->elementCount;
}

void complement_set(set_t *A, lines_t *U)
{

    unsigned i = 1;
    unsigned j = 1;
    printf("S");
    while(i < U->univerzumWordsCount)
    {
        if(strcmp(U->univerzum[i], A->set[j]) == 0)
        {
            j++;
            i++;            
        }
        else 
        {
            printf(" %s", U->univerzum[i]);
            i++; 
        }
    }
}

void union_set(set_t *A, set_t *B)
{

    printf("%s", A->set);
    unsigned i = 1;
    int j = 1;
    while(j < B->elementCount)
    {
        if(strcmp(A->set[i], B->set[j]) == 0)
        {
            j++;
            i++;            
        }
        else 
        {
            printf(" %s", B->set[j]);
            j++; 
        }
    }
}

void intersect_set(set_t *A, set_t *B, lines_t *U) 
{


    (void) A;
    (void) B;
    (void) U;
    // while(j < A->elementCount)
    // {
    //     if(strcmp(A->set[i], B->set[j]) == 0)
    //     {
    //         printf(" %s", A[i]);
    //         i++;            
    //         j++;
    //     }
    //     else 
    //     {
    //         j++; 
    //     }
    // }

}

char** minus_set(set_t *A, set_t *B)
{
    (void) A;
    (void) B;
    return 0;
}

bool subseteq_set(set_t *A, set_t *B)
{
    (void) A;
    (void) B;
    return 0;
}

bool subset_set(set_t *A, set_t *B)
{
    (void) A;
    (void) B;
    return 0;
}

bool equals_set(set_t *A, set_t *B)
{
    (void) A;
    (void) B;
    return 0;
}

int main(int argc, char *argv[]){
    lines_t Strings;
    Strings.number = 0;
    char **lines = NULL;
    if (argc > MAX_ARG_COUNT || argc == 1) {
        fprintf(stderr, "Error! Wrong argument count\n");
        return EXIT_FAILURE;
    }
    FILE *in = fopen(argv[1], "r");
    if (in == NULL){
        fprintf(stderr, "Something went wrong with file\n");
        return EXIT_FAILURE;
    }

    /* error: 'lines' may be used uninitialized in this function [-Werror=maybe-uninitialized] */
    read_file(in, lines, &Strings);

    //free(lines);
    free(Strings.str);
    free(Strings.univerzum);
    fclose(in);
    return EXIT_SUCCESS;
}