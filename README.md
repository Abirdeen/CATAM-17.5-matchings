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

### Problem 3

Implement an algorithm to find a complete matching. The output should show (at least) whether a complete matching exists or, if not, the size of a blocking set. For each of the seven values of $p$ varying from 0.05 to 0.35 by steps of 0.05, and from $0.1 \times \frac{\ln n}{n}$ to $1.9 \times \frac{\ln n}{n}$ by steps of $0.3 \times \frac{\ln n}{n}$, run the program on twenty random $n \times n$ bipartite graphs with $n = 60$.

#### Solution

This algorithm is implemented as `findMatching` in the `MatchAlgs` modules.

We use the following code to compute our results, with a trivial modification for the second set:
```haskell
results :: Probability -> GraphSize -> Int -> Int -> [(Probability, Int, Int, Double)]
results _ _ _ 0 = []
results p k numDraws iter = result:results p k numDraws (iter - 1)
    where result = (prob, numMatchings, numBlockings, avgBlockingSize)
          prob = fromInteger (round (100 * (p * fromIntegral iter))) / 100
          matchingsAndBlockings = [findMatching (fst (randomBipartiteGraph k prob (randomList ((1777779+iter)*x)))) | x <- [1..numDraws]]
          numMatchings = length (filter (null.snd) matchingsAndBlockings)
          blockingSizes = [length b | (_,Just b) <- filter (null.fst) matchingsAndBlockings]
          numBlockings = length blockingSizes
          avgBlockingSize = fromIntegral (sum blockingSizes) / fromIntegral (max numBlockings 1)

main :: IO ()
main = do 
    print (results 0.05 60 20 7)
```

Our results are tabulated below:

| $p$  | $N^o$ of Matchings | $N^o$ of blocking sets | Avg. size of blocking set |
| ---  | ------------------ | ---------------------- | ------------------------- |
| 0.05 | 0                  | 20                     | 11.95                     |
| 0.10 | 17                 | 3                      | 45.67                     |
| 0.15 | 20                 | 0                      | N/A                       |
| 0.20 | 20                 | 0                      | N/A                       |
| 0.25 | 20                 | 0                      | N/A                       |
| 0.30 | 20                 | 0                      | N/A                       |
| 0.35 | 20                 | 0                      | N/A                       |
|      |                    |                        |                           |
| $0.1\frac{\ln n}{n}$ | 0  | 20                     | 1.55                      |
| $0.4\frac{\ln n}{n}$ | 0  | 20                     | 7.25                      |
| $0.7\frac{\ln n}{n}$ | 0  | 20                     | 13.8                      |
| $1.0\frac{\ln n}{n}$ | 4  | 16                     | 34.5                      |
| $1.3\frac{\ln n}{n}$ | 17 | 3                      | 36.0                      |
| $1.6\frac{\ln n}{n}$ | 20 | 0                      | N/A                       |
| $1.9\frac{\ln n}{n}$ | 19 | 1                      | 16.0                      |

A classic result of Erdős and Rényi[$^{[1]}$](#1)[$^{[2]}$](#2) established the critical point for a random bipartite graph to have a matching.

Given a probability $p = \frac{f(n)+\ln n}{n}$, the probability that a random bipartite graph of edge weight $p$ will have a matching (as $n \rightarrow \infty$) is

$$ \lim_{n\rightarrow \infty} \mathbb{P}(G_n \text{ has a matching}) = \begin{cases} 0 & f(n) \rightarrow \infty \\ e^{-2e^{-c}} & f(n) \rightarrow c \\ 1 & f(n) \rightarrow \infty \end{cases} $$

Indeed, this theoretical criterion is reflected in our results, where $p < \frac{\ln n}{n} \approx 0.068$ generally results in a blocking set, $p\approx \frac{\ln n}{n}$ results in a mix of blocking sets and matchings, while $p > \frac{\ln n}{n}$ generally results in a matching. 

### Problem 4

Run your program on ten random bipartite graph processes, with $n = 40$. Tabulate your results. What simple properties of a graph are necessary for a complete matching to exist?

#### Solution

We use the following code to compute our results:
```haskell
results :: GraphSize -> Int -> [(Int, Int)]
results _ 0 = []
results k iter = result:results k (iter - 1)
    where result = (firstMatching, lastIsolatedVertex)
          rList = randomList (20020 + iter)
          (process, _) = completeBipartiteProcess k rList
          matchingsAndBlockings = [(not.null.snd) (findMatching g) | g <- process]
          firstMatching = length (filter id matchingsAndBlockings) +1
          noIsolatedVertex = length (filter (>0) [(2*k) - length eList | (eList,_) <- process]) +1
          
main :: IO ()
main = do 
    print (results 40 10)
```
Our results are tabulated below:

| Process number | Number of edges for first matching | Number of edges before all vertices are non-isolated |
| -------------- | --------------------------------- | --- |
| 1              | 228                               | 228 |
| 2              | 144                               | 141 |
| 3              | 189                               | 179 |
| 4              | 155                               | 155 |
| 5              | 179                               | 165 |
| 6              | 172                               | 172 |
| 7              | 180                               | 180 |
| 8              | 137                               | 137 |
| 9              | 244                               | 244 |
| 10             | 167                               | 167 |

Based on the comments in the previous section, we should expect the first matching to appear after around $n \ln n \approx 147.55$ edges. Indeed, this is borne out by our results: in the worst case, we only need an additional $5\%$ of possible edges before a matching appears.

A simple property that is necessary for a matching to exist is that there are no isolated vertices. It is notable that in 7 of 10 cases, a matching appeared precisely when there were no remaining isolated vertices. 

From the same work of Erdős and Rényi as before, the critical point for isolated vertices is also at around $p = \frac{\ln n}{n}$, so this behaviour is also expected.

