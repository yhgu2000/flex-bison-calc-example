/* 生成.output文件 */
%verbose

/* 用于调试 (yydebug) */
%define parse.trace

%code top {
int yylex (void);
void yyerror (char const *);
}

%code requires {
#include "asg.hpp"
}

%union {
  Expr* Expr;
  Number* Number;
  UnaryOp* UnaryOp;
  BinaryOp* BinaryOp;
  ExprList* ExprList;
}

%nterm <ExprList> ExprList
%nterm <Expr>     Expr;
%nterm <Expr>     Expr3;
%nterm <Expr>     Expr2;
%nterm <Expr>     Expr1;
%nterm <Expr>     Expr0;

%token <Number>   NUMBER
%token ADD
%token SUB
%token MUL
%token DIV
%token L_PAREN
%token R_PAREN
%token SEMI

%start start

%%

start:
  ExprList { gExprList = $1; }
| ExprList SEMI { gExprList = $1; }
;

ExprList:
  %empty { $$ = Mgr::g.make<ExprList>(); }
| Expr { $$ = Mgr::g.make<ExprList>(), $$->push_back($1); }
| ExprList SEMI Expr { $$ = $1, $$->push_back($3); }
;

Expr:
  Expr3
;

Expr3:
  Expr2
| Expr2 MUL Expr2 {
    auto p = Mgr::g.make<BinaryOp>();
    p->op = BinaryOp::kMul, p->lft = $1, p->rht = $3;
    $$ = p;
  }
| Expr2 DIV Expr1 {
    auto p = Mgr::g.make<BinaryOp>();
    p->op = BinaryOp::kDiv, p->lft = $1, p->rht = $3;
    $$ = p;
  }
;

Expr2:
  Expr1
| Expr1 ADD Expr1 {
    auto p = Mgr::g.make<BinaryOp>();
    p->op = BinaryOp::kAdd, p->lft = $1, p->rht = $3;
    $$ = p;
  }
| Expr1 SUB Expr1 {
    auto p = Mgr::g.make<BinaryOp>();
    p->op = BinaryOp::kSub, p->lft = $1, p->rht = $3;
    $$ = p;
  }
;

Expr1:
  Expr0
| ADD Expr0 {
    auto p = Mgr::g.make<UnaryOp>();
    p->op = UnaryOp::kPos, p->sub = $2;
    $$ = p;
  }
| SUB Expr0 {
    auto p = Mgr::g.make<UnaryOp>();
    p->op = UnaryOp::kNeg, p->sub = $2;
    $$ = p;
  }
;

Expr0:
  NUMBER { $$ = $1; }
| L_PAREN Expr R_PAREN { $$ = $2; }
;

%%
