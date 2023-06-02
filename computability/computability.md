<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-W295PVPC2K"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-W295PVPC2K');
</script>




**[Up][up] [Home][home]**


Introduction
============


Background
----------


We explore the limits of computability, i.e. the question:
*Are there functions which cannot be computed?*

At the turn of the 19th/20th century there was a great optimism regarding this
question. Most of the mathematicians thought that every mathematical function
must be computable, every mathematical question has to be decidable.

The famous german mathematician David Hilbert formulated a program (today called
*Hilbert's program*) to ground all mathematics on axioms and formal proofs and
prove that such a system is free of inconsistencies. In such a formal system it
should be possible to prove or disprove all mathematical statements. He
expressed his belief with his famous sentence

> *We must know, we will know*.

This optimism had not been restricted to mathematics. It had been present in all
science and technology. The Eiffel tower has been build for the world exposition
in 1889. A 324 m high steel building representing the power of technology.
Albert Einstein published 1905 his theory of relativity and in 1915 his theory
of general relativity. Both theories had been verified by various experiments.
The Wright brothers invented and flew the first airplane in 1903.

But let's go back to mathematics. In 1901 Bertrand Russel discovered a paradox
in naive set theory. It has been customary to talk about the set of all sets.
Bertrand Russel found out that this leads to the paradoxical

> *set of all sets which do not contain themself.*

Does this unversal set contain itself? If yes, it contains itself and therefore
cannot be in the set. If no, it does not contain itself and therefore must
contain itself.

In order to avoid such paradoxes which lead to contradictions, Whitehead and
Russel published in 1910, 1912 and 1913 the famous *Principia Mathematica* which
provided a foundation for mathematics free of paradoxes.

The young viennese mathematician Kurt Goedel invented a technique called *Goedel
Numbering*. He used this technique to formulate a sentence similar to Russel's
paradox as a mathematical statement about natural numbers. Such a statement can
be expressed in the formalism of Principia Mathematica and therefore can be
injected into Principia Mathematica like a Trojan horse. In his famous
incompleteness theorem (1931) Goedel demonstrated that paradoxical statements
can be injected into all formalisms which are powerful enough to express basic
arithmetics.

Imagine the blow to Hilbert's program! All formal theories sufficiently
powerful are either inconsistent or incomplete.


The positive side of Goedels incompleteness theorem: Paradoxes are not
necessarily bad. They are part of the mathematicians toolkit to prove something.

In 1936 Alan Turing and Alonzo Church proved independently that there are
undecidable (or uncomputable) problems in mathematics. They basically used the
technique of Goedel numbering in their proofs.

In this paper we are going to show that there are functions which cannot be
computed in lambda calculus. Note that functions can return a boolean value and
a not computable boolean valued function represents an undecidable predicate.

We don't use a lot of math here. We continue to express the ideas in
programmer's terms like we did in [Programming with Lambda
Calculus][lambda-intro]. Everybody who is able to program functions should be
able to follow.





Barberville
-----------

Nearly all proofs of undecidability use the encoding of some logical paradox.
Let's review the outline of such proofs using the example of the *barber
paradox*.

Definition:

> A village has the *barber* property if there is a barber in the village who
  shaves all the men in the village who do not shave themselves.

Theorem:

> A village with the barber property does not exist.

Proof:

Let's assume by way of contradiction that such a village exists. Then there is
a barber who shaves every man in the village who does not shave himself.

Now there are two possibilities:

1. The barber shaves himself: This is not possible because the barber can only
   shave men who do not shave themselves. Therefore the assumption that the
   barber shaves himself leads to a contradiction.

2. The barber does not shave himself: This is not possible because the barber
   shaves all the men who do not shave themselves. Therefore the assumption that
   the barber does not shave himself leads to a contradiction as well.

The assumption that such a village exists leads to a contradicion. Therefore we
have to conclude that a village with the barber property cannot exist.


Note that some kind of self reference is essential in all paradoxes. In order to
use this technique to show that some predicates are undecidable in lambda
calculus we have to introduce some self referential lambda terms. I.e. we need
some lambda terms and encoded versions of them.

