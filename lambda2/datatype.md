# Data Types


## Construction Principle

```
class Group A :=
    el:    A -> Group A
    unit:  Group A
    inv:   Group A -> Group A
    (<*>): Group A -> Group A -> Group A


-- expression
    inv (element 5 <*> unit) <*> element 10

-- expression tree
                  <*>
                   |
         ---------------------
         |                   |
        inv                el 10
         |
        <*>
      ---------
      |       |
    el 5     unit
```




## Church Numerals Revisited

```
class Natural :=
    zero: Natural
    succ: Natural -> Natural

-- expression
    succ (succ zero)

-- expression tree
        succ
         |
        succ
         |
        zero
```

```
Natural: (R -> R) -> R -> R
```


## Lists

```
class List A :=
    nil: List A
    cons: A -> List A -> List A

-- expression
    cons 1 (cons 2 (cons 3 nil))

-- expression tree
           cons
            |
        ---------
        |       |
        1      cons
                |
             --------
             |      |
             2     cons
                    |
                 -------
                 |      |
                 3     nil
```


```
List A: (A -> R -> R) -> R -> R

nil :=
    \ f s := s

cons head tail :=
    \ f s :=
        f head (tail f s)


length (list: List A) :=
    list (\ a res := successor res) zero

sum (list: List Natural) :=
    list (\ a res := a + res) zero

concat (a b: List A): List A :=
    a cons b


reverse (a: List A): List A :=
    a
        (\ el res := concat res (cons el nil))
        nil
```


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


## Trees

```
class Tree A :=
    leaf: A -> Tree A
    node: Tree A -> Tree A -> Tree A

-- expression
    node (node (leaf 3) (leaf 2)) (leaf 5)

-- expression tree
            node
             |
        --------------
        |            |
       node        leaf 5
        |
    -----------
    |         |
  leaf 3   leaf 2

Tree A: (R -> R -> R) -> (A -> R) -> R

leaf a :=
    \ nd lf :=
        lf a

node a b
    \ nd lf :=
        nd (a nd lf) (b nd lf)

count-nodes tree :=
    tree
        (\ size-a size-b := one + size-a + size-b)
        (\ _ := one)

flip tree :=
    tree
        (\ left right := node right left)
        leaf


to-list (tree: Tree A): List A :=
    tree
        concat
        (\ el := cons el nil)
```





