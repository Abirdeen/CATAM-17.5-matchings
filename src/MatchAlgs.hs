module MatchAlgs where
    import Data.Map as Map (Map, insert, notMember, (!), empty)
    import Data.List ( (\\) )

    import GraphTypes

    {-| Finds an alternating path between unmatched vertices.

    Parameters
    ----------

    g : Graph
        A bipartite graph.

    m : Matching
        A partial matching of `g`.  

    a : A
        A vertex of A to match.

    Returns
    -------
    
    Maybe AlternatingPath
        An alternating path between `a` and an unmatched vertex, if it exists.
    -}
    findAlternatingPath :: Graph -> Matching -> A -> Maybe AlternatingPath
    findAlternatingPath g m a = extendPath g m a []
        where extendPath g m a excVertices
                | notMember a eList || null validNeighbours = Nothing
                | not (null newMatches) = Just ([], (a, head newMatches))
                | not (null augdPaths) = Just (head augdPaths)
                | otherwise = Nothing
                where (eList, _) = g
                      (mList,x,y) = m
                      validNeighbours = (eList ! a) \\ excVertices
                      newMatches = validNeighbours \\ y
                      possiblePaths = [(b,extendPath g m (mList!b) (excVertices ++ validNeighbours)) | b <- validNeighbours]
                      filteredPaths = filter (not.null.snd) possiblePaths
                      augdPaths = [((a,b,mList!b):path,fe) | (b, Just (path, fe)) <- filteredPaths]

    {-| Enlarges a partial matching given an alternating path.

    Parameters
    ----------

    m : Matching
        An initial matching.  

    (path, fe) : AlternatingPath
        An alternating path with respect to `m`.

    Returns
    -------
    
    Maybe Matching
        A strictly larger matching than `m`. Returned as a Maybe for monadic reasons.
    -}
    augmentMatching :: Matching -> AlternatingPath -> Maybe Matching
    augmentMatching m ([], (a,b)) = Just (Map.insert b a mList,a:x,b:y)
        where (mList,x,y) = m
    augmentMatching m ((a,b,a'):path, fe) = augmentMatching m' (path,fe)
        where (mList,x,y) = m
              m' = (Map.insert b a mList, a : Prelude.filter (/=a') x, y)

    {-| Finds a matching if possible, or else a blocking set.

    Parameters
    ----------

    g : Graph
        A bipartite graph.

    Returns
    -------
    
    Maybe Matching
        A complete matching of `g`.

    Maybe BlockingSet
        A blocking set for `g`.
    -}
    findMatching :: Graph -> (Maybe Matching, Maybe BlockingSet)
    findMatching g = extendMatching g (empty :: Map B A, [], []) n
        where (_,n) = g
              extendMatching _ m 0 = (Just m, Nothing)
              extendMatching g m a = case m' of
                                       Just n -> extendMatching g n (a-1)
                                       Nothing -> (Nothing, Just (a:x))
                where (mList,x,y) = m
                      m' = do path <- findAlternatingPath g m a
                              augmentMatching m path
