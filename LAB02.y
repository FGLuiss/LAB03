%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Error {
    char message[256];
    int line;
};

struct Error errors[100];  // Asumiendo un máximo de 100 errores
int error_count = 0;
int has_errors = 0;  // Nuevo indicador para determinar si hay errores

extern int yylex();
extern int yyerror(const char*);
extern char* yytext;
extern FILE* yyin;
extern int yylineno;

int yywrap() {
    return 1;
}

%}

%union {
    int integer;
    double decimal;
    char* identifier;
    char* string;
}

%token <integer> INTEGER
%token <decimal> DECIMAL
%token IDENTIFIER
%token STRING
%token CREATE_TABLE DROP_TABLE INSERT INTO VALUES DELETE FROM UPDATE SET SELECT WHERE GROUP_BY 
%token ORDER_BY ASC DESC AND  MAX MIN AVG COUNT VARCHAR ENTERO CONST_CADENA IDENTIFICADOR
%token LLAVE_A LLAVE_C PARENTESIS_A PARENTESIS_C CHAR_COMA CHAR_PUNTOYCOMA CHAR_ASTERISCO OP_IGUAL
%token OP_COMP_IGUAL OP_DISTINTO OP_MENORIGUAL OP_MAYORIGUAL OP_MENOR OP_MAYOR OP_NEGACION OP_SUMA
%token OP_DIV OP_RESTA
%token SEMICOLON LPAREN RPAREN COMMA DOT EQUAL PLUS MINUS MULTIPLY DIVIDE GT LT GE LE EQ NEQ
%token ASTERISK FUNCTION

// Definir la gramática
%start statements

%%

statements: statement SEMICOLON statements
          | /* empty */
          ;

statement: create_table_statement
         | drop_table_statement
         | insert_statement
         | delete_statement
         | update_statement
         | select_statement
         ;

create_table_statement: CREATE TABLE IDENTIFIER LPAREN column_definitions RPAREN
                    ;

column_definitions: column_definition
                | column_definitions COMMA column_definition
                ;

column_definition: IDENTIFIER IDENTIFIER LPAREN INTEGER RPAREN
                ;

drop_table_statement: DROP TABLE IDENTIFIER
                  ;

insert_statement: INSERT INTO IDENTIFIER values_list
               ;

values_list: LPAREN values RPAREN
          ;

values: value
      | values COMMA value
      ;

value: INTEGER
     | DECIMAL
     | STRING
     | IDENTIFIER
     ;

delete_statement: DELETE FROM IDENTIFIER WHERE conditions
               ;

update_statement: UPDATE IDENTIFIER SET update_list WHERE conditions
               ;

update_list: IDENTIFIER EQUAL value
           | update_list COMMA IDENTIFIER EQUAL value
           ;

select_statement: SELECT select_list FROM IDENTIFIER where_group_order
               ;

select_list: ASTERISK
           | selected_columns
           | functions
           ;

selected_columns: IDENTIFIER
               | selected_columns COMMA IDENTIFIER
               ;

functions: FUNCTION LPAREN IDENTIFIER RPAREN
         | functions COMMA FUNCTION LPAREN IDENTIFIER RPAREN
         ;

where_group_order: WHERE conditions
                | GROUP BY IDENTIFIER
                | ORDER BY order_list
                | /* empty */
                ;

order_list: IDENTIFIER ASC
          | IDENTIFIER DESC
          | order_list COMMA IDENTIFIER ASC
          | order_list COMMA IDENTIFIER DESC
          ;

conditions: condition
          | conditions AND condition
          | conditions OR condition
          ;

condition: IDENTIFIER EQ value
         | IDENTIFIER NEQ value
         | IDENTIFIER GT value
         | IDENTIFIER LT value
         | IDENTIFIER GE value
         | IDENTIFIER LE value
         ;
%%

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s archivo_de_entrada\n", argv[0]);
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        perror("Error al abrir el archivo de entrada");
        return 1;
    }

    yyin = input;
    if (yyparse() == 0 && !has_errors) {
        printf("Correcto\n");
    } else {
        for (int i = 0; i < error_count; i++) {
            fprintf(stderr, "Incorrecto\n%s en la línea %d\n", errors[i].message, errors[i].line);
        }
    }

    fclose(input);

    return 0;
}

int yyerror(const char* msg) {
    // Almacena información sobre el error
    strcpy(errors[error_count].message, msg);
    errors[error_count].line = yylineno;
    error_count++;
    has_errors = 1;  // Indica que ha ocurrido un error sintáctico
    return 0;
}
