/******************************************************************************************************************************************/
/* * *                                            Projekt 2 - Práce s datovými strukturami, IZP                                       * * */   
/* * *                                                  Autor: Taipova Evgeniya, xtaipo00                                             * * */
/* * *                                                              6.12.2020                                                         * * */

/*                                                          Příkazy pro změnu výběru
[R,C] - výběr buňky na řádku R a sloupci C.
[R,_] - výběr celého řádku R.
[_,C] - výběr celého sloupce C.
[R1,C1,R2,C2] - výběr okna, tj. všech buněk na řádku R a sloupci C, pro které platí R1 <= R <= R2, C1 <= C <= C2. Pokud namísto čísla R2 resp. C2 bude pomlčka, nahrazuje tak maximální řádek resp. sloupec v tabulce.
[_,_] - výběr celé tabulky.
[min] - v již existujícím výběru buněk najde buňku s minimální numerickou hodnotou a výběr nastaví na ni.
[max] - obdobně jako předchozí příkaz, ale najde buňku s maximální hodnotou.
[find STR] - v již existujícím výběru buněk vybere první buňku, jejíž hodnota obsahuje podřetězec STR.
[_] - obnoví výběr z dočasné proměnné (viz níže).
                                                        Příkazy pro úpravu struktury tabulky
irow - vloží jeden prázdný řádek nad vybrané buňky.
arow - přidá jeden prázdný řádek pod vybrané buňky.
*/

#include "pch.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>


char commands_[1000][20];
int quantitCommands_ = 0;
char* table_[10][10];
int cols_=1,rows_=1;
int row1=1, row2=1, col1=1, col2=1;
char filePath_[200];
 const int sizeSstring_=200;
 char delim_ = ' ';
 int parseCommand(char* str);

 

 void initCommands()
 {
	 for (int i = 0; i < 1000; i++)
		 strcpy(commands_[i], "\0");


 }
int  findStr(char* str1, int pos1, int pos2,  char* str)
 {
	for (int i = pos1; i < pos2; i++)
		str[i - pos1] = str1[i];
	str[pos2 - pos1] = '\0';
	return 0;
 }
