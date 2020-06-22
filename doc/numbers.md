<!--[Table of Contents](toc.md)-->

# Numbers

## Church Numerals

```
zero f s := s

successor n :=
    \ f s := f (n f s)

one := successor zero

two := successor one
```

```
one

=   successor zero

=   \ f s := f (zero f s)

~>  \f s := f s


successor (successor zero)

=   \ f s := f (successor zero f s)

~>  \ f s := f (f s)

```




## Simple Arithmetics

```
(+) n m :=
    n successor m

(*) n m :=
    n ((+) m) zero

(^) n m :=
    m ((*) m) (successor zero)

```


## Simple Predicates


```
isZero n :=
    n (\ _ := false) true


isEven n :=
    n not true

isOdd n :=
    n not false
```


## Recursion

```
nat-rec n f s :=
    second (n step start) where
        start :=
            (zero, start)
        step p :=
            p (\ pred accu :=
                    (successor pred, f pred accu))
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



## Recursion with Predicates

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
$z!$.

```
nth-prime n :=
    nat-rec n f two where
        f pred res :=
                -- res is the 'pred'th prime
            least-below
                (factorial (res + one))
                (\ x := res < x and isPrime x)
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
