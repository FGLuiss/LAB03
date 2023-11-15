%{
        #include <stdio.h>
        #include <stdlib.h>
        #include "LAB02.tab.h"
        void yyerror(const char *s);

        char aux[100];
%}

%option yylineno

/*Se presentan las declaraciones de las expresiones regulares*/
 /*  SECCION TOKENS  */
DIGITO          [0-9]
ESPACIO         [" "]
CHAR_COMA       [","]
CHAR_PUNTO      ["."]
CHAR_PUNTOYCOMA [";"]
CHAR_DOSPUNTOS  [":"]
CHAR_ASTERISCO  ["*"]

IDENTIFICADOR   ([a-zA-Z]|á|é|í|ó|ú|Á|É|Ó|Ú|Í)([a-zA-Z0-9]|á|é|í|ó|ú|Á|É|Ó|Ú|Í)*
ENTERO  {DIGITO}+
DECIMAL     {DIGITO}{0,8}{CHAR_PUNTO}{DIGITO}{1,8}


 /*La regex de abajo considera string a todo lo que este dentro de comillas dobles excepto el caracter de fin de linea y la pripia comilla doble*/
CONST_CADENA    ([\"][a-zA-ZñÑ0-9%_+\\ -']+["])|([\'][a-zA-ZñÑ0-9%_+\\ -']+['])|([‘][a-zA-ZñÑ0-9%_+\\ -']+[’])

 /*Operadores lógicos y operadores aritmeticos basicos*/
OP_SUMA         ["+"]
OP_RESTA        ["-"]
OP_MULT         ["*"]
OP_DIV          ["/"]
OP_IGUAL        ["="]
OP_MAYOR        [">"]
OP_MENOR        ["<"]
OP_MAYORIGUAL   ">="
OP_MENORIGUAL   "<="
OP_COMP_IGUAL   "=="
OP_NEGACION     "!"
OP_DISTINTO     "!="
 /*Tiene doble funcioanlidad, definir un tipo de dato o asignar un valor*/
OP_DOSPUNTOS    [":"]

 /*Caracteres que de apertura, cierre y fin de linea*/
LLAVE_A         "{"
LLAVE_C         "}"
PARENTESIS_A    "("
PARENTESIS_C    ")"
FIN_SENTENCIA   ";"


%%
"CREATE Table"              {return CREATE_TABLE; }
"CREATE TABLE"              {return CREATE_TABLE; }
"DROP Table"                {return DROP_TABLE; }
"DROP TABLE"                {return DROP_TABLE; }
SELECT                      {return SELECT; }
WHERE                       {return WHERE; }
"GROUP BY"                  {return GROUP_BY; }
"ORDER BY"                  {return ORDER_BY; }
INSERT                      {return INSERT; }
DELETE                      {return DELETE; }
UPDATE                      {return UPDATE; }
MAX                         {return MAX; }
MIN                         {return MIN; }
AVG                         {return AVG; }
COUNT                       {return COUNT; }
INTO                        {return INTO; }
VALUES                      {return VALUES; }
FROM                        {return FROM; }
SET                         {return SET; }
ASC                         {return ASC; }
DESC                        {return DESC; }
DECIMAL                     {return DECIMAL; }
VARCHAR                     {return VARCHAR; }
INTEGER                     {return INTEGER; }
AND                         {return AND; }
OR                          {return OR;}

 /*Expresiones regulares*/
{DECIMAL}    	            { return DECIMAL; }
{ENTERO}      	            { return ENTERO; }
{CONST_CADENA}      	    { return CONST_CADENA; }
{IDENTIFICADOR}          	{ return IDENTIFICADOR; }

 /*Simbolos*/
{LLAVE_A}          	        { return LLAVE_A; }
{LLAVE_C}           	    { return LLAVE_C; }
{PARENTESIS_A}        	    { return PARENTESIS_A; }
{PARENTESIS_C}          	{ return PARENTESIS_C; }
{CHAR_COMA}           	    { return CHAR_COMA; }
{CHAR_PUNTOYCOMA}           { return CHAR_PUNTOYCOMA; }
{CHAR_ASTERISCO}            { return CHAR_ASTERISCO; }

 /*Comparacion*/
{OP_IGUAL}          		{ return OP_IGUAL; }
{OP_COMP_IGUAL}          	{ return OP_COMP_IGUAL; }
{OP_DISTINTO}         	    { return OP_DISTINTO; }
{OP_MENORIGUAL}          	{ return OP_MENORIGUAL; }
{OP_MAYORIGUAL}          	{ return OP_MAYORIGUAL; }
{OP_MENOR}           	    { return OP_MENOR; }
{OP_MAYOR}           	    { return OP_MAYOR; }
{OP_NEGACION}           	{ return OP_NEGACION; }

 /*Booleanos*/
{OP_NEGACION}           	{ return OP_NEGACION; }
 /*Operadores aritméticos y asignación*/
{OP_SUMA}       {return OP_SUMA; }
{OP_MENOR}      {return OP_MENOR; }
{OP_DIV}        {return OP_DIV; }
{OP_RESTA}      {return OP_RESTA; }

 /*Espacios adicionales*/
{ESPACIO}           {}

 /* Aqui se detecta si no se cumple ninguna de las reglas anteriores y se marca como error */
({ENTERO}|{DECIMAL}){IDENTIFICADOR}   		{
                                    sprintf( aux, "ERROR léxico constante numerica %s", yytext );
                                    yyerror( aux );
                                }
								
.                               {
                                    sprintf( aux, "ERROR léxico caracter inválido %s", yytext );
                                    yyerror( aux );
                                }

%%
int yywrap( void ) {
        return 1;
}