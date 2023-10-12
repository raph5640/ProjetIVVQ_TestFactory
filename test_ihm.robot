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

Effectuer_un_transfert_dargent_cas_passant
    Execute Transfer    ${USERNAME_A}    ${USERNAME_B}    passant

Effectuer_un_transfert_dargent_cas_non_passant
    Execute Transfer    ${USERNAME_A}    ${USERNAME_B}    non_passant

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
    Set Timestamp And Usernames
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
    Click Element    //a[text()='Open New Account']
    Sleep    1s
    Wait Until Page Contains    Open New Account
    Sleep    2s
    Click Element    //input[@value='Open New Account']
    Wait Until Page Contains    Account Opened!    30s
    Sleep    2s
    # Navigate to Transfer Funds
    Click Element    //a[text()='Transfer Funds']
    Sleep    1s
    Wait Until Page Contains Element    //input[@id='amount']
    ${amount_to_transfer}=    Set Variable If    "${type}" == "non_passant"    ${EMPTY}    10
    Input Text    //input[@id='amount']    ${amount_to_transfer}
    Select From List By Index    //select[@id='fromAccountId']    0
    Select From List By Index    //select[@id='toAccountId']    1
    Click Element    //input[@value='Transfer']
    Run Keyword If    "${type}" == "passant"    Verify Transfer Completed Successfully
    Run Keyword If    "${type}" == "non_passant"    Verify Error Message Displayed
    Close Browser

Verify Transfer Completed Successfully
    Wait Until Page Contains    Transfer Complete

Verify Error Message Displayed
    Wait Until Page Contains    The amount cannot be empty.

Input User Details
    Input Text    //input[@id='customer.firstName']    Raphael
    Input Text    //input[@id='customer.lastName']    De Oliveira
    Input Text    //input[@id='customer.address.street']    20 rue de la fraternité
    Input Text    //input[@id='customer.address.city']    Paris
    Input Text    //input[@id='customer.address.state']    France
    Input Text    //input[@id='customer.address.zipCode']    91210
    Input Text    //input[@id='customer.phoneNumber']    0169584251
    Input Text    //input[@id='customer.ssn']    123-45-6789
