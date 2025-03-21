#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AIParameters = CommonClaudeAICached.GetAIParameters();
	NeedToAddGeneralPrompt = True;
	
	ChatHistoryData = CommonClaudeAI.GetChatHistoryDataByUser(CommonClaudeAICached.GetCurrentUser());
	If ChatHistoryData <> Undefined Then
		ChatData.Load(ChatHistoryData);
		CommonClaudeAI.UpdateChatMessages(ThisObject);
	EndIf;
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ChatMessagesOnClick(Item, EventData, StandardProcessing)
	CommonClaudeAIClient.ChatMessagesOnClick(Item, EventData, StandardProcessing);
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlersAdditionalContextData

&AtClient
Procedure AdditionalContextDataDrag(Item, DragParameters, StandardProcessing, Row, Field)
	CommonClaudeAIClient.AdditionalContextDataDrag(ThisObject, DragParameters, StandardProcessing);
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
	CommonClaudeAI.SendRequestAtServer(ThisObject);
	CommonClaudeAI.UpdateChatMessages(ThisObject);
EndProcedure

#EndRegion