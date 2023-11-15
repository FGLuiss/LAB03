%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;
int linea;
extern char *yytext;

int has_syntax_error = 0;
int num_syntax_errors = 0;

void yyerror(const char *s);


%}


%token CREATE_TABLE DROP_TABLE INSERT INTO VALUES DELETE FROM UPDATE SET SELECT WHERE GROUP_BY 
%token ORDER_BY ASC DESC AND OR MAX MIN AVG COUNT VARCHAR ENTERO DECIMAL CONST_CADENA IDENTIFICADOR
%token LLAVE_A LLAVE_C PARENTESIS_A PARENTESIS_C CHAR_COMA CHAR_PUNTOYCOMA CHAR_ASTERISCO OP_IGUAL
%token OP_COMP_IGUAL OP_DISTINTO OP_MENORIGUAL OP_MAYORIGUAL OP_MENOR OP_MAYOR OP_NEGACION OP_SUMA
%token OP_DIV OP_RESTA INTEGER
%start program

%%

program: declaracion
        ;

declaracion: tipo declaracion
        | /* epsilon */
        ;

tipo: create_table
    | drop_table
    | insert 
    | delete
    | update 
    | select 
    | error 
    ;

create_table: CREATE_TABLE IDENTIFICADOR PARENTESIS_A columnas PARENTESIS_C CHAR_PUNTOYCOMA
            ;

columnas: columnas CHAR_COMA IDENTIFICADOR tipo_dato
        | IDENTIFICADOR tipo_dato
        ;

tipo_dato: INTEGER
         | DECIMAL PARENTESIS_A ENTERO PARENTESIS_C
         | VARCHAR PARENTESIS_A ENTERO PARENTESIS_C
         ;

drop_table: DROP_TABLE IDENTIFICADOR CHAR_PUNTOYCOMA
        ;

insert: INSERT INTO IDENTIFICADOR algo VALUES PARENTESIS_A valores PARENTESIS_C CHAR_PUNTOYCOMA
    ;

algo: PARENTESIS_A columnas PARENTESIS_C
    | /* epsilon */
    ;

valores: valores CHAR_COMA valor
       | valor
       ;

valor: ENTERO
     | CONST_CADENA
     | DECIMAL
     ;

delete: DELETE FROM IDENTIFICADOR WHERE condiciones CHAR_PUNTOYCOMA
    ;

update: UPDATE IDENTIFICADOR SET asignaciones WHERE condiciones CHAR_PUNTOYCOMA
    ;

asignaciones: asignaciones CHAR_COMA IDENTIFICADOR OP_IGUAL valor
            | IDENTIFICADOR OP_IGUAL valor
            ;

select: SELECT proyeccion FROM IDENTIFICADOR condiciones_agrupacion_orden CHAR_PUNTOYCOMA
    ;

proyeccion: CHAR_ASTERISCO
          | IDENTIFICADOR
          | funciones
          ;

funciones: funciones CHAR_COMA funcion
         | funcion
         ;

funcion: MAX PARENTESIS_A IDENTIFICADOR PARENTESIS_C
       | MIN PARENTESIS_A IDENTIFICADOR PARENTESIS_C
       | AVG PARENTESIS_A IDENTIFICADOR PARENTESIS_C
       | COUNT PARENTESIS_A IDENTIFICADOR PARENTESIS_C
       ;

condiciones_agrupacion_orden: WHERE condiciones GROUP_BY IDENTIFICADOR
                          | ORDER_BY IDENTIFICADOR ASC
                          | ORDER_BY IDENTIFICADOR DESC
                          | WHERE condiciones GROUP_BY IDENTIFICADOR ORDER_BY IDENTIFICADOR ASC
                          | WHERE condiciones GROUP_BY IDENTIFICADOR ORDER_BY IDENTIFICADOR DESC
                          | WHERE condiciones ORDER_BY IDENTIFICADOR ASC
                          | WHERE condiciones ORDER_BY IDENTIFICADOR DESC
                          ;
                          
condiciones: condiciones AND condicion
           | condiciones OR condicion
           | condicion
           ;

condicion: IDENTIFICADOR OP_IGUAL valor
         | IDENTIFICADOR OP_COMP_IGUAL valor
         | IDENTIFICADOR OP_DISTINTO valor
         | IDENTIFICADOR OP_MENOR valor
         | IDENTIFICADOR OP_MAYOR valor
         | IDENTIFICADOR OP_MENORIGUAL valor
         | IDENTIFICADOR OP_MAYORIGUAL valor
         | OP_NEGACION condicion
         ;

%%

void yyerror(const char *s) {
    fprintf(yyout, "\nError sintactico en la linea numero: %d", yylineno);
    fprintf(yyout, "\n%s\n", yytext);  // Imprime el texto que causó el error
    num_syntax_errors++;
}

int main(int argc, char *argv[]){    
    if (argc==2) {
        yyin = fopen(argv[1], "r");
        yyout = fopen("salida.txt", "w");
        
        if (yyin == NULL) {
            printf("No se pudo abrir el archivo %s \n", argv[1]);
            exit(-1);
        }else{            
                           
            yyparse(); 

            
            if(num_syntax_errors == 0 ){
                fprintf(yyout, "Correcto");
                
            }else{
                fprintf(yyout, "\nIncorrecto \nEl archivo de entrada tiene %d errores sintacticos. \n",num_syntax_errors);
                
            }
        }
    }else{
        printf("Debe escribir el nombre del archivo que quiere analizar");
        exit(-1);

    }
    
}