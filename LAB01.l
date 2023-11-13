%{
#include "y.tab.h"  // Archivo de cabecera generado por Yacc/Bison
%}

%%
CREATE          { return CREATE; }
TABLE           { return TABLE; }
DROP            { return DROP; }
INSERT          { return INSERT; }
INTO            { return INTO; }
VALUES          { return VALUES; }
DELETE          { return DELETE; }
FROM            { return FROM; }
UPDATE          { return UPDATE; }
SET             { return SET; }
SELECT          { return SELECT; }
WHERE           { return WHERE; }
GROUP           { return GROUP; }
BY              { return BY; }
ORDER           { return ORDER; }
ASC             { return ASC; }
DESC            { return DESC; }
[0-9]+          { yylval.integer = atoi(yytext); return INTEGER; }
[0-9]+"."[0-9]+ { yylval.decimal = atof(yytext); return DECIMAL; }
[a-zA-Z][a-zA-Z0-9]* { yylval.identifier = strdup(yytext); return IDENTIFIER; }
"'"[^']*"'"     { yylval.string = strdup(yytext + 1, yyleng - 2); return STRING; }
"=="            { return EQ; }
"!="            { return NEQ; }
">"             { return GT; }
"<"             { return LT; }
">="            { return GE; }
"<="            { return LE; }
"AND"           { return AND; }
"OR"            { return OR; }
";"             { return SEMICOLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }
","             { return COMMA; }
"."             { return DOT; }
"="             { return EQUAL; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
[ \t\n]         ; // Ignorar espacios en blanco y saltos de línea
.               { /* Ignorar caracteres desconocidos */ }
%%

