# AICAD2 Project Memory

## Project Location
C:\Users\ys199\Desktop\AICAD2

## Solution
AICAD2.sln — three projects:
- AICAD.Core (netstandard2.0): shared contracts, pipe protocol, action model
- AICAD.Desktop (net8.0-windows, WPF): floating chat window, AI API client, pipe client
- AICAD.AutoCAD (net48): AutoCAD 2018 plugin, pipe server, drawing executor

## Key Architecture
- Named pipe: AICAD2.Pipe (default). Desktop=client, AutoCAD plugin=server.
- Pipe message types: Ping, GetSelectionSummary, ExecuteAction
- AicadActionPlan dispatched via switch in ActionExecutionService inside LockDocument + transaction
- Selection: SelectionContextService tries PickFirst then SelectImplied
- Config: %AppData%\AICAD2\appsettings.json (seeded from AICAD_API_KEY, AICAD_API_URL, AICAD_MODEL env vars)

## AutoCAD Install (this machine)
D:\Autodesk\CAD2018\AutoCAD 2018

## Build Commands (from repo root)
### Desktop
dotnet publish .\src\AICAD.Desktop\AICAD.Desktop.csproj -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true
Output: src\AICAD.Desktop\bin\Release\net8.0-windows\win-x64\publish\AICAD.Desktop.exe

### Plugin
dotnet build .\src\AICAD.AutoCAD\AICAD.AutoCAD.csproj -c Release [/p:AutoCADSdkDir="D:\Autodesk\CAD2018\AutoCAD 2018"]
Output: src\AICAD.AutoCAD\bin\Release\net48\AICAD.AutoCAD.dll

### Register bundle
.\scripts\Register-AICADBundle.ps1 -PluginBuildDirectory ".\src\AICAD.AutoCAD\bin\Release\net48"

## Runtime Paths
- Desktop config: %AppData%\AICAD2\appsettings.json
- Desktop log: %LocalAppData%\AICAD2\desktop.log
- Plugin log: %LocalAppData%\AICAD2\autocad-plugin.log
- Bundle: %ProgramData%\Autodesk\ApplicationPlugins\AICAD.bundle

## Current Status (updated)
- SelectionContextService now subscribes to Editor.SelectionAdded/SelectionRemoved events
- Selection is cached eagerly at event time (on AutoCAD main thread, before user switches focus)
- GetSelectionSummary fast path: TryGetEagerSummary() returns cached summary without any context dispatch
- Build confirmed: 0 warnings, 0 errors
- Primary fix for selectedCount=0 instability is deployed
- Next step: register bundle, NETLOAD in AutoCAD, verify logs show "selection cached via event" then "served from eager cache"

## Known Constraints
- ChangeTextWidthFactor: DBText only, MText has no equivalent
- ReplaceText on MText uses Contents field — needs real-device validation
- Plugin targets net48, cannot use .NET 5+ APIs
