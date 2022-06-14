*** Settings ***
Documentation     This is the bot to check if the new owner and mortgage have been signed into mortgage register
Library           RPA.Browser.Selenium    timeout=90s    implicit_wait=90s
Library           lib/helpers.py
Library           lib/notifications.py
Variables         settings.yaml

*** Keywords ***
Log Into EKW
    Open Available Browser    ${EKWURL}    headless=${False}
    Input Text When Element Is Visible    //*[@id="kodWydzialuInput"]    ${DepartmentCode}  
    Input Text When Element Is Visible    //*[@id="numerKsiegiWieczystej"]    ${KWNumber}  
    Input Text When Element Is Visible    //*[@id="cyfraKontrolna"]    ${ControlDigit}  
    Click Element When Visible    //*[@id="wyszukaj"]    

    
Check for new owner entry
    Click Element When Visible    //input[@alue="Dział II"] 
    Wait Until Page Contains Element    //*[@id="contentDzialu"]
    ${containsSurname}=    Does Page Contain    ${Surname}
    [Return]    ${containsSurname}


Check for new mortgage entry
    Click Element When Visible    //input[@alue="Dział IV"] 
    Wait Until Page Contains Element    //*[@id="contentDzialu"]
    ${containsBankName}=    Does Page Contain    ${BankName}
    [Return]    ${containsBankName}


CHeck the EKW   
    Log into EKW
    Wait Until Page Contains Element    //*[@id="content-wrapper"]
    Click Element When Visible    //*[@id="przyciskWydrukZwykly"]   
    ${containsSurname}=    Check for new owner entry
    ${containsBankName}=    Check for new mortgage entry
    [Return]    ${containsSurname}    ${containsBankName}


Teardown
    [Arguments]    ${taskCompleted}    ${containsSurname}    ${containsBankName} 
    IF    ${taskCompleted} == ${True}
        Show Status Notification
    ELSE
        Show Status Notification    ${False}
    END
    Close Browser

*** Tasks ***
EKW-checker
    Show Start Notification
    ${taskCompleted}=    Set Variable    ${False}
    ${containsSurname}    ${containsBankName}=    CHeck the EKW
    ${taskCompleted}=    Set Variable    ${True}
    [Teardown]    Teardown    ${taskCompleted}    ${containsSurname}   ${containsBankName}