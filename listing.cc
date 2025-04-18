#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

// Track line number and error counts
static int lineNumber;
static queue<string> errorQueue;

// Global error counters
int lexicalErrors = 0;
int syntaxErrors = 0;
int semanticErrors = 0;
int semanticErrorCount = 0;


void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ", lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ", lineNumber);
}

void lastLine() {
    int totalErrors = lexicalErrors + syntaxErrors + semanticErrorCount;

    displayErrors();  // Ensure any remaining errors are printed

    if (totalErrors == 0) {
        printf("\nCompiled Successfully\n");
    } else {
        printf("\nLexical Errors: %d\n", lexicalErrors);
        printf("Syntax Errors: %d\n", syntaxErrors);
        printf("Semantic Errors: %d\n", semanticErrorCount);
    }
}


void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " };

	// Store the error message in the queue
	errorQueue.push(messages[errorCategory] + message);

	// Increment the appropriate error count
	switch (errorCategory) {
        case LEXICAL:
            lexicalErrors++;
            break;
        case SYNTAX:
            syntaxErrors++;
            break;
        case SEMANTIC:
        case GENERAL_SEMANTIC:
        case DUPLICATE_IDENTIFIER:
        case UNDECLARED:
            semanticErrors++ ;
            break;
    }
}
void displayErrors()
{
	// Print and clear all stored errors for the current line
	while (!errorQueue.empty()) {
		printf("%s\n", errorQueue.front().c_str());
		errorQueue.pop();
	}
}
