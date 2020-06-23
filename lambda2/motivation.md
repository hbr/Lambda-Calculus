# Motivation{#sec:motivation}

Lambda calculus is a fascinating topic for the following reasons.

1. It is simple. It just consists of variables, functions and function
   applications.

2. Despite of being simple it is possible to express any computable function
   in the calculus.

   This is the reason why Alonzo Church [-@church1936] invented the lambda
   calculus. He wanted to explore the limits of computability and decidability.
   If you want to prove that something is undecidable you need a clear
   definition what you mean by *computable* or *decidable*. Lambda calculus
   is the proper tool.

3. It is fun. In lambda calculus we don't care about execution. We just express
   functions. And as you will see: We can express arbitrarily complex and
   interesting functions. No matter if their execution would last longer than
   the universe exists.

4. We can learn a lot about computation. In lambda calculus we can express
   iteration, recursion, arbitrary data structures by using only variables,
   functions and function applications.


In the following I do not expect any prior knowledge. The reader should have
some experience with programming.

All concepts are introduced step by step.

Many texts on lambda calculus use a lot of math. The goal usually is not to do
programming in lambda calculus, only to demonstrate its computational power.

In this text we use lambda calculus as a programming language. We build first
simple functions and step by step compose the simple functions to more complex
functions. At the end, the same goal is achieved: Demonstrate the expressive
power of lambda calculus. But I hope that leaving out math notation makes
the topic more accessible.
