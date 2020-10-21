Double Substitution Lemma<span id=double-substitution></span>
====

Theorem:

~~~
    x /= y
    x not in (FV b)
    -----------------------------------
    t[x:=a][y:=b] = t[y:=b][x:=a[y:=b]]
~~~

Proof by induction on the structure of `t`.

The only interesting case is when `t` a variable. If the variable is different
from `x` and `y`, then the goal is trivial, because no substitution is done.

Case `t = x`:

~~~
    x[x:=a][y:=b]       =   a[y:=b]

    x[y:=b][x:=a[y:=b]] =   a[y:=b]
~~~


Case `t = y`:

~~~
    y[x:=a][y:=b]       =   b

    y[y:=b][x:=a[y:=b]] =   b[x:=a[y:=b]]

                        =   b   because x not in (FV b)
~~~

The case `t = s` where `s` is a sort is trivial, because a sort does not have
any variables to substitute.

The other cases are easy, because substitution distributes to the subterms and
the equality of the substitution of the subterms can be derived from the
corresponding induction hypothesis.




Free Variable Lemma
====


Substitution Lemma
======

Theorem:

~~~
    Gamma |- a : A
    Gamma, (x: A), Delta |- t : T
    ---------------------------------------
    Gamma, Delta[x:=a] |- t[x:=a] : T[x:=a]
~~~

Proof by induction on `Gamma, (x: A), Delta |- t : T`.

We use the abbreviation `u' := u[x:=a]`.


#### Axiom

This case is not possible because the context is not empty.


#### Variable

*Subcase `Delta = []`:*

In that subcase we have to prove

~~~
    Gamma |- a : A
    Gamma |- A : s
    Gamma, (x:A) |- x: A
    --------------------------
    Gamma, (x:A) |- x' : A'
~~~

Since `A` cannot contain `x` the goal is `Gamma, (x:A) |- a : A` which can be
derived from the first premise by the weakening rule.


*Subcase `Delta = Delta0, (y: B)`:*

In that case we have to prove

~~~
    Gamma |- a : A
    Gamma, (x:A), Delta0 |- B : s
    Gamma, (x:A), Delta0, (y:B) |- y : B
    --------------------------------------
    Gamma, Delta0', (y:B') |- y' : B'
~~~

Firstly we know that `x` and `y` must be different and therefore that `y' = y`.

From the induction hypothesis of `Gamma, (x:A), Delta0 |- B : s` we conclude
`Gamma, Delta0' |- B' : s` and by applying the variable rule we get the desired
result.


#### Weaken


*Subcase `Delta = []`:*

We have to prove

~~~
    Gamma |- a : A
    Gamma |- t : T
    Gamma |- A : s
    Gamma, (x:A) |- t : T
    ---------------------------
    Gamma |- t' : T'
~~~

Because of `Gamma |- t : T` we know that neither `t` nor `T` can contain the
variable `x`. Therefore the goal is a trivial consequence.


#### Product


#### Abstraction


#### Application

~~~
    Gamma |- a : A
    Gamma, (x:A), Delta |- f : (all (y: C): D)
    Gamma, (x:A), Delta |- c : C
    Gamma, (x:A), Delta |- f a: D[y:=c]
    -----------------------------------------------
    Gamma, Delta' |- (f c)' : (D[y:=c])'
~~~

From the induction hypotheses we get

~~~
    Gamma, Delta' |- f' : (all (y: C'): D')
    Gamma, Delta' |- c' : C'
~~~

which by applying the application rule leads to

~~~
    Gamma, Delta' |- (f c)' : D'[y:=c']
~~~

Note that by the [Double Substitution Lemma](#double-substitution) we get

~~~
    (D[y:=c])'

    = D[y:=c][x:=a]

    = D[x:=a][y:=c[x:=a]]

    = D'[y:=c']

        when y not in (FV a)
~~~

and we are done.




#### Conversion





