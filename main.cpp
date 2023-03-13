#include "parser.hh"
#include <cassert>
#include <iostream>

#define self (*this)

class Eval
{
public:
  double operator()(Expr* expr)
  {
    if (auto p = dynamic_cast<Number*>(expr))
      return self(p);

    if (auto p = dynamic_cast<UnaryOp*>(expr))
      return self(p);

    if (auto p = dynamic_cast<BinaryOp*>(expr))
      return self(p);

    assert(false);
  }

  double operator()(Number* expr) { return expr->val; }

  double operator()(UnaryOp* expr)
  {
    switch (expr->op) {
      case UnaryOp::kPos:
        return self(expr->sub);

      case UnaryOp::kNeg:
        return -self(expr->sub);

      default:
        assert(false);
    }
  }

  double operator()(BinaryOp* expr)
  {
    switch (expr->op) {
      case BinaryOp::kAdd:
        return self(expr->lft) + self(expr->rht);

      case BinaryOp::kSub:
        return self(expr->lft) - self(expr->rht);

      case BinaryOp::kMul:
        return self(expr->lft) * self(expr->rht);

      case BinaryOp::kDiv:
        return self(expr->lft) / self(expr->rht);

      default:
        assert(false);
    }
  }

  std::vector<double> operator()(ExprList* expr)
  {
    std::vector<double> ret;
    for (auto&& i : *expr)
      ret.push_back(self(i));
    return ret;
  }
};

Mgr Mgr::g;
ExprList* gExprList;

void
yyerror(char const* s)
{
  fprintf(stderr, "%s\n", s);
}

int
main(int argc, char const* argv[])
{
  if (argc > 1)
    yydebug = 1;

  if (auto e = yyparse())
    return e;

  Eval eval;
  auto ans = eval(gExprList);
  for (auto&& i : ans)
    std::cout << i << std::endl;
}
