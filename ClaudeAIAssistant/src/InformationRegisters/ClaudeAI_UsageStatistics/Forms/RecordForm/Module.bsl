#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Cancel = True;
	MessageText = NStr("en = 'Users can not change data in this register.'");
	Message = New UserMessage;
	Message.Text = MessageText;
	Message.Message();
EndProcedure

#EndRegion
