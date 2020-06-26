# Data Types

Data types are an important means to structure computations. We thing in data
types like `Boolean`, `Natural`, `List`, `Tree`, etc. In the previous chapters
we manage to repesent the types `Boolean` and `Natural` in lambda calculus.

Since lambda calculus has only functions, we have to represent objects of a
certain type as functions. We represented the type `Boolean` as a function
taking two arguments and returning one of the them depending on its boolean
value. We represented natural numbers as functions taking two arguments. The
first argument is a function and the second a start value. The natural number
iterates the function `n` times on the start value.

It is possible to define any datatype in lambda calculus. In textbooks on lambda
calculus you are many times shown that it is possible e.g. to represent lists.
It sometimes look like some rabbit has been pulled out of the hat by some magic.

But no magic and no genious is needed to find lambda representations of
datatypes. There is a construction principle which is fairly general. In this
chapter we present the construction principle and show it on some old (natural
numbers) and new (lists and trees) examples.






## Construction Principle

In order to understand the construction principle, we have to understand a
seemingly unrelated topic: Algebra.

An important example of an algebra is the concept of a *group*. A group must
have

+ a set of elements
+ a unit element (i.e. a constant)
+ a unary function which applied to an element returns its inverse
+ a binary function which let us combine elements

Apart from that it takes some properties. The unit element must be neutral with
respect to the binary operation. An element combined with its inverse is the
unit element. The binary operation is associative. However we don't need the
properties here. The operations are sufficient.

In a functional language you could define a datatype like

```haskell
class Group A :=
    el:    A -> Group A
    unit:  Group A
    inv:   Group A -> Group A
    (<*>): Group A -> Group A -> Group A
```
with three constructors for the constant, the unary and the binary operation,
and one constructor (`el`) to produce elements from some generator set
`A`.

We can use such a type to form expressions and each expression has some tree
associated with it.

```
-- expression
    inv (el 1 <*> unit) <*> el 0

-- expression tree
                  <*>
                   |
         ---------------------
         |                   |
        inv                el 0
         |
        <*>
      ---------
      |       |
    el 1     unit
```

The numbers are just a silly example for an arbitrary generator set. Usually the
set of generators is finite.

But anyhow. The possible expressions don't have any intrinsic meaning. Speaking
in terms of abstract algebra we have defined a *signature*.  A *signature* is a
set of operation symbols where each operation symbol has an arity. An operation
symbol with arity 0 is a constant.

The signature just defines a collection of wellformed expressions in that
algebra.


In order to give a meaning (i.e. semantics) to the expressions, we have to
define a function which *evaluates* the expression to a value of some type `R`
(standing for the result type).

This can be done by assigning a meaning to each operator symbol. For programming
this means that every symbol has to get type signature.

----------------------------------------
symbol          type signature
-----------     ------------------------
`el`            `A -> R`

`unit`          `R`

`inv`           `R -> R`

`<*>`           `R -> R -> R`
-----------     ------------------------

Note that `Group A` has been replaced by `R` i.e. each group expression
corrensponds to some value in its interpretation.

A lambda term representing some group expression is a function with four
arguments, one for each operation symbol. Each argument is a function (or
constant) according to the type signature. I.e. a lambda term representing a
group expression is an **evaluator** of that group expression.


It is straightforward to define the four constructors in lambda calculus.

```haskell
el (a: A): Group A :=
    \ e u i m := e a

unit: Group A :=
    \ e u i m :=
        u

inv (g: Group A): Group A :=
    \ e u i m :=
        i (g u i m)

(<*>) (g1 g2: Group A): Group A :=
    \ e u i m :=
        m (g1 e u i m) (g2 e u i m)
```

Having this we can write the expression `inv (el one <*> unit) <*> zero` in
lambda calculus.

A lambda expression of type `Group A` has the complicated looking type
```
(A -> R) -> R -> (R -> R) -> (R -> R -> R) -> R
```

But remember that we use type annotations as comments to document our
intentions. The lambda calculus described here is untyped.









## Church Numerals Revisited

Let's revisit church numerals to see how they fit into the construction
principle.

In a functional programming language we would define natural numbers as

```haskell
class Natural :=
    successor: Natural -> Natural
    zero:      Natural
```

Interpreted as an abstract algebra:

```
-- expression
    successor (successor zero)

-- expression tree
        successor
           |
        successor
           |
          zero
```

----------------------------------------
symbol          type signature
-----------     ------------------------
`successor`     `R -> R`

`zero`          `R`
-----------     ------------------------


A lambda term representing an expression of the algebra must have the type
```
(R -> R) -> R -> R
```

We get the following lambda terms for the constructors
```
zero: Natural :=
    \ f s := s

succ (n: Natural): Natural :=
    \ f s := f (n f s)

```



## Lists


Now let's apply the construction pattern to lists and look at a definition of
the list type in a functional programming language.

```haskell
class List A :=
    cons: A -> List A -> List A
    nil:  List A
```

We interpret the type definition as the definition of an algebra and look at
the expressions it generates and at corresponding expressions trees.

```
-- expression
    cons 0 (cons 1 (cons 2 nil))

-- expression tree
           cons
            |
        ---------
        |       |
        0      cons
                |
             --------
             |      |
             1     cons
                    |
                 -------
                 |      |
                 2     nil
```

The definition has two symbols `cons` and `nil` with the following type
signatures.

----------------------------------------
symbol          type signature
-----------     ------------------------
`cons`          `A -> R -> R`

`nil`           `R`
-----------     ------------------------

Therefore a lambda term of type `List A` must have the type
```haskell
(A -> R -> R) -> R -> R
```

We apply the construction principle and get the lambda terms for the
constructors.

```
nil: List A :=
    \ f s := s

cons (head: A) (tail: List A): List A :=
    \ f s :=
        f head (tail f s)
```

By applying the constructors we can form expressions to construct arbitrary
lists e.g. `cons zero (cons one (cons two nil))`. 

Each list expression is a lambda term which iterates over the list given the
folding function `f` and the start value `s` as arguments.

Some simple list functions:

```
length (list: List A) :=
    list (\ a res := res + one) zero

sum (list: List Natural) :=
    list (\ a res := a + res) zero
```


We get the concatenation of the two lists `a` and `b` by folding `cons` over the
list `a` with the start value `b`.

```
concat (a b: List A): List A :=
    a cons b
```

A list reversal is done by reversing the tail and concate the resversed tail
with the one element list of the head.
```
reverse (a: List A): List A :=
    a
        (\ head res := concat res (cons head nil))
        nil
```

If we want to compute the tail of a list we face the same problems as with the
predecessor function on church numerals. Since the empty list does not have a
tail, we accept the empty list as the tail of an empty list.

We can solve the problem in the same manner as with the church numerals. We
define a list recursor which internally not only has access to the result of the
previous iteration, but also to the previous lists. I.e. the folding function
has the type `A -> List A -> R -> R`.

Internally the recursor uses a pairs `(tail list, previous result)` starting
with `(nil, s)` and throwing away the tail list at the end of the iteration.

```haskell
list-rec (list: List A) (f: A -> List A -> R -> R) (s: R): R
:=
    second (list step start) where
        start :=
            (nil, s)
        step a p :=
            p (\ tail res :=
                (cons a tail, f a tail res))
```

Now we can define the function `tail`.

```
tail (list: List A): List A :=
    list-rec
        list
        (\ head tail res := tail)
        nil
```

In the same manner we can define a function `head`. In that case we have to
provide a default value since we cannot pull out an arbitrary list element from
an empty list.

```
head (list: List A) (default: A): A :=
    list-rec
        list
        (\ hd tl res := hd)
        default
```




## Trees

I hope that the construction principle becomes clearer and clearer. As a last
expample we show how to represent binary trees as lambda terms.

In order to keep things simple we look at binary trees which store information
only in the leaves.

A type definition of such a tree in a functional programming language looks like

```
class Tree A :=
    node: Tree A -> Tree A -> Tree A
    leaf: A -> Tree A
```

As before we look at the expressions and expression trees of the corresponding
algebra.

```
-- expression
    node (node (leaf 0) (leaf 1)) (leaf 2)

-- expression tree
            node
             |
        --------------
        |            |
       node        leaf 2
        |
    -----------
    |         |
  leaf 0   leaf 1
```


----------------------------------------
symbol          type signature
-----------     ------------------------
`node`          `R -> R -> R`

`leaf`          `A -> R`
-----------     ------------------------

A lambda term representing a tree has two arguments one representing the binary
operation on the node and one which maps the leaf information into the result
type. I.e. the type `Tree A` is represented by a lambda term having the type

```
(R -> R -> R) -> (A -> R) -> R
```


The lambda terms representing the two constructors look like.
```
leaf a :=
    \ nd lf :=
        lf a

node a b
    \ nd lf :=
        nd (a nd lf) (b nd lf)
```

With these constructors we can form tree expressions like `node (node (leaf 0)
(leaf 1)) leaf 2`.

Some simple functions on trees:

```haskell
count-nodes tree :=
        -- Count the nodes in a tree including the leaf nodes.
    tree
        (\ size-a size-b := one + size-a + size-b)
        (\ _ := one)

flip tree :=
        -- Make a mirror image of the tree.
    tree
        (\ left right := node right left)
        leaf


to-list (tree: Tree A): List A :=
        -- Transform the tree into a list of leaf values
    tree
        concat
        (\ el := cons el nil)
```


**Exercise**: Define a binary tree in lambda calculus where all information is
stored in the nodes and the leaves are empty. Implement the
functions `count-nodes`, `flip` and `to-list` for this kind of tree.



I hope that by looking at these examples it should be easy to represent any data
type which can be represented in a functional language.

This ends this introduction into programming with lambda calculus. I hope
you enjoyed it.





