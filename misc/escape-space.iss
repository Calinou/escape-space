#define MyAppName "Escape Space"
; Define MyAppVersion using /DMyAppVersion="x.y.z" on the command line
#define MyAppPublisher "Hugo Locurcio"
#define MyAppURL "https://github.com/Calinou/escape-space"
#define MyAppBaseName "escape-space"

[Setup]
AppId={{257DA64B-400E-40F6-B073-E796D34D9A79}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
; Don't add "version {version}" to the installed app name in the Add/Remove Programs menu
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={localappdata}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
UninstallDisplayIcon={app}\{#MyAppBaseName}.exe
OutputDir=..\..
#ifdef App32Bit
  OutputBaseFilename={#MyAppBaseName}-{#MyAppVersion}-setup-x86
#else
  OutputBaseFilename={#MyAppBaseName}-{#MyAppVersion}-setup-x86_64
  ArchitecturesAllowed=x64
  ArchitecturesInstallIn64BitMode=x64
#endif
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#MyAppBaseName}.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppBaseName}.pck"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppBaseName}.exe"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppBaseName}.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppBaseName}.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
