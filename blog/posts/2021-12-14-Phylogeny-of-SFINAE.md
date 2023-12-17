---
title: SFINAE 的发展史
date: 2021-12-14
authors: 
    - Offensive77
categories:
    - blog
tags: SFINAE
---

说到 C++ 的模板技术，有一个术语不得不提：**SFINAE** (读作 Sfee-nay，**S**ubstitution **F**ailure is **N**ot **A**n **E**rror )。这个技术使得 C++ 这样的静态语言在一定程度上可以实现类似反射的功能 (可以根据类型的特征，表现出不同的行为)。在 C++20 标准概念库发布之后，许多运用到 **SFINAE** 技术的场景都可以被概念取代，这一古老的技术也许也将退出历史舞台。

当然，这不是一件值得悲伤的事情，这说明标准委员会在积极地寻求摆脱历史的包袱的途径。

这篇文章旨在向想要了解 **SFINAE** 的读者介绍这一技术的发展历史。
<!--more-->

## 什么是 **SFINAE**?

任何人，看到那样一长串的英文解释，或许都会懵逼。**替换失败不是一个错误？**什么鬼？

更加具体地说，这句话的意思是，在**模板实例化的过程中，替换失败不是一个错误。**

## C++98 的做法

下面我将以判断一个类是否拥有 `size_t size()` 方法为例，来深入 **SFINAE**。

我们希望，假如这个类拥有 `size` 方法，那么就调用这个方法，否则使用另外一个泛化版本的方法。

### traits

我们定义一个结构体 `hasSize` 作为类的特征，假如这个类拥有 `size` 方法，那么 `hasSize::value` 将会是 `true ` (或1)，否则为 `false`。

```cpp
template <typename T>
struct hasSize
{
    // Compile-time Boolean
    typedef char yes;
    typedef int  no;
};
```



**Q:** 你一定注意到了上面的 `typedef`，并且对此有些不解。它是做什么的？

**A:** 它是用来做编译期的对错判断的。



**Q:** 为什么要这么写？直接用函数返回 `true` 或 `false` 难道不好吗？

**A:** 确实好，但是 C++98 的函数返回值只能在运行时获得。直到 C++11 引入 `constexpr` 之后，这一问题才得到改善。



**Q:** 那为什么这么写就能达成我们的目的？

**A:** 我们应该还记得 C 里的一个运算符，它长得有点像函数，但与它有关的求值却全都发生在编译期。那就是 `sizeof`。

```cpp
const int a = sizeof(int);
const bool b = sizeof(int) == sizeof(char);
```

上面的两个赋值语句，其赋值号右边的值均可以在编译期求得。而看到第二个语句，你一定已经恍然大悟。



下面就是我们的 **SFINAE** 登场的时候了。

我们在结构体内加入另外一个脚手架结构体 `reallyHas`：

```cpp
template <typename U, U u> struct reallyHas;
```

我们在参数 `U` 中可以给出函数指针的类型，在参数 `u` 中给出成员函数的具体名字。



然后给出两个函数 `test` 的重载版本：

```cpp
template <typename U,
          typename = reallyHas<size_t(U::*)() const, &U::size>>
static yes test(U) { }

// Fallback:
static no test(...) { }
```

第一个版本返回 `yes`，接受 `U` 类型的变量为参数，模板参数列表里第一个是 `U`，第二个参数是我们之前的脚手架 `reallyHas`。

第二个版本接受可变长参数。

匹配 `test` 版本的过程中，会发生这样的事：

* `test` 从参数中推导出 `U` 的具体类型，代入模板的第一个参数，然后把所有的 `U` 替换成这个类型。
* 替换 (Substitution) 完毕，接着编译器会去查找实例化后 `test` 中和替换后 `U` 有关的部分（本例中就是 `size_t(U::*)() const` 类型的 `&U::size`），假如它们不存在，那么这次替换就宣告失败 (Failure)。但替换失败不是一个错误 (Error)，编译器会接着匹配，直到所有候选名单 (*candidates*) 的成员都不匹配，才会报错。
* 随着第一个匹配失败，模板去匹配可变长参数版本的 `test`。这个版本无论如何一定能匹配成功，而它的返回值类型是 `no`。



