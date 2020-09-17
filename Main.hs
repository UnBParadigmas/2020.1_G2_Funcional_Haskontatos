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

    putStrLn "Menu";
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


