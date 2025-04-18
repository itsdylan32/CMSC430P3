/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL REAL_LITERAL CHAR_LITERAL
%token ADDOP MULOP SUBOP DIVOP MODOP NOTOP EXPOP RELOP GTE LTE NEQ ASSIGNOP OROP 
%token ARROW ANDOP

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS RETURNS SWITCH WHEN
%token IF THEN ELSIF ENDIF

%token REAL
%token FOLD ENDFOLD LEFT RIGHT

%%

function:
	function_header optional_variable body ;

function_header:
    FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

type:
	INTEGER |
	CHARACTER |
	REAL ;

optional_variable:
    variable_list |
    %empty ;

optional_parameters:
    parameters |
    %empty ;

parameters:
    parameter |
    parameters ',' parameter ;

parameter:
    IDENTIFIER ':' type ;

variable_list:
    variable_list variable |
    variable ;

variable:
    IDENTIFIER ':' type IS expression ';' |
    IDENTIFIER ':' LIST OF type IS list ';' |
    error ';' ;

expressions:
    expressions ',' expression |
    expression ;

expression:
    expression OROP and_expr |
    and_expr ;

and_expr:
    and_expr ANDOP rel_expr |
    rel_expr ;

rel_expr:
    rel_expr RELOP add_expr |
    rel_expr GTE add_expr |
    rel_expr LTE add_expr |
    rel_expr NEQ add_expr |
    add_expr ;

add_expr:
    add_expr ADDOP mul_expr |
    add_expr SUBOP mul_expr |
    mul_expr ;

mul_expr:
    mul_expr MULOP exp_expr |
    mul_expr DIVOP exp_expr |
    mul_expr MODOP exp_expr |
    exp_expr ;

exp_expr:
    exp_expr EXPOP unary_expr |
    unary_expr ;

unary_expr:
    NOTOP unary_expr |
    SUBOP unary_expr |
    primary ;

primary:
    '(' expression ')' |
    INT_LITERAL |
    REAL_LITERAL |
    CHAR_LITERAL |
    IDENTIFIER '(' expression ')' |
    IDENTIFIER ;

list:
	'(' expressions ')' ;

body:
    BEGIN_ statements END ';' ;


statement_:
    statement ';' |
    fold_statement ';' |
    error ';' ;

statement:
	expression |
	WHEN expression ',' expression ':' expression |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH |
	if_statement |
	fold_statement ;

statements:
    statements statement ';' |
    statement ';' ;



if_statement:
    IF expression THEN statements
    elsif_list
    else_clause
    ENDIF ;


fold_statement:
    FOLD direction operator fold_args ENDFOLD ;

fold_args:
    list |
    expression ;

direction:
    LEFT |
    RIGHT ;

operator:
    ADDOP |
    SUBOP |
    MULOP |
    DIVOP |
    MODOP ;

if_statement:
    IF expression THEN statements
    elsif_list
    else_clause
    ENDIF ;


elsif_list:
    elsif_list ELSIF expression THEN statements |
    ELSIF expression THEN statements |
    %empty ;

else_clause:
    ELSE statements |
    %empty ;



cases:
	cases case |
	%empty ;

case:
	CASE INT_LITERAL ARROW statement ';' ; 

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
}
