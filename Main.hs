module Main (main) where

import ContactList (
    Contact,
    createContact,
    ContactList,
    addContact,
    createContactList
    )

import Util (
    dayFromString
    )

import Data.Time (
    Day
    )


main :: IO ()
main = do   
    contactList <- createContactList;
    programLoop contactList;

programLoop contactList = do 
    putStrLn "Menu";
    putStrLn "1 - Adicionar Contato";
    putStrLn "2 - Ver tudo";

    selection <- getLine;
    
    case selection of
        "1" -> do 
            contact <- getContactFromUser;
            contactList <- addContact contactList contact 
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

    newContact <- createContact name email number (dayFromString birthday);
    return newContact;


