#Region Public

Procedure OnCreateAtServer(Form) Export
	Form.AIParameters = GetAIParameters();
	
	Form.NeedToAddGeneralPrompt = True;
EndProcedure

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

Procedure SendRequestAtServer(AIParameters, NeedToAddGeneralPrompt, ChatData, QueryText) Export
	SSL = New OpenSSLSecureConnection(Undefined, New OSCertificationAuthorityCertificates());
	Connection = New HTTPConnection("api.anthropic.com", 443,,,,, SSL);
	
	// Prepare HTTP request
	Headers = New Map;
	Headers.Insert("anthropic-version", "2023-06-01");
	Headers.Insert("content-type", "application/json"); 
	Headers.Insert("x-api-key", AIParameters.API_Key);
	
	If NeedToAddGeneralPrompt Then
		NeedToAddGeneralPrompt = False;		
		GeneralPrompt = CommonClaudeAIOverridable.GetGeneralPrompt();
		
		If ValueIsFilled(GeneralPrompt) Then
			NewChatMessage = ChatData.Add();
			NewChatMessage.Role = "user";
			NewChatMessage.Message = GeneralPrompt;
			NewChatMessage.Predefined = True;
		EndIf;
	EndIf;
	
	Messages = New Array;
	
	For Each Message In ChatData Do
		HistoryMessage = New Map;
		HistoryMessage.Insert("role", Message.Role);
		HistoryMessage.Insert("content", Message.Message);
		Messages.Add(HistoryMessage);
	EndDo;
	
	NewMessage = New Map;
	NewMessage.Insert("role", "user");
	NewMessage.Insert("content", QueryText + ". Your answer must be in html format");
	Messages.Add(NewMessage);
	
	NewChatMessage = ChatData.Add();
	NewChatMessage.Role = "user";
	NewChatMessage.Message = QueryText;
	
	Data = New Structure;
	Data.Insert("model", AIParameters.Model);
	Data.Insert("max_tokens", AIParameters.Max_Tokens); 
	Data.Insert("messages", Messages); 
	
	JSONWriter = New JSONWriter;            
	JSONWriter.SetString();
	WriteJSON(JSONWriter, Data);            
	RequestBody = JSONWriter.Close(); 
	
	Request = New HTTPRequest("/v1/messages", Headers);
	Request.SetBodyFromString(RequestBody);
	
	Response = Connection.CallHTTPMethod("POST", Request);
	
	AIAnswer = Response.GetBodyAsString();

	JSONReader = New JSONReader;
	JSONReader.SetString(AIAnswer);
	ResponseData = ReadJSON(JSONReader);
	JSONReader.Close();
	
	NewChatMessage = ChatData.Add();
	NewChatMessage.Role = "assistant";
	
	If ResponseData.Property("error") Then
		NewChatMessage.Message = ResponseData.error.message;
	Else
		NewChatMessage.Message = ResponseData.content[0].text;
		
		UpdateUsageStatistics(ResponseData);
	EndIf;
	
	QueryText = "";
EndProcedure

Procedure UpdateChatMessages(ChatMessages, ChatData) Export
	ChatMessages = "<!DOCTYPE html> <html><body>";
	ChatMessageTemplate = "<table><tbody><tr>
							|<td align=""center""><img height = ""%1"" width = ""%2"" src=""data:image/jpg;base64,%3""/></td>
							|<td align=""justify"" bgcolor = ""%4""><p>%5</p></td>
							|</tr></tbody></table>";
	
	For Each Message In ChatData Do
		If Message.Predefined Then
			Continue;
		EndIf;
		
		If Message.Role = "user" Then
			PicData = PictureLib.UserWithoutPhoto.GetBinaryData();
			PicData = Base64String(PicData);
			MessageText = StrTemplate(ChatMessageTemplate, "44", "32", PicData, "#ccffcc", Message.Message);
		Else
			PicData = PictureLib.ClaudeAILogo.GetBinaryData();
			PicData = Base64String(PicData);
			MessageText = StrTemplate(ChatMessageTemplate, "32", "32", PicData, "#ffcc99", Message.Message);
		EndIf;
		
		ChatMessages = ChatMessages + MessageText;
	EndDo;
	
	ChatMessages = ChatMessages + "</body></html>";
EndProcedure

#EndRegion