#Region Public

Procedure ShowHideAIAssistant(Form) Export
	Form.Items.AIAssistantGroup.Visible = Not Form.Items.AIAssistantGroup.Visible;
	Form.Items.FormAIAssistant.Check = Not Form.Items.FormAIAssistant.Check;
EndProcedure

Procedure Clear(Form) Export
	Form.ChatData.Clear();
	
	Form.NeedToAddGeneralPrompt = True;
	
	Form.ChatMessages = "<!DOCTYPE html><html><body></body></html>";
	
	CommonClaudeAIServerCall.WriteChatHistory();
EndProcedure

Procedure ChatMessagesOnClick(Item, EventData, StandardProcessing) Export
	StandardProcessing = False;
	If EventData.Href <> Undefined Then
		RunAppAsync(EventData.Href);
	EndIf;
EndProcedure

Procedure AdditionalContextDataDrag(Form, DragParameters, StandardProcessing) Export
	StandardProcessing = False;
	
	For Each ContextObject In DragParameters.Value Do
		AdditionalContextRow = Form.AdditionalContext.Add();
		AdditionalContextRow.Context = ContextObject;
	EndDo;
EndProcedure

Procedure ClearAdditionalContext(Form) Export
	Form.AdditionalContext.Clear();
EndProcedure

#EndRegion