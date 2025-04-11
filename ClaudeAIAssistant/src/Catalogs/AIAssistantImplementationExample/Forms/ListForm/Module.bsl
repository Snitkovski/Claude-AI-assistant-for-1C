#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CommonClaudeAI.OnCreateAtServer(ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "AI_Assistant_Update" And Source <> ThisObject Then
		AIAssistantUpdateAtServer();
	EndIf;
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
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure AttachableCommand_AIAssistantCommandSendRequest()
	If Not ValueIsFilled(ThisObject.QueryText) Then
		Return;
	EndIf;
	
	AttachableCommand_AIAssistantCommandSendRequestAtServer();
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtServer
Procedure AttachableCommand_AIAssistantCommandSendRequestAtServer()
	CommonClaudeAI.SendRequestAtServer(ThisObject);
	CommonClaudeAI.UpdateChatMessages(ThisObject);
EndProcedure

&AtClient
Procedure Attachable_ChatMessagesOnClick(Item, EventData, StandardProcessing)
	CommonClaudeAIClient.ChatMessagesOnClick(Item, EventData, StandardProcessing);
EndProcedure

&AtClient
Procedure AttachableCommand_AIAssistantClearAdditionalContext(Command)
	CommonClaudeAIClient.ClearAdditionalContext(ThisObject);
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure Attachable_AdditionalContextDataDrag(Item, DragParameters, StandardProcessing, Row, Field)
	CommonClaudeAIClient.AdditionalContextDataDrag(ThisObject, DragParameters, StandardProcessing);
	Attachable_AdditionalContextDataOnChangeAtServer();
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure Attachable_AdditionalContextDataContextOnChange(Item)
	Attachable_AdditionalContextDataOnChangeAtServer();
	Notify("AI_Assistant_Update",, ThisObject);
EndProcedure

&AtClient
Procedure Attachable_AdditionalContextDataContextStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	CurrentData = Items.AIAssistantAdditionalContextTable.CurrentData;
	
	If TypeOf(CurrentData.Context) = Type("String") Then
		StandardProcessing = False;
		
		Handler = New NotifyDescription("AIAssistantAddFileToContextAfterFileSelection", ThisObject);
		CommonClaudeAIClient.OpenFileDialog(Handler);
	EndIf;
EndProcedure

&AtServer
Procedure Attachable_AdditionalContextDataOnChangeAtServer()
	CommonClaudeAI.WriteChatHistory(ThisObject);
EndProcedure

&AtServer
Procedure AIAssistantUpdateAtServer()
	CommonClaudeAI.AIAssistantUpdateAtServer(ThisObject);
EndProcedure

&AtClient
Procedure AIAssistantAddFileToContextAfterFileSelection(SelectedFiles, AdditionalParameters) Export
	CommonClaudeAIClient.AddFileToAdditionalContext(SelectedFiles, Items);
EndProcedure

#EndRegion

#EndRegion