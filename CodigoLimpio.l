/*----- Sección de Declaraciones --------------*/
%{
    #include <iostream>
    #include <vector>
    #include <fstream>

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
caracter    [0-9a-zA-Z\=\;\+\- \/\*]
alfanum     [0-9a-zA-Z]
condicion   [(if) | (else)]
simbolo    [\=\/\+\-\*]
punto_coma  [\;]
/*----- Sección de Reglas ----------------*/
%%
{bucle}\(([\=\/\+\-\*]{caracter})+\)\{  {codigo_final=codigo_final+yytext;}
{bucle}\(([\=\/\+\-\*]{caracter})+\)  {codigo_final=codigo_final+yytext;codigo_final+="{";} 

\{  {indentacion++;codigo_final=codigo_final+yytext;}
\}  {--indentacion;codigo_final[codigo_final.length()-1]=*yytext;}

\n      {poner_indentacion();}
^[\t]	{codigo_final=codigo_final+yytext;}

.		{codigo_final+=yytext;}


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
  return 1;
}

void poner_indentacion(){
  codigo_final=codigo_final+'\n';
  for(int i = 0; i < indentacion; i++)
    codigo_final=codigo_final+'\t';

}

void escribe_fichero(){
  std::ofstream outfile ("salida.txt");

  int size = codigo_final.length();
  outfile.write(codigo_final.c_str(), size);
  outfile.close();

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


