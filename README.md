# CATAM-17.5-matchings
A rewrite of my Cambridge CATAM undergraduate project, "Matchings".

## Haskell

Haskell is a pure functional language with lazy evaluation. While this style is rare in modern programming, it encourages programmers to think more carefully about the structures they build and the way they pass around data. For this graph-theoretic project, it encourages careful attention to ideas of recursion and tabulation.

## The project

The aim of this project is to study [matchings](https://en.wikipedia.org/wiki/Matching_(graph_theory)) in [bipartite graphs](https://en.wikipedia.org/wiki/Bipartite_graph).

### Random bipartite graphs and processes

For much of this project, we want to study either random bipartite graphs, where edges of the complete bipartite graph are included with probability $p$, or random bipartite processes, where we add random edges to an empty bipartite graph until we have a complete one. These algorithms are implemented in `randomGraph` and `completeBipartiteProcess`, respectively, in the `GraphGenerator` module.

### Hall's theorem

The celebrated [Hall's theorem](https://en.wikipedia.org/wiki/Hall%27s_marriage_theorem) tells us that an $n \times n$ bipartite graph $(G,X,Y)$ has either a complete matching or a blocking set, that is, either there is a set of $n$ independent edges in $G$, or there is a set $A \subseteq X$ with $$|\Gamma(A)| = |\{ b \in Y | \exists a \in A, (a,b) \in G \}| < |A|.$$ 

From this result, we want to develop an algorithm that, given a bipartite graph (either as an [adjacency matrix](https://en.wikipedia.org/wiki/Adjacency_matrix) or an [adjacency list](https://en.wikipedia.org/wiki/Adjacency_list)), will output either a complete matching or a maximal matching and a blocking set.

### Alternating paths

Given a matching $M$ between $A \subseteq X$ and $B \subseteq Y$, an alternating path is a path from ${u \in X \backslash A}$ to some ${v \in Y}$ such that every second edge of the path is in $M$. We say that $v$ is reachable from $u$ by an alternating path. 

We can use the set of vertices reachable from $u$ to find either a blocking set, or a larger matching, as discussed in Problem 2.

## Problems

The original CATAM project involved certain explicit questions and problems, which are reproduced (and solved) here.

### Problem 1

One algorithm to check whether G has a complete matching is to check each subset A to see if it is a blocking set. Why is this a poor method?

#### Solution

There are two major problems with this method: 
1. It is non-constructive, meaning that when a complete matching exists, this algorithm will not tell us what such a matching looks like;
2. There are $2^n$ subsets of a size $n$ bipartite graph, so the runtime of this algorithm will be at least exponential.

### Problem 2

Suppose $M$ is a matching between $A \subseteq X$ and $B \subseteq Y$. Pick $u \in X \backslash A$, and consider the set of vertices reachable from $u$, which we write as $V$.

- How can a matching larger than $M$ be found if $V \not\subseteq B$?

- How can a blocking set be found if $V \subseteq B$?

#### Solution

If $V \not \subseteq B$, then in particular we can find a vertex $v \not\in B$ and an alternating path from $u$ to $v.$ By adding the odd edges of this path to $M$ and removing the even ones, we obtain a strictly larger matching.

If $V \subseteq B$, then $\Gamma(A \cup \{u\}) = B$, so $$\left| \Gamma(A \cup \{u\}) \right| = \left| B \right| = \left| A \right| < \left| A \right| + 1 = \left| A \cup \{u\} \right|,$$ that is, $A \cup \{u\}$ is a blocking set.