int parseCommandsList(char* str)
{
	int size = strlen(str);
	char command[100];
	int pos1 = 0, pos2 = 0;
	for (int i = 0; i < size; i++)
		if ((i == size - 1) || (str[i] == ';'))
		{

			if (i == size - 1)
				pos2 = size;
			else
				pos2 = i;
			for (int j = pos1; j < pos2; j++)
				command[j - pos1] = str[j];
			command[pos2 - pos1] = '\0';
			
			parseCommand(command);
			pos1 = i + 1;
		}

}

 float findMax()//najdeme maximální prvek
 {
	 double  max = atof(table_[row1-1][col1-1]);
	 int c1 = col1, c2 = col2, r1 = row1, r2 = row2;
	 for (int i = r1; i <= r2; i++)
		 for (int j = c1; j <= c2; j++)
		 {
			 
			 float val= atof(table_[i-1][j-1]);
			
			 if (val > max)
			 {

				 max = val;
				 col1 = col2 = j;
				 row1 = row2 = i;
			 }
		 }

	 printf("%f", max); printf("\n");
	 return max;
 }
 float findMin()//najdeme minimální prvek
 {
	 int c1 = col1, c2 = col2, r1 = row1, r2 = row2;
	 double min = atof(table_[row1 - 1][col1 - 1]);
	 for (int i = r1; i <= r2; i++)
		 for (int j = c1; j <= c2; j++)
		 {
			 float val = atof(table_[i - 1][j - 1]);
			 if (val < min) {
				 min = val;
				 col1 = j; col2 = j;
				 row1 = i; row2 = i;
			 }
		 }
	 printf("%f", min);
	 printf("\n");
	 return min;
 }

 void findStr(char * str)
 {
	 
	 for (int i = row1; i <= row2; i++) {

		 for (int j = col1; j <= col2; j++)
			 if (strstr(table_[i][j], str))
			 {
				 col1 = j; col2 = j;
				 row1 = i; row2 = i;
				 return;
			 }
	 }
	 
 }
 

 int irow()
 {
	 FILE *fp1;
	 if ((fp1 = fopen(filePath_, "w")) == NULL) {
		 printf("Cannot open file.\n");
		 return 1;
	 }
	 char str[sizeSstring_];
	 for (int i = 1; i <= rows_; i++) {
		 
		 if(i==row1)
			 fprintf(fp1, "%s", "\n");
		 for (int j = 1; j <= cols_; j++)
		 {
			 
			 fprintf(fp1, "%s", table_[i-1][j-1]);
			 if(j!=cols_-1)
				 fprintf(fp1, "%s", " ");
		 }
		 if (i != rows_ - 1)
			 fprintf(fp1, "%s", "\n");
	 }

	 fclose(fp1);
	
	 return 0;
 
 }
 int arow()
 {

	 FILE *fp1;
	 if ((fp1 = fopen(filePath_, "w")) == NULL) {
		 printf("Cannot open file.\n");
		 return 1;
	 }
	 char str[sizeSstring_];
	 for (int i = 1; i <= rows_; i++) {

		
		 for (int j = 1; j <= cols_; j++)
		 {

			 fprintf(fp1, "%s", table_[i-1][j-1]);
			 if (j != cols_ - 1)
				 fprintf(fp1, "%s", " ");
		 }
		 if (i != rows_ - 1)
			 fprintf(fp1, "%s", "\n");
		 if (i == row2)
			 fprintf(fp1, "%s", "\n");
	 }

	 fclose(fp1);
	 return 0;
 }

 int parseCommandOther(char* str)//Zpracování arow irow
 {
	 if (!strcmp(str, "irow"))
		 irow();
	 else
	 if(!strcmp(str, "arow"))
		 arow();
	 return 0;

 }
 int parseCommandHighlight(char* str)// Zpracování příkazů pro výběr buněk
 {
	 int positions[3];
	 char com[4][10];
	 int size = strlen(str);
	 int count = 0;
	 for (int i = 1; i < size; i++)
		 if (str[i] == ',')
			 positions[count++]=i;
	 if (count == 0) {
		 if (str[1] == 'm')
		 {
			 if ((str[2] == 'a') && (str[3] == 'x'))

				 findMax();
			 else
				 if ((str[2] == 'i') && (str[3] == 'n'))
					 findMin();
			 return 0;
		 }

		 if((str[1] == 'n')&& (str[2] == 'a') && (str[3] == 'j') && (str[4] == 'i') && (str[5] == 't') )
		 {
			 char str1[200];
			 for (int i = 7; i < size - 1; i++)
				 str1[i - 7] = str[i];
			 str1[size - 8] = '\0';
			 findStr(str1);
			 return 0;
		 }
		 if (str[1] == '_')
		 {
			 row1 = 1; row2 = 1; col1 = 1; col2 = 1;
			
			 return 0;
		 }
		 

	 
	 }
	 
	 if(count==1)
	 {
		 findStr(str, 1, positions[0], com[0]);
		 findStr(str,  positions[0]+1, size-1, com[1]);
		 if ((com[0][0] == '_')&&(com[1][0] == '_'))
		 {
			 row1 = 1; row2 = rows_ ; col1 = 1; col2 = cols_;
			 
			 return 0;
		 }
		 
		 if ((com[0][0] == '_') && (com[1][0] != '_'))
		 {
			 row1 = 1; row2 = rows_ ; 
			 int d = atoi(com[1]);
			 col1 = d; col2 = d;
			 
			 return 0;
		 }
		 if ((com[0][0] != '_') && (com[1][0] == '_'))
		 {
			 
			 int d = atoi(com[1]);
			 row1 = d; row2=d;
			 col1 = 1; col2 = cols_;
			 
			 return 0;
		 }
		 if ((com[0][0] != '_') && (com[1][0] != '_'))
		 {

			 int d1 = atoi(com[1]),d0 = atoi(com[0]);
			 row1 = d0; row2 = d0;
			 col1 = d1; col2 = d1;
			
			 return 0;
		 }

	 }
	 else
		 if(count==3)
	 {
		 findStr(str, 1, positions[0], com[0]);
		 findStr(str, positions[0]+1, positions[1], com[1]);
		 findStr(str, positions[1] + 1, positions[2], com[2]);
		 findStr(str, positions[2] + 1, size-1, com[3]);
		 row1 = atoi(com[0]); row2 = atoi(com[1]);
		 col1 = atoi(com[2]);col2= atoi(com[3]);
		// count << row1 << row2 << col1 << col2 << endl;
		 return 0;
		
	 }
	 return 1;
 }

 int parseCommand(char* str)
 {
	 int size = strlen(str);
	 if (str[0] == '[')
		 parseCommandHighlight(str);
	 else
		 parseCommandOther(str);
	
		 
	 return 0;

 }

 int parseString(char* str,int count)
 {

	 int size = strlen(str);
	
	 cols_ = 1;
	 int pos = 0;
	 int countCols = 0;
	 char str2[50];
	 for (int i = 0; i < size; i++) {
		if(str[i]=='\"')
			str[i] = '\\"';
		 if ((str[i] == delim_) || (i == size - 1))
		 {
			 int pos1 = 0;
			 if (i == size - 1)
				 pos1 = i + 1;
			 else
				 pos1 = i;
			 for (int j = pos; j < pos1; j++)
				str2[j - pos]=str[j];
			 str2[pos1 - pos] = '\0';
			 strcpy(table_[rows_ - 1][cols_ - 1], str2);
		
			 cols_++;
			 pos = i + 1;

		 }
		 
	 }
	 cols_--;
	 
	
	 return 0;
 }
 
 int readTable()// Čtení dat ze souboru s tabulkou
 {
	 
	 rows_ = 1;
	 
	 FILE *fp;
	 if ((fp = fopen(filePath_, "r")) == NULL) {
		 printf("Cannot open file.\n");
		 return 1;
	 }
	 rows_ = 1;
	 char str[sizeSstring_];
	 while (fgets(str, sizeSstring_, fp)) {
		
		  parseString(str, rows_);

	 rows_++;
 }
	 rows_--;

	
	fclose(fp);
	

	return 0;
}

int main(int argc, char** argv)
{
	
	double c = 0.5;
	

	for (int i = 0; i < 10; i++)
	{

		for (int j = 0; j < 10; j++) {
			table_[i][j] = (char*)malloc(20 * sizeof(char));
			if (!table_[i][j])
				;
	}
	}
	strcpy(filePath_, argv[1]);
	
	if(argc==4)
	delim_ = argv[3][0];
	
	char str[10000];
	readTable();
	while (fgets(str, sizeSstring_, stdin))
	{

		parseCommandsList(str);
		fseek(stdin, 0, SEEK_END);
	}
