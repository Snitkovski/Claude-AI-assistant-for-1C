#Region Public

Procedure ShowHideAIAssistant(Form) Export
	Form.Items.AIAssistantGroup.Visible = Not Form.Items.AIAssistantGroup.Visible;
	Form.Items.FormAIAssistant.Check = Not Form.Items.FormAIAssistant.Check;
EndProcedure

Procedure Clear(Form) Export
	Form.ChatData.Clear();
	
	Form.NeedToAddGeneralPrompt = True;
	
	Form.ChatMessages = "<!DOCTYPE html><html><body></body></html>";
EndProcedure

#EndRegion