In order to do this, we need some techniques. After having the machinery the
actual proof is not complicated.







Lambda Calculus Basics
======================


This section summarizes some basic knowledge of lambda calculus which is
required to understand the rest of the text.

If the summary is too compressed, then read the text [Programming with Lambda
Calculus][lambda-intro] which gives more detailed introduction.



Lambda terms
------------


A lambda term is either a variable, an application of a function term to a
variable term or a lambda abstraction.

~~~haskell
    t   ::=     x           -- variable
        |       (a b)       -- application of 'a' to the argument 'b'
        |       (\ x := a)  -- abstraction
                   ^    ^ definition term
                   | bound variable
~~~

where `x` ranges over an infinite supply `x0, x1, x2, ...` of variables and `a,
b, t` range over arbitrary lambda terms.

In mathematical texts the abstraction `(\x := a)` is usually written as $\lambda
x. a$. In this text we prefer an ascii notation in order to be able to write
lambda terms more like terms in a functional programming language. However the
mathematical notation and the ascii notation denote the same thing.


The name of a bound variable is irrelevant. The names of bound variables can be
changed consistently as long as the change does not interfere with variables
which are not bound by the same binder. This restriction is necessary, because a
renaming must not make a free variable bound.

Bound variable names in lambda calculus have the same character as formal
argument names in programming languages.

All functions in lambda calculus have only one argument. This is not a
restriction, because the function applied to an argument can return another
function which can be applied another argument.


Reduction
---------

The lambda term `(\ x := exp) a` is a reducible expression. The basic reduction
step is

~~~
    (\ x := exp) a      ~>      exp[x := a]
                        ^
                        read "reduces to"
~~~

where `exp[x:=a]` is the term `exp` where all free variables in `exp` have been
replaced by the term `a`. Note that it might be necessary to rename bound
variables in `exp` before doing the substution in such a way that they do not
interfere with any free variables in `a`. This is always possible since we have
an infinite supply of variables.

Example:

~~~
    ((\ x := (\ y := x)) a) b
    ~> (\ y := x)[x:=a] b
    =  (\ y := a) b
    ~> a[y:=b]
    =  a
~~~

Note that the last equality is valid. `a` must not contain the free variable
`y`. Otherwise we would have been obliged to rename `y` to a new variable which
is not contained in `a`.


Notation
--------

In order to avoid excessive brackets we use some conventions.

1. Outer brackets can be ommitted.

2. Function application associates to the left. I.e. `((a b) c) d)` can be
   written as `a b c d`.

3. Functions with more than one argument can be written in a compressed form.
   I.e. instead of writing `\ x := (\y := exp)` we can write `\ x y := exp`.


Booleans
--------

Data types in lambda calculus are represented by functions which *do something*
which is meaningful for the data type.

A boolean term has two values, true and false. We can encode such values in
lambda calculus as functions taking two arguments and returning either the first
in case of a true value and the second in case of a false value.

~~~
    true  := (\ x y := x)
    false := (\ x y := y)
~~~

Therefore `true a b ~> a` and `false a b ~> b`.

Note that we use the reduction symbol `~>` in a sloppy manner. `t ~> u` can mean
that `t` reduces to `u` in one step or in more steps. In this paper there is no
need to distinguish between one step and multistep reduction. In other contexts
it might be necessary to use different symbols.

In order to make our notation look more like definitions in a programming
language we can write the definitions of `true` and `false` as

~~~
    true  x y := x
    false x y := y
~~~

But remember that definitions are just abbreviations to make the terms
more readable. Lambda calculus does not know of any definitions. The
corresponding lambda term can always be obtained by expanding the definitions.
This is always possible, because no recursive definitions are allowed.
Definitions are just abbreviations.


Pairs
-----

We can use our notation to define pairs in lambda calculus.

~~~
    pair x y f := f x y
~~~

If we apply `pair` only to two arguments `pair a b` we get a function which
expects another argument and then applies the missing argument to the first two
arguments. This fact can be used to define the following projections

