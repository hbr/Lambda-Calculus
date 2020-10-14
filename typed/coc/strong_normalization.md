Basics
=========

~~~haskell
    t   ::= s                   -- sort (either '*' or '<>')
        |   x                   -- variable
        |   (a b)               -- application
        |   (\ (x: A) := e)     -- abstraction
        |   (all (x: A): B)     -- dependent product
~~~


Typing relation:

~~~
    Gamma |- t : T
~~~

means that in context `Gamma` the term `t` has type `T`.




~~~
    Axiom:

    [] |- * : <>
~~~



~~~
    Variable:

    Gamma |- A : *
    x not in Gamma
    ----------------------
    Gamma, (x:A) |- x : A
~~~



~~~
    Weaken:

    Gamma |- t : T
    Gamma |- A : *
    x not in Gamma
    ----------------------
    Gamma, (x:A) |- t : T
~~~



~~~
    Product:

    Gamma |- A : s1
    Gamma, (x:A) |- B : s2
    ----------------------
    Gamma |- (all (x: A): B): s2
~~~



~~~
    Abstraction:

    Gamma, (x:A) |- e : B
    -----------------------------------------
    Gamma |- (\ (x: A) := e): (all (x: A): B)
~~~



~~~
    Application:

    Gamma |- f : (all (x: A): B)
    Gamma |- a : A
    ----------------------
    Gamma |- f a : B[x:=a]
~~~



~~~
    Conversion:

    Gamma |- t : T
    Gamma |- U : s
    T ~> U   or   U ~>  T
    ----------------------
    Gamma |- t : U
~~~



Strong Normalization
====================


Lambda Function Space
---------------------

Let `A` and `B` be set of strongly normalizing lambda terms. We define the
lambda function space between `A` and `B` as the set of lambda terms

~~~
    [A -> B] :=
        {f: f a in B for all a in A}
~~~

Theorem: *All elements of `[A -> B]` are strongly normalizing as long as the
elements of `A` and `B` are strongly normalizing:*

Proof:

Let `f` be an element of `[A -> B]`.

Then by definition of `[A -> B]` the term `f a` must be in `B` for all `a` in
`A`.

Since `A` is saturated, it is not empty.  Therefore there is at least one `f
a` which is in `B`.

Since all elements of `B` are strongly normalizing, the term `f a` is strongly
normalizing.

Since all subterms of a strongly normalizing term are strongly normalizing,
we can conclude that `f` is strongly normalizing.





Saturated Set
-------------

Definition: *A base term is a term of the form `x t1 t2 ... tn` where `x` is a
variable and `t1`, `t2`, ... `tn` are strongly normalizing terms. `n` can be
zero.*


Definition: *A set `S` of terms is saturated if the following conditions are
satisfied:*

- All terms in `S` are strongly normalizing

- `S` contains all base terms

- For all `b` in `S`, `a` is in `SN` and `key-reduce a = b`, then `a` is in
  `S` as well.

The last two conditions are *closure conditions*.


Definition: `SAT` is the set of all saturated sets.


We can saturate a set `S` of strongly normalizing terms.

~~~
    saturate S :=
        least superset of S which contains all base terms and is closed
        under key expansion
~~~

The function `saturate` is a closure operator i.e. it is monotonic, increasing
and idempotent. Therefore the set of all saturated sets `SAT` forms a complete
lattice which has the nice property that arbitrary intersections of saturated
sets are saturated.


Theorem: *If `A` and `B` are saturated sets, then `[A -> B]` is saturated as
well.*

Proof: We have to show that `[A -> B]` satisfies the 3 conditions required to be
saturated set.

1. All elements of `[A -> B]` are strongly normalizing:

   As has been proved above are all elements of `[A -> B]` strongly normalizing
   as long as all elements of `A` and `B` are strongly normalizing.

   Since `A` and `B` are saturated, all their elements are strongly normalizing
   by definition.

2. All base terms must be in `[A -> B]`:

   Remember that a base term has the form `x t1 t2 ... tn` where `x` is a
   variable and `t1`, `t2`, ... are strongly normalizing and `n` can be zero.

   Let `a` be a term of `A`. Then `x t1 t2 ... tn a` is in `B`, because `B`
   contains all base terms.

   Then the term `x t1 t2 ... tn` is in `[A -> B]` by definition of `[A -> B]`.

   Therefore all base terms are in `[A -> B]`.

3. `[A -> B]` must be closed under key expansion:

   Let `e t1 t2 ... tn` be in `[A -> B]`. By definition `e t1 t2 ... tn a` is in
   `B` for all `a` in `A`. Since `A` is not empty there exists an `e t1 t2 ...
   tn a` in `B` for some `a` in `A`.

   Therefore `r t1 t2 ... tn a` is in `B` where `r` is a strongly normalizing
   redex reducing to `e`. Reason: `B` is saturated and therefore closed under
   key expansion.

   By definition of `[A -> B]` the term `r t1 t2 ... tn` is in `[A -> B]`.

   This proves that `[A -> B]` is closed under key expansion.


