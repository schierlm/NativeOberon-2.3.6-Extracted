ET is a more advanced text editor for the basic Oberon system.
It adds additional functionality to the standard text editor.
	
ET.Open ^  |  ET.Show ^  |  ET.New  |  ET.Init *

ET.Left	ET.Right 	 [selection]
ET.Delete				   [selection]
ET.Recall					[insert last deletion]
	
ET.OpenLog				[extended log]
ET.OpenAscii ^		   [ascii file]

--- command execution ---
ET.Do Init		[Execute file with list of commands]
ET.Call Compiler.Compile "*\s" ~
ET.Call System.CopyFiles "* => s.*" ~

--- ET settings ---
ET.Popup on	 	ET.Popup off
ET.SetMenu default
ET.SetMenu user "System.Close System.Copy System.Grow ET.Search ET.Store"
ET.ReplaceSystemEditor		[make ET the default editor]

--- documentation ---
ET.Open ETGuide.Text
