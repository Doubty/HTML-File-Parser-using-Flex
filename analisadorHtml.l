%{
// Faz contagem de caracteres, palavras e linhas de um arquivo
#include <iostream>
#include <fstream>
using namespace std;

unsigned linhasContador = 1, tagContador = 0;// colocando pra começar em 1, pq a última linha ás vezes não tem o \n
%}

%option noyywrap

eol  \n
tipo "<!DOCTYPE html>"
comentario "<!--".*"-->"
tagAbertura [ \t]*"<"([a-zA-Z]|[1-6])*([ \t]+[a-zA-Z -]*"="\"([1-9]|[a-zA-Z ]|\.|\-|"="|"_"|,|\t|\/)*\")*[ \t]*">"
tagFechamento  [ \t]*"</"([a-zA-Z]|[1-6])*">"[ \t]*

%%


{tagFechamento}     cout << "F->\t" << YYText() << endl;
{tagAbertura}      { tagContador++;  cout << "A->\t"<< YYText() << endl;}
{comentario}        cout << "M->\t" << YYText() << endl;
{tipo}             { tagContador++; cout << "T->\t" << YYText() << endl; } 
{eol}	            { linhasContador++; }
.	                ;

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

		 << "Pares de tags: " << tagContador << "\n";

	fin.close();
	return 0;
}
