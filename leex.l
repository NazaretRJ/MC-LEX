/*----- Sección de Declaraciones --------------*/
%{
    #include <iostream>
    #include <vector>
    #include <fstream>

    using namespace std;

    std::string codigo_inicial;
    std::string codigo_final;
    int indentacion;
	bool saltar,sin_llave,fin_cod;
    void escribir_datos ();
    void poner_indentacion();
    void escribe_fichero();
	void poner_espacio_final(string orig);
	void poner_espacio_entre_punto_coma(string orig);
	void codigo_sin_tabulador(string orig);


%}
bucle	[(for)(while)]
caracter    [0-9a-zA-Z\=\ \+\-\/\*\<\>\)\]\[\(]
caracter2	[0-9a-zA-Z\=\;\+\-\/\*\<\>\)\]\[\(\ ]
alfanum     [0-9a-zA-Z]
condicion	[(if)]
simbolo    [\=\/\+\-\*\<\>]
punto_coma  [\;]
cart_main	[a-z\*]
%s BUSCAR_LLAVE
%s IMPRIMIR_LLAVE

/*----- Sección de Reglas ----------------*/
%%
<INITIAL>"else"	{codigo_final=codigo_final+"else";BEGIN BUSCAR_LLAVE;}
"else"\{	{indentacion++;codigo_final=codigo_final+yytext;}

<INITIAL>{bucle}+\({caracter2}+\)	{codigo_final=codigo_final+yytext;BEGIN BUSCAR_LLAVE;}
{bucle}+\({caracter2}+\)\{  {indentacion++;codigo_final=codigo_final+yytext;}
<INITIAL>{condicion}+\({caracter}+\)	{codigo_final=codigo_final+yytext;BEGIN BUSCAR_LLAVE;}
{condicion}+\({caracter}+\)\{	{indentacion++;codigo_final=codigo_final+yytext;}
<BUSCAR_LLAVE>{caracter2}+	{indentacion++;poner_indentacion();codigo_final=codigo_final+yytext+"\n";indentacion--;BEGIN INITIAL;}
<BUSCAR_LLAVE>[ \t\n]*\{	{codigo_final=codigo_final+"{";indentacion++;BEGIN IMPRIMIR_LLAVE;}
<IMPRIMIR_LLAVE>{caracter2}+\n	{poner_indentacion();codigo_final=codigo_final+yytext;}
<IMPRIMIR_LLAVE>\}	{indentacion--;poner_indentacion();codigo_final=codigo_final+"}";BEGIN INITIAL;}


^[ \t]*\{	{}
{caracter2}+\{  {codigo_final+=yytext;indentacion++;}
{caracter2}+\n\{	{codigo_final+=yytext;indentacion++;}	
\}  {indentacion--;codigo_final[codigo_final.length()-1]=*yytext;}

\n	{poner_indentacion();}
[\t]*	{codigo_sin_tabulador(yytext);}

{caracter}*{punto_coma}	{poner_espacio_final(yytext);}
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
	saltar=false;
	sin_llave=false;
	fin_cod=false;
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
  
	if(sin_llave==true && fin_cod == true){
		codigo_final=codigo_final+'}';
		sin_llave=false;
		fin_cod=false;
	}
	else{
		if(sin_llave==true){
			fin_cod=true;
			indentacion--;
		}
	}
}

void escribe_fichero(){
  std::ofstream outfile ("salida.txt");

  int size = codigo_final.length();
  outfile.write(codigo_final.c_str(), size);
  outfile.close();
cout<<"FIN"<<endl;
}


void poner_espacio_final(string orig){
	//sabemos que el último carácter es ;
	std::string::iterator it=orig.end();
	it--;

	orig.insert(it,' ');

	codigo_final=codigo_final+orig;

}


void poner_espacio_entre_punto_coma(string orig){
	string aux;

	aux.append(";",sizeof(char));
	aux.append(" ",sizeof(char));

	for(int i = 1 ; i<orig.size()-1 ; i++){
		aux.append(orig[i],sizeof(char));
	}

	if(orig[orig.size()-1] == ';'){
		aux.append(" ",sizeof(char));
		aux.append(";",sizeof(char));
	}

codigo_final=codigo_final+aux;

}

void codigo_sin_tabulador(string orig){

string aux;

	for(int i = 0; i < orig.size() ; i++){
		if(orig[i]!='\t'){
			aux.append(orig[i],sizeof(char));
		}
	}
	codigo_final=codigo_final+aux;
}

/*void poner_espacio_simbolo(string orig){
string aux;
string simb;
int j=0;

	for(int i=0;i<orig.size();i++){
		if( orig[i] == '=' || orig[i] == '/' || orig[i] == '+' || orig[i] == '-' || orig[i] == '*' || orig[i] == '<' || orig[i] == '>'){
			cout<<"entra"<<endl;
			j=i;
			simb.push_back(orig[i]);
		}
		else
			aux.append(orig[i],sizeof(char));
				
	}
	if(simb.size()==2){
		j--;		
	}
	
	aux.insert(j-1," ");
	cout<<"simb "<<simb.size()<<" j "<<j<<" aux "<<aux.size()<<endl;
	aux.insert(j,simb,0,simb.size());
	aux.insert(j+1," ");
	
	codigo_final=codigo_final+aux;

} */
