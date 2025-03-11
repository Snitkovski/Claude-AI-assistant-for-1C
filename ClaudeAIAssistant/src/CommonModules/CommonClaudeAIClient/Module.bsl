#Region Public

Procedure ShowHideAIAssistant(Form) Export
	Form.Items.AIAssistantGroup.Visible = Not Form.Items.AIAssistantGroup.Visible;
EndProcedure

Procedure Clear(Form) Export
	Form.ChatData.Clear();
	
	Form.NeedToAddGeneralPrompt = True;
	
	Form.ChatMessages = "";
EndProcedure

#EndRegion