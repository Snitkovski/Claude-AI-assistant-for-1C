#Region Public

Function GetAIParameters() Export
	AIParameters = New Structure;
	
	AIParameters.Insert("API_Key", Constants.API_Key.Get());
	AIParameters.Insert("Max_Tokens", Constants.Max_Tokens.Get());
	AIParameters.Insert("Model", Constants.Model.Get());

	Return AIParameters;
EndFunction

Function GetUserAdditionalPrompts(User) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	UsersAdditionalPrompts.Prompt.Prompt AS Prompt
		|FROM
		|	InformationRegister.UsersAdditionalPrompts AS UsersAdditionalPrompts
		|WHERE
		|	UsersAdditionalPrompts.User = &User";
	
	Query.SetParameter("User", User);
	
	QueryResult = Query.Execute();
	
	Return QueryResult.Select();
EndFunction

#EndRegion