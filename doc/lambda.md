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



# Pairs

    pair x y f :=
        f x y

    first p :=
        p true

    second p :=
        p false


    first (pair x y)
    -> (pair x y) true
    -> true x y
    -> x

    second (pair x y)
    -> (pair x y) false
    -> false x y
    -> y


# Church Numerals and Primitive Recursion

## Basics

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
    -> \ f s := f (church0 f s)
    -> \ f s := f s
    =  church1

    successor church1
    -> \ f s := f (church1 f s)
    -> \ f s := f (f s)
    = church2


A primitive recursive function is a function taking a number and another
argument. In a conventional programming language we would write a primitive
recursive function as

    f n x :=
        if n = 0 then
            g x
        else
            h (n-1) (f (n-1) x) x

Addition would be defined as

    add n m :=
        if n = 0 then
            m
        else
            successor (add (n-1) m)

    -- where
    g m :=
        m
    h pred res m :=
        successor res


However in lambda calculus we have neither control flow nor recursive calls. We
only have function application and lambda abstraction.

We have no problems representing the function `g` and `h` needed to calculate
addition in lambda calculus. Let's see if we can define a function `prim-rec g
h` taking the two function `g` and `h` and returning the result of the
corresponding primitive recursive function.

In lambda calculus we can iterate a function `f` `n` times with the church numeral
representing the number `n` and a start value. We can represent the primitive
recursion by iteration.

Each iteration step takes the result of the previous step and the church numeral
which has done the previous iterations. I.e. the first step shall return the
lambda value

    pair (g x) church0

then we need a step function transforming the pair of the `i`th iteration into
the pair for the `(i+1)`th iteration

    step x p :=
        pair
            (h (second p) (first p) x)
            (successor (second p))

At the end of the iteration we just extract the first component which is the
result of the operation.

The whole function reads like

    prim-rec g h n x :=
        first (n (step x) start)
        where
            start :=
                pair (g x) church0
            step x p :=
                pair
                    (h (second p) (first p) x)
                    (successor (second p))

