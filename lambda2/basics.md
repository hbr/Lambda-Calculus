<!--
[Table of Contents](toc.md)

- Definitions

    - Lambda terms and reduction

    - Conventions

    - Rename bound variables

    - Substitution

    - Substitution Example

- Combinators

    - Projections

    - Partial Application and Storage

    - Booleans

    - Pairs

- Type Annotations

    - Syntax with Types

    - Pairs with Types

- Terminating and Non Terminating Computations

    - Normal Forms

    - Loops

-->




# Basics of Lambda Calculus




## Definitions



### Terms and Reduction

In lambda calculus everything is a function. A *lambda term* is either a
variable, a function application or a function abstraction.
```
term ::=    x               -- variable
        |   \ x := term     -- function
        |   term term       -- application
```

We pronounce the term `\ x := e` _lambda x body e_. The backslash
should remind us of the greek letter $\lambda$.

The most interesting term is the function term.
```
\ x := term
  ^    ^-- body (might contain variable x)
  |
  \------  bound variable
```

The bound variable is meaningful only within the body. We can change the name of
the bound variable arbitrarily as long as we change it consistently within the
body.

What can we do with a function? We can apply it to an argument and
get `(\ x := e) a`.  This term is called a reducible expression (short
redex). As the name says, this expression can be reduced or we can compute the
result of the function applied to the argument.

```
(\x := e) a ~> e[x:=a]
```

where `~>` reads _reduces to_ and `e[x:=a]` is the expression `e` where all
occurrences of the variable `x` have been replaced by `a`. A reduction is the
most elementary *computation step* in lambda calculus.


We pronounce the substitution `e[x:=a]` _e with a for x_.

Example: Application of the identity function
```
(\x := x) a ~> x[x:=a] = a
```




### Conventions

There are some conventions which make writing lambda terms more convenient.

Function application associates to the left
```
f a b c             =           ((f a) b) c
```

Nested function abstractions associate to the right
```
\ x := \y := e      =           \x := (\y := e)
```

and the arguments of nested function abstractions can be compressed.
```
\ x := \y := e      =           \ x y := e
```



### Rename Bound Variables

The names of bound variable are irrelevant. We can change the names arbitrarily
without changing really the term.
```
\ x := x            =           \ y := y

\ x y := x          =           \ z u := z

\ x y := y          =           \ z u := u

\ x x := x          =           \ x y := y
```

This is the same as with any other programming language. The names of formal
arguments of a function are irrelevant to the caller of the function.

Furthermore we have to make sure to choose names for bound variables which
cannot change the meaning of an expression.

The last example demonstrates that a variable is always bound by the innermost
binder.




### Substitution

Since the basic computation step is based on substitution, we better define
substitution exactly.
```
x[x:=e]             =       e                   -- same variable

y[x:=e]             =       y                   -- different variables

(a b)[x:=e]         =       a[x:=e]  b[x:=e]    -- independent substitution

(\y := t)[x:=e]     =       \y := t[x:=e]       -- pull into abstraction
        -- y must not occur in e !!             -- hygiene condition

```
The effect of the substitution applied to a variable depends on the variable
name.

The substitution of an application is done on both terms independently.

We are allowed to pull a substitution into a lambda abstraction only if the
replacement term does not contain the bound variable of the abstraction.

This is a *hygiene condition* which is not really a restriction, because we can
always rename the bound variable so that the hygiene condition is satisfied.

The hygiene condition guarantees that the name of the bound variable does not
*interfere* with variable names in the world outside the abstraction.






### Substitution Example

```
(\ x y := x) a b

=   (\x := (\ y := x)) a b

~>  (\ y := x)[x:=a] b          -- y not in a !!

=   (\ y := a) b

~>  a[y:=b]

=   a
```

The hygiene condition tells us that `y` must not occur in `a` (otherwise we would
have to rename `y`).

So we get
```
(\ x y := x) a b    ~>      a
```

i.e. the term `\x y := x` applied to two arguments returns the first argument
and ignores the second argument.

In the same manner
```
(\ x y := y) a b    ~>      b
```

can be shown.






## Combinators

Lambda terms where all variables are bound are called *combinators*.


