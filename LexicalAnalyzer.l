/*************************************************************************/
/*                                                                       */
/* Copyright (c) 2015 Mario J. García Navarro                            */
/*                                                                       */
/* File name: LexicalAnalyzer.l                                          */
/*                                                                       */
/* Author:                                                               */
/*          Mario J. García Navarro                                      */
/*                                                                       */
/* Purpose:                                                              */
/*          This program implements a basic lexical analyzer for Tiny C, */
/*          a subset of the C language.                                  */
/*                                                                       */
/* Usage:   The scanner reads an input file from the command line. The   */
/*          usage form is:                                               */
/*                                                                       */
/*          scanner < file.c                                             */
/*                                                                       */
/* References:                                                           */
/*          The material that describes regular expressions and Lex/Flex */
/*          usage covered in the class notes for TC2006.                 */
/*          The manual for Flex 2.5.37 for syntactical references,       */
/*          patterns, start conditions, usage and simple examples. Can   */
/*          be found in:                                                 */
/*              http://flex.sourceforge.net/manual/                      */
/*                                                                       */
/* File formats:                                                         */
/*          The input file should have a "valid" C(Tiny C) program       */ 
/*                                                                       */
/* Restrictions:                                                         */
/*          Actually, any text file can be passed from the command line, */
/*          it is not necessary to have the .c extension                 */
/*                                                                       */
/* Revision history:                                                     */
/*                                                                       */
/*          Sep 09 09:14 2015 - File created                             */
/*                                                                       */
/*          Sep 09 20:10 2015 - The scanner recognizes all the           */
/*                              specified tokens                         */
/*                                                                       */
/*                                                                       */
/* Error handling:                                                       */
/*          When uknown tokens are found, the program indicates an error */
/*          on the line where the token is found and shows the actual    */
/*          uknown token                                                 */
/*                                                                       */
/* Notes:                                                                */
/*          The output is in a table-like format, with 2 columns: The    */
/*          type of the token and the value for it. Since multi-line     */
/*          comments are handled, consider that the output in the table  */
/*          for those is not managed perfectly. Everything else works    */
/*          really fine in the table format                              */
/*                                                                       */
/*************************************************************************/

/*************************************************************************/
/*                         Declaration Section                           */
/*************************************************************************/
/*************************************************************************/
/*                                                                       */
/*  (int)idToDel: This variable express the index that is used to        */
/*                indicate that a number is an octal one (which is       */
/*                always in the second position of the string). This is  */
/*                used for the octal to decimal conversion               */
/*                                                                       */
/*  (int)numberLines: This is a simple counter of newlines. It is used   */
/*                    whenever an error occurs, showing the user the     */
/*                    line where the error has arise                     */
/*                                                                       */
/*************************************************************************/
%{
    int idToDel = 1; 
    int numberLines = 1;
%}


/*************************************************************************/
/*                       User Defined MACROS Section                     */
/*************************************************************************/
/*************************************************************************/
/*                                                                       */
/*  DIGIT: A single number from 0 to 9 or a composed number starting     */
/*         from 1 to 9 followed by any number from 0 to 9                */
/*                                                                       */
/*  EXPONENTIAL: In this case, any floating point number followed by an  */
/*               an e (or E), a positive or negative sign and finally,   */
/*               an integer number indicating the power                  */
/*                                                                       */
/*  HEX: An hexadecimal number                                           */
/*                                                                       */
/*  OCTAL: An octal number                                               */
/*                                                                       */
/*  ID: Identifiers that are supported in ANSI C                         */
/*                                                                       */
/*  OPERATOR: Arithmetic operator: Addition, subtraction, multiplication */
/*            and finally division                                       */
/*                                                                       */
/*  KEYWORD: A set of reserved words supported by Tiny C                 */
/*                                                                       */
/*  PUNCTUATION: The set of punctuation tokens supported by ANSI C       */
/*                                                                       */
/*  RELATIONAL: Tokens used when comparing two elements                  */
/*                                                                       */
/*  ASSIGNMENT: Used when assigning a value to an identifier. Consider   */
/*              that the operator does not follows the ANSI C '='        */
/*                                                                       */
/*  COMMENT: A regular expression that takes account all the possible    */
/*           types of comments in ANSI C. Considering single-line        */
/*           comments and multi-line ones                                */
/*                                                                       */
/*************************************************************************/
DIGIT		[0-9]|[1-9][0-9]* 
EXPONENTIAL [0-9]*"."[0-9]+[e|E][-|+]?[0-9]+
HEX			0(x|X)[0-9A-Fa-f]+
OCTAL		0(c|C)[0-7]+
ID       	[A-Za-z_][A-Za-z0-9_]*
OPERATOR 	[+|*|/]|-
KEYWORD  	if|int|float|then|else|read|write|while
PUNCTUATION [{|}|(|)|;|,]
RELATIONAL 	<|<=|>|>=|!=
ASSIGNMENT	:=
COMMENT     ("/*"([^*]|([*]+[^*/]))*[*]+"/")|"//".*

