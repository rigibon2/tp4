%code top{
#include <stdio.h>
#include "scanner.h"
}

%code provides{
void yyerror(const char *);
extern int yylexerrs;
}

%defines "parser.h"
%output "parser.c"
%token PROGRAMA ENTERO LEER ESCRIBIR FIN_PROGRAMA IDENTIFICADOR CONSTANTE ASIGNACION
%define api.value.type {char *}
%define parse.error verbose
%left '+' '-'
%left '*' '/' '%'
%precedence NEG

%%
programa:               PROGRAMA IDENTIFICADOR {printf("programa %s\n", yylval);} lista-sentencias FIN_PROGRAMA {if (yynerrs || yylexerrs) YYABORT;}
                        ;

lista-sentencias:       sentencia
                        |   lista-sentencias sentencia
                        ;

sentencia:              ENTERO IDENTIFICADOR {printf("entero %s\n", yylval);} ';' 
                        |   IDENTIFICADOR ASIGNACION expresion ';' {printf("asignacion\n");}
                        |   LEER '(' lista-identificadores ')' ';' {printf("leer\n");}
                        |   ESCRIBIR '(' lista-expresiones ')' ';' {printf("escribir\n");}
                        |   error ';'
                        ;

lista-identificadores:  lista-identificadores ',' IDENTIFICADOR
                        |   IDENTIFICADOR
                        ;

lista-expresiones:      lista-expresiones ',' expresion
                        |   expresion
                        ;

expresion:              expresion '+' expresion {printf("suma\n");}
                        |   expresion '-' expresion {printf("resta\n");}
                        |   expresion '*' expresion {printf("multiplicacion\n");}
                        |   expresion '/' expresion {printf("division\n");}
                        |   expresion '%' expresion {printf("modulo\n");}
                        |   IDENTIFICADOR
                        |   CONSTANTE
                        |   '(' expresion ')'       {printf("parentesis\n");}                        
                        |   '-' expresion %prec NEG {printf("inversion\n");}                        
                        ;
%%

void yyerror(const char *s) {
    printf("linea #%d: %s\n", yylineno, s);
    return;
}