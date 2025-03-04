#Region Public

Procedure Send(AIParameters, NeedToAddGeneralPrompt, ChatData, ChatMessages, QueryText) Export
	CommonClaudeAI.SendRequestAtServer(AIParameters, NeedToAddGeneralPrompt, ChatData, QueryText);
	CommonClaudeAI.UpdateChatMessages(ChatMessages, ChatData);
EndProcedure

#EndRegion