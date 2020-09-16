
module ContactList
    ( 
     Contact,
     createContact,
     ContactList,
     addContact,
     createContactList
    ) where

import Data.Time ( Day, diffDays, fromGregorian, toGregorian )

data ContactList = ContactList {
    contacts :: [Contact]
} deriving (Eq, Show, Read)

createContactList :: IO ContactList
createContactList = return (ContactList {contacts=[]})

addContact :: ContactList -> Contact -> IO ContactList
addContact list contact = return (ContactList {contacts=contact : (contacts list)})


addContacts :: ContactList -> [Contacts] ->  IO ContactList
addContacts list [] = list
addContacts list [contact] = addContact list contact
addContacts list (currentContact:otherContacts) = addContacts (addContact list currentContact) otherContacts

data Contact = Contact {
    name :: String,
    email :: String,
    telephone :: String,
    birthday :: Day 
} deriving (Eq, Show, Read)

createContact :: String -> String -> String -> Day -> IO Contact
createContact name email telephone birthday = return (Contact name email telephone birthday)

isBirthday :: Day -> Contact -> Bool
isBirthday today contact = daysToBirthday today contact == 0

adaptDayToTargetYear :: Day -> Integer -> Day
adaptDayToTargetYear currentDay targetYear = fromGregorian targetYear month day 
            where
                (_, month, day) = toGregorian currentDay

daysToBirthday :: Day -> Contact -> Integer
daysToBirthday day contact = diffDays day birthdayDay
            where 
                (targetYear, _, _) = toGregorian day
                birthdayDay = adaptDayToTargetYear (birthday contact) targetYear