~~~
    first p     :=  p (\ x y := x)
    second p    :=  p (\ x y := y)
~~~

The following reduction shows that `first` behaves as expected extracting the
first part of a pair.

~~~
    first (pair a b)
    =  first ((\ x y f := f x y) a b)
    ~> first (\ f := f a b)
    =  (\ f := f a b) (\x y := x)
    ~> (f a b)[f:= (\x y := x)]
    =  (\x y := x) a b
    ~> (\ y := x)[x:=a] b
    =  (\ y := a) b
    ~> a[y:=b]
    =  a
~~~

Note again that `a` must not contain `y`. Otherwise the variable `y`
must be renamed to another variable which does not occur in `a`.




Church Numerals and Arithmetics
-------------------------------

We can represent numbers in lambda calculus as functions with two arguments. The
first argument is a function and the second is a start value. The so represented
number is a lambda term which applies the function argument `n` times on the
start value.

Such lambda terms are called *Church Numerals*.


The number zero is represented by the term

~~~
    zero f s := s
~~~

which is in our notation equivalent to

~~~
    zero := (\ f s := s)
~~~

The function `zero` applies the function argument `f` zero times on the start
value `s`.

The successor function takes a Church numeral `n` and a function argument `f`
and a start value `s` and applies the function `f` one more time upon the start
value than `n` already does.

~~~
    successor n f s := f (n f s)
~~~

Make sure that you understand that the partial application `successor n` returns
a Church numeral if supplied with a Church numeral argument.

Having this we can define arbitrary Church numerals

~~~
    one := successor zero
    two := successor one
    ...
~~~


We can define addition as the iterated application of the successor function,
multiplication as the iterated addition of a number and exponentiation as the
iterated multiplication of a number.

~~~
    plus  n m  := n successor m
    times n m  := n (plus m) zero
    power n m  := m (times n) one
~~~

Addition, multiplication and exponentiation are just simple iterations. In order
to implement the predecessor function we need a little trick.

We want a function `predecessor` which returns for any number the predecessor of
that number and which returns `zero` for the predecessor of the number `zero`.

We implement the function by iterating over a pair of numbers of the form

~~~
    pair counter predecessor-of-counter
~~~

with the start value `pair zero zero`. At each iteration we copy the counter to
the predecessor field and increment the counter. At the end of the iteration we
extract the second component of the pair.

~~~haskell
    predecessor n :=
        second
            (n step (pair zero zero))
        where
            step p :=
                p (\ counter pred-counter :=
                    pair (successor counter) counter)
~~~


These arithmetic functions are sufficient for the rest of the text.

The paper [Programming with Lambda Calculus][lambda-intro] shows many more
functions which can be implemented in lambda calculus. All computable functions
can be implemented in lambda calculus.





Encoding of Lambda Terms
========================

It is not possible to write a lambda term which can inspect its own arguments i.e.
find something about the structure of its arguments. E.g. a lambda term
`isVariable` where `isVariable a` returns `true`, if `a` is a variable and
otherwise `false`, is not possible.

A lambda term can only use its arguments as functions and apply it to other
arguments or as arguments to feed them to other arguments. This is due to the
fact that lambda terms are either variables, applications or abstractions.

Therefore we must encode a boolean value as a function taking two arguments and
returning either the first or the second depending on its truth value. We have
to encode numbers as functions taking two arguments and applying the first
argument n times on the second argument.

All arithmetic functions expect their arguments to be Church
numerals. E.g. the function `successor` expects one argument which has to be a
Church numeral to compute the Church numeral of the successor of the number
represented by its argument.

All our functions expressed in lambda calculus do the *right thing* only if
their arguments have the correct form. The lambda calculus cannot check if the
argument is a Church numeral and throw an exception in case of failure.

If we want to have lambda terms which are self referential we have to give the
lambda term an argument, which is some encoding of itself. The most popular
encoding is Goedel numbering which is in lambda calculus the encoding of lambda
terms as Church numerals. However Goedel numbering is not the only way to encode
lambda terms. We separate in the following the parts which are independent of
the encoding technique and the parts which do the actual encoding as Church
numerals.