然后我们使用一个枚举常量 `value` 来接受结果：（C++11 之后便被 `constexpr` 取代）

```cpp
enum
{
    value = sizeof(test(T())) == sizeof(yes)
};
```



这一过程，我们并不需要函数具体的返回值，而只是对返回值的类型作操作。这冥冥之中也印证了一句话：C++的模板是编译期的多态，是类型的多态（或者也可以说，类型和值本身可以等价）。



当然上面的并不是最终版本，假如我们的 `size` 有两种可能的版本：

* `size_t(U::*)() const`
* `size_t(U::*)()`

那么我们就无法简单使用上面的做法了。

下面提供一种更加简洁的做法：

```cpp
template <typename T>
struct hasSize
{
    typedef char yes;
    typedef int  no;

    template <typename U, U u> struct reallyHas;

    template <typename U> static yes test(reallyHas<size_t(U::*)(), &U::size> *) { }
    template <typename U> static yes test(reallyHas<size_t(U::*)() const, &U::size> *) { }
    template <typename> static no test(...) { }

    enum
    {
        value = sizeof(test<T>(int())) == sizeof(yes)
    };
};
```

由于 C++ 整形可以隐式转化为指针，我们仍然会先匹配 `yes` 版本的 `test`。

### enable_if

下面我们使用之前的 `hasSize` 来帮助我们实现目的。我们来引入另外一个工具人：`enable_if`。

```cpp
template <bool, typename T>
struct enable_if
{
    typedef T type;
};

template <typename T>
struct enable_if<false, T>
{ };
```

看起来有点懵？不知道它要干嘛？我们继续实现我们的 `getSize` 函数：

```cpp
template <typename T>
  typename enable_if<hasSize<T>::value, size_t>::type
getSize(const T &obj)
{
    std::cout << "obj has size" << std::endl;
    return obj.size();
}

template <typename T>
/* disable if: */
  typename enable_if<!hasSize<T>::value, size_t>::type
getSize(const T &obj)
{
    std::cout << "obj has no size" << std::endl;
    return sizeof(obj);
}
```

两处都得写上 `enable_if`，否则会产生二义性。（如果其中一个 `enable_if` 的参数1为 `true`，那么返回值是 `size_t`，那么另外一个 `enable_if` 必然没有返回值，所以它会被排除在候选名单之外，假如另外一个函数拥有返回值，那么这个时候编译器将会不清楚应该调用哪个版本的函数，从而产生 error）

下面来试验一下：

```cpp
std::vector<int> v = {4, 5, 6, 7};
char c = 'c';
std::cout << getSize(v) << std::endl;
std::cout << getSize(c) << std::endl;
```

输出结果：

```bash
obj has size
4
obj has no size
1
```

## 时间来到 C++11

我们在讲述 C++98 的解决方法的时候，已经说过：许多东西到了 C++11 会有更好的解决办法。

现在我们终于可以介绍 C++11 了。

其实本来并没有 C++11，它最早的名字叫做 C++0x，因为人们坚信在二十一世纪的前十年 C++11 的标准就能够实现，然而实际上直到2011年，C++11 才正式发布。

C++11 为模板编程带来了许多的便利。

* 首先是编译期表达式类型推导 `decltype`。
* 接着是 `std::declval`，这是一个模板函数，它允许我们构造一个类型 `T` 的临时量，而无需我们提供参数对其构造。
* 还有我们之前说过的 `constexpr`，也是千呼万唤始出来。
* `std::enable_if`，它进标准了。
* 当然还有新的标准库头文件，`type_traits`，它为我们提供了许许多多方便的 `traits`，我们不需要再自己手动实现了。



在 C++11 中，我们将使用另外一个例子——判断一个类是否是可以比较大小的。(这里以小于号为例)

我们写一个类模板 `isComparable`：

