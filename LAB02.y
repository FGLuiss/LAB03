%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yyerror(const char*);
extern char* yytext;
extern FILE* yyin;

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
%token <identifier> IDENTIFIER
%token <string> STRING
%token CREATE TABLE DROP INSERT INTO VALUES DELETE FROM UPDATE SET SELECT WHERE GROUP BY ORDER ASC DESC AND OR
%token SEMICOLON LPAREN RPAREN COMMA DOT EQUAL PLUS MINUS MULTIPLY DIVIDE GT LT GE LE EQ NEQ
%token ASTERISK FUNCTION


%type <integer> number
%type <decimal> value
%type <string> string
%type <string> condition



%%

program: statement SEMICOLON program
        | /* empty */
        ;

statement: create_table
         | drop_table
         | insert_values
         | delete_from
         | update_set
         | select_statement
         ;

create_table: CREATE TABLE IDENTIFIER LPAREN columns RPAREN
            ;

columns: column
       | column COMMA columns
       ;

column: IDENTIFIER IDENTIFIER LPAREN number RPAREN
      ;

drop_table: DROP TABLE IDENTIFIER
          ;

insert_values: INSERT INTO IDENTIFIER values
             ;

values: LPAREN values_list RPAREN
      ;

values_list: value
           | value COMMA values_list
           ;

value: IDENTIFIER
     | number
     | STRING
     ;

delete_from: DELETE FROM IDENTIFIER WHERE condition
           ;

update_set: UPDATE IDENTIFIER SET assignment WHERE condition
          ;

assignment: IDENTIFIER EQUAL value
          ;

select_statement: SELECT select_list FROM IDENTIFIER where_group_order
               ;

select_list: ASTERISK
           | select_item
           | select_item COMMA select_list
           ;

select_item: value
           | FUNCTION LPAREN IDENTIFIER RPAREN
           ;

where_group_order: WHERE condition
                | GROUP BY IDENTIFIER
                | ORDER BY order_list
                | WHERE condition GROUP BY IDENTIFIER
                | WHERE condition ORDER BY order_list
                | GROUP BY IDENTIFIER ORDER BY order_list
                | WHERE condition GROUP BY IDENTIFIER ORDER BY order_list
                | /* empty */
                ;

order_list: IDENTIFIER
          | IDENTIFIER COMMA order_list
          ;

condition: value EQ value
         | value NEQ value
         | value GT value
         | value LT value
         | value GE value
         | value LE value
         | condition AND condition
         | condition OR condition
         | LPAREN condition RPAREN
         ;

number: INTEGER
      ;

value: INTEGER
     | DECIMAL
     | STRING
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
    yyparse();

    fclose(input);

    return 0;
}

int yyerror(const char* msg) {
    fprintf(stderr, "Error sintáctico: %s\n", msg);
    return 0;
}
