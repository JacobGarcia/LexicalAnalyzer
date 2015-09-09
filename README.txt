Lexical Analyzer For Tiny C
Copyright © 2014 Mario J. García
=========================================

=========================================
+             USEFUL NOTES 		+
=========================================
The source code, version changes, and
more information about the project can
be found in: 
github.com/JacobGarcia/LexicalAnalyzer

=========================================
+             CONTRIBUTORS 		+
=========================================
Mario Jacob García Navarro   - A01363206

=========================================
+        IMPLEMENTATION PROCESS         +
=========================================
Different regular expressions were 
developed with the purpose of simulate 
the behaviour of a lexical analyzer
for Tiny C, a subset of the C language. 

-----------------------------------------
        IMPORTANT CONSIDERATIONS        
-----------------------------------------
Take account that this only is a lexical
analyzer for a (Tiny) C program. 
Therefore, if the input program by any 
means is not valid or has invalid 
syntactic or semantic definitions,
the analyzer will ignore them. 

=========================================
+      HOW TO BUILD THE EXECUTABLE      +
=========================================

------------------------------------------
	  flex LexicalAnalyzer.l
	  gcc lex.yy.c -o scanner -ll
------------------------------------------

When the build is executed, the c program 
file must be passed as an argument:
NOTE: Consider for the next command 
that the test file must be in the same 
folder. If that were not the case, then 
add the file address.
-----------------------------------------
	/.scanner < test.c
-----------------------------------------
