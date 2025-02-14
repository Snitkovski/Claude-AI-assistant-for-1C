#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AIParameters = CommonClaudeAI.GetAIParameters();
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Clear(Command)
	Chat.Clear();
EndProcedure

&AtClient
Procedure Send(Command)
	If Not ValueIsFilled(Object.QueryText) Then
		Return;
	EndIf;
	        
	SendRequestAtServer();
EndProcedure

#EndRegion

#Region Private

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
	For Each Message In Chat Do
		HistoryMessage = New Map;
		HistoryMessage.Insert("role", Message.Role);
		HistoryMessage.Insert("content", Message.Message);
		Messages.Add(HistoryMessage);
	EndDo;
	
	NewMessage = New Map;
	NewMessage.Insert("role", "user");
	NewMessage.Insert("content", Object.QueryText);
	Messages.Add(NewMessage);
	
	NewChatMessage = Chat.Add();
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
	
	NewChatMessage = Chat.Add();
	NewChatMessage.Role = "assistant";
	NewChatMessage.Message = Response.GetBodyAsString();
EndProcedure

#EndRegion