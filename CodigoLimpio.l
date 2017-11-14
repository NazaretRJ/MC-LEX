/*----- Sección de Declaraciones --------------*/
%{
    #include <iostream>
    #include <vector>
    using namespace std;

    std::string codigo_inicial;
    std::string codigo_final;

    void escribir_datos ();
%}
bucle   [(for)|(while)]
caracter    [a-z|A-Z|\=|\;|\+\-| ]
condición   [(if) | (else)]
/*----- Sección de Reglas ----------------*/
%%
{bucle}\({caracter}+\)\{    {codigo_final+=yytext;}
{bucle}\({caracter}+\)  {codigo_final+=yytext + "{" ;}
{condicion}\({caracter}+\)  {codigo_final+=yytext + "{" ;}    

[0-4]{digito}{digito}{digito}{digito} { linea_codigo_postal.push_back(nl); codigo_postal.push_back(yytext); }
[5][0|1|2]{digito}{digito}{digito} { linea_codigo_postal.push_back(nl); codigo_postal.push_back(yytext); }

[a-z]*[A-Z]*{digito}*\@([a-z]+{digito}*\.)+{dominio}+ { correo.push_back(yytext); linea_correo.push_back(nl); }

{digito}{digito}{digito}{digito}[\- ]*[A-Z][A-Z][A-Z] { matricula.push_back(yytext); linea_matricula.push_back(nl); }

[http://]+[www]*([a-z]+{digito}*\.)+{dominio}+ { pag_web.push_back(yytext); linea_pag_web.push_back(nl); }
[https://]+[www]*([a-z]+{digito}*\.)+{dominio}+ { pag_web.push_back(yytext); linea_pag_web.push_back(nl); }
[www]*([a-z]+{digito}*\.)+{dominio}+ { pag_web.push_back(yytext); linea_pag_web.push_back(nl); }

{digito}{digito}{digito}{digito}{digito}{digito}{digito}{digito}[\- ]*[A-Z] { linea_dni.push_back(nl); dni.push_back(yytext); }

(\+{digito}{digito})*[\- ]*([67]|[98]){digito}{digito}[\- ]*{digito}{digito}{digito}[\- ]*{digito}{digito}{digito}  { linea_telefono.push_back(nl); telefono.push_back(yytext); }

[0-2][0-8]\-(01|02|03|04|05|06|07|08|09|10|12)\-{digito}{digito}{digito}{digito} { fecha.push_back(yytext); linea_fecha.push_back(nl); }
(29|30)\-(01|03|04|05|06|07|08|09|10|12)\-{digito}{digito}{digito}{digito} { fecha.push_back(yytext); linea_fecha.push_back(nl); }
(31\-(01|03|05|07|08|10|12)\-{digito}{digito}{digito}{digito}) { fecha.push_back(yytext); linea_fecha.push_back(nl); }

[^ \t\n]+   { np++; nc += yyleng; }
[ \t]+      { nc += yyleng; }
\n          { nl++; nc++; }
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
    nc = np = nl = 0;
    yylex ();
    return 0;
}
void escribir_datos () {
    std::cout << endl;
    std::cout << "/*----- Correo ----------------*/" << endl;
    for(int i = 0; i < correo.size(); i++){
        std::cout << "Linea " << linea_correo[i] << " --> " << correo[i] << endl;
    }
    
    std::cout << "/*----- Fecha ----------------*/" << endl;
    for(int i = 0; i < fecha.size(); i++){
        std::cout << "Linea " << linea_fecha[i] << " --> " << fecha[i] << endl;
    }
    
    std::cout << "/*----- Codigo Postal ----------------*/" << endl;
    for(int i = 0; i < codigo_postal.size(); i++){
        std::cout << "Linea " << linea_codigo_postal[i] << " --> " << codigo_postal[i] << endl;
    }
    
    std::cout << "/*----- Telefono ----------------*/" << endl;
    for(int i = 0; i < telefono.size(); i++){
        std::cout << "Linea " << linea_telefono[i] << " --> " << telefono[i] << endl;
    }
    std::cout << "/*----- DNI ----------------*/" << endl;
    for(int i = 0; i < dni.size(); i++){
        std::cout << "Linea " << linea_dni[i] << " --> " << dni[i] << endl;
    }
    std::cout << "/*----- Matrícula ----------------*/" << endl;
    for(int i = 0; i < matricula.size(); i++){
        std::cout << "Linea " << linea_matricula[i] << " --> " << matricula[i] << endl;
    }
    std::cout << "/*----- Página Web ----------------*/" << endl;
    for(int i = 0; i < pag_web.size(); i++){
        std::cout << "Linea " << linea_pag_web[i] << " --> " << pag_web[i] << endl;
    }
    std::cout << endl;
}

int yywrap(){
    escribir_datos();
    return 1;
}