Summary: The set of saturated sets is closed under forming of arbitrary
intersections and under forming of lambda function spaces.



Kinds
-----

Definition: A *syntactic kind* is a term of one of the forms


~~~
    *

    all (x: A) (y: B) ... : *
~~~

i.e. a kind `K` is a term described by the grammar

~~~
    K   ::=     *
        |       all (x: A): K
~~~

where `K` ranges over kinds, `x` ranges over variables and `A` is an arbitrary
term.


For any term it can be decided by inspection if it is a syntactical kind. From
the definition we see that `K` being a kind implies that `all (x: A): K` is a
kind as well.

In the calculus of constructions it is not possible, that a term reduces to a
kind unless it had been a kind before the reduction. We prove this claim by
showing that all valid syntactical kinds have the type `<>` and all terms of
type `<>` are syntactical kinds.

Both subclaims are sufficient because of the subject reduction property which
states that a reduction does not change its type. So assume that `A ~> K` and
`K` is a kind which has type `<>`. Then by the subject reduction property `A`
must have the same type. This requires that `A` is a syntactical kind if both
subclaims are valid.

It remains to prove the two subclaims.

Theorem: *All valid syntactic kinds `K` have type `<>`*

Proof:

1. `K = *`: Trivial, because `*` has the type `<>`.

2. `K = (all (x: A): B)` and `B` is a kind:

   Since `B` is a kind it has the type `<>`. The product rule states that the
   type of `all (x: A): B` is the type of `B`.




Theorem: *`Gamma |- A: <>` implies that `A` is a syntactical kind.*

Proof by induction on `Gamma |- A: <>`:

- Axiom: `[] |- * : <>`

  Trivial, `*` is a syntactical kind.


- Variable rule: `Gamma |- A : *` implies `Gamma, (x:A) |- x : A`

  This case is not possible, because `A` cannot be `<>`. If it were, it would
  require `Gamma |- <> : *` to be valid which cannot be the case.



- Weaken: `Gamma |- t : T` and `Gamma |- A : *` implies `Gamma, (x:A) |- t : T`

  If `T` is `<>`, then the induction hypothesis already states that `t` is a
  kind.



- Product: `Gamma |- A : s1` and `Gamma, (x:A) |- B : s2` implies `Gamma |- (all
  (x: A): B): s2`

  If `s2 = <>` then the second induction hypothesis states that `B` is a kind.
  This implies that `all (x: A): B` is a kind as well.



- Abstraction: `Gamma |- (all (x: A): B): s` and `Gamma, (x:A) |- e: B` imply
  `Gamma |- (\ (x: A) := e): (all (x: A): B)`

  This case is impossible, because `all (x: A): B` cannot be `<>`.


- Application: `Gamma |- f: all (x: A): B` and `Gamma |- a: A` imply `Gamma |- f
  a: B[x:=a]`

  There are 2 possibilities for `B[x:=a]` is equal to `<>`:

  - `B = <>`: This leads to a contradiction, because the term `all (x: A): <>`
    which is the type of `f` is illegal.

  - `B = x` and `a = <>`: This leads to a contradiction as well, because `Gamma
    |- <> : A` is an invalid typing judgement.


- Conversion: `Gamma |- t : T` and `Gamma |- U: s` and `(T ~> U or U ~> T)`
  imply `Gamma |- t: U`

  This case is impossible because `Gamma |- <>: s` is not a valid typing
  judgement.






Models for a Context
--------------------


A model set is either the set of saturated sets or a function from one model set
to another.

~~~
    ModelSet * :=
        SAT

    ModelSet (all (x: A): B) :=
        {f: ModelSet A -> ModelSet B}, if A is a kind

    ModelSet (all (x: A): B) :=
        ModelSet B,   if A is not a kind
~~~

For each kind, we can define a canonical model

~~~
    canonical-model * :=
        SN

    canonical-model (all (x: A): B) :=
        \ _ := canonical-model B,   if A is a kind

    canonical-model (all (x: A): B) :=
        canonical-model B,  if A is not a kind
~~~

The canonical model of `*` is the set strongly normalizing terms. The canonical
model of `all (x: A): B` depends on whether `A` is a syntactical kind or not. In
the first case it is a function which ignores its argument and returns the
canonical model of `B`. In the second case is the canonical model of `B`.




A model for a context attaches a model to variables.

~~~
    model = [(x1, m1), (x2, m2), ....]
~~~

A model `model` satisfies a valid context `Gamma`, written

~~~
    model |= Gamma
~~~

if it attaches to all constructor variables of the context a model of the model
set of its type (which is a kind by definition of a constructor).

Since there is a canonical model for each syntactic kind, all valid contexts
have a canonical model which satisfies it.




Models for Constructors
-----------------------



