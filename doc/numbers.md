# Numbers

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
```



Let's check, if the definition really behaves expected.

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




```haskell
nat-rec n f s :=
    second (n step start) where
        start :=
            (zero, start)
        step p :=
            p (\ pred accu :=
                    (pred + one, f pred accu))
```


```
predecessor n :=
    nat-rec n (\ pred _ := pred) zero

```


```
isOne n :=
    isZero (predecessor n)
```


```
(-) n m :=
    m predeccessor n
```

```
(<=) n m :=
    isZero (n - m)
    and
    isZero (m - n)
```


```
(<) n m :=
    successor n <= m
```

```
equal n m :=
    n <= m and m <= n
```


```
factorial n :=
    nat-rec
        n
        (\ pred res := (pred + one) * res)
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
