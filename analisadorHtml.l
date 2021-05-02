%{
// Faz contagem de caracteres, palavras e linhas de um arquivo
#include <iostream>
#include <fstream>
using namespace std;

unsigned contCaracteresMostrados = 0, contadorCaracteres = 0, linhasContador = 0, tagContador = 0, aux = 0; // criei uma variável aux para ajudar mostrar a hierarquia do documento
%}

%option noyywrap 
%x STYLETRATAMENTO 
%s TEXTOTAGS 


word [^ \t\n]+
eol  \n
tipo "<!DOCTYPE html>"
comentario "<!--".*"-->"
tagAbertura ([ \t]*"<"([a-zA-Z]|[1-6])*([ \t]+[a-zA-Z -]*"="\"([0-9]|[a-zA-Z ]|\.|\-|"="|"_"|":"|"("|")"|,|\t|\/)*\")*[ \t]*">")
tagFechamento  ([ \t]*"</"([a-zA-Z]|[1-6])*">"[ \t]*)


%%
[ \t\n]*"<style>"     {contadorCaracteres += YYLeng(); cout << "<style>" << endl; linhasContador++; tagContador++;   BEGIN STYLETRATAMENTO; }//Começo do tratamento de style
<STYLETRATAMENTO>{eol}	            {contadorCaracteres += YYLeng(); linhasContador++; }
<STYLETRATAMENTO>.*                 {contadorCaracteres += YYLeng();}   
<STYLETRATAMENTO>[ \t\n]*"</style>" {contadorCaracteres += YYLeng(); linhasContador++; cout << "</style>" << endl; BEGIN INITIAL;}
{tagAbertura}   {cout << YYText() << endl; contadorCaracteres += YYLeng(); tagContador++;   BEGIN TEXTOTAGS; }//Começo do tratamento de style
<TEXTOTAGS>[^\<\t\n]*                { contCaracteresMostrados+= YYLeng(); contadorCaracteres += YYLeng(); cout << "Texto[" << YYLeng() << "]"  << endl;  }   
<TEXTOTAGS>"<" { cout << YYText() << endl;  contadorCaracteres += YYLeng(); BEGIN INITIAL;}
{tagFechamento}     { contadorCaracteres += YYLeng(); cout << YYText() << endl;}
{comentario}       { contadorCaracteres += YYLeng(); cout  << YYText() << endl;}
{tipo}              { contadorCaracteres += YYLeng(); tagContador++; cout << YYText() << endl; } 
{eol}	            {contadorCaracteres++; linhasContador++;  }
.	            {contadorCaracteres++; } 

%%

int main(int argc, char ** argv)
{
	yyFlexLexer lexer;  // lexer lê da entrada padrão (teclado)
	ifstream fin;

	if (argc > 1) 
	{    
		fin.open(argv[1]);
		if (!fin.is_open()) 
        {
			cout << "Arquivo " << argv[1] << " não pode ser aberto!\n";
			exit(EXIT_FAILURE);
		}
		else
		{
			// altera entrada para arquivo aberto
			lexer.switch_streams(&fin);
		}
	}

	lexer.yylex();

	cout << "\n\nLinhas: " << linhasContador << "\n"
		 << "Pares de tags: " << tagContador << "\n"
		  << "Total de caracteres exibidos: " << contCaracteresMostrados << "\n"
		<< "Total de caracteres do arquivo: " << contadorCaracteres << "\n";

	fin.close();
	return 0;
}
