Name EKW-checker
Icon "ekw.ico"
OutFile "ekw_checker_installer.exe"
InstallDir $APPDATA\EKW-checker

RequestExecutionLevel user

Section
    SetOutPath $INSTDIR

    # Files
    file ekw_checker.bat
    file ekw_checker.vbs
    file /r /x go /x __pycache__ rcc
    file ekw.png
    file ekw.ico

    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
	
	CreateDirectory "$SMPrograms\EKW-checker"
    CreateShortcut "$SMPrograms\EKW-checker\EKW-checker.lnk" "$INSTDIR\ekw-checker.vbs" "" "$INSTDIR\ekw.ico" 0
    CreateShortcut "$SMPrograms\EKW-checker\EKW-checker Uninstall.lnk" "$INSTDIR\uninstall.exe"
    CreateShortCut "$DESKTOP\EKW-checker.lnk" "$INSTDIR\ekw_checker.vbs" "" "$INSTDIR\ekw.ico" 0

    var /global Surname
    MessageBox MB_USERICON  "Please type the new owner's surname"
    nsDialogs::SelectFolderDialog "Please type the new owner's surname" "$DESKTOP"
    Pop $Surname

    var /global BankName
    MessageBox MB_USERICON  "Please type the new bank's name"
    nsDialogs::SelectFileDialog open "$BankName"
    Pop $Surname

    FileOpen $4 "$INSTDIR\rcc\settings.yaml" a
    FileSeek $4 0 END
    FileWrite $4 "Surname: $Surname"
    FileWrite $4 "$\r$\n" 
    FileWrite $4 "BankName: $BankName"
    FileClose $4

    ExecWait "$INSTDIR\rcc\rcc.exe task script -r $INSTDIR\rcc\robot.yaml -- pip list"

SectionEnd

Section "uninstall"
    Delete "$INSTDIR\uninstall.exe"
	
    Delete "$INSTDIR\ekw_checker.vbs"
	Delete "$INSTDIR\ekw_checker.bat"
	RMDir /R "$INSTDIR\rcc"
	RMDir /R "$INSTDIR"

	RMDir /R "$SMPrograms\EKW-checker\"
    Delete "$SMPROGRAMS\EKW-checker Uninstall.lnk"
    Delete "$SMPROGRAMS\EKW-checker.lnk"
    Delete "$DESKTOP\EKW-checker.lnk"

    RMDir $INSTDIR

SectionEnd
