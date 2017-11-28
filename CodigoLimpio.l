/*----- Sección de Declaraciones --------------*/
%{
    #include <iostream>
    #include <vector>
	#include<fstream>
    using namespace std;

    std::string codigo_inicial;
    std::string codigo_final;
    int indentacion;
    void escribir_datos ();
    void poner_indentacion();
    void escribe_fichero();
	void poner_espacio_final(string orig);
	void poner_espacio_oper(string orig);
	
%}
bucle   [(for)|(while)]
caracter    [0-9|a-z|A-Z|\=|\;|\+\-| |\/|\*]
alfanum     [0-9|a-z|A-Z]
condicion   [(if) | (else)]
simbolo    [\=|\/|\+|\-|\*]
punto_coma  [\;]
/*----- Sección de Reglas ----------------*/
%%
{bucle}\({caracter}+\)\{  {codigo_final=codigo_final+yytext;}
{bucle}\({caracter}+\)  {codigo_final=codigo_final+yytext + "{" ;}
{condicion}\({caracter}+\)  {codigo_final=codigo_final+yytext + "{" ;}
{alfanum}*{simbolo}{alfanum}*   {poner_espacio_oper(yytext);}
{alfanum}*{punto_coma}  {poner_espacio_final(yytext);}
\{  {indentacion++;}
\}  {indentacion--;}

\n          {poner_indentacion();}
^[\t]	{codigo_final=codigo_final+yytext;}

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
  escribe_fichero();
  return 0;
}

void poner_indentacion(){
  codigo_final=codigo_final+'\n';
  for(int i = 0; i < indentacion; i++)
    codigo_final=codigo_final+'\t';

}

void escribe_fichero(){
  ofstream fi;
  fi.open("salida.txt");
  if(!fi){
    cerr<<"Error al generar archivo de salida"<<endl;
    exit(-1);
  }

  fi<<codigo_final;
  fi.close();
}


void poner_espacio_final(string orig){
	//sabemos que el último carácter es ;
	std::string::iterator it=orig.end();
	it--;
		
	orig.insert(it,' ');

	codigo_final=codigo_final+orig;
	
}

void poner_espacio_oper(string orig){
	string aux;
	
	for(int i = 0; i < orig.size(); i++ ){
		if( orig[i] == '=' || orig[i] == '/' || orig[i] == '+' || orig[i] == '-' || orig[i] == '*' ){
			aux.append(" ",sizeof(char));
			aux.append(orig[i],sizeof(char));
			aux.append(" ",sizeof(char));
		}
		else
			aux.append(orig[i],sizeof(char));
	}

	codigo_final=codigo_final+aux;
	
}


