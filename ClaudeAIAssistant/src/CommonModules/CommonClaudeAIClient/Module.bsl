#Region Public

Procedure Clear(Form) Export
	Form.ChatData.Clear();
	
	Form.NeedToAddGeneralPrompt = True;
	
	Form.ChatMessages = "";
EndProcedure

Procedure Send(Form) Export
	If Not ValueIsFilled(Form.QueryText) Then
		Return;
	EndIf;
	        
	CommonClaudeAIServerCall.Send(Form.AIParameters, Form.NeedToAddGeneralPrompt, Form.ChatData, Form.ChatMessages, Form.QueryText);
EndProcedure

#EndRegion