/*************************************************************************/
/*                              Rules Section                            */
/*************************************************************************/
%%

{COMMENT} { 
            printf("|         COMMENT         | %21s |\n", yytext);
            printf("---------------------------------------------------\n");
}

{DIGIT} {
     		printf("|     INTEGER NUMBER      | %21s |\n", yytext);
            printf("---------------------------------------------------\n");
}

{DIGIT}"."{DIGIT}+ {    /* This expression is used to differentiate floating point number from integer ones */
     		printf("|      FLOAT NUMBER       | %21s |\n", yytext);
            printf("---------------------------------------------------\n");
}

{HEX} {
     		printf("|   HEXADECIMAL NUMBER    | %6s (Decimal: %3d) |\n", yytext, (int)strtol(yytext, NULL, 0)); /* Strtol() is used to convert the hex number to a decimal one 
                                                                                                                then the value is printed aside the hex definition */
            printf("---------------------------------------------------\n");
}

{OCTAL} {
            /* Since strtol cannot recongnize a 'C|c' as an input, an array with the exact same values except for the 'C|c' is needed */
            char octal[strlen(yytext)]; /* The string that will store the original octal number */
            strcpy(octal, yytext);  /* The contents of yytext are copied to the new array */
            memmove(&yytext[idToDel], &yytext[idToDel + 1], strlen(yytext) - idToDel); /* The 'C|c' is removed from the original string, leaving a string that can be
                                                                                        passed to strtol() */
     		printf("|       OCTAL NUMBER      | %6s (Decimal: %3d) |\n", octal, (int)strtol(yytext, NULL, 0));/* Strtol() is used to convert the octal number to a decimal one 
                                                                                                                then the value is printed aside the octal definition */
            printf("---------------------------------------------------\n");
}


{KEYWORD} {
             printf("|      RESERVED WORD      | %21s |\n", yytext);
             printf("---------------------------------------------------\n");
}

{PUNCTUATION} {
             printf("|    PUNCTUATION TOKEN    | %21s |\n", yytext);
             printf("---------------------------------------------------\n");
}


{ASSIGNMENT} {
             printf("|   ASSIGNMENT OPERATOR   | %21s |\n", yytext);
             printf("---------------------------------------------------\n");
}

{RELATIONAL} {
             printf("|   RELATIONAL OPERATOR   | %21s |\n", yytext);
             printf("---------------------------------------------------\n");
}

{EXPONENTIAL} {
             printf("|   EXPONENTIAL NUMBER    | %21s |\n", yytext);
             printf("---------------------------------------------------\n");
}

{ID}       { printf("|        IDENTIFIER       | %21s |\n", yytext );
             printf("---------------------------------------------------\n");
}

{OPERATOR}  { printf("|   ARITHMETIC OPERATOR   | %21s |\n", yytext ); 
             printf("---------------------------------------------------\n");
}

[ \t]+          /* Eat up the whitespace */    

\n              numberLines++;  /* When a newline is found, add one the global 
                                counter to track the line numbers */

. {             /* When an uknown token is found, indicate an error */
             printf("|         ERROR           | %11s (Line %2d) |\n", yytext, numberLines);
             printf("--------------------------------------------------\n"); 
}        

%%
 
/*************************************************************************/
/*                            Main entry point                           */
/*************************************************************************/ 
 int main(int argc, char **argv)
 {
     ++argv, --argc;  /* Skip over program name */
     if (argc > 0)
             yyin = fopen( argv[0], "r" );
     else
             yyin = stdin;
             
     /* Create Table Header */
     printf("---------------------------------------------------\n"); 
     printf("|          TYPE           |         VALUE         |\n");
     printf("---------------------------------------------------\n");
     yylex();
 }
