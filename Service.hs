module Service (
    validateName
    ) where

countString :: String -> Int
countString nameSize = sum [ 1 | _ <- nameSize ]

validateName :: String -> Bool
validateName name = if countString name > 2 then True else False