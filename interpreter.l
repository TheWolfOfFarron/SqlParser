%{
#include "y.tab.h"
%}

%%

SELECT      { printf("SELECT "); return SELECT; }
selecteaza      { printf("SELECT "); return SELECT; }
afiseaza      { printf("SELECT "); return SELECT; }

UPDATE      { printf("UPDATE "); return UPDATE; }
actualizeaza      { printf("UPDATE "); return UPDATE; }



DELETE      { printf("DELETE "); return DELETE; }
sterge      { printf("DELETE "); return DELETE; }


INSERT      { printf("INSERT "); return INSERT; }
adauga      { printf("INSERT "); return INSERT; }
insereaza      { printf("INSERT "); return INSERT; }

FROM        { printf("FROM "); return FROM; }
din        { printf("FROM "); return FROM; }
in        { printf("FROM "); return FROM; }


WHERE       { printf("WHERE "); return WHERE; }
unde       { printf("WHERE "); return WHERE; }

tot     {printf("* ");
            yylval.strval = "*";
            return STRING;}

INTO        {printf("INTO "); return INTO;}
in        {printf("INTO "); return INTO;}

AND         { printf("AND "); return AND; }
si         { printf("AND "); return AND; }

OR          { printf("OR "); return OR; }
sau          { printf("OR "); return OR; }

SET         { printf("SET "); return SET; }
seteaza         { printf("SET "); return SET; }

VALUES      { printf("VALUES "); return VALUES; }
valori      { printf("VALUES "); return VALUES; }

[0-9]+  {   printf("%s",yytext);
            //yylval.val = atoi(yytext);
            return STRING;
        }
[a-zA-Z',()0-9]+ { printf("%s",yytext);
            yylval.strval = strdup(yytext);
            return STRING;
}



[\n=><+\-*/%;]+    {printf("%s",yytext); return *yytext;}


[ \t]+       ; // Ignore whitespace

%%



