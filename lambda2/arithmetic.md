# Arithmetic

## Church Numerals

We want to encode the natural numbers `0, 1, 2, ...` in lambda calculus. Since
lambda calculus only has functions, we have to figure out a way to encode
numbers as functions.

What can we do with a number `n`? We can do something `n` times. And what can
lambda calculus do? Correct answer: **Function application**.

Therefore we encode a natural number as a function which takes a function
argument and a start value and iterates the function `n` times on the start
value.

This is called the *Church encoding* of numbers and the encoded numbers are
called *Church numerals*.



So we encode the number zero as
```
zero f s := s
```


The successor function just takes a church numeral and applies the function one
more time.
```
successor n :=
    \ f s := f (n f s)
```

We can use the combinators `zero` and `successor` to generate arbitrary church
numerals.
```
one := successor zero

two := successor one

...
```



Let's check, if the definition really behaves as expected.

```haskell
one

=   successor zero              -- definition 'one'

=   \ f s := f (zero f s)       -- definition 'successor'

~>  \ f s := f s                -- apply 'zero' to 'f' and 's'
```

I.e. we see that `one` really applies the function `f` once on the start value
`s`.

Let's do the same for `two`.

```haskell
two

=   successor one               -- definition 'two'

=   \ f s := f (one f s)        -- definition 'successor'

~>  \ f s := f (f s)            -- see previous derivation
```

So we see the function `f` applied 2 times on the start value `s`.






## Simple Arithmetics

Church numerals are iterations. We can use that to do simple arithmetics. To add
the numbers `n` and `m` which are represented as church numerals we simply apply
the successor function `n` times with start value `m`.


```
(+) n m :=
    n successor m
```

Multiplication of the numbers `n` and `m` is defined as `n` times the iterated
addition of `m` on the number `zero`.


```
(*) n m :=
    n ((+) m) zero
```

The exponentiation `n ^ m` is defined as `n * n * .... * n * one`, i.e. it is an
`m` times iterated multiplication. There is no problem to define exponentiation
in lambda calculus

```
(^) n m :=
    m ((*) n) one

```


## Simple Predicates

A predicate is a function returing a boolean value. Predicates are *deciders*.
We want to be able to decide, if a number is zero, is an even number or is an
odd number.

The encoding of the predicate `isZero` as an iteration is surprisingly simple.
Evidently the start value of the iteration is `true`, because the number `zero`
is zero. The iteration function just ignores the result of the previous
iterations and returns `false`.

```
isZero n :=
    n (\ _ := false) true
```


The evenness and oddness predicates can be represented as iterations as well.
The start value for `isEven` is `true` and the start value for `isOdd` is false
to return the correct value for the number zero.

On each iteration step we toggle the truth value of the result by using the
function `not`.


```
isEven n :=
    n not true

isOdd n :=
    n not false
```






## Recursion

Up to now all functions on church numerals have used iterations. This technique
has its limits. Assume you want to write the predecessor function which returns
zero for zero (since zero has no predecessor) and the actual predecessor for any
other number. Trying iteration our function looks like
```
predecessor n :=
    n (\ x := ?) zero
```

The start value is clear. According to the definition it has to be `zero`. But
how to design the step function? The task of the step function is to map the
predecessor of the predecessor into the predecessor of the current number. In
nearly all cases adding one does the job. But it fails for the number one, since
the predecesssor of `zero` is `zero` we would compute `one` as the predecessor
of `one` which is wrong.

Alonzo Church, the inventor of the lambda calculus, had been puzzled to find a
proper definition of the predecessor function. A difficult situation when
you want to define a calculus where all computable functions can be encoded and
the calculus fails on such a simple task as to compute the predecessor of a
natural number.

One of his phd students, the mathematician Stephen Kleene (pronounced Klay-nee),
came up with a solution which not only let us encode the predecessor function,
but also a lot of other complex functions.

The problem with iteration: The step function has only access to the function
result of the function called on the predecessor argument, but not to the value
of the predecessor itself. The iteration *consumes* the numbers. This is clear
if we look at the type signatures of the start value `s` and the iteration
function `f`.

```
s: A

f: A -> A
```

`s` has a value of some type `A` and the iteration function `f` maps step by
step the value into its final result value. What we want is the following
types:

```
s: A

f: Natural -> A -> A
```

We want the step function `f` having access to an iteration counter and the
result of the overall function for this iteration counter. The function `f` then
computes the result of the next iteration.

