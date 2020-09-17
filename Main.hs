module Main (main) where

import ContactList (
    Contact,
    createContact,
    addContact,
    getNextBirthdays,
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
import System.IO
import System.Directory

saveFilepath :: String
saveFilepath = "./haskontatos.txt"

main :: IO ()
main = do   

    system "clear";

    startupList <- readSavedFile; 
    contacts <- programLoop startupList;
    preapreQuit contacts;

readSavedFile :: IO [Contact]
readSavedFile = do
    
    fileExist <- doesFileExist saveFilepath
        
    if fileExist
        then do
            content <- readFile saveFilepath
            return (read content) 
        else return []

saveToSaveFile :: [Contact] -> IO ()
saveToSaveFile contacts = do
    writeFile saveFilepath (show contacts)
    putStrLn "Salvo!" 

preapreQuit :: [Contact] -> IO ()
preapreQuit contactList = do 
    putStrLn "Salvar? S/N"
    choice <- getLine;

    case choice of
        "S" -> do
            saveToSaveFile contactList;
            return ()
        "N" -> do
            return ()
        otherwise -> do
            putStrLn "Resposta invalida..."
            preapreQuit contactList;



programLoop :: [Contact] -> IO [Contact]
programLoop contactList = do 

    putStrLn "====================HASKONTATOS===================="
    
    putStrLn "Hoje é:"
    currentDate <- getCurrentDate
    putStrLn (show currentDate)

    birthdaysCount <- return (length (getNextBirthdays currentDate contactList))
    if birthdaysCount > 0 
        then showNextBirthdays (getNextBirthdays currentDate contactList)
        else putStrLn "Que pena, sem aniversários próximos...";

    putStrLn "====================HASKONTATOS===================="

    putStrLn "Operações";
    putStrLn "0 - Sair";
    putStrLn "1 - Adicionar Contato";
    putStrLn "2 - Ver tudo";
   
    selection <- getLine;
    
    case selection of
        "0" -> do
            system "clear";
            return contactList;
        "1" -> do 
            system "clear";
            contact <- getContactFromUser;
            contactList <- return (addContact contactList contact)
            contactList <- programLoop contactList;
            return contactList;
        "2" -> do
            putStrLn (show contactList);
            contactList <- programLoop contactList;
            return contactList;

showNextBirthdays :: [Contact] -> IO ()
showNextBirthdays contactList = do

    putStrLn "Aniversários em 30 dias:"
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