Required Functions for Encoding
-------------------------------



We use the following notation.

~~~
    lambda term                 encoded term

    a                           <a>
~~~

The correspondence between a lambda term `a` and its encoding `<a>` must be
one-to-one. I.e. two different lambda terms must not have the same encoding.

In order to encode lambda terms we need the functions `var`, `appl`, `lam` and
`wrap` which satisfy the following requirements.

~~~
    var c[i]            ~>          <xi>
    app <a> <b>         ~>          <a b>
    lam c[i] <a>        ~>          <\ xi := a>
    wrap <a>            ~>          < <a> >
~~~

1. The function `var` expects a Church numeral representing the number `i` and
   returns the encoding of the variable `xi`.

2. The function `app` expects an encoding of the lambda terms `a` and `b` and
   returns the encoding of the lambda term `a` applied to `b` i.e. the encoding
   of `a b`.

3. The function `lam` expects a Church numeral representing the number `i` and
   an encoding of the lambda term `a` and returns an encoding of the lambda term
   `\ xi := a`

4. The function wrap expects an encoding of the lambda term `a` and returns the
   encoding of the encoding of the lambda term `a`.

In order to satisfy the *one-to-one* requirement, the functions `var`, `app`,
`lam` and `wrap` have to be one-to-one. Remember that the composition of
one-to-one functions is one-to-one as well. I.e. all combinations of the four
basic functions are one-to-one.



Self Reference
--------------


All four functions are needed to encode self referential terms. E.g. to generate
the encoding of the term `a <a>` i.e. the encoding of the term `a` applied to
its encoding we can use the equivalence

~~~
    <a <a>>            =   app <a> (wrap <a>)
~~~

I.e. the function

~~~
    self x := app x (wrap x)
~~~

satisfies the specification

~~~
    self <a>    ~>  <a <a>>
~~~


Goedel/Church Numbering
-----------------------

In this section we show how to encode lambda terms as Church numerals, i.e. a
term of the form `<a>` is the Church numeral encoding the term `a`.

Before doing that we define a mathematical pairing function $[.,.]$ which maps
pairs of natural numbers one-to-one and onto to the natural numbers. There are
many possibilities. We choose the function
$$
    [n,m] := 2^n (2m + 1) - 1
$$

Note that this is a mathematical function and has nothing to do with a lambda
term.

Some example values:

    n        m        [n,m]
  -----    ----      -------
    0        0          0
    1        0          1
    2        0          3
    3        0          7
    0        1          2
    0        2          4
    0        3          6
    1        1          5
    2        1         11



In order to see that the pairing function is one-to-one and onto we show that
given the value of $[n,m]$ we can uniquely recover $n$ and $m$. Assume $z =
[n,m]$. We divide $z + 1$ by $2$ until we get an odd number. $n$ is the number
of times, we can divide $z + 1$ by $2$. Since all odd numbers can be uniqueley
represented by $2m + 1$, we get a unique value for $m$.

For example let $z = 11$. We get $z + 1 = 12$. Dividing 12 subsequently by 2 we
get the sequence $6,3$ i.e. we can divide 2 times by 2 and therefore $n = 2$.
Resolving the equation $3 = 2m + 1$ we get $m = (3 - 1)/ 2 = 1$.

We can transform the mathematical pairing function $2^n (2m + 1) - 1$ into a
lambda term.

~~~haskell
    compress n m :=
            -- Compute the pairing function [n,m] where
            -- n and m are Church numerals representing
            -- the numbers.
        predecessor
            (times
                (power two n)
                (successor (times two m)))
~~~


We use the function `compress` to do the basic encoding of lambda terms.

~~~haskell
    var i :=
            -- Encoding of xj where i is the Church numeral
            -- representing the index j.
        compress zero i

    app enca encb :=
            -- Encoding of the lambda term a b, where
            -- enca and encb are the encodings of a and b.
        compress one (compress enca encb)

    lam i enca :=
            -- Encoding of (\xj := a) where i is the Church
            -- numeral representing the index j and enca is
            -- the Church numeral representing the lambda term a.
        compress two (compress i enca)
