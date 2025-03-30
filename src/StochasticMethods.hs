module StochasticMethods (RandomList, Probability, randomList, binomialDraw) where
    import System.Random

    type RandomList = [Double]
    type Probability = Double

    randomList :: Int -> RandomList
    randomList seed = randoms (mkStdGen seed) :: [Double]

    {-| Simulates drawing from a random binomial distribution.

    Parameters
    ----------

    k : Int
        Number of draws to make.

    p : Probability
        Probability of success in a given draw.

    rList : RandomList
        Seeded list of random numbers between 0 and 1.

    Returns
    -------
    
    Int
        Number of successful draws.
    -}
    binomialDraw :: Int -> Probability -> RandomList -> (Int, RandomList)
    binomialDraw 0 _ rList = (0, rList)
    binomialDraw k p (randomNum:rList) = (drawResult + n, rList')
        where (n, rList') = binomialDraw (k-1) p rList
              drawResult = fromEnum (randomNum < p)
