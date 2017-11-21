/*----- Sección de Declaraciones --------------*/
%{
    #include <iostream>
    #include <fstream>
    using namespace std;

    std::string codigo_inicial;
    std::string codigo_final;
    int indentacion;
    void poner_indentacion();
    void escribir_fichero();
%}
bucle       [(for)|(while)]
caracter    [0-9|a-z|A-Z|\=|\;|\+\-| |\/|\*]
alfanum     [0-9|a-z|A-Z]
condicion   [(if) | (else)]
simbolo    [\=|\/|\+|\-|\*]
punto_coma  [\;]
/*----- Sección de Reglas ----------------*/
%%
{bucle}\({caracter}+\)\{  {codigo_final.push_back(*yytext);}
{bucle}\({caracter}+\)  {codigo_final.push_back(*yytext);codigo_final += "{";}
{condicion}\({caracter}+\)  {codigo_final.push_back(*yytext);codigo_final += "{";}
{alfanum}{simbolo}{alfanum}   {codigo_final.push_back(*yytext);codigo_final += " ";}
{alfanum}{punto_coma}  {codigo_final.push_back(*yytext);codigo_final += " ";}
\{  {indentacion++;}
\}  {indentacion--;}
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

int yywrap(){
  escribir_fichero();
  return 0;
}

void poner_indentacion(){
    codigo_final+="\n";
    for(int i = 0; i < indentacion; i++)
        codigo_final+="\t";

}

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


