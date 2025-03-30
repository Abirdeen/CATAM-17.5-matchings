# CATAM-17.5-matchings
A rewrite of my Cambridge CATAM undergraduate project, "Matchings".

## Haskell

Haskell is a pure functional language with lazy evaluation. While this style is rare in modern programming, it encourages programmers to think more carefully about the structures they build and the way they pass around data. For this graph-theoretic project, it encourages careful attention to ideas of recursion and tabulation.

## The project

The aim of this project is to study [matchings](https://en.wikipedia.org/wiki/Matching_(graph_theory)) in [bipartite graphs](https://en.wikipedia.org/wiki/Bipartite_graph).

### Random bipartite graphs and processes

For much of this project, we want to study either random bipartite graphs, where edges of the complete bipartite graph are included with probability $p$, or random bipartite processes, where we add random edges to an empty bipartite graph until we have a complete one. These algorithms are implemented in `randomGraph` and `completeBipartiteProcess`, respectively, in the `GraphGenerator` module.
