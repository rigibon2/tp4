%top{
	#include <stdio.h>
    #include "parser.h"
}

%option header-file="scanner.h"
%option outfile="scanner.c"
%option noinput
%option nounput
%option yylineno

Letra									[[:alpha:]]
Digito									[0-9]
Letra_Digito								[[:alnum:]]
Espacio								[[:space:]]
Asignacion								"<<"
Comentario								"//".*
Otros								[[:punct:]]{-}[();,+\-*/%]

%%
programa 								        return PROGRAMA;
entero									        return ENTERO;
leer									        return LEER;
escribir								        return ESCRIBIR;
fin-programa								    return FIN_PROGRAMA;
{Letra}{Letra_Digito}*							{yylval = strdup(yytext); return IDENTIFICADOR;}
{Digito}+								        {yylval = strdup(yytext); return CONSTANTE;}
"("									            return '(';
")"									            return ')';
";"									            return ';';
","									            return ',';
"+"									            return '+';
"-"									            return '-';
"*"									            return '*';
"/"									            return '/';
"%"									            return '%';

{Asignacion} 								                return ASIGNACION;
{Otros}+								                    {yylexerrs++; yyerror("Error léxico: cadena desconocida");}
{Letra}{Letra_Digito}*{Otros}+({Letra_Digito}|{Otros})*		{yylexerrs++; yyerror("Error léxico: identificador inválido");}
{Digito}+{Letra}+{Letra_Digito}*					        {yylexerrs++; yyerror("Error léxico: constante inválida");}
{Espacio}+								|
{Comentario}								;
%%