---
layout: post
title: The Church-Rosser Theorem and the Consistency of Lambda Calculus
tags: [math, theory, computability, lambda calculus]
date: 2013-05-17
---

For my [Computability final paper](https://www.dropbox.com/s/u1c6pbi0qwtnjqi/The%20Consistency%20of%20Lambda%20Calculus.pdf), I wrote about the [Church-Rosser Theorem](http://en.wikipedia.org/wiki/Church%E2%80%93Rosser_theorem) and the consistency of &lambda;-calculus, as well as introducing the general theory of &lambda;-calculus and showing how arithmetic can be performed within it.

### What is the Church-Rosser Theorem?

The main operation of &lambda;-calculus (at least in its standard form) is &beta;-reduction. Loosely speaking, &beta;-reduction means that, given a function that takes an argument <span>\\(x\\)</span> and returns <span>\\(M\\)</span>, applying this function to some argument <span>\\(y\\)</span> yields the same result as substituting <span>\\(y\\)</span> for every occurrence of <span>\\(x\\)</span> in <span>\\(M\\)</span>. In the notation of &lambda;-calculus, we write this as:

<div>\[
(\lambda x . M) y = M [x := y]
\]</div>

where <span>\\((λx.M)\\)</span> means "the function that returns <span>\\(M\\)</span> given <span>\\(x\\)</span>" and <span>\\(M[x := y]\\)</span> means "the result of substituting <span>\\(y\\)</span> for <span>\\(x\\)</span> in <span>\\(M\\)</span>".

A statement <span>\\(M\\)</span> can be _&beta;-reduced_ to <span>\\(N\\)</span> if you can apply the above formula some number of times to <span>\\(M\\)</span> to turn it into <span>\\(N\\)</span>.

For example, <span>\\(((λx.(λy.y))z)z\\)</span> &beta;-reduces to <span>\\(z\\)</span>, because

<div>\[
\Big(\big(\lambda x . (\lambda y . y)\big) z\Big) z = \big((\lambda y . y) [x := z]\big) z = (\lambda y . y) z = y [y := z] = z
\]</div>

The **Church-Rosser Theorem** for &beta;-reduction states that whenever some expression <span>\\(M\\)</span> can be &beta;-reduced to two different expressions <span>\\(N\\)</span> and <span>\\(P\\)</span>, there exists some expression <span>\\(Q\\)</span> that both <span>\\(N\\)</span> and <span>\\(P\\)</span> can &beta;-reduce to. This property is also called _confluence_, and is sometimes referred to as the _diamond property_, because the resulting graph of reductions looks like this:

<img class="figure" src="/blog/images/confluence.jpg">

### Proving the Church-Rosser Theorem

In my paper, my proof of the Church-Rosser mainly follows the classic Tait-Martin-Löf proof, which is well-known as one of the simplest proofs of the theorem, relying on nothing more than a basic understanding of the theory of &beta;-reductions.

The proof has three stages:

- First, I introduce a new notion of reduction, that I call &loz;, and show that &loz; satisfies the diamond property. In this section, I follow Barendregt's exposition of the Tait-Martin-Löf proof.
- Next, I show that &loz;-equivalence is the transitive closure of &beta;-equivalence. In other words, the &beta;-equivalence relation is the minimal superset of the &loz;-equivalence relation that satisfies transitivity.
- Finally, I prove the **Strip Lemma**, which states that if a notion of reduction satisfies the diamond property, then so does its transitive closure. Thus, since &loz; satisfies the diamond property, so does &beta;. I primarily follow Robert Pollack's [simplified proof](http://www.researchgate.net/publication/2588155_Polishing_Up_the_Tait-Martin-Lf_Proof_of_the_Church-Rosser_Theorem) of the Strip Lemma.

### What does this mean for consistency?

In the final section of my paper, I show that it follows from the Church-Rosser Theorem that every expression in &lambda; has a unique "&beta;-normal form" - that is, a unique form from which the expression cannot be &beta;-reduced any further.

Then, I show that two terms cannot be equal to each other in &lambda;-calculus if they are not &beta;-equivalent. This is a result that follows directly from the axioms of &lambda;-calculus.

Putting all of these pieces together, if two terms <span>\\(M\\)</span> and <span>\\(N\\)</span> do not share the same &beta;-normal form, then the statement <span>\\(M = N\\)</span> is not provable in &lambda;-calculus.

It's easy to find two terms that do not share a &beta;-normal form - for example, <span>\\(I = λx.x\\)</span> and <span>\\(K = λx.(λy.x)\\)</span>. Thus, the statement <span>\\(I = K\\)</span> is not provable in &lambda;-calculus, and so &lambda;-calculus is a consistent theory, because if &lambda;-calculus were inconsistent, then by definition every (syntactically valid) statement would be provable in it.

### Interested in this sort of thing?

If this has piqued your interest, check out my paper [here](https://www.dropbox.com/s/u1c6pbi0qwtnjqi/The%20Consistency%20of%20Lambda%20Calculus.pdf).
