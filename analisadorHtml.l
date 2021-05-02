%{
// Faz contagem de caracteres, palavras e linhas de um arquivo
#include <iostream>
#include <fstream>
#include <algorithm>
using namespace std;

string noTabSpace(string tag);

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
[ \t\n]*"<style>"     {contadorCaracteres += YYLeng(); cout << "+--<style>" << endl; linhasContador++; tagContador++;   BEGIN STYLETRATAMENTO; }//Começo do tratamento de style
<STYLETRATAMENTO>{eol}	            {contadorCaracteres += YYLeng(); linhasContador++; }
<STYLETRATAMENTO>.*                 {contadorCaracteres += YYLeng();}   
<STYLETRATAMENTO>[ \t\n]*"</style>" {contadorCaracteres += YYLeng(); linhasContador++; cout << "+--</style>" << endl; BEGIN INITIAL;}
{tagAbertura}   {cout  <<"+--" << noTabSpace(YYText()) << endl; contadorCaracteres += YYLeng(); tagContador++;   BEGIN TEXTOTAGS; }//Começo do tratamento de style
<TEXTOTAGS>[^\<\t\n]*                { contCaracteresMostrados+= YYLeng(); contadorCaracteres += YYLeng(); cout  <<"+--" << "Texto[" << YYLeng() << "]"  << endl;  }   
<TEXTOTAGS>"<" { cout << YYText() << endl;  contadorCaracteres += YYLeng(); BEGIN INITIAL;}
{tagFechamento}     { contadorCaracteres += YYLeng(); cout <<"+--" << noTabSpace(YYText()) << endl;}
{comentario}       { contadorCaracteres += YYLeng();}
{tipo}              { contadorCaracteres += YYLeng(); } 
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


// criei essa função para remover espaços e tabulações das string antes de printar
string noTabSpace(string tag){

tag.erase(std::remove(tag.begin(), tag.end(), '\t'), tag.end());
tag.erase(std::remove(tag.begin(), tag.end(), ' '), tag.end());

	return tag;

}