```cpp
template <typename T>
struct isComparable
{
    template <typename U>
    static constexpr bool test(decltype(std::declval<U>() < std::declval<U>()) *)
    { return true; }

    template <typename>
    static constexpr bool test(...) { return false; }
	// C++11 initializer list
    static constexpr bool value { test<T>(int()) };
};
```

在  `test` 的参数中用到了 `decltype` 和 `std::declval`。用 `declval` 来查询是否两个 `U` 类型的变量重载了（或者本身就拥有）`operator<`，如果拥有，则匹配成功，否则匹配失败，将会匹配可变长参数版本的 `test`。

C++11 版本下我们的许多操作变得更加符合直觉，实现也更加简洁明了。



试验：

```cpp
class Test1
{
public:
    bool operator<(Test1);
};

class Test2
{ };

std::cout << isComparable<Test1>::value << std::endl; // 1
std::cout << isComparable<Test2>::value << std::endl; // 0
```



除此之外还有另一种方法：

```cpp
template <typename T,
          typename = bool>
struct isComparable: std::false_type // 继承而来的 value 成员为 false，下面类似。
{ };

template <typename T>
struct isComparable<T, decltype(std::declval<T>() < std::declval<T>())>: std::true_type
{ };
```

第一个版本的 `isComparable` 默认参数一定要设为 `bool`，也就是 `operator<` 返回值的类型，原因是：

* 当类模板有默认参数的时候，编译器会更加偏袒那个有默认参数的模板；
* 当带有默认参数的模板与另外一个偏特化模板参数一致的时候，则会优先选择那个偏特化的版本。



于是当 `[T = Test1]`，偏特化版本模板的第二个参数也是 `bool`，于是选择了第二个偏特化版本的模板。

当 `[T = Test2]`，**SFINAE** 的规则让我们不得不选择第一个版本的模板。

## C++14 泛型 `lambda`

C++14 让我们的匿名函数支持 `auto` 类型的参数。它的本质其实就是带有模板括号运算符的仿函数。

```cpp
auto f = [] (auto x) { return x; };

// equivalent to:
struct Unnamed
{
    template <typename T>
    auto operator()(T x) { return x; }
} functor;
```

因此 **SFINAE** 的技术也能够适用于它。

我们可以用泛型 `lambda` 来实现袖珍版的 `traits`。

先上效果：

```cpp
class A { };

class B
{
public:
    bool operator<(B const &) const { }
};

auto hasLess = is_valid([] (auto &&x) -> decltype(x < x) { });
std::cout << std::boolalpha;
std::cout << hasLess(43)  << std::endl;
std::cout << hasLess(A()) << std::endl;
std::cout << hasLess(B()) << std::endl;

auto comparableWith = is_valid([] (auto &&x, auto &&y) -> decltype(x < y) { });
std::cout << comparableWith(43, "Abc"s) << std::endl;
std::cout << comparableWith(43, 72.2)   << std::endl;
std::cout << comparableWith(B(), B())   << std::endl;
std::cout << comparableWith(A(), B())   << std::endl;
```

输出结果：

```bash
true
false
true
false
true
true
false
```

这个 `is_valid` 是个啥，好神奇。下面我们就来详细解释一下：

首先，它是一个**工厂函数**。产生 `is_valid_impl` 类型的对象。

```cpp
template <typename F>
struct is_valid_impl
{
private:
    F _f;

    template <typename... Ts>
    static constexpr auto test(Ts&&... ts) -> decltype(_f(ts...), true)
    { return true; }

    // fallback
    static constexpr bool test(...)
    { return false; }

public:
    constexpr explicit is_valid_impl(F &&f): _f(f) { }

    template <typename... Us>
    constexpr auto operator()(Us&&... us)
    { return test(us...); }
};

template <typename F>
is_valid_impl<F> is_valid(F &&f)
{ return is_valid_impl<F>(std::forward<F>(f)); }
```

`is_valid_impl` 的工作原理：

