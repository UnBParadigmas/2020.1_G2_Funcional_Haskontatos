
module ContactList
    ( 
     Contact,
     createContact,
     addContact,
     delContact,
     getNextBirthdays,
     getContactsByName,
     name,
     email,
     telephone,
     birthday
    ) where

import Data.Time ( Day, diffDays, fromGregorian, toGregorian )
import Data.List (isInfixOf)
import Data.Char (toLower)

addContact :: [Contact] -> Contact -> [Contact]
addContact contactList contact = contact:contactList

delContact :: [Contact] -> String -> [Contact]
delContact contactList searchName = [contact | contact <- contactList, (name contact) /=searchName]

getNextBirthdays :: Day -> [Contact] -> [Contact]
getNextBirthdays currentDay contacts = [x | x <- contacts, daysToBirthday currentDay x < 30, daysToBirthday currentDay x > 0]

data Contact = Contact {
    name :: String,
    email :: String,
    telephone :: String,
    birthday :: Day 
} deriving (Eq, Show, Read)

createContact :: String -> String -> String -> Day -> Contact
createContact name email telephone birthday = Contact name email telephone birthday

isBirthday :: Day -> Contact -> Bool
isBirthday today contact = daysToBirthday today contact == 0

adaptDayToTargetYear :: Day -> Integer -> Day
adaptDayToTargetYear currentDay targetYear = fromGregorian targetYear month day 
            where
                (_, month, day) = toGregorian currentDay

daysToBirthday :: Day -> Contact -> Integer
daysToBirthday day contact = diffDays birthdayDay day
            where 
                (targetYear, _, _) = toGregorian day
                birthdayDay = adaptDayToTargetYear (birthday contact) targetYear

getContactsByName :: [Contact] -> String -> [Contact]
getContactsByName contactList nameSubString = [x | x <- contactList , isInfixOf (map toLower nameSubString) (map toLower (name x)) ]


