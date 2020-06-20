<!--
Motivation

Basics of Lambda Calculus

Church Numerals

    successor function, addition, multiplication, exponentiation, zero tester,
    Ackermann function

Primitive Recursion

    Predecessor, factorial, difference, less equal, equality test, bounded
    search, division, divides exactly, prime number tester, prime exponent, ith
    prime number, encode pairs of numbers.

General Recursion / Unbounded Search

Canonic Lambda Terms

        constant, unary operator `\`, binary operator: application

            term ::= number | t t | \t

        examples:

            \ x y := x                  \\ 1
            \ x y := y                  \\ 0

            \ x y f := f x y            \\\ 0 2 1


            \ f s := f (f (f s))        \\ 1 (1 (1 0))

Data Structures

    list, binary tree

    canonic lambda terms

        definition

            variable n :=
                \ app lam var :=
                    var n

            application term1 term2 :=
                \ app lam var :=
                    app (term1 app lam var) (term2 app lam var)

            lambda term :=
                \ app lam var :=
                    lam (term app lam var)

-->

# Identity Function

    identity x := x

    -- or in the long form
    identity :=
        \ x := x



# Boolean Values

A boolean is represented by a function taking two arguments. The boolean value
`true` returns always the first argument and the boolean value `false` returns
the second argument. I.e. boolean values represent a *decision* between the two
arguments.


    true  x y := x

    false x y := y

    and bool1 bool2 :=
            -- if 'bool1' is true, then return 'bool2'
            -- otherwise return 'false'
        bool1 bool2 false

    or bool1 bool2 :=
        bool1 true bool2


    not (b: Boolean): Boolean :=
        b false true



# Pairs

    pair x y f :=
        f x y

    first p :=
        p true

    second p :=
        p false


    first (pair x y)
    ~> (pair x y) true
    ~> true x y
    ~> x

    second (pair x y)
    ~> (pair x y) false
    ~> false x y
    ~> y


# Church Numerals


The church numeral representing the number `n` is a function taking two
arguments. The first is regards as a function which it applies `n` times to the
start value `s`.



    church0 f s := s

    church1 f s := f s

    church2 f s := f (f s)

    church3 f s := f (f (f s))

    ...


The successor function takes a number and returns another number i.e. it returns
a function having two arguments. The function applies the number to the two
arguments and then applies the first argument one more time to the result.

    successor number :=
        \ f s :=
            f (number f s)


With the successor function we can generate all church numerals starting with
`church0`.

    successor church0
    ~> \ f s := f (church0 f s)
    ~> \ f s := f s
    =  church1

    successor church1
    ~> \ f s := f (church1 f s)
    ~> \ f s := f (f s)
    = church2


Since a church numeral is a function which applies the first argument `n` times
on the second argument, it is nealy trivial to define addition. To add the two
numbers `n` and `m` we just apply the successor function `n` times to `m`.


    (+) n m :=
        n successor m


Muliplication of the numbers `n` and `m` is just adding `m` `n` times to zero.

    (*) n m :=
        n (\ x := m + x) church0



In the same way we can define exponentiation


    (^) n m :=
            -- raise `n` to the `m`th power
        m (\ x := n * x) church1


Sometimes we want to test, if a church numeral is zero or not. The function
shall return `true` for `isZero church0` and `false` for any other church
numeral. We can implement the function with the iteration feature of church
numerals. E.g. `church0 f s` always returns `s`. So `n f false` returns the
correct answer in case that `n = church0`.

For all other church numeral the function `f` is applied one or more times to
the value `false`. We know that the function should return always `false`, i.e.
ignore its argument. Therefore the following is a valid implementation of a zero
tester.

    isZero (n: Church): Bool :=
        n (\ _ := false) true



Surprisingly we can define the famous *Ackermann* function. Let's look at the
defining equations first

    ackermann 0 n             = 1 + n

    ackermann (1 + k) 0       = ackermann k 1

    ackermann (1 + k) (1 + o) = ackermann k (ackermann (1 + k) o)


First we give the definition and then we show that the definition satisfies the
defining equations



```
ackermann m n :=
    m g successor n
    where
        g f o :=
            successor o f church1
```


Proof of the first equation

    ackermann church0 n

    = church0 g successor n

    ~> successor n

In order to proof the second and third equation we first proof the lemma

    ackermann (successor k) o  ~>  g (ackermann k) o


This can be seen by the following sequence

    ackermann (successor k) o

    = (successor k) g successor o   -- definition

    ~> g (k g successor) o          -- definition of 'successor'

    = g (ackermann k) o             -- definition


Now we proof the second equation

    ackermann (successor k) church0

    ~> g (ackermann k) church0                  -- above lemma

    =  successor church0 (ackermann k) church1  -- definition of 'g'

    ~> ackermann k church1                      -- definition of 'successor'


And the third equation

    ackerman (successor k) (successor o)

    ~> g (ackermann k) (successor o)                    -- above lemma

    =  successor (successor o) (ackermann k) church1    -- definition 'g'

    ~> ackermann k (successor o (ackermann k) church1)  -- definition 'successor'

    =  ackermann k (g (ackermann k) o)                  -- definition 'g'

    <~ ackermann k (ackermann (successor k) o)          -- above lemma


It might not be easy to find that definition of the Ackermann function in lambda
calculus. And the proof that the definition satisfies the needed equations is
not trivial either.

However the definition of the Ackermann function in lambda calculus is
surprisingly simple. No recursion involved, just iterations.

It might be even more surprising if you remember why *Wilhelm Ackermann*
invented that function. His motivation was prove the existence of functions
which are computable, but not primitive recursive. This already gives a hint
that lambda calculus is much more powerful than primitive recursion.





# Primitive Recursion


    nat-recurse
        (n: Natural)
        (f: Natural -> A -> A)
        (s: A):
        A
    :=
        second (n step start) where
            start :=
                (zero, s)
            step p :=
                p (\ pred accu :=
                        (successor pred, f pred accu))

    predecessor (n: Natural): Natural :=
        nat-recurse
            n
            (\ pred _ := pred)


    (-) (n m: Natural): Natural :=
        m predecessor n


    factorial (n: Natural): Natural :=
        nat-recurse
            n
            (\ pred accu := successor pred * accu)
            (successor zero)


    lessEqual (n m: Natural): Boolean :=
        isZero (n - m)


    lessThan (n m: Natural): Boolean :=
        lessEqual (successor n) m


    equal (n m: Natural): Boolean :=
        lessEqual n m  and lessEqual m n


    least-below (n: Natural) (p: Natural -> Boolean): Natural :=
            -- The least number below 'n' satisfying 'p',
            -- or 'n' if no number below 'n' satisfies 'p'.
        nat-recurse
            n
            (\ pred accu :=
                p accu accu (successor pred))
            zero


    (/) (a b: Natural): Natural :=
            -- 'q' is the result of 'a / b', if it is the smallest
            -- number below 'a' with the property 'a < (q + 1) * b'
            -- In case 'b = 0', the algorithm returns 'a', because
            -- the property is unsatisfiable.
        least-below
            a
            (\ q := a < successor q * b)


    (|) (a b: Natural): Boolean :=
            -- 'a' divides 'b' i.e. 'a | b' is valid, if 'a' is not zero
            -- and b / a * a = b
        not (isZero a)
        and
        equal (b / a * a) b