* 依靠 `is_valid_impl` 构造函数把仿函数对象 `_f` 初始化。
* `operator()` 从调用时的实参列表推导出来 `Us...` 将运算委任给 `test` 函数。
* 首先匹配第一个版本的 `test`，这个过程有 **SFINAE** 的参与：`decltype` 时，将形参代入 `_f`，而我们的 `_f` 形如：`[] (auto &&x, auto &&y) -> decltype(x < y) { }`，如果参数无法进行某些指定操作，或者参数长度不匹配，那么第一个版本的 `test` 被 `SFINAE out`。否则匹配成功，返回 `true`。
* 匹配失败，这个时候就进入第二个版本的 `test`，其无论如何都会返回 `false`。

由于 C++14 参数推导还不够智能，所以我们这里**不得不使用**一个工厂函数来帮助我们推导 `F` 的类型，而在后续标准，我们可以不再需要这个工厂函数，而直接使用构造函数了。

## C++17 void_t

C++17 引入了一个 类模板`std::void_t`，它可以干啥呢？接受一长串的类型，但自己永远是 `void`。它其实就是一个别名模板，长成这样：

```cpp
template <typename...>
using void_t = void;
```

现在可以方便地使用 `decltype` + 逗号表达式，来完成一长串的判断，而无需判断返回值类型了（有的时候返回值类型是难以判断的，比如返回值类型带有模板参数）。

下面给出一个终极版 `isComparable`：

```cpp
template <typename T,
          typename = void>
struct isComparable: std::false_type
{ };

template <typename T>
struct isComparable<T, std::void_t<decltype(std::declval<T>() < std::declval<T>(),
                                            std::declval<T>() > std::declval<T>(),
                                            std::declval<T>() >= std::declval<T>(),
                                            std::declval<T>() <= std::declval<T>(),
                                            std::declval<T>() == std::declval<T>(),
                                            std::declval<T>() != std::declval<T>())>>: std::true_type
{ };
```

## C++20 concepts

如前言所说，C++20 概念库或给 **SFINAE** 的时代画上一个句号。那么我们也用概念重写的 `isComparable` 为本文画上一个句号。

```cpp
template <typename T>
concept is_bool = std::is_convertible_v<T, bool>;

template <typename T>
concept isComparable =
  requires (T t)
{                            
    {t >  t} -> is_bool; {t <  t} -> is_bool;
    {t >= t} -> is_bool; {t <= t} -> is_bool;
    {t == t} -> is_bool; {t != t} -> is_bool;
};

template <typename T>
concept isNotComparable = !isComparable<T>;
```

我们可以这么使用：

```cpp
// 使用不同的概念我们可以提供不同的重载函数版本（即便参数列表相同）
void foo(isComparable auto&&)
{
    std::cout << "is comparable" << std::endl;
}

void foo(isNotComparable auto&&)
{
    std::cout << "is not comparable" << std::endl;
}

class Test { };

foo(1);
foo(Test());
```

结果：

```bash
is comparable
is not comparable
```

当然我们可以把 `concepts` 和上面的那些类模板结合起来，用来做空基类优化，不过那就不是本文要讨论的内容了。

## 后记

尽管我曾在前言说过，我们毋须为 **SFINAE** 技术的退出而悲伤，但我认为 **SFINAE** 技术是老一代 C++ 工程师智慧的结晶。二十多年过去，C++ 标准从跛脚逐步开始走向完善，使用 C++ 抽象的方法日趋成熟，我想这其中不无他们的功劳。在模板技术发展的过程中，许多东西都事出偶然，然而如果没有前人的不懈尝试，这些偶然又怎会成为已经发生的必然？

当然，**SFINAE** 作为 C++ 本身的一个语言规则，它仍然会在底层发挥作用。不得不直接倚赖底层的东西去解决上层的问题，这是 C++ 过去的缺陷。

人们始终不停地在探索这个语言的极限，我想这才是 C++ 吸引人的地方。

如果这篇文章能给读者带来一丝启发，那就再好不过了。

## 参考

***Jean Guegant: An introduction to C++'s SFINAE concept: compile-time introspection of a class member*** [https://jguegant.github.io/blogs/tech/sfinae-introduction.html](https://jguegant.github.io/blogs/tech/sfinae-introduction.html) （我的 **SFINAE** 启蒙读物）
