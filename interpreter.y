%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>
extern int yylex();
extern int yyparse();
extern char* yytext;
extern FILE* yyin;
void yyerror(const char* s);

typedef struct _node{
    int type;
    struct _node *first;
    struct _node *second;
    struct _node *third;
    char* value;
    
} node;

node *opr2(int type, node *first, node *second);
node *opr3(int type, node *first, node *second, node * third);
node *setConst(char* value);
void printpre(node *np);





%}

%union {
    char* strval;
    struct _node *np;
}

%token <strval> STRING
%token<np> SELECT UPDATE DELETE INSERT FROM WHERE VALUES INTO 
%left  AND OR SET 
%left '<' '>' '='
%type <np>  query select_query update_query delete_query insert_query columns table conditions condition update_values update_value insert_values

%%

start: query '\n' { printpre($1); free($1); }
;

query: select_query 
|update_query 
|delete_query 
|insert_query 
;

select_query: SELECT columns FROM table WHERE conditions { $$ = opr3('s',$2, $4, $6);}// sprintf($$, "SELECT %s FROM %s WHERE %s;", $2, $4, $6); }
;

update_query: UPDATE table SET update_values WHERE conditions {$$ = opr3('U',$2, $4, $6);}// sprintf($$, "UPDATE %s SET %s WHERE %s;", $2, $4, $6); }
;

delete_query: DELETE FROM table WHERE conditions { $$ = opr2('D',$3,$5);}// sprintf($$, "DELETE FROM %s WHERE %s;", $3, $5); }
;

insert_query: INSERT INTO table VALUES '(' insert_values ')' { $$ = opr2('I',$3,$6);}// sprintf($$, "INSERT INTO %s VALUES (%s);", $3, $6); }
;

columns: STRING { $$ = opr2('c',setConst($1),NULL); }
        |columns ',' columns{ $$ = opr2('c',$1,$3); }
       | '*' { $$ = opr2('*',NULL,NULL);  }
;

table: STRING { $$ = opr2('t',setConst($1),NULL); }
;

conditions: condition { $$ = opr2('C',$1,NULL); }
          | condition AND conditions { $$ = opr2('a',$1,$3); }//sprintf($$, "%s AND %s", $1, $3); }
          | condition '>' conditions { $$ = opr2('>',$1,$3); }//sprintf($$, "%s > %s", $1, $3); }
          | condition '<' conditions { $$ = opr2('<',$1,$3);}// sprintf($$, "%s < %s", $1, $3); }
          | condition '=' conditions { $$ = opr2('=',$1,$3); }//sprintf($$, "%s = %s", $1, $3); }
          | condition OR conditions { $$ = opr2('o',$1,$3); }//sprintf($$, "%s OR %s", $1, $3); }
;

condition: STRING { $$ = opr2('C',setConst($1),NULL); }
;

update_values: update_value { $$ = opr2('u',$1,NULL); }
             | update_values ',' update_values { $$ = opr2(',',$1,$3);  }//sprintf($$, "%s, %s", $1, $3); }
;

update_value: STRING '=' STRING {$$ = opr2('=',setConst($1),setConst($3));}//{ $$ = malloc(strlen($1) + strlen($3) + 10); }//sprintf($$, "%s='%s'", $1, $3); }
;

insert_values: STRING { opr2('i',setConst($1),NULL);}
             | insert_values ',' STRING {$$ = opr2(',',$1,setConst($3));}//{ $$ = malloc(strlen($1) + strlen($3) + 10); }//sprintf($$, "%s, %s", $1, $3); }
;

%%

void yyerror(const char* s) {
    printf("Parser error: %s\n", s);
}

int main(int argc, char* argv[]) {
    if (argc > 1) {
        FILE* inputFile = fopen(argv[1], "r");
        if (!inputFile) {
            printf("Failed to open input file.\n");
            return 1;
        }
        yyin = inputFile;
    } else {
        yyin = stdin;
    }
    yyparse();
    return 0;
}
node *opr2(int type, node *first, node *second){
   node *p;
   p=(node*)malloc(sizeof(node));
   p->type= type;
   p->first=first;
   p->second = second;
}

node *opr3(int type, node *first, node *second, node * third){
   node *p;
   p=(node*)malloc(sizeof(node));
   p->type= type;
   p->first=first;
   p->second = second;
   p->third = third;
}

node *setConst(char* value){
   node *p;
   p=(node*)malloc(sizeof(node));
   p->type= STRING;
   p->value=value;

}
void printpre(node *opr){
    if (opr==NULL)
       return ;
    if (opr->type ==STRING)
       printf("%s ", opr->value);
    else
     {
      switch (opr->type ){
      case SELECT: printf("( IF ");break;
      case INSERT: printf("( Variable ");  break;
      default : printf(" ( %c ", opr->type);
      }
      printpre(opr->first);
      printpre(opr->second);
      printpre(opr->third);
      printf(" ) ");
     }
 
}





