Script.Open System.Text
  click middle mouse button (or Ctrl) on 
  Script.Open above for introductory text

System.Open ^  System.Recall
  Edit.Tool  Script.Tool  Miscellaneous.Tool
  Compiler.Tool  Backup.Tool  Tools.Tool
  NetSystem.Tool  Partition.Tool  Hello.Mod

Edit.Open ^  Edit.Print LPT1 *
Edit.Show ^  Edit.Recall

Compiler.Compile *  Compiler.Compile *\s 
Compiler.Compile *\f  (select PC in Trap)
Browser.ShowDef ^  Browser.ShowObj ^

Script.Open ^  Script.Print LPT1 *
  UserGuide.Text  Feedback.Text  System.Text
Script.ChangeFont <fontname>

System.Directory ^
  *.Tool  *.Text  *.Pict  *.Scn.Fnt  *.Graph  
  *.Mod  *.Obj  *.Bak  *.Arc

Backup.Directory  Backup.DeleteFiles ^
Backup.ReadFiles ^  Backup.WriteFiles ^

Desktops.OpenDoc ^	requires Gadgets 
  System3.Tool  (TextDoc)  (LogDoc)
  http://www.oberon.ethz.ch/native/
Desktops.Open Oberon.Desk

System.CopyFiles => ~
System.RenameFiles => ~
System.DeleteFiles ~

System.ShowModules  System.Free ^
System.ShowCommands ^  System.State ^
System.ShowLibraries   System.FreeLibraries ^
System.ShowTasks  System.OpenKernelLog
System.Watch  System.Collect
System.Time ~ 25 12 95   13 10 0
!System.Reboot	!System.Quit
