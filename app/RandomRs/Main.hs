module Main (main) where

import Data.List qualified as L
import System.Environment
import System.Random

rands :: Integer -> Int -> [Integer]
rands range seed = L.unfoldr (Just . randomR (0, range - 1)) $ mkStdGen seed

main :: IO ()
main = do
    args <- getArgs
    case args of
        (rstr : nstr : rest) -> mapM_ print . take n . rands range $ seed
          where
            n = read nstr :: Int
            range = read rstr :: Integer
            seed = case rest of
                [sdstr] -> read sdstr :: Int
                [] -> 0
        _ -> putStrLn "usage: randomRs <range> <n> [<seed>]"
