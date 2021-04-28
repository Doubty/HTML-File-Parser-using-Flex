
# Compiladores
CC=g++
LEX=flex++

# Dependências
all: analisadorHtml

wordcount: lex.yy.cc
	$(CC) lex.yy.cc -std=c++17 -o analisadorHtml

lex.yy.cc: analisadorHtml.l
	$(LEX) analisadorHtml.l

clean:
	rm analisadorHtml lex.yy.cc
