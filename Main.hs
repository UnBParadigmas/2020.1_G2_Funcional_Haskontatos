module Main (main) where

import ContactList (
    Contact,
    createContact,
    addContact,
    delContact,
    getNextBirthdays,
    )

import Util (
    dayFromString,
    getCurrentDate
    )

import Service (
    validateName
    )

-- import Text.Email.Validate (
--     isValid
--     )

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

preapreQuit :: [Contact] -> IO ()
preapreQuit contactList = do
    system "clear";
    putStrLn "\nSalvar? S/N"
    choice <- getLine;

    case choice of
        "S" -> do
            system "clear";
            putStrLn "O Super Haskontados salvou o dia! lol"
            putStrLn "Ps: salvou seu contato tambem <3"
            saveToSaveFile contactList;
            return ()
        "s" -> do
            system "clear";
            putStrLn "O Super Haskontados salvou o dia! lol"
            putStrLn "Ps: salvou seu contato tambem <3"
            saveToSaveFile contactList;
            return ()
        "N" -> do
            system "clear";
            putStrLn "Até logo! :)"
            return ()
        "n" -> do
            system "clear";
            putStrLn "Até logo! :)"
            return ()
        otherwise -> do
            system "clear";
            putStrLn "Resposta invalida..."
            preapreQuit contactList;




programLoop :: [Contact] -> IO [Contact]
programLoop contactList = do 
    system "clear";
    putStrLn "____________________HASKONTATOS____________________\n"

    putStrLn "Data de Hoje:"
    currentDate <- getCurrentDate
    putStrLn (show currentDate)

    birthdaysCount <- return (length (getNextBirthdays currentDate contactList))
    if birthdaysCount > 0
        then showNextBirthdays (getNextBirthdays currentDate contactList)
        else putStrLn "Que pena, nenhum aniversário próximo...";


    putStrLn "\n_______________________Menu________________________\n"

    putStrLn "[1] - Adicionar Contato"
    putStrLn "[2] - Ver todos os contatos"
    putStrLn "[3] - Deletar Contato"
    putStrLn "[0] - Sair"

    putStrLn "\nDigite a opção desejada:"

    selection <- getLine;

    case selection of
        "0" -> do
            return contactList;
        "1" -> do
            contact <- getContactFromUser;
            contactList <- return (addContact contactList contact)
            contactList <- programLoop contactList;
            return contactList;
        "2" -> do
            putStrLn (show contactList);
            _ <- getLine
            contactList <- programLoop contactList;
            return contactList;
        "3" -> do
            contactList <- delContactFromUser contactList;
            contactList <- programLoop contactList;
            return contactList;



showNextBirthdays :: [Contact] -> IO ()
showNextBirthdays contactList = do

    putStrLn "Aniversáriantes do mês:"
    putStrLn (show contactList)

getContactFromUser :: IO Contact
getContactFromUser = do
    putStrLn "Insira o nome:";
    name <- getNameFromUser;

    putStrLn "Insira o email:";
    email <- getLine;

    putStrLn "Insira o numero de telefone:";
    number <- getLine;

    putStrLn "Insira a data de nascimento (DD/MM/YYYY):";
    birthday <- getLine;
    system "clear";

    newContact <- return (createContact name email number (dayFromString birthday));
    return newContact;

delContactFromUser :: [Contact] -> IO [Contact]
delContactFromUser contactList = do
    putStrLn "Digite o nome do contato a ser deletado:";
    name <- getLine;

    newList <- return (delContact contactList name);
    return newList;

getNameFromUser :: IO String
getNameFromUser = do
    name <- getLine;
    if validateName name
        then return name
        else do
            putStrLn "Nome inválido!";
            name <- getNameFromUser
            return name;