We can reach this goal if we do the iteration with the pair `(iteration
counter, result) and finally extract the second component of the pair.

For the predecessor function trying to compute the predecessor of a number n we
would expect the following sequence of pairs

```
    (0, 0)
    (1, 0)
    (2, 1)
    ....
    (n, n-1)
```
or more generally
```
    (0, result for iteration 0)
    (1, result for iteration 1)
    (2, result for iteration 2)
    ....
    (n, result for iteration n)
```
where at the end we extract the second component of the pair.


The following function does exactly that

```haskell
nat-rec (n: Natural)
        (f: Natural -> A -> A)
        (s: A):
        A
:=
    second (n step (zero, s)) where
        step p :=
            p (\ i res :=
                    (i + one, f i res))
```
Note how the `step` function has two components. The first component just
increments the iteration counter and the second component uses the function `f`
to compute from the iteration counter and the result of the previous iteration
the result of the current iteration.

Having such a generic recursor, the encoding of the predecessor function is just
a piece of cake.
```
predecessor n :=
    nat-rec n (\ i _ := i) zero

```
`predezessor zero` is `zero` because of the start value `zero`. `predecessor
one` is `zero` because the iteration counter is `zero`. `predecessor n`
receives at the last iteration the iteration counter `n - 1` which is exactly
the required result. The iteration function `f` just used the iteration counter
to compute the next result and ignores the result of the previous iteration.


Based on the function `predecessor` we can encode the difference between two
natural numbers
```
(-) n m :=
    m predeccessor n
```


Coding of comparison functions is now easy.
```
(<=) n m :=
    isZero (n - m)
```


```
(<) n m :=
    successor n <= m
```

```
equal n m :=
    n <= m and m <= n
```


Even the factorial function computing $1\times 2\times 3\times ...\times n$ is
now possible which uses the recursive definition
$$
\begin{array}{lll}
0! &=& 1
\\
n! &=& n * (n-1)! \quad\text{for } 0 < n
\end{array}
$$

```
factorial n :=
    nat-rec
        n
        (\ i res := res * (i + one))
        one
```

It might not be immediately obvious that `factorial` really does the right
thing. In order to be sure, the following table shows the computation steps for
different arguments.

 argument       computation
----------      -------------
    0           1
    1           1 * 1
    2           1 * 1 * 2
    3           1 * 1 * 2 * 3
----------      -------------






## Searching with Predicates



### Bounded Search


It is a standard task to find a number `i` which satisfies a certain predicate
`p`. We want to write a function which finds the smallest number below a certain
bound which satisfies the predicate. In case that no number below the bound
satisfies the number, the function should return the bound.

The result cannot be computed by simple iteration, we need the recursor
`nat-rec`. The recursor gives to the step function always the iteration counter
`i` of the previous step and the result `res` of the previous step.

We want the recursor to maintain the invariant that all numbers below the
previous result do not satisfy the predicate i.e. to maintain

    for all j: j < res => not (p j)

It is easy to find a start value for `res` which satisfies the invariant. Just
use `zero`, because there is no number below 0 and therefore all numbers below 0
do not satisfy `p`.

As long as `res` does not satisfy `p`, we increment `res` by one.

As soon as we encounter the first value of `res` which satisfies `p res` we have
encountered the smallest number and therefore we do not change the value of
`res` anymore.

With this preparation, it is easy to write the function `least-below` and
convince ourself that the implementation is correct.

```haskell
least-below (n: Natural) (p: Natural -> Boolean): Natural :=
        -- Least number 'i' below 'n' satisfying 'p i'
        -- or 'n' if there is no such number.
    n (\ res := p res res (res + one)) zero
        -- maintain the invariant: all numbers below
        -- 'res' do not satisfy 'p'.
```
The expression `p res` checks if `res` satisfies the predicate. If the answer is
`true`, then the value `res` is kept for the next iteration. If the answer is
`false`, then the value of `res` is incremented. If no number below `n`
satisfies the predicate `p`, then the value `zero` is incremented `n` times,
i.e. `n` is returned as the final result.

Next we want to implement an existential quantifier with an upper bound.

If we find a number below the bound which satisfies a certain predicate, we know
that at least one number below the bound exists, which satisfies the predicate.
The existential quantifier with an upper bound can be implemented by looking at
the result of `least-below` and comparing it with the bound.

```haskell
exist-below (n: Natural) (p: Natural -> Boolean): Boolean :=
        -- Is there a number 'i' below 'n' satisfying 'p i'?
    least-below n p < n
```


If there exists no number below a bound which does not satisfy a certain
predicate, then all numbers below the bound satisfy the predicate. Therefore
implementation of the universal quantifier with an upper bound is easy as well.

```haskell
all-below (n: Natural) (p: Natural -> Boolean): Boolean :=
        -- Are all numbers 'i' below 'n' satsifying 'p i'?
    not
        (exist-below
            n
            (\ x := not (p x)))
```


### Division

With these helper functions based on predicates we can implement division
functions and functions computing prime numbers.


The value of `a` divided by `b` i.e. `a / b` is the unique solution `x` of the
inequalities

    b * x <= a

    a < b * (x + 1)

Division by zero is undefined. In the case `b = 0` the second inequality is
cannot be satisfied. In that case we want the expression `a / b` to return `a`
in order to have a total function.

We can use `least-below` with upper bound `a` to find the smallest number `x`
which satisfies the second inequality. In case that no such numbers exist, we
get as expected the upper bound `a`. But are we sure that the first inequality
is satisfied?

From the reasoning above we know, that the function `least-below` maintains the
invariant for all numbers strictly below `x`

    not (a < b * (x + 1))

which is equivalent to

    b * (x + 1) <= a

and

    b * x + b <= a

which in turn implies

    b * x <= a

Therefore the first inequality is maintained by the function `least-below`.

I.e. the following implementation is correct.

```
(/) a b :=
    least-below
        a
        (\ x :=
            a < b * (x + one))
```


The function `divides a b` shall decide, if `a` divides `b` exactly i.e. if
there exist a solution `x` satisfying

    x * a = b

The number `b / a` is a good candidate for the solution `x`, because according
to its definition it satisfies

    b / a * a <= b

So we just compute `b / a * a` and compare it with `b`.

```
divides a b :=
    equal (b / a * a) b
```






### Prime Numbers

Prime numbers are very important in number theory and cryptography. In this
section we show the implementation of some important prime number functions.

A prime number is a natural number greater than 1 which is only divisible
by 1 and itself.

If we reformulate the definition a little bit, we can implement it and get a
prime number tester in lambda calculus.

```
isPrime n :=
    one < n
    and
    all-below
        n
        (\ x :=
            x <= one
            or
            not (divides x n))
```


If we want to compute the `n`th prime number, we have to think a little bit.

We know that `two` is the first prime number.

If we have the `i`th prime number `pi`, we get the next prime number by finding
the smallest number `x` strictly above `pi` which satisfies `isPrime x`. In
order to use the function `least-below` we need an upper bound for the search.

Let's find an upper bound for the next prime number above `pi`. We form the
product `z = p0 * p1 * ... * pi` of all prime numbers below `pi` including `pi`.
Certainly none of these prime numbers divides `z + 1` because each division
leaves the remainder 1. Therefore `z + 1` is either a prime number or there
exists a prime number different from the prime numbers in the product dividing
`z + 1`. Therefore `z + 2` is a strict upper bound for the next prime number.

Next we observe that `z <= factorial pi` is valid, because the factorial is the
product of more numbers than `z`. Therefore `factorial pi + 2` is a strict upper
bound for the next prime number above `pi`.

Now the implementation is straightforward.
```haskell
nth-prime n :=
    n f two where
        f p_i :=
                -- p_i is the 'i'th prime
            least-below
                (factorial p_i + two)
                (\ x := p_i < x and isPrime x)
```

>   Note that the above reasoning to find an upper bound for the next prime
>   number is the reasoning which has been used by Euclid to
>   prove that there are infinitely many prime numbers.



From number theory we know that every natural number above zero has a unique
prime number factorisation. I.e. each positive number `n` can be written as the
infinite product

    n = p0 ^ e0 * p1 ^ e1 * p2 ^ e2 * ...

where `pi` is the `i`th prime number and `ei` is the corresponding exponent. For
`n = 1` all exponents are 0.

We want to have a function which computes for all numbers `n` the exponent `ei`
of the `i`th prime number.

For each pair `(pi,ei)`

    divides (pi ^ k) n

is valid for all `k <= ei` and

    divides (pi ^ (ei + 1)) n

is invalid.

Therefore we can find the exponent by a search for the least number which does
not satisfy the last proposition.

The upper bound for the search is easy to find. Since all prime numbers are
greater than 1, all exponents are lower than `n`.

```haskell
prime-exponent i n :=
        -- Exponent of the 'i'th prime number in 'n'
    least-below
        n
        (\ x :=
            not (divides
                    ((nth-prime i) ^ (x + one))
                    n))
