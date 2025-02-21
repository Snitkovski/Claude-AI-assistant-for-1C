#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AIParameters = CommonClaudeAI.GetAIParameters();
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Clear(Command)
	ChatData.Clear();
	
	UpdateChatMessages();
EndProcedure

&AtClient
Procedure Send(Command)
	If Not ValueIsFilled(Object.QueryText) Then
		Return;
	EndIf;
	        
	SendAtServer();
EndProcedure

&AtClient
Procedure ImportToDB(Command)
	
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure SendAtServer()
	SendRequestAtServer();
	UpdateChatMessages();
EndProcedure

&AtServer
Procedure SendRequestAtServer()
	SSL = New OpenSSLSecureConnection(Undefined, New OSCertificationAuthorityCertificates());
	Connection = New HTTPConnection("api.anthropic.com", 443,,,,, SSL);
	
	// Prepare HTTP request
	Headers = New Map;
	Headers.Insert("anthropic-version", "2023-06-01");
	Headers.Insert("content-type", "application/json"); 
	Headers.Insert("x-api-key", AIParameters.API_Key);
	
	Messages = New Array;
	For Each Message In ChatData Do
		HistoryMessage = New Map;
		HistoryMessage.Insert("role", Message.Role);
		HistoryMessage.Insert("content", Message.Message);
		Messages.Add(HistoryMessage);
	EndDo;
	
	NewMessage = New Map;
	NewMessage.Insert("role", "user");
	NewMessage.Insert("content", Object.QueryText);
	Messages.Add(NewMessage);
	
	NewChatMessage = ChatData.Add();
	NewChatMessage.Role = "user";
	NewChatMessage.Message = Object.QueryText;
	
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
		
		CommonClaudeAI.UpdateUsageStatistics(ResponseData);
	EndIf;
	
	Object.QueryText = "";
EndProcedure

&AtServer
Procedure UpdateChatMessages()
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