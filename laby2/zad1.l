
%option noyywrap noinput nounput

%x W_LINII

%{
#include <stdio.h>

int liczba_linii = 0;
int liczba_slow = 0;
%}

BIALE    [ \t\r\f\v]
SLOWO    [^ \t\r\f\v\n]+

%%

<INITIAL>{BIALE}+    ;
<INITIAL>\n          ;

<INITIAL>{SLOWO} {
    printf("%s", yytext);

    liczba_linii++;
    liczba_slow++;

    BEGIN(W_LINII);
}

<W_LINII>{BIALE}+    ;

<W_LINII>{SLOWO} {
    putchar(' ');
    printf("%s", yytext);

    liczba_slow++;
}

<W_LINII>\n {
    putchar('\n');
    BEGIN(INITIAL);
}

<W_LINII><<EOF>> {
    putchar('\n');
    yyterminate();
}

%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uzycie: %s plik.txt\n", argv[0]);
        return 1;
    }

    FILE *plik = fopen(argv[1], "rb");

    if (plik == NULL) {
        perror("Nie mozna otworzyc pliku");
        return 1;
    }

    yyin = plik;
    yylex();

    printf("Liczba linii: %d\n", liczba_linii);
    printf("Liczba slow: %d\n", liczba_slow);

    fclose(plik);
    return 0;
}
