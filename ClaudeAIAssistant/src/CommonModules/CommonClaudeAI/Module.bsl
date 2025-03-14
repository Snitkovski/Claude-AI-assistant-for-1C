#Region Public

Procedure OnCreateAtServer(Form) Export
	NewFormAttibutes = New Array;
	
	AIParameters = New FormAttribute("AIParameters", New TypeDescription("Undefined"));
	NewFormAttibutes.Add(AIParameters);
	
	ChatMessages = New FormAttribute("ChatMessages", New TypeDescription("String"));
	NewFormAttibutes.Add(ChatMessages);
	
	NeedToAddGeneralPrompt = New FormAttribute("NeedToAddGeneralPrompt", New TypeDescription("Boolean"));
	NewFormAttibutes.Add(NeedToAddGeneralPrompt);
	
	QueryText = New FormAttribute("QueryText", New TypeDescription("String"));
	NewFormAttibutes.Add(QueryText);
	
	ChatData = New FormAttribute("ChatData", New TypeDescription("ValueTable"));
	NewFormAttibutes.Add(ChatData);
	
	ChatDataRole = New FormAttribute("Role", New TypeDescription("String"), "ChatData", "Role");
	NewFormAttibutes.Add(ChatDataRole);
	
	ChatDataMessage = New FormAttribute("Message", New TypeDescription("String"), "ChatData", "Message");
	NewFormAttibutes.Add(ChatDataMessage);
	
	ChatDataPredefined = New FormAttribute("Predefined", New TypeDescription("Boolean"), "ChatData", "Predefined");
	NewFormAttibutes.Add(ChatDataPredefined);
	
	Form.ChangeAttributes(NewFormAttibutes);
		
	If Form.Items.Find("MainGroup") = Undefined Then
		MainGroup = Form.Items.Add("MainGroup", Type("FormGroup"));
		MainGroup.Type = FormGroupType.UsualGroup;
		MainGroup.ShowTitle = False;
		MainGroup.Representation = UsualGroupRepresentation.None;
		MainGroup.Group = ChildFormItemsGroup.Horizontal;
		
		If Form.Items.Find("MainObjectGroup") = Undefined Then
			MainObjectGroup = Form.Items.Add("MainObjectGroup", Type("FormGroup"), MainGroup);
			MainObjectGroup.Type = FormGroupType.UsualGroup;
			MainObjectGroup.ShowTitle = False;
			MainObjectGroup.Representation = UsualGroupRepresentation.None;
			MainObjectGroup.Group = Form.Group;

			For Each Item In Form.Items Do
				If Item.Parent = Form Then
					Form.Items.Move(Item, MainObjectGroup);
				EndIf;
			EndDo;
		EndIf;
	EndIf;
	
	AIAssistantCommand = Form.Commands.Add("AIAssistant");
	AIAssistantCommand.Action = "AttachableCommand_AIAssistant";
	AIAssistantCommand.Title = NStr("en = 'AI assistant'");
	AIAssistantCommand.Representation = ButtonRepresentation.PictureAndText;
	If Form.Items.Find("GroupGlobalCommands") <> Undefined Then
		AIAssistantButton = Form.Items.Add("FormAIAssistant", Type("FormButton"), Form.Items.GroupGlobalCommands);
	Else
		AIAssistantButton = Form.Items.Add("FormAIAssistant", Type("FormButton"), Form.Items.AIAssistant);
	EndIf;
	AIAssistantButton.CommandName = "AIAssistant";
	AIAssistantButton.Picture = PictureLib.ClaudeAILogo;
	
	AIAssistantGroup = Form.Items.Add("AIAssistantGroup", Type("FormGroup"), MainGroup);
	AIAssistantGroup.Type = FormGroupType.UsualGroup;
	AIAssistantGroup.ShowTitle = False;
	AIAssistantGroup.Representation = UsualGroupRepresentation.None;
	AIAssistantGroup.Group = ChildFormItemsGroup.Vertical;
	AIAssistantGroup.Visible = False;
	AIAssistantGroup.Width = 15;
	
	AIAssistantHeaderGroup = Form.Items.Add("AIAssistantHeaderGroup", Type("FormGroup"), AIAssistantGroup);
	AIAssistantHeaderGroup.Type = FormGroupType.UsualGroup;
	AIAssistantHeaderGroup.ShowTitle = False;
	AIAssistantHeaderGroup.Representation = UsualGroupRepresentation.None;
	AIAssistantHeaderGroup.Group = ChildFormItemsGroup.Horizontal;
	
	AIAssistantHeaderPicture = Form.Items.Add("AIAssistantHeaderPicture", Type("FormDecoration"), AIAssistantHeaderGroup);
	AIAssistantHeaderPicture.Type = FormDecorationType.Picture;
    AIAssistantHeaderPicture.Picture = PictureLib.ClaudeAILogo;
    AIAssistantHeaderPicture.Width = 2;
    AIAssistantHeaderPicture.Height = 1;
    AIAssistantHeaderPicture.HorizontalStretch = False;
    AIAssistantHeaderPicture.VerticalStretch = False;
    AIAssistantHeaderPicture.AutoMaxWidth = False;
    AIAssistantHeaderPicture.AutoMaxHeight = False;
    AIAssistantHeaderPicture.PictureSize = PictureSize.Proportionally;
    
    AIAssistantHeaderLabel = Form.Items.Add("AIAssistantHeaderLabel", Type("FormDecoration"), AIAssistantHeaderGroup);
	AIAssistantHeaderLabel.Type = FormDecorationType.Label;
	AIAssistantHeaderLabel.Title = NStr("en = 'How can AI assistant helps you today?'");
	AIAssistantHeaderLabel.Font = StyleFonts.LargeTextFont;
	
	AIAssistantCommandBar = Form.Items.Add("AIAssistantCommandBar", Type("FormGroup"), AIAssistantGroup);
	AIAssistantCommandBar.Type = FormGroupType.CommandBar;
	
	AIAssistantCommandClear = Form.Commands.Add("AIAssistantCommandClear");
	AIAssistantCommandClear.Action = "AttachableCommand_AIAssistantClear";
	AIAssistantCommandClear.Title = NStr("en = 'Clear'");
	AIAssistantCommandClear.Representation = ButtonRepresentation.PictureAndText;
	
	AIAssistantButtonClear = Form.Items.Add("AIAssistantClear", Type("FormButton"), Form.Items.AIAssistantCommandBar);
	AIAssistantButtonClear.CommandName = "AIAssistantCommandClear";
	AIAssistantButtonClear.Picture = PictureLib.InputFieldClear;
	AIAssistantButtonClear.Enabled = True;
	
	AIAssistantChatMessages = Form.Items.Add("AIAssistantChatMessages", Type("FormField"), AIAssistantGroup);
	AIAssistantChatMessages.Type = FormFieldType.HTMLDocumentField;
	AIAssistantChatMessages.DataPath = "ChatMessages";
	AIAssistantChatMessages.ReadOnly = True;
	AIAssistantChatMessages.TitleLocation = FormItemTitleLocation.None;
	AIAssistantChatMessages.SetAction("OnClick", "Attachable_ChatMessagesOnClick");
	
	AIAssistantCurrentMessageGroup = Form.Items.Add("AIAssistantCurrentMessageGroup", Type("FormGroup"), AIAssistantGroup);
	AIAssistantCurrentMessageGroup.Type = FormGroupType.UsualGroup;
	AIAssistantCurrentMessageGroup.ShowTitle = False;
	AIAssistantCurrentMessageGroup.Representation = UsualGroupRepresentation.None;
	AIAssistantCurrentMessageGroup.Group = ChildFormItemsGroup.Horizontal;
	
	AIAssistantCurrentMessage = Form.Items.Add("AIAssistantCurrentMessage", Type("FormField"), AIAssistantCurrentMessageGroup);
	AIAssistantCurrentMessage.Type = FormFieldType.InputField;
	AIAssistantCurrentMessage.DataPath = "QueryText";
	AIAssistantCurrentMessage.ReadOnly = False;
	AIAssistantCurrentMessage.TitleLocation = FormItemTitleLocation.Top;
	AIAssistantCurrentMessage.Title = NStr("en = 'Your message'");
	AIAssistantCurrentMessage.MultiLine = True;
	
	AIAssistantCommandSendRequest = Form.Commands.Add("AIAssistantCommandSendRequest");
	AIAssistantCommandSendRequest.Action = "AttachableCommand_AIAssistantCommandSendRequest";
	AIAssistantCommandSendRequest.Title = NStr("en = 'Send'");
	AIAssistantCommandSendRequest.Representation = ButtonRepresentation.PictureAndText;

	AIAssistantButtonSendRequest = Form.Items.Add("AIAssistantButtonSendRequest", Type("FormButton"), Form.Items.AIAssistantCurrentMessageGroup);
	AIAssistantButtonSendRequest.CommandName = "AIAssistantCommandSendRequest";
	AIAssistantButtonSendRequest.Picture = PictureLib.SendMessage;
	AIAssistantButtonSendRequest.Enabled = True;
	
	Form.AIParameters = CommonClaudeAICached.GetAIParameters();
	
	Form.NeedToAddGeneralPrompt = True;
EndProcedure

Procedure UpdateUsageStatistics(ResponseData) Export
	Record = InformationRegisters.ClaudeAI_UsageStatistics.CreateRecordManager();
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

Procedure SendRequestAtServer(Form) Export
	SSL = New OpenSSLSecureConnection(Undefined, New OSCertificationAuthorityCertificates());
	Connection = New HTTPConnection("api.anthropic.com", 443,,,,, SSL);
	
	// Prepare HTTP request
	Headers = New Map;
	Headers.Insert("anthropic-version", "2023-06-01");
	Headers.Insert("content-type", "application/json"); 
	Headers.Insert("x-api-key", Form.AIParameters.API_Key);
	
	If Form.NeedToAddGeneralPrompt Then
		Form.NeedToAddGeneralPrompt = False;		
		GeneralPrompt = CommonClaudeAIOverridable.GetGeneralPrompt();
		
		If ValueIsFilled(GeneralPrompt) Then
			NewChatMessage = Form.ChatData.Add();
			NewChatMessage.Role = "user";
			NewChatMessage.Message = GeneralPrompt;
			NewChatMessage.Predefined = True;
		EndIf;
	EndIf;
	
	Messages = New Array;
	
	For Each Message In Form.ChatData Do
		HistoryMessage = New Map;
		HistoryMessage.Insert("role", Message.Role);
		HistoryMessage.Insert("content", Message.Message);
		Messages.Add(HistoryMessage);
	EndDo;
	
	UserAdditionalPrompts = CommonClaudeAICached.GetUserAdditionalPrompts(UserFullName());
	While UserAdditionalPrompts.Next() Do
		Filter = New Structure;
		Filter.Insert("Role", "user");
		Filter.Insert("Message", UserAdditionalPrompts.Prompt);
		Filter.Insert("Predefined", True);
		
		Rows = Form.ChatData.FindRows(Filter);
		If Rows.Count() > 0 Then
			Form.ChatData.Delete(Rows[0]);
		EndIf;
		
		NewChatMessage = Form.ChatData.Add();
		NewChatMessage.Role = "user";
		NewChatMessage.Message = UserAdditionalPrompts.Prompt;
		NewChatMessage.Predefined = True;
		
		HistoryMessage = New Map;
		HistoryMessage.Insert("role", NewChatMessage.Role);
		HistoryMessage.Insert("content", NewChatMessage.Message);
		Messages.Add(HistoryMessage);
	EndDo;
	
	NewMessage = New Map;
	NewMessage.Insert("role", "user");
	NewMessage.Insert("content", Form.QueryText + ". Your answer must be in html format");
	Messages.Add(NewMessage);
	
	NewChatMessage = Form.ChatData.Add();
	NewChatMessage.Role = "user";
	NewChatMessage.Message = Form.QueryText;
	
	Data = New Structure;
	Data.Insert("model", Form.AIParameters.Model);
	Data.Insert("max_tokens", Form.AIParameters.Max_Tokens); 
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
	
	NewChatMessage = Form.ChatData.Add();
	NewChatMessage.Role = "assistant";
	
	If ResponseData.Property("error") Then
		NewChatMessage.Message = ResponseData.error.message;
	Else
		NewChatMessage.Message = ResponseData.content[0].text;
		
		UpdateUsageStatistics(ResponseData);
	EndIf;
	
	Form.QueryText = "";
EndProcedure

Procedure UpdateChatMessages(Form) Export
	Form.ChatMessages = "<!DOCTYPE html> <html><body>";
	ChatMessageTemplate = "<table><tbody><tr>
							|<td align=""center""><img height = ""%1"" width = ""%2"" src=""data:image/jpg;base64,%3""/></td>
							|<td align=""justify"" bgcolor = ""%4""><p>%5</p></td>
							|</tr></tbody></table>";
	
	For Each Message In Form.ChatData Do
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
		
		Form.ChatMessages = Form.ChatMessages + MessageText;
	EndDo;
	
	Form.ChatMessages = Form.ChatMessages + "</body></html>";
EndProcedure

#EndRegion