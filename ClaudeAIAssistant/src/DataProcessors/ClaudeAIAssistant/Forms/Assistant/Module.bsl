#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AIParameters = CommonClaudeAICached.GetAIParameters();
	NeedToAddGeneralPrompt = True;

	AIAssistantUpdateAtServer();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "AI_Assistant_Update" And Source <> ThisObject Then
		AIAssistantUpdateAtServer();
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
	AdditionalContextDataOnChangeAtServer();
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure AdditionalContextDataContextOnChange(Item)
	AdditionalContextDataOnChangeAtServer();
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Clear(Command)
	CommonClaudeAIClient.Clear(ThisObject);
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure Send(Command)
	If Not ValueIsFilled(QueryText) Then
		Return;
	EndIf;
	
	SendAtServer();
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure ClearAdditionalContext(Command)
	CommonClaudeAIClient.ClearAdditionalContext(ThisObject);
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure SendAtServer()
	CommonClaudeAI.SendRequestAtServer(ThisObject);
	CommonClaudeAI.UpdateChatMessages(ThisObject);
EndProcedure

&AtServer
Procedure AdditionalContextDataOnChangeAtServer()
	CommonClaudeAI.WriteChatHistory(ThisObject);
EndProcedure

&AtServer
Procedure AIAssistantUpdateAtServer()
	ChatHistoryData = CommonClaudeAI.GetChatHistoryDataByUser(CommonClaudeAICached.GetCurrentUser());
	
	If ChatHistoryData.ChatHistory <> Undefined Then
		ChatData.Load(ChatHistoryData.ChatHistory);
		CommonClaudeAI.UpdateChatMessages(ThisObject);
	EndIf;
	
	If ChatHistoryData.AdditionalContext <> Undefined Then
		AdditionalContext.Load(ChatHistoryData.AdditionalContext);
	EndIf;
EndProcedure

#EndRegion