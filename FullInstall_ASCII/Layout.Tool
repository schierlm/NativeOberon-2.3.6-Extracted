Desktops.OpenDoc LayoutEdit.Panel ~

Desktops.OpenDoc (LayoutPanels.NewDoc) ~

--- insert containers
LayoutPanels.InsertTable ^ 2 1		LayoutPanels.InsertPlace ^

--- table tools
LayoutPanels.AddRow ^ 0
LayoutPanels.AddRow ^ bottom	LayoutPanels.AddRow ^ top
LayoutPanels.AddRow @ lower	LayoutPanels.AddRow @ upper

LayoutPanels.DelRow ^ bottom	LayoutPanels.DelRow ^ top
LayoutPanels.DelRow ^ 0
LayoutPanels.DelRow @

LayoutPanels.AddCol ^ 0
LayoutPanels.AddCol ^ left	LayoutPanels.AddCol ^ right
LayoutPanels.AddCol @ left	LayoutPanels.AddCol @ right

LayoutPanels.DelCol ^ left	LayoutPanels.DelCol ^ right
LayoutPanels.DelCol ^ 0
LayoutPanels.DelCol @

---  shrink to fit
LayoutPanels.Minimize ^

--- sample panels
Desktops.OpenDoc LayoutSamples.Arc
