/*----- Sección de Declaraciones --------------*/
%{
    #include <iostream>
    #include <vector>
    using namespace std;

    std::string codigo_inicial;
    std::string codigo_final;
    int indentacion;
    void escribir_datos ();
    void poner_indentacion();
    void escribir_fichero();
%}
bucle   [(for)|(while)]
caracter    [0-9|a-z|A-Z|\=|\;|\+\-| |\/|\*]
alfanum     [0-9|a-z|A-Z]
condición   [(if) | (else)]
simbolos    [\=|\/|\+|\-|\*]
punto_coma  [\;]
/*----- Sección de Reglas ----------------*/
%%
{bucle}\({caracter}+\)\{  {codigo_final+=yytext;}
{bucle}\({caracter}+\)  {codigo_final+=yytext + "{" ;}
{condicion}\({caracter}+\)  {codigo_final+=yytext + "{" ;}
{alfanum}{simbolo}{alfanum}   {poner_espacio(yytext);}
{alfanum}{punto_coma}  {poner_espacio(yytext);}
\{  {indentacion++;}
\}  {indentacion--;}


[^ \t\n]+   { np++; nc += yyleng; }
[ \t]+      { nc += yyleng; }
\n          {poner_indentacion();}
%%
/*----- Sección de Procedimientos --------*/
int main (int argc, char *argv[]) {
    if (argc == 2) {
    yyin = fopen (argv[1], "rt");
        if (yyin == NULL) {
            printf ("El fichero %s no se puede abrir\n", argv[1]);
            exit (-1);
        }
    }
    else yyin = stdin;
    indentacion = 0;
    yylex ();
    return 0;
}
void escribir_datos () {
    std::cout << endl;
    std::cout << "/*----- Correo ----------------*/" << endl;
    for(int i = 0; i < correo.size(); i++){
        std::cout << "Linea " << linea_correo[i] << " --> " << correo[i] << endl;
    }

}

int yywrap(){
  escribe_fichero();
  return 0;
}

void poner_indentacion(){
  codigo_final+=\n;
  for(int i = 0; i < indentacion; i++)
    codigo_final+=\t;

}
#include<fstream>
void escribir_fichero(){
  ofstream fi;
  fi.open("salida.txt");
  if(!fi){
    cerr<<"Error al generar archivo de salida"<<endl;
    exit(-1);
  }

  fi<<codigo_final;
  fi.close();
}


