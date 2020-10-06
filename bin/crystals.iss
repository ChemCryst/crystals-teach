
#if "INW" == GetEnv('COMPCODE')
  #define crysOS 'win-int'
#elif "GID" == GetEnv('COMPCODE')
  #define crysOS 'win-dvf'
#else
  #define crysOS 'unknown'
#endif

#if "TRUE" == GetEnv('CROPENMP')
  #define crysOS 'win-int32-openmp'
#endif

#if "TRUE" == GetEnv('CR64BIT')
  #define crysOS 'win-int64-openmp'
#endif


#if Len(GetEnv('CRYSVNVER')) > 0
  #define crysSVN GetEnv('CRYSVNVER')
#else
  #define crysSVN 'xxxx'
#endif

#define crysDATE GetDateTimeString('mmmyy','','')
#define crysVDATE GetDateTimeString('mmm yyyy','','')

[Setup]
;
;Adjust the program names and version here as appropriate:
;
AppVerName=CRYSTALS-teach 1.{#crysSVN} ({#crysVDATE})
AppVersion=1.0.{#crysSVN}
OutputBaseFilename=crystals-teach-{#crysOS}-1.{#crysSVN}-{#crysDATE}-setup

PrivilegesRequired=none

AppName=CRYSTALS
OutputDir=..\installer
AppCopyright=Copyright (c) University of Oxford, {#crysVDATE}. All rights reserved.
AppPublisher=Chemical Crystallography Laboratory, University of Oxford
AppPublisherURL=http://www.xtl.ox.ac.uk/
BackSolid=0
ChangesAssociations=Yes

SolidCompression=yes
Compression=bzip

DisableDirPage=0
DisableStartupPrompt=yes
CreateAppDir=1
DisableProgramGroupPage=yes
Uninstallable=1
AllowNoIcons=0
DefaultDirName={autopf64}\crystals-teach
DefaultGroupName=Crystals Teach Version
;These files display during the installation:
DiskSpanning=0
WizardImageFile=..\bin\instimage.bmp
LicenseFile=..\bin\licence.txt
InfoAfterFile=..\bin\postinst.txt

[Dirs]
Name: {app}\Manual
Name: {app}\Script
Name: {autoappdata}\crystals\demo; Permissions: users-modify
Name: {app}\mce
Name: {app}\MCE\mce_manual_soubory

[Files]
Source: ..\build\*.*; DestDir: {app}\; Excludes: "make*,buildfile.bat,code.bat"; Flags: ignoreversion;
Source: ..\build\script\*.*; DestDir: {app}\script\; Excludes: "*~";
Source: ..\build\mce\*.*; DestDir: {app}\mce\;  Flags: ignoreversion recursesubdirs;
Source: ..\build\manual\*.*; DestDir: {app}\manual\; Flags: ignoreversion recursesubdirs;
Source: ..\build\demo\*; DestDir: {autoappdata}\crystals\demo\; Flags: recursesubdirs; Excludes: "*.doc"; Permissions: users-modify;

[Icons]
Name: "{userdesktop}\Crystals Teaching Version";                 Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0; Check: Not IsAdminInstallMode;
Name: "{userdesktop}\Crystals Getting Started"; Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"; Check: Not IsAdminInstallMode;
Name: "{commondesktop}\Crystals Teaching Version";                 Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0; Check: IsAdminInstallMode;
Name: "{commondesktop}\Crystals Getting Started"; Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"; Check: IsAdminInstallMode;

Name: "{group}\Crystals Teaching Version";                       Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0;
Name: "{group}\HTML help";                      Filename: "{app}\Manual\primer.html"; WorkingDir: "{app}"
Name: "{group}\Getting Started";                Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"
Name: "{group}\Uninstall CRYSTALS";             Filename: "{uninstallexe}";
Name: "{group}\Example structures";             Filename: "{autoappdata}\crystals\demo\"
Name: "{group}\Script folder";                  Filename: "{app}\script\";


[Code]

// see https://stackoverflow.com/questions/2000296/inno-setup-how-to-automatically-uninstall-previous-installed-version

/////////////////////////////////////////////////////////////////////
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\CRYSTALS_is1');
  sUnInstallString := '';
// We're only interested in uninstalling admin-installed copies, so only check HKLM.
//  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
//    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;


/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
    begin
      if (not IsAdminInstallMode) then   //Admin install will just overwrite, no problem.
        begin
          if (IsUpgrade()) then
            begin
  	// Ask the user a Yes/No question
              if MsgBox('Uninstall previous version of CRYSTALS?', mbConfirmation, MB_YESNO) = IDYES then
                begin
                // user clicked Yes
                  UnInstallOldVersion();
                end;
            end;
        end;
    end;
end;




[Registry]

Root: HKA32; Subkey: "Software\Chem Cryst"; Flags: uninsdeletekeyifempty
Root: HKA32; Subkey: "Software\Chem Cryst\CrystalsTeach"; Flags: uninsdeletekey

Root: HKA64; Subkey: "Software\Chem Cryst"; Flags: uninsdeletekeyifempty; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\CrystalsTeach"; Flags: uninsdeletekey; Check: IsWin64


Root: HKA32; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "Strdir"; ValueData: "{autoappdata}\crystals\demo\demo"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "FontHeight"; ValueData: "8"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "FontWidth"; ValueData: "0"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "FontFace"; ValueData: "Lucida Console"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "PLATONDIR"; ValueData: "{app}\platon.exe"; Flags: createvalueifdoesntexist

Root: HKA64; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "Strdir"; ValueData: "{autoappdata}\crystals\demo\demo"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "FontHeight"; ValueData: "8"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "FontWidth"; ValueData: "0"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "FontFace"; ValueData: "Lucida Console"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\CrystalsTeach"; ValueType: string; ValueName: "PLATONDIR"; ValueData: "{app}\platon.exe"; Flags: createvalueifdoesntexist; Check: IsWin64


Root: HKA32; SubKey: "Software\Classes\.dsc"; ValueType: STRING; ValueData: CrystalsFile; Flags: uninsdeletevalue
Root: HKA32; SubKey: "Software\Classes\CrystalsFile"; ValueType: STRING; ValueData: Crystals Data File; Flags: uninsdeletevalue
Root: HKA32; SubKey: "Software\Classes\CrystalsFile\Shell\Open\Command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1"""; Flags: uninsdeletevalue
Root: HKA32; SubKey: "Software\Classes\CrystalsFile\DefaultIcon"; ValueType: STRING; ValueData: {app}\crystals.exe,1; Flags: uninsdeletevalue

Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueType: STRING; ValueData: Open CrystalsTeach Here;  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1\crfilev2.dsc""";  Flags: uninsdeletekey; OnlyBelowVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; MinVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey; Check: IsWin64

Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals"; ValueType: STRING; ValueData: Open CrystalsTeach Here;  Flags: uninsdeletekey
Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1\crfilev2.dsc""";  Flags: uninsdeletekey; OnlyBelowVersion: 6.0
Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; MinVersion: 6.0
Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals"; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey

Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueType: STRING; ValueData: Open CrystalsTeach Here;  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1\crfilev2.dsc""";  Flags: uninsdeletekey; OnlyBelowVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; MinVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey; Check: IsWin64


Root: HKA32; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueType: STRING; ValueData: Open CrystalsTeach Here;  Flags: uninsdeletekey
Root: HKA32; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey
Root: HKA32; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey

Root: HKA64; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueType: STRING; ValueData: Open CrystalsTeach Here;  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey; Check: IsWin64
