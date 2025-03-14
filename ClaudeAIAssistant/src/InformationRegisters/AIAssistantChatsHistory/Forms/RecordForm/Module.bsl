#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Cancel = True;
	StandardProcessing = False;
	
	MessageText = NStr("en = 'You can''t open this form manually'");
	Message(MessageText);
EndProcedure

#EndRegion
