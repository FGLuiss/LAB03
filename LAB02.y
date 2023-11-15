%{

#include <iostream>
#include <vector>

using namespace std;

int yylex();
int yyerror(const char* s);
extern "C" FILE* yyin;

vector<int> line_errors;
int numLinea = 1;


%}

%token CREATE_TABLE DROP_TABLE INSERT INTO VALUES DELETE FROM UPDATE SET SELECT WHERE GROUP_BY 
%token ORDER_BY ASC DESC AND OR MAX MIN AVG COUNT VARCHAR ENTERO DECIMAL CONST_CADENA IDENTIFICADOR
%token LLAVE_A LLAVE_C PARENTESIS_A PARENTESIS_C CHAR_COMA CHAR_PUNTOYCOMA CHAR_ASTERISCO OP_IGUAL
%token OP_COMP_IGUAL OP_DISTINTO OP_MENORIGUAL OP_MAYORIGUAL OP_MENOR OP_MAYOR OP_NEGACION OP_SUMA
%token OP_DIV OP_RESTA INTEGER

%%


declaracion: tipo declaracion
            | /* epsilon */
           ;

tipo: create_table { numLinea++; }
    | drop_table { numLinea++; }
    | insert { numLinea++; }
    | delete { numLinea++; }
    | update { numLinea++; }
    | select { numLinea++; }
    | error { line_errors.push_back(numLinea++); }
    ;

create_table: CREATE_TABLE IDENTIFICADOR PARENTESIS_A columnas PARENTESIS_C CHAR_PUNTOYCOMA
            ;

columnas: columnas CHAR_COMA IDENTIFICADOR tipo_dato PARENTESIS_A ENTERO PARENTESIS_C
        | IDENTIFICADOR tipo_dato PARENTESIS_A ENTERO PARENTESIS_C
        ;

tipo_dato: INTEGER
         | DECIMAL PARENTESIS_A ENTERO PARENTESIS_C
         | VARCHAR PARENTESIS_A ENTERO PARENTESIS_C
         ;

drop_table: DROP_TABLE IDENTIFICADOR CHAR_PUNTOYCOMA
        ;

insert: INSERT INTO IDENTIFICADOR PARENTESIS_A columnas PARENTESIS_C VALUES PARENTESIS_A valores PARENTESIS_C CHAR_PUNTOYCOMA
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

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Uso: " << argv[0] << " archivo.txt\n";
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        cerr << "No se pudo abrir el archivo " << argv[1] << endl;
        return 1;
    }

    yyparse();
    fclose(yyin);

    if (line_errors.size() > 0) {
        cout << "Incorrecto\n";
        for (int linea : line_errors) {
            cout << endl << "Error en la linea " << linea;
        }
        line_errors.clear();
    } else {
        cout << "Correcto\n";
    }

    return 0;
}

int yyerror(const char* mensaje) {
    return 1;
}