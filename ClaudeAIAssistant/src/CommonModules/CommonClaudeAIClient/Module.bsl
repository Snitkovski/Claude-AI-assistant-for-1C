#Region Public

Procedure Clear(Form) Export
	Form.ChatData.Clear();
	
	Form.NeedToAddGeneralPrompt = True;
	
	Form.ChatMessages = "";
EndProcedure

#EndRegion