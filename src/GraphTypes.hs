module GraphTypes where
    import Data.Map ( Map )

    type A = Int
    type B = Int
    type EdgeList = Map Int [Int]
    type GraphSize = Int
    type Graph = (EdgeList, GraphSize)
    type Matching = (Map B A, [A], [B])
    type BlockingSet = [A]
    type AlternatingPath = ([(A,B,A)], (A,B))