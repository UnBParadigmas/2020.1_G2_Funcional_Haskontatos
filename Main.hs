module Main (main) where

import ContactList (
    Contact,
    createContact,
    addContact,
    delContact,
    updateContact,
    getNextBirthdays,
    getContactsByName,
    name,
    email,
    telephone,
    birthday
    )

import Util (
    dayFromString,
    getUpdated,
    getCurrentDate
    )

import Service (
    validateName
    )

import Text.Email.Validate (
    isValid
    )
    
import Data.ByteString.UTF8  (
    fromString
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
    
    showNextBirthdays (getNextBirthdays currentDate contactList) currentDate;


    putStrLn "\n_______________________Menu________________________\n"

    putStrLn "[1] - Adicionar Contato"
    putStrLn "[2] - Ver todos os contatos"
    putStrLn "[3] - Deletar Contato"
    putStrLn "[4] - Buscar contato por nome"
    putStrLn "[5] - Atualizar contato"
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
            showContacts contactList;
            _ <- getLine
            contactList <- programLoop contactList;
            return contactList;
        "3" -> do
            contactList <- delContactFromUser contactList;
            contactList <- programLoop contactList;
            return contactList;
        "4" -> do
            filteredContacts <- searchContact contactList;
            putStrLn "\nResultado da busca:\n";
            mapM displayContact filteredContacts;
            _ <- getLine;
            contactList <- programLoop contactList;
            return contactList;
        "5" -> do
            contactList <- updateContactFromUser contactList;
            _ <- getLine;
            putStrLn (show contactList);
            contactList <- programLoop contactList;

            return contactList;


showContacts :: [Contact] -> IO [()]
showContacts contactList = do
    system "clear";
    putStrLn "Todos os contatos salvos:\n\n"
    mapM displayContact contactList;

showNextBirthdays :: [Contact] -> Day -> IO [()]
showNextBirthdays contactList currentDate = do
    birthdaysCount <- return (length (getNextBirthdays currentDate contactList))

    if birthdaysCount > 0 
        then
            putStrLn "Aniversáriantes do mês:"
        else 
            putStrLn "Que pena, nenhum aniversário próximo..."

    mapM showBirthday contactList;

showBirthday :: Contact -> IO ()
showBirthday contact = do
    putStrLn (show (name contact) ++ " - " ++ show (birthday contact));

getContactFromUser :: IO Contact
getContactFromUser = do
    putStrLn "Insira o nome:";
    name <- getNameFromUser;

    putStrLn "Insira o email:";
    email <- getEmailFromUser;

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

getEmailFromUser :: IO String
getEmailFromUser = do
       
        emailText <- getLine;
        email <- return (fromString emailText); 
        if isValid email 
            then do
                return emailText;
            else do
                putStrLn "Email inválido!";
                getEmailFromUser;
        

searchContact :: [Contact] -> IO [Contact]
searchContact contactList = do
    putStrLn "Insira o nome do contato:";
    name <- getLine;
    filteredContacts <- return (getContactsByName contactList name);
    return filteredContacts;

displayContact :: Contact -> IO ()
displayContact contact =  do
    putStrLn (show (name contact));
    putStrLn (show (email contact));
    putStrLn (show (telephone contact));
    putStrLn (show (birthday contact));
    putStrLn "\n____________________________\n";

updateContactFromUser :: [Contact] -> IO [Contact]
updateContactFromUser contactList = do

    result <- searchContact contactList;
    if length result < 1
       then do
            putStrLn "\nContato não encontrado, tente novamente :("
            updatedList <- updateContactFromUser contactList;
            return updatedList;
        else do
            contCurrent <- return (head result);

            putStrLn "Aperte enter caso não deseje alterar o valor."
            putStrLn "Contato selecionado:"

            displayContact contCurrent;

            putStrLn "Alterar Nome: "
            upName <- getLine;
            upName <- return (getUpdated (name contCurrent) upName);

            putStrLn "Alterar Email: "
            upEmail <- getLine;
            upEmail <- return (getUpdated (email contCurrent) upEmail);

            putStrLn "Alterar Telefone: "
            upTelephone <- getLine;
            upTelephone <- return (getUpdated (telephone contCurrent) upTelephone);

            putStrLn "Alterar Aniversário: "
            upBirthdayText <- getLine;
            upBirthday <- if upBirthdayText == ""
                then do
                    return (birthday contCurrent);
                else do
                    return (dayFromString upBirthdayText);

            updatedContact <- return (createContact upName upEmail upTelephone upBirthday);
            originalName <- return (name contCurrent);

            cleanedList <- return (delContact contactList originalName);

            updatedList <- return (addContact cleanedList updatedContact);

            putStrLn "Alterado com sucesso"
            return updatedList;

