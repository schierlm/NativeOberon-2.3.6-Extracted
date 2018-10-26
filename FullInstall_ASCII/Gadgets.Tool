Gadgets - Commands for manipulating Gadgets

Gadgets.Insert view ~	insert visual gadget at caret
Gadgets.Insert view model ~	insert visual/model gadget pair
Gadgets.Insert ^	insert selected view/model pair
	Button ~  Panel ~  TextField Integer ~
	Slider Integer ~  BasicGadgets.NewButton ~
  
Gadgets.Copy	insert deep copy of the selection at caret
Gadgets.Change view ~	change type of selected gadget
Gadgets.Link model ~	link selection to new model

Gadgets.ChangeAttr attr val ~	change/define attribute
Gadgets.ChangeAttr ^	change/define selected attribute
	Value "Hello World" ~  Value Yes ~  Value No ~
	Color 1 ~  Caption "Open" ~  Name X ~
	Cmd  "Desktops.OpenDoc Gadgets.Panel" ~

Watson.ShowDef Gadgets	module documentation

"view" and "model" are object generator names or aliases.
See Gadgets.Aliases in Oberon.Text for a list of aliases.
