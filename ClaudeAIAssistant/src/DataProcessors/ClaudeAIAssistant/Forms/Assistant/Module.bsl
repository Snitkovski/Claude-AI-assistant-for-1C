#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AIParameters = CommonClaudeAICached.GetAIParameters();
	NeedToAddGeneralPrompt = True;
	Items.Navigation.Enabled = False;
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ChatMessagesOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = False;
	If EventData.Href <> Undefined Then
		RunAppAsync(EventData.Href);
	EndIf;
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