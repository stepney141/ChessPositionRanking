module Chess.Position (Square, boardSquares, pawnSquares, CastleMap, filterMap, Symbol, emptySymbol, Diagram, emptyDiagram, showDiagram, Position (..), emptyPosition, readFEN, writeFEN, printDiagram, Opposing, mkOpps) where

import Data.Array
import Data.Bits
import Data.Char
import Data.List
import Data.List.Split
import Data.Map qualified as M
import Data.Maybe

-- ccordinate
-- integer in 0..63 corresponding to a8,b8,...,h8,a7,...,h7,...,a1,...,h1
type Square = Int

-- common coordinate lists
boardSquares :: [Square]
boardSquares = [0 .. 63]

-- pawns can only appear on the central 8x6 squares
pawnSquares :: [Square]
pawnSquares = [8 .. 55]

-- filter list by bitmap, assuming 64 bit Ints
filterMap :: Int -> [a] -> [a]
filterMap 0 _ = []
filterMap i (x : xs) = let fm = filterMap (i `shiftR` 1) xs in if odd i then x : fm else fm

-- convert bitmap into list of set bit indices
bitmapSquares :: Int -> [Square]
bitmapSquares bm = filterMap bm boardSquares

-- contents of a chess board square
type Symbol = Char

-- display a king queen rook bishop knight as character
emptySymbol = '.'

-- a diagram is just an array of (64) squares
type Diagram = Array Square Symbol

-- empty diagram
emptyDiagram :: Diagram
emptyDiagram = listArray (0, 63) (repeat emptySymbol)

-- bitmap with bit 0 black queen(side), 1 black king, 2 white queen, 3 white king
type CastleMap = Int

-- position info corresponding to FEN fields
data Position = Position
    { diagram :: Diagram
    , sideToMove :: Char
    , castlings :: CastleMap
    , enPassant :: Square
    , num0 :: Int
    , num1 :: Int
    }
    deriving (Eq, Ord, Show)

-- empty position
emptyPosition :: Position
emptyPosition =
    Position
        { diagram = listArray (0, 63) (repeat emptySymbol)
        , sideToMove = 'w'
        , castlings = 0
        , enPassant = 0
        , num0 = 0
        , num1 = 1
        }

-- show a diagram as 8 lines of text
showDiagram :: Diagram -> String
showDiagram = concat . map ((++ ['\n']) . intersperse ' ') . chunksOf 8 . elems

-- run length encode pawns in FEN
compact :: String -> String
compact "" = ""
compact (c : s) = if c == emptySymbol then show (1 + length empties) ++ compact rest else c : compact s
  where
    (empties, rest) = span (== emptySymbol) s

-- convert a position to FEN
writeFEN :: Position -> String
writeFEN pos = intercalate " " [board, [stm], castles, enpassants, show n0, show n1]
  where
    Position{diagram = d, sideToMove = stm, castlings = c, enPassant = ep, num0 = n0, num1 = n1} = pos
    board = intercalate "/" . map compact . chunksOf 8 . elems $ d
    castles = if c == 0 then "-" else reverse $ filterMap c "qkQK"
    enpassants = if ep == 0 then "-" else [fileChar, rowChar]
    fileChar = ['a' .. 'h'] !! (ep `mod` 8)
    rowChar = intToDigit (8 - (ep `div` 8))

-- run length decode pawns in FEN
uncompact :: String -> String
uncompact "" = ""
uncompact (c : s) = uc ++ uncompact s
  where
    uc = if c == '/' then "" else if isDigit c then replicate (digitToInt c) emptySymbol else [c]

-- read a FEN
readFEN :: String -> Position
readFEN fen = case words fen of
    [board, [stm], castles, enpassant, n0, n1] ->
        let
            diag = listArray (0, 63) (uncompact board)
            cstl = if castles == "-" then 0 else sum . map ((1 `shiftL`) . fromJust . flip elemIndex "qkQK") $ castles
            ep = if enpassant == "-" then 0 else row * 8 + file
              where
                [fileChar, rowChar] = enpassant
                file = ord fileChar - ord 'a'
                row = 8 - digitToInt rowChar
         in
            Position{diagram = diag, sideToMove = stm, castlings = cstl, enPassant = ep, num0 = read n0, num1 = read n1}
    _ -> error $ "Not a FEN: " ++ fen

-- show position as string
-- instance Show Position where show = showDiagram . diagram
printDiagram :: Position -> IO ()
printDiagram = putStrLn . showDiagram . diagram

-- file that contains opposing black and white pawns on given coordinates
type Opposing = (Square, Square)

-- make list of possible opposings on each file
mkOpps :: Diagram -> [[Opposing]]
mkOpps diag = map mkFileOpp [0 .. 7]
  where
    mkFileOpp f = [(bp, wp) | (('p', bp) : ('P', wp) : _) <- tails filePawns]
      where
        filePawns = [(sq, co) | co <- [8 + f, 16 + f .. 48 + f], let sq = diag ! co, toLower sq == 'p']