```

The prime factorization for the number 0 is not defined. However the function
`prime-exponent i zero` returns `zero`. This is no problem. We have just
assigned an arbitrary result to the function for arguments, where it is
mathematically undefined. For all other arguments the function returns the
correct exponent.








## Unbounded Search


If we have a predicate `p: Natural -> Boolean` and know that there exists a
number which satifies the predicate, then we can find the least number by an
unbounded search. In traditional programming languages we would use a while-loop
which has the continuation condition `not (p i)` and which increments in the
body of the loop the number by one until the continuation condition is violated.


In lambda calculus we don't have while loops. Therefore we have to find a way to
do the search with functions.

We would like to write the function in the following form

```haskell
search-least (p: Natural -> Boolean): Natural :=
    iterate step zero where
        step := ?
        iterate := ?
```
which iterates a step function as long as needed starting with `zero` and
maintaining the invariant, that all numbers below the current number do not
satisfy the predicate.


The function `step` needs as an argument the current number to check. We could
try the following.
```
step i :=
    p i i ?
```

If the term `p i` returns true, then `p i i ?` returns the value `i` which
satisfies the predicate. But we don't know what to return in case that `i` does
not satisfy the predicate. If we had recursive functions in lambda calculus
we would just replace the question mark with `step (i + one)`. Unfortunately
this is not a valid lambda term.

But we can give the step function another argument, which is a continuation
(traditionally called `k`) knowing how to do the rest of the computation.

```
step k i :=
    p i i (k (i + one))
```

Now the rest of the difficulty remains on the unkwnown term `iterate`. We just
know that this term has to do some kind of *self replication* to implement the
loop. In the chapter *Basics of Lambda Caluculus* we have already encountered a
combinator `U` which does some kind of replication.

```
U x y := y (x x y)
```

The combinator `U` expects two arguments and returns a term which contains both
arguments twice. It is interesting to see what happens, if we evaluate `U U
step i`. We get

```
U U step i    ~>  step (U U step) i
```

I.e. `U U step i` calls `step` with `U U step` as first argument and `i` as
second argument. Now `step` is in the function position and has control of what
to do next. The function `step` evaluates `p i`. If the result is `true` then it
returns `i` and the iteration terminates. If `p i` evaluates to `false` then it
returns `(U U step) (i + one)` and the iteration can continue.

The iteration is started with `U U step zero` i.e. we can use `U U` as
`iterate` and we are ready.

We see, that we have implemented an iteration which stops, as soon as a number
is encountered which satisfies the predicate. The complete function reads

```haskell
search-least (p: Natural -> Boolean): Natural :=
    U U step zero where
        step k i :=
                -- invariant: all numbers below `i` do not
                -- satisfy `p i`.
            p i i (k (i + one)
        U x y :=
            y (x x y)
```

It might be necessary to read this section twice or more to understand the
tricky mechanism to implement the unbounded search. But it is possible.

However I admire the genious, who invented it. I would have never found such a
cleverly constructed lambda term by myself.

Some remarks:

+ All functions constructed before this section on unbounded search are strongly
  normalizing (provided that their arguments are of the proper kind). The
  function `search-least` is only weakly normalizing (provided that a number
  exists which satisfies the predicate, otherwise it is diverging).

  I.e. there are only some reduction sequences, which terminate with the desired
  result. But there are other reductions sequences which are infinite. The
  subterm `U U step` has an infinite reduction sequence, because it reduces to
  `step (U U step)` which contains itself as a subterm.

  However there are reduction strategies, which find for all weakly normalizing
  terms a reduction path which terminates.

+ As long as you remain in constructive mathematics, you don't need unbounded
  search. Unbounded search needs a guarantee, that a number satisfying the
  predicate exists. In constructive mathematics an existence proof requires a
  construction of an object which satisfies the condition. But if you have a
  construction of such an object, you can use it as an upper bound and use
  `least-below` to find the smallest number satisfying the predicate.


+ The availability of unbounded search makes lambda calculus as expressive as
  general recursive functions. The class of general recursive functions consists
  of the constant zero, the successor function, all projections (`K` and `KI`
  cover the special case with two arguments, but the generalization to more
  argumentes is obvious) and are closed under primitive recursion (`nat-rec`)
  and minimization (*unbounded search*).

  There are many definitions of computable functions. E.g.

    - Recursive functions

    - Turing machines

    - Lambda calculus

  Fortunately it can be proved that they are all equivalent i.e. they define the
  same class of functions.
