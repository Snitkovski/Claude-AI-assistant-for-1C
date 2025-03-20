#Region Public

Function GetAIParameters() Export
	AIParameters = New Structure;
	
	AIParameters.Insert("API_Key", Constants.API_Key.Get());
	AIParameters.Insert("Max_Tokens", Constants.Max_Tokens.Get());
	AIParameters.Insert("Model", Constants.Model.Get());

	Return AIParameters;
EndFunction

Function GetCurrentUser() Export
	Return UserFullName();
EndFunction

#EndRegion