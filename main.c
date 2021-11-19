#include "parser.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"

int yylexerrs = 0;
extern int yynerrs;

int main()
{
	switch( yyparse() ) {
        case 0:
            printf("OK\n");
            break;
        case 1:
            printf("ERRORES\n");
            break;
        case 2:
            printf("MEMORIA INSUFICIENTE\n");
            break;
    }

    printf("ERRORES SINTACTICOS: %d, ERRORES LEXICOS: %d\n", yynerrs, yylexerrs);
	return 0;		
}