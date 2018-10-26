The Tools Package contains developer's tools

System.Open ^
  Draw.Tool  NetSystem.Tool  IFS.Tool
  ET.Tool  BootLinker.Tool
  Math.Tool  Greek.Tool

Script.Open OpenType.Text

Decoder.Decode ^
Decoder.Find *  select PC in Trap

DiskSpace.Start  DiskSpace.Stop
DiskSpace.ShowMem ^ on off
DiskSpace.SetColor ^ 1 3 15

Info.Memory ^  select adr in Trap
Info.DeRef ^  select ptr in Trap
Info.ShowLibraries {textfile} ~
Info.ShowImports {objfile} ~
Info.ScanFilenames ^
Info.ShowModules

HSV.Show

Browser.ShowDef Log ~
Edit.Open Keyboard.Mod