~~~

The first argument is the Church numeral for the numbers 0, 1, or 2 depending
whether the lambda term is a variable, an application or an abstraction. This
shows that the encoding is not onto. The Church numerals for the numbers 3, 4,
... are never used in the top level compress functions. I.e. there are Church
numerals which do not encode a lambda term. But this is not a problem, because
we only require that the encoding is one-to-one, i.e. that there are never two
lambda terms which have the same encoding.

We still have to define the function `wrap` which given the encoding of a lambda
term returns the encoding of the encoding of the the lambda term. In order to
achieve that we first encode `zero` and `successor` and then use these encodings
to define `wrap`.


Remember the definition of `zero` and `successor`.

~~~
    zero := (\ f s := s)

    successor := (\n f s := f (n f s))
~~~

These functions have the bound variables `s`, `f` and `n`. But formally we have
only the variables `x0`, `x1`,  `x2`, ... We use here the convention to number
the bound variables *inside-out*, i.e. the innermost bound variable gets the
name `x0`, the next outer variable gets the name `x1` and so on. Since the names
of bound variables are arbitrary as long as they don't interfere with the
outside world, this choice is as good as any other choice.


The encoding of the lambda term `zero` is a straightforward application of the
basic encoding functions.

~~~
    zero := (\ x1 x0 := x0)

    enc_zero :=
        lam one (lam zero (var zero))
~~~



The encoding of the successor function looks a little bit more complicated. But
no magic is involved. Just a systematic use of the basic encoding functions
`var`, `app` and `lam`.


~~~haskell
    successor := (\x2 x1 x0 := x1 (x2 x1 x0))

    enc_successor :=
        lam two (lam one (lam zero enc)) where
            enc :=
                app
                    (var one)
                    (app (app (var two) (var one)) (var zero))
~~~

Having an encoding of `zero` and `successor`, the definition of `wrap` is easy.

~~~haskell
    wrap enca :=
            -- Given the encoding enca of a lambda term a,
            -- compute the encoding of the encoding of a.
        enca (app enc_successor) enc_zero
~~~

Note that the argument `enca` is the encoding of some lambda term. Therefore it
is a Church numeral. Church numerals can be used to iterate the application of
the encoding of the successor function `enca` times to get an encoding of
`enca` which is an encoding of the encoding of the corresponding lambda term.

You see: Encoding of lambda terms as Church numerals is not difficult. It is
only necessary to be careful in distinguishing lambda terms and their encodings
properly.










Undecidability
==============


This chapter proves some undecidability theorems. In order to do this we have to
encode lambda terms. From the previous chapter we need only two facts.

1. There is a unique encoding of lambda terms which maps a lambda term `a` into
   its encoding `<a>`. The encoding is unique in the sense that different lambda
   terms never have the same enconding, i.e. the encoding is one-to-one.

2. There is a lambda term `self` which maps the encoding `<a>` of the lambda
   term `a` into the lambda term `< a <a> >` which represents the encoding of
   the lambda term `a` applied to its own encoding `<a>`.

Nothing more is needed in the proofs.

In the proofs we work with set of lambda terms.

Definition: Non-trivial set

> We say a set `A` of lambda terms is *non-trivial* if it is neither empty nor
> contains all possible lambda terms.

I.e. for each non-trivial set of lambda terms there is always a lambda term `m0`
which is in the set and a lambda term `m1` which is not in the set.


Definition: Closed set

> We say a set `A` of lambda terms is *closed* if it contains with each lambda
> term `a` all lambda terms which are alpha or beta equivalent to the term.



Definition: Decider

> We say a lambda term `p` is a decider for a set of lambda terms `A` if for any
> term `a` the application `p <a>` either returns `true` or `false`
> depending on the fact whether `a` is in `A` or `a` is not in `A`.




Basic Undecidability
--------------------

Theorem: *Any set `A` of lambda terms which is non-trivial and closed does not
have a decider.*

We prove this theorem by assuming that it is decidable i.e. that there is a
decider `p` for the set `A` and derive a contradiction from the assumption.

Since the set `A` is nontrivial there is term `m0` which is in the set and a
term `m1` which is not in the set.

Using `p`, `self`, `m0` and `m1` we define the term `g`

~~~
    g := (\ x := p (self x) m1 m0)
~~~

Let's see what happens if we apply `g` to the description of a lambda term `a`.

~~~
    g <a>   ~>  p (self <a>) m1 m0
            ~>  p (<a <a>>) m1 m0

            ~>  m1,             if a <a> is in A
            ~>  m0,             if a <a> is not in A
~~~

The whole thing gets more interesting if we apply `g` to its own description. We
have to distinguish the cases that `g <g>` is in `A` and `g <g>` is not in `A`:


`g <g>` is in `A`:

~~~
    g <g>   ~>  p (self <g>) m1 m0
            ~>  p (<g <g>>) m1 m0
            ~>  true m1 m0
            ~>  m1
~~~

`g <g>` and `m1` are betaequivalent. However this would require that `m1` is in
`A` by the closedness of `A` and contradicts the assumption that `m1` is not in
`A`.


`g <g>` is not in `A`:

~~~
    g <g>   ~>  p (self <g>) m1 m0
            ~>  p (<g <g>>) m1 m0
            ~>  false m1 m0
            ~>  m0
~~~

`m0` and `g <g>` are betaequivalent. This would require that `g <g>` is in `A` by
the closedness of `A` and contradicts the assumuption that `g <g>` is not in
`A`.

Conclusion: The assumption that there exists a decider `p` for the terms in `A`
leads to a contradiction. Therefore such a decider cannot exist.

Note how the application of the term `g` to its own description `<g>` and the
existence of a decider `p` are essential to prove the contradiction.










Undecidability of Beta Equivalence
----------------------------------



Theorem: *It is undecidable if two arbitrary lambda terms `a` and `b` are beta
equivalent.*

We proof this theorem by contradiction assuming that there is a lambda term `q`
such that `q <a> <b>` returns `true`, if `a` and `b` are beta equivalent and
otherwise `false`.

1. We form the set `A` which contains `a`  and all beta (or alpha) equivalent
   terms. Therefore `A` is closed by definition.

2. `A` is nonempty, because it contains at least the term `a`.

3. `A` cannot contain all lambda terms for the following reasons:

    1. If `a` is normalizing, then any term which does not reduce to a normal
       form cannot be contained in `A`. There are terms which do not reduce to a
       normal form (e.g. `(\x := x x)(\x := x x)`).

    2. If `a` does not reduce to a normal form, then any term in normal form
       cannot be in `A`. There are terms in normal form (e.g. `\ x := x`).

4. `A` is nontrivial.

5. Because `A` is closed and non-trivial there cannot be a decider for `A`.

6. Since `q <a>` is a decider for `A` we get a contradiction.

Therefore the assumption that a decider `q` exists must be false.







Undecidability of the Halting Problem
-------------------------------------

Theorem: *It is undecidable if an arbitrary lambda term `a` reduces to a normal
form.*

We prove this theorem by contradiction assuming that there is a lambda term `q`
such that `q <a>` returns `true`, if `a` reduces to a normal form and otherwise
`false`.

1. We form the set `A` which contains all lambda terms which reduce to a normal
   form.

2. `A` is certainly closed because it contains all normal forms and all terms
   which reduce to a normal form i.e. all terms which are alpha or beta
   equivalent.

3. `A` is certainly nontrivial, because there are terms which are in normal form
   (e.g. all variables) and are therefore in the set and because there are terms
   which do not have a normal form and are therefore not in `A`.

4. `q` would be a decider for `A`.

Since a non-trival closed set cannot have a decider, the existence that a term
like `q` exists leads to a contradiction and therefore must be false.


















<!-- Links -->

[home]: https://hbr.github.io
[up]: ../index.html
[lambda-intro]: ../lambda2/lambda.html
