
%option noyywrap noinput nounput

%{
#include <stdio.h>
%}

%%

\"([^"\r\n]|\"\")*\"    { ECHO; }

'[^\r\n]'               { ECHO; }

"--"[^\r\n]*            ;

(.|\n)                  { ECHO; }

%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uzycie: %s plik.adb\n", argv[0]);
        return 1;
    }

    FILE *plik = fopen(argv[1], "rb");

    if (plik == NULL) {
        perror("Nie mozna otworzyc pliku");
        return 1;
    }

    yyin = plik;
    yylex();

    fclose(plik);
    return 0;
}
