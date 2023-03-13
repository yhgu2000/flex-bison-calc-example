#pragma once

#include <memory>
#include <string>
#include <vector>

class Obj
{
public:
  virtual ~Obj() = default;

public:
  template<typename T>
  T* dcast()
  {
    return dynamic_cast<T*>(this);
  }

  template<typename T>
  T& rcast()
  {
    return *reinterpret_cast<T*>(this);
  }
};

class Mgr : public std::vector<std::unique_ptr<Obj>>
{
public:
  static Mgr g;

public:
  template<typename T, typename... Args>
  T* make(Args... args)
  {
    auto ptr = std::make_unique<T>(args...);
    auto obj = ptr.get();
    emplace_back(std::move(ptr));
    return obj;
  }
};

struct Expr : public Obj
{};

struct Number : public Expr
{
  double val;
};

struct UnaryOp : public Expr
{
  enum
  {
    kPos,
    kNeg
  } op;
  Expr* sub;
};

struct BinaryOp : public Expr
{
  enum
  {
    kAdd,
    kSub,
    kMul,
    kDiv
  } op;
  Expr *lft, *rht;
};

struct ExprList
  : public Obj
  , public std::vector<Expr*>
{};

extern ExprList* gExprList;
