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
%left '*' '/'
%precedence NEG

%%

programa                :   PROGRAMA IDENTIFICADOR lista-sentencias FIN_PROGRAMA {if (yynerrs || yylexerrs) YYABORT; else YYACCEPT;}
                        ;

lista-sentencias        :   sentencia
                        |   lista-sentencias sentencia
                        ;

sentencia               :   ESCRIBIR '(' lista-identificadores ')' ';'
                        |   LEER '(' lista-identificadores ')' ';'
                        |   IDENTIFICADOR ASIGNACION expresion ';'
                        |   ENTERO IDENTIFICADOR ';'
                        |   error ';'
                        ;

lista-identificadores   :   lista-identificadores ',' IDENTIFICADOR
                        |   IDENTIFICADOR
                        ;

expresion               :   expresion '+' expresion
                        |   expresion '-' expresion
                        |   expresion '*' expresion
                        |   expresion '/' expresion
                        |   '-' expresion %prec NEG
                        |   '(' expresion ')'
                        |   IDENTIFICADOR
                        |   CONSTANTE
                        ;

%%

void yyerror(const char *s) {
    printf("linea %d: %s\n", yylineno, s);
    return;
}