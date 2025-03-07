#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CommonClaudeAI.OnCreateAtServer(ThisObject);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Clear(Command)
	CommonClaudeAIClient.Clear(ThisObject);
EndProcedure

&AtClient
Procedure Send(Command)
	If Not ValueIsFilled(QueryText) Then
		Return;
	EndIf;
	
	SendAtServer();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure SendAtServer()
	CommonClaudeAI.SendRequestAtServer(AIParameters, NeedToAddGeneralPrompt, ChatData, QueryText);
	CommonClaudeAI.UpdateChatMessages(ChatMessages, ChatData);
EndProcedure

#EndRegion