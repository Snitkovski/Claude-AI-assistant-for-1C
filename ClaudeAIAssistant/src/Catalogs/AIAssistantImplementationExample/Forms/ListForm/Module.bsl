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

#EndRegion

#EndRegion