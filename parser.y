/* CMSC 430 Compiler Theory and Design
   Project 3 Parser
   UMGC CITE
   Summer 2023 */

%{
#include <string>
#include <cstdlib>
#include "listing.h"
#include "values.h"

using namespace std;

int yylex();
void yyerror(const char* message);

double* parameters;
int currentParamIndex = 0;
%}

%define parse.error verbose

%token IDENTIFIER "identifier"
%token INT_LITERAL "int_literal"
%token REAL_LITERAL "real_literal"
%token CHAR_LITERAL "char_literal"
%token ADDOP "+"
%token SUBOP "-"
%token MULOP "*"
%token DIVOP "/"
%token MODOP "%"
%token EXPOP "^"
%token NOTOP "~"
%token RELOP "relop"
%token GTE ">="
%token LTE "<="
%token NEQ "<>"
%token ASSIGNOP "="
%token OROP "|"
%token ANDOP "&"
%token ARROW "=>"
%token BEGIN_ "begin"
%token CASE "case"
%token CHARACTER "character"
%token ELSE "else"
%token END "end"
%token ENDSWITCH "endswitch"
%token FUNCTION "function"
%token INTEGER "integer"
%token IS "is"
%token LIST "list"
%token OF "of"
%token OTHERS "others"
%token RETURNS "returns"
%token SWITCH "switch"
%token WHEN "when"
%token IF "if"
%token THEN "then"
%token ELSIF "elsif"
%token ENDIF "endif"
%token REAL "real"
%token FOLD "fold"
%token ENDFOLD "endfold"
%token LEFT "left"
%token RIGHT "right"

%%

function:
	function_header optional_variable body {
		printf("Compiled Successfully\n");
		printf("Result = %d\n", 42);  // Replace 42 with evaluated value once integrated
	};


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
    IDENTIFIER ':' type { } ;

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

elsif_list:
    elsif_list ELSIF expression THEN statements |
    ELSIF expression THEN statements |
    %empty ;

else_clause:
    ELSE statements |
    %empty ;

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

	parameters = new double[argc - 2];
	for (int i = 2; i < argc; i++) {
		parameters[i - 2] = atof(argv[i]);
	}

	yyparse();
	lastLine();
	delete[] parameters;
	return 0;
}
