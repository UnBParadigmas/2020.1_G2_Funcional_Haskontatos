module Util (
    dayFromString
    ) where

import Data.Time (Day, fromGregorian)

dayFromString :: String -> Day
-- receive a string in the format DD/MM/YYYY and return the Day
dayFromString dateStr = fromGregorian year month day 
            where
                day = read (take 2 dateStr) :: Int
                month = read (take 2 (snd (splitAt 3 dateStr))) :: Int
                year = read (take 4 (snd (splitAt 6 dateStr))) :: Integer