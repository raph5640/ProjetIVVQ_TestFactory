*** Settings ***
Library           DateTime
Library           SeleniumLibrary

*** Variables ***
${BASE_USERNAME}    rD
${TIMESTAMP}      ${EMPTY}
${USERNAME_A}     ${EMPTY}
${USERNAME_B}     ${EMPTY}
${PASSWORD}       raphmdp

*** Test Cases ***
Creation_compte_A
    Set Timestamp And Usernames
    Create Account    ${USERNAME_A}

Creation_compte_B
    Create Account    ${USERNAME_B}

Effectuer_un_transfert_dargent_cas_non_passant
    Execute Transfer    ${USERNAME_A}    ${USERNAME_B}    non_passant

Effectuer_un_transfert_dargent_cas_passant
    Execute Transfer    ${USERNAME_A}    ${USERNAME_B}    passant

Creation_dun_compte_client_donnees_valides
    Set Timestamp And Usernames
    Open Browser    https://parabank.parasoft.com/parabank/    chrome
    Maximize Browser Window
    Wait Until Page Contains    Register
    Click Element    //a[text()='Register']
    Input User Details
    Input Text    //input[@id='customer.username']    ${USERNAME_A}
    Input Password    //input[@id='customer.password' and @type='password']    ${PASSWORD}
    Input Password    //input[@id='repeatedPassword' and @type='password']    ${PASSWORD}
    Click Element    //input[@value='Register']
    Wait Until Page Contains    Welcome ${USERNAME_A}    10s
    Close Browser

Creation_dun_compte_client_donnees_non_valides
    Set Timestamp And Usernames    # Setting the username directly within this test case
    Open Browser    https://parabank.parasoft.com/parabank/    chrome
    Maximize Browser Window
    Wait Until Page Contains    Register
    Click Element    //a[text()='Register']
    Input User Details

*** Keywords ***
Set Timestamp And Usernames
    ${TIMESTAMP}=    Get Current Date    result_format=%H%M%S
    Set Global Variable    ${USERNAME_A}    ${BASE_USERNAME}${TIMESTAMP}A
    Set Global Variable    ${USERNAME_B}    ${BASE_USERNAME}${TIMESTAMP}B

Create Account
    [Arguments]    ${username}
    Open Browser    https://parabank.parasoft.com/parabank/    chrome
    Maximize Browser Window
    Wait Until Page Contains    Register
    Click Element    //a[text()='Register']
    Input User Details
    Input Text    //input[@id='customer.username']    ${username}
    Input Password    //input[@id='customer.password' and @type='password']    ${PASSWORD}
    Input Password    //input[@id='repeatedPassword' and @type='password']    ${PASSWORD}
    Click Element    //input[@value='Register']
    Wait Until Page Contains    Welcome ${username}    10s
    Close Browser

Execute Transfer
    [Arguments]    ${username_from}    ${username_to}    ${type}
    Open Browser    https://parabank.parasoft.com/parabank/    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //input[@name='username']
    Input Text    //input[@name='username']    ${username_from}
    Input Password    //input[@type='password']    ${PASSWORD}
    Click Element    //input[@value='Log In']
    Wait Until Page Contains Element    //a[text()='Transfer Funds']    10s
    Click Element    //a[text()='Transfer Funds']
    Wait Until Page Contains Element    //input[@id='amount']
    Input Text    //input[@id='amount']    10
    Select From List By Index    //select[@id='fromAccountId']    0
    Select From List By Index    //select[@id='toAccountId']    0
    Click Element    //input[@value='Transfer']
    # Ajouter des validations spécifiques selon le type de test (passant vs non passant) si nécessaire
    Wait Until Page Contains Element    //h1[@class='title' and text()='Transfer Complete!']
    Close Browser

Input User Details
    Input Text    //input[@id='customer.firstName']    Raphael
    Input Text    //input[@id='customer.lastName']    De Oliveira
    Input Text    //input[@id='customer.address.street']    20 rue de la fraternité
    Input Text    //input[@id='customer.address.city']    Paris
    Input Text    //input[@id='customer.address.state']    France
    Input Text    //input[@id='customer.address.zipCode']    91210
    Input Text    //input[@id='customer.phoneNumber']    0169584251
    Input Text    //input[@id='customer.ssn']    123-45-6789
