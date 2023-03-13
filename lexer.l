%{
#include "parser.hh"
%}

%option 8bit warn noyywrap
/* yylineno */

%%

[0-9]+ {
  yylval.Number = Mgr::g.make<Number>();
  yylval.Number->val = atol(yytext);
  return NUMBER;
}

[0-9]+\.[0-9]+ {
  yylval.Number = Mgr::g.make<Number>();
  sscanf(yytext,"%lf",&yylval.Number->val);
  return NUMBER;
}

"+"        { return ADD; }
"-"        { return SUB; }
"*"        { return MUL; }
"/"        { return DIV; }
"("        { return L_PAREN; }
")"        { return R_PAREN; }
";"        { return SEMI; }

[\f\r\t\v ]*     /* 忽略空白符 */

%%
