module Main (main) where

import ContactList (
    Contact,
    createContact,
    addContact,
    getNextBirthdays
    )

import Util (
    dayFromString,
    getCurrentDate
    )

import Data.Time (
    Day,
    addDays
    )

import System.Process


main :: IO ()
main = do   
    -- todo: Read from file
    programLoop [];
    -- todo: Save on close

programLoop :: [Contact] -> IO b
programLoop contactList = do 

    system "clear";
    putStrLn "====================HASKONTATOS===================="
    
    currentDate <- getCurrentDate
    birthdaysCount <- return (length (getNextBirthdays currentDate contactList))

    if birthdaysCount > 0 
        then showNextBirthdays contactList;
        else putStrLn "Que pena, sem aniversários próximos...";

    putStrLn "====================HASKONTATOS===================="

    putStrLn "Operações";
    putStrLn "1 - Adicionar Contato";
    putStrLn "2 - Ver tudo";
   
    selection <- getLine;
    
    case selection of
        "1" -> do 
            contact <- getContactFromUser;
            contactList <- return (addContact contactList contact)
            programLoop contactList;
        "2" -> do
            putStrLn (show contactList);
            programLoop contactList;

showNextBirthdays :: [Contact] -> IO ()
showNextBirthdays contactList = do

    putStrLn "\n\nAniversários:\n"
    putStrLn (show contactList)



getContactFromUser :: IO Contact
getContactFromUser = do
    putStrLn "Insira o nome:";
    name <- getLine;
    
    putStrLn "Insira o email:";
    email <- getLine;
    
    putStrLn "Insira o numero de telefone:";
    number <- getLine;
    
    putStrLn "Insira a data de nascimento (DD/MM/YYYY):";
    birthday <- getLine;

    newContact <- return (createContact name email number (dayFromString birthday));
    return newContact;


