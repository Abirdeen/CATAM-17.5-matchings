module GraphGenerator (completeBipartiteProcess, randomBipartiteGraph) where
    import Data.Map as Map
    import Data.List as DList
    import Data.Maybe

    import GraphTypes
    import StochasticMethods
    
    {-| Adds a (uniformly) random edge to a bipartite graph.

    Parameters
    ----------

    (eList,n) : Graph
        Initial bipartite graph.

    rList : RandomList
        List of random numbers between 0 and 1.

    Returns
    -------
    
    Graph
        Graph with new edge added.

    RandomList
        The list of random numbers, excluding those used in the function.
    -}
    newRandomEdge :: Graph -> RandomList -> (Graph, RandomList)
    newRandomEdge (eList,n) (r1:r2:rList)
        | notMember a eList && notMember b eList = ((Map.insert b [a] (Map.insert a [b] eList),n), rList)
        | notMember a eList = ((Map.insert b gbWitha (Map.insert a [b] eList),n), rList)
        | notMember b eList = ((Map.insert a gaWithb (Map.insert b [a] eList),n), rList)
        | b `notElem` (eList ! a) = ((eList',n), rList)
        | otherwise = newRandomEdge (eList,n) rList
      where a = ceiling (r1 * fromIntegral n) :: A
            b = ceiling (r2 * fromIntegral n) + n :: B
            gaWithb = sort (b:(eList ! a))
            gbWitha = sort (a:(eList ! b))
            eList' = Map.insert b gbWitha (Map.insert a gaWithb eList)

    {-| Creates a bipartite process.

    Parameters
    ----------

    g : Graph
        An initial bipartite graph.  

    k : Int
        Number of edges to add to `g`.

    rList : RandomList
        List of random numbers between 0 and 1.

    Returns
    -------
    
    [Graph]
        A sequence of bipartite graphs. The first element is `g`, and the m+1th element is the mth element with one additional edge.
    
    RandomList
        The list of random numbers, excluding those used in the function.
    -}
    bipartiteProcess :: Graph -> Int -> RandomList -> ([Graph], RandomList)
    bipartiteProcess g 0 rList = ([g], rList)
    bipartiteProcess g k rList = (g:gs, rList'')
        where (g', rList') = newRandomEdge g rList
              (gs, rList'') = bipartiteProcess g' (k - 1) rList'

    {-| Creates a complete bipartite process.

    Parameters
    ----------

    n : GraphSize
        The size of the bipartite graphs in the process.  

    rList : RandomList
        List of random numbers between 0 and 1.

    Returns
    -------
    
    [Graph]
        A sequence of bipartite graphs. The first element is the empty graph, and the m+1th element is the mth element with one additional edge.
    
    RandomList
        The list of random numbers, excluding those used in the function.
    -}
    completeBipartiteProcess :: GraphSize -> RandomList -> ([Graph], RandomList)
    completeBipartiteProcess n = bipartiteProcess (empty :: EdgeList,n) (n*n)

    {-| Creates a random bipartite graph.

    Parameters
    ----------

    n : GraphSize
        The size of bipartite graph to generate.  

    p : Probability
        A number 0<=p<=1, representing the probability a given edge is in the graph.

    rList : RandomList
        List of random numbers between 0 and 1.

    Returns
    -------
    
    Graph
        A random bipartite graph of size `n` with edge weighting `p`.
    
    RandomList
        The list of random numbers, excluding those used in the function.
    -}
    randomBipartiteGraph :: GraphSize -> Probability -> RandomList -> (Graph, RandomList)
    randomBipartiteGraph n p rList = (last graphs, rList'')
        where (graphs, rList'') = bipartiteProcess (empty :: EdgeList,n) k rList'
              (k, rList') = binomialDraw (n*n) p rList
