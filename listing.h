// CMSC 430 Compiler Theory and Design
// Project 1 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the function prototypes for the functions that produce
// the compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED, SEMANTIC };

void firstLine();
void nextLine();
void lastLine();
void appendError(ErrorCategories errorCategory, string message);
void displayErrors();


extern int lexicalErrors;
extern int syntaxErrors;
extern int semanticErrorCount;
extern int semanticErrors;



