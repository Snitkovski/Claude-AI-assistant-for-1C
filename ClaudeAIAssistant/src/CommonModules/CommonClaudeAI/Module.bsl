#Region Public

Function GetAIParameters() Export
	AIParameters = New Structure;
	
	AIParameters.Insert("API_Key", Constants.API_Key.Get());
	AIParameters.Insert("Max_Tokens", Constants.Max_Tokens.Get());
	AIParameters.Insert("Model", Constants.Model.Get());

	Return AIParameters;
EndFunction

Procedure UpdateUsageStatistics(ResponseData) Export	Record = InformationRegisters.ClaudeAI_UsageStatistics.CreateRecordManager();
	Record.Period = CurrentSessionDate();
	Record.User = UserFullName();
	Record.InputTokens = ResponseData.usage.output_tokens;
	Record.OutputTokens = ResponseData.usage.input_tokens;
	Try
		Record.Write();
	Except
		Message = New UserMessage;
		Message.Text = ErrorDescription();
		Message.Message();
	
		WriteLogEvent("UpdateUsageStatistics", EventLogLevel.Error, , , ErrorDescription());	
	EndTry;
EndProcedure

#EndRegion