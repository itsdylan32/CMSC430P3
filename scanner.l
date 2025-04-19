%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"
%}

%option noyywrap

%%

[ \t\r]+                        { /* Ignore whitespace */ }
"//".*                          { /* Ignore comments */ }
\n                              { nextLine(); }

"~"                             { return NOTOP; }
"+"                             { return ADDOP; }
"-"                             { return SUBOP; }
"*"                             { return MULOP; }
"/"                             { return DIVOP; }
"%"                             { return MODOP; }
"^"                             { return EXPOP; }
"!"                             { return NOTOP; }         // Alias for logical NOT
"&"                             { return ANDOP; }
"|"                             { return OROP; }
"="                             { return ASSIGNOP; }
">="                            { return GTE; }
"<="                            { return LTE; }
"<>"                            { return NEQ; }
"<"                             { return RELOP; }
">"                             { return RELOP; }
":"                             { return ':'; }
";"                             { return ';'; }
","                             { return ','; }
"("                             { return '('; }
")"                             { return ')'; }

"begin"                         { return BEGIN_; }
"case"                          { return CASE; }
"character"                     { return CHARACTER; }
"end"                           { return END; }
"endswitch"                     { return ENDSWITCH; }
"function"                      { return FUNCTION; }
"integer"                       { return INTEGER; }
"is"                            { return IS; }
"list"                          { return LIST; }
"of"                            { return OF; }
"others"                        { return OTHERS; }
"returns"                       { return RETURNS; }
"switch"                        { return SWITCH; }
"when"                          { return WHEN; }
"real"                          { return REAL; }
"if"                            { return IF; }
"then"                          { return THEN; }
"elsif"                         { return ELSIF; }
"else"                          { return ELSE; }
"endif"                         { return ENDIF; }
"left"                          { return LEFT; }
"right"                         { return RIGHT; }
"fold"                          { return FOLD; }
"endfold"                       { return ENDFOLD; }

[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? { return REAL_LITERAL; }
\.[0-9]+([eE][-+]?[0-9]+)?       { return REAL_LITERAL; }
[0-9]+[eE][-+]?[0-9]+            { return REAL_LITERAL; }

"#"[0-9A-Fa-f]+                 { return HEX_LITERAL; }

\'([^\\'\n]|\\[nrt0\\'\"])\'    { return CHAR_LITERAL; }

[A-Za-z][A-Za-z0-9]*            { return IDENTIFIER; }

. {
    printf("Lexical Error: Invalid Character '%c'\n", yytext[0]);
    appendError(LEXICAL, yytext);
}

%%
