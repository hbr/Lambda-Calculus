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

We want the step function `f` having access to the predecessor value and the
predecessor result and compute a new result.

We can reach this goal if we do the iteration with the pair `(predecessor value,
predecessor result)` and finally extract the second component from the pair.

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
    (0, result for 0)
    (1, result for 1)
    (2, result for 2)
    ....
    (n, result for n)
```
where at the end we extract the second component from the pair.


The following function does exactly that

```haskell
nat-rec (n: Natural)
        (f: Natural -> A -> A)
        (s: A):
        A
:=
    second (n step start) where
        start :=
            (zero, start)
        step p :=
            p (\ pred res :=
                    (pred + one, f pred res))
```
Note how the `step` function has two components. The first component just
increments the iteration counter and the second component uses the function `f`
to compute from the iteration counter and the result of the previous iteration
the result of the current iteration.

Having such a generic recursor, the encoding of the predecessor function is just
a piece of cake.
```
predecessor n :=
    nat-rec n (\ pred _ := pred) zero

```

Based on `predecessor` we can encode the predicate `isOne`
```
isOne n :=
    isZero (predecessor n)
```
and the difference between two natural numbers
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
        (\ pred res := (pred + one) * res)
        one
```







## Bounded Search, Division and Prime Numbers


```haskell
least-below (n: Natural) (p: Natural -> Boolean): Natural :=
        -- Least number 'i' below 'n' satisfying 'p i'
        -- or 'n' if there is no such number.
    nat-rec n f zero where
        f pred res := p res res (res + one)
```

```haskell
exist-below (n: Natural) (p: Natural -> Boolean): Boolean :=
        -- Is there a number 'i' below 'n' satisfying 'p i'?
    least-below n p < n
```


```haskell
all-below (n: Natural) (p: Natural -> Boolean): Boolean :=
        -- Are all numbers 'i' below 'n' satsifying 'p i'?
    not
        (exist-below
            n
            (\ x := not (p x)))
```


```
(/) a b :=
    least-below
        a
        (\ x :=
            a < b * (x + one))
```

```
divides a b :=
    not (isZero a)
    and
    equal (b / a * a) b
```

```
isPrime n :=
    not (isZero n) and not (isOne n)
    and
    all-below
        n
        (\ x :=
            isZero x or isOne x or
            not (divides x n))
```

If $z$ is a prime number then there is another prime number between $z+1$ and
$z! + 1$.
$$
    p_0 p_1 \ldots p_i + 1
$$

```haskell
nth-prime n :=
    n f two where
        f p_i :=
                -- p_i is the 'i'th prime
            least-below
                (factorial p_i + two)
                (\ x := p_i < x and isPrime x)
```


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




## Unbounded Search

```
U x y := y (x x y)


U U f   ~>  f (U U f)


U U f a ~>  f (U U f) a
              \-----/
                 |
              continuation

```



```
                 /   i,              if p i
                |
step k i    ~>  |
                |
                 \   k (i + 1),      if not (p i)
```


```
step k i :=
    p i i (k (i plus one))
```


```
U U step i

~>  step (U U step) i

    ~>  i                       -- if p i

    ~>  (U U step) (i + one)    -- if not (p i)
```



```haskell
search-least (p: Natural -> Boolean): Natural :=
    U U step zero where
        U x y :=
            y (x x y)
        step k i :=
                -- invariant: all numbers below `i` do not
                -- satisfy `p i`.
            p i i (k (i plus one)
```
