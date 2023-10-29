%{
  #include "tokens.h"
  #include "hash.h"
  int lineNumber = 1;
  int running = 1;
%}

%x MULTILINE_COMMENT

%%

"char" {
  return KW_CHAR;
}

"int" {
  return KW_INT;
}

"float" {
  return KW_FLOAT;
}

"code" {
  return KW_CODE;
}

"if" {
  return KW_IF;
}

"else" {
  return KW_ELSE;
}

"while" {
  return KW_WHILE;
}

"input" {
  return KW_INPUT;
}

"print" {
  return KW_PRINT;
}

"return" {
  return KW_RETURN;
}


"<=" {
  return OPERATOR_LE;
}

">=" {
  return OPERATOR_GE;
}

"==" {
  return OPERATOR_EQ;
}

"!=" {
  return OPERATOR_DIF;
}


[0-9]+ {
  return LIT_INT;
}

'.' {
  hashInsert(yytext, LIT_CHAR);
  return LIT_CHAR; 
}

[0-9]+\.[0-9]+ {
  hashInsert(yytext, LIT_REAL);
  return LIT_REAL; 
}

[a-zA-Z0-9_]+[a-zA-Z0-9_]* {
  hashInsert(yytext, TK_IDENTIFIER); 
  return TK_IDENTIFIER;
}

\"[^\"\n]*\" { 
  hashInsert(yytext, LIT_STRING); 
  return LIT_STRING; 
}

[,;()\[\]{}=+\-*/%<>&|~] {
  return yytext[0];
}

"\n" {
  lineNumber++;
}

[ \t]+

"///".+ {
  BEGIN(MULTILINE_COMMENT);
}

"//".+

. {
  return TOKEN_ERROR;
}

<MULTILINE_COMMENT>"\\\\\\" {
  BEGIN(INITIAL);
}
<MULTILINE_COMMENT>"\n" {
  lineNumber++;
}
<MULTILINE_COMMENT>.

%%

#include "hash.c"
#include "main.c"

int getLineNumber(void) {
	return lineNumber;
}

void initMe(void) {
	hashInit();
}

int isRunning(void) {
	return running;
}

int yywrap(void) {
	running = 0;
	return 1;
}