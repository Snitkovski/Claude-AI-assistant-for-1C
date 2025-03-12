#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CommonClaudeAI.OnCreateAtServer(ThisObject);
EndProcedure

#EndRegion

#Region Private

#Region AIAssistant

&AtClient
Procedure AttachableCommand_AIAssistant()
	CommonClaudeAIClient.ShowHideAIAssistant(ThisObject);
EndProcedure

&AtClient
Procedure AttachableCommand_AIAssistantClear()
	CommonClaudeAIClient.Clear(ThisObject);
EndProcedure

&AtClient
Procedure AttachableCommand_AIAssistantCommandSendRequest()
	//@skip-check undefined-variable
	If Not ValueIsFilled(QueryText) Then
		Return;
	EndIf;
	
	AttachableCommand_AIAssistantCommandSendRequestAtServer();
EndProcedure

&AtServer
Procedure AttachableCommand_AIAssistantCommandSendRequestAtServer()
	CommonClaudeAI.SendRequestAtServer(ThisObject);
	CommonClaudeAI.UpdateChatMessages(ThisObject);
EndProcedure

#EndRegion

#EndRegion