### Projections

We have seen already the combinators `\ x y := x` and `\x y := y`. In order to
use them later on we give them names.

```
K   :=  \ x y := x
KI  :=  \ x y := y
```

We have chosen the names `K` and `KI` to be inline with the literature on lambda
calculus which uses the names *K combinator* and *KI combinator*.

These two definitions give just names to the coresponding lambda terms. The
names are only for humans. The lambda calculus does not know of any names which
we give to combinators. I.e. whenever we see `K` in a lambda term we always
mean the term `\ x y := x`.

In order to write the definition of `K` and `KI` more like function definitions
in a programming language we use the syntax
```
K x y := x

KI x y := y
```

which we pronounce _K x y with body x_. We just replaced the backslash by a
name. Therefore we call `\ x y := x` an anonymous or unnamed function and `K x
y := x` a named function.

But note that we always mean the same thing. `K x y := x` is the same as `K := \
x y := x`. The first form just uses syntactic sugar.








### Partial Application and Storage

What happens if we apply a function with two arguments to only one argument?

Nothing special. Lambda calculus only knows of functions with one argument.
However the function can return another function which then can be applied to
the remaining argument.

But let's see what happens of we apply the `K` combinator to one argument.
```
K a

=   (\ x y := x) a

=   (\ x := (\ y := x)) a

~>  (\ y := x)[x:=a]

=   \y := a                 -- y must not occur in a!!
```

Now we have a function which ignores any arguments to which it is applied. The
term `K a` *stores*  the term `a` and returns it to any other term which
applies `K a` to an arbitrary argument.

Note that the hygiene condition is important to guarantee that `K a` returns
exactly `a` if applied to another argument. If we hadn't required that `y` must
not occur in `a`, then the application `K a b` would return `a[y:=b]` which in
that case could be different from `a`.




### Boolean

Lambda calculus does not have any primitive values. It only has functions ---
nothing else.

We have to find a way to express boolean values as functions.

Since there are only two boolean values, we can encode booleans as functions
taking two arguments. The boolean value *true* returns the first argument and
the boolean value *false* returns the second argument.

I.e. booleans are *decisions* which decide between two alternatives where the
alternatives are represented the by the two function arguments.

```
true x y  := x

false x y := y
```

Note that `true` and `K`  and `false` and `KI` are defined by the same lambda
term. We use different names to express different intentions. But again: This is
just for us. From the viewpoint of the lambda calculus the terms are equivalent.

It is not too difficult to define boolean functions. Negation can be defined as

```
not b := b false true
```

The correctness of the definition can be shown by the following reductions.
```
not true

~>  true false true         -- definition 'not'

~>  false                   -- 'true' selects the first argument


not false

~>  false false true        -- definition 'not'

~>  true                    -- 'false' selects the second argument
```


More boolean functions
```
and a b :=  a b false   -- if 'a' is true, return 'b', otherwise 'false'

or a b  :=  a true b    -- if 'a' is true, return 'true', otherwise 'b'
```






### Pair


A lambda term representing a pair of values has to *store* in some sense the
values. We have already seen that lambda calculus is able to store one value.
Remember the term `K a` which *stores* the value `a` and returns it if another
argument is given to the term.

The right choice to represent a pair is a lambda term which expects three
arguments. The first two arguments are the terms which form the pair of values.
The third argument is a function using these two values as arguments.

```
(,) x y := \ f := f x y
```

Here we use the comma operator to use the notation `(a,b)` to express the pair
of `a` and `b`. We could have chosen e.g. the name `pair` and written `pair a b`
instead of `(a,b)`.

The term `(a,b)` is a partial application. It expects a further argument which
should be a function taking two arguments.

We can use the combinators `K` and `KI` to extract either the first or the
second component of the pair.

```
first p := p K

second p := p KI
```

Let's see this in action on the term `first (a,b)`.

```
first (a,b)

=   (a,b) K                     -- definition of 'first'

=   (\ x y f := f x y) a b K    -- definition of '(,)'

~>  K a b

~>  a
```








## Type Annotations

*Untyped lambda calculus* does not know of any types. Therefore the name.
However the programmer thinks in types. We have already talked about booleans
and pairs. These are *types*. We use types to express our intentions.

Since we want to do *programming* in lambda calculus, we want to be able to
express our intentions in the source code.




### Example: Boolean

We have already seen, that a boolean value is represented as a choice between
the two arguments which follow. Usually our intention is to express a choice
between two things of the same kind, and not a choice between a string and a
number.

The lambda calculus does not care what arguments you provide. But we can use
types to express our intentions.

```
true (x: A) (y: A): A   := x

false (x: A) (y: A): A  := y
```

We use capital letters to express any type. Here the definitions tell us, that
we can use the functions `true` and `false` on any two arguments provided that
they have the same *type*. Both functions then return a value of exactly that
type.

But what type do the terms `true` and `false` have? They have the type
```
true:  A -> A -> A
false: A -> A -> A
```

We can use `Boolean` as an abbreviation for `A -> A -> A`.

Since these are just annotations which are ignored by the compiler, we don't
need formal rules. Otherwise we would have to switch to *typed lambda calculus*
which we won't do here.

Remember: **Type annotations are comments**.



### Example: Pair

If `(a,b)` is a pair of values, then the types of `a` and `b` can be different.
However the type of the third argument, the function which uses the two values
has to be consistent with the component types.

We can express the constraint in the following way.
```
(,) (x: A) (y: B): (A -> B -> C) -> C
:=
    \ f := f x y
```

The type of `(,)` is then
```
(,): A -> B -> (A -> B -> C) -> C
```

Since we are not formal on type annotations we can use `Pair A B` to express the
type of a pair where the first component is of type `A` and the second component
is of type `B`.

We can add type annotations to the terms `K`, `KI`, `first` and `second` as
well.

```
K (x: A) (y: B): A  := x

KI (x: A) (y: B): B := y

first (p: Pair A B): A := p K

second (p: Pair A B): B := p KI
```

If we use type annotations, then we have to type a little bit more. However the
definitions are much more readable. Understanding the definitions in 3 months
from now is easier with type annotations.

And our version of lambda calculus looks more and more like a programming
language.




## Terminating and Non Terminating Computations

Up to now all lambda terms we have used have *terminated* in the sense that we
reached a state, where no more reducible expressions are in the term.

Is this always the case? Unfortunately not. In the following we show how to
construct potentially endless loops in lambda calculus.


### Normal Forms

We call a lambda term to be in normal form if it contains no more redexes.


A term not in normal form can contain one or more redexes. A computation step is
done by choosing any redex and reduce it. Therefore evaluating a lambda term
might be non deterministic.


A reduction sequence might lead to a term in normal form or be an infinite
sequence.
```

t1 ~> t2 ~> t3 ~> .......  ~> tN        -- 'tN' is in normal form

t1 ~> t2 ~> t2 ~> .............................
```


We call a lambda term strongly normalizing, if any sequence of reduction steps
finally leads to a term in normal form.

We call a lambda term weakly normalizing, if there is a reduction sequence which
leads to a term in normal form.


### Loops

We can apply a lambda term to itself. This is the easiest form to build an
infinite loop.

```
M x := x x
```

Let's see what happens if we apply `M` to itself.

```
M M

=   (\ x := x x) M

~>  (x x)[x:=M]

~>  M M

~>  M M

...
```

I.e. the term `M M` is neither strongly nor weakly normalizing. It is diverging.

The term `M M` is not useful at all. It is just a silly term to demonstrate
what can go wrong, because an infinite loop is certainly not desirable.

But we can construct another term which is only potentially non terminating.

```
U x f := f (x x f)
```

Let's see what happens if we apply `U U` to an arbitrary argument.

```
U U g

=   (\ x f := f (x x f)) U g

~>  g (U U g)

~>  g (g (U U g))

~>  g (g (g (U U g)))

...
```

Here we get a potentially infinite reduction sequence. But we can choose `g` in
a manner that it might in some states ignore its argument i.e. which might
generate some *exit condition* from the loop.

In this introductory chapter we don't look deeper into this possibility. We just
wanted to demonstrate that we can program *loops* in lambda calculus which are
potentially infinite.



