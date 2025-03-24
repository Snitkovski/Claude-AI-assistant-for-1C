#Region Public

Procedure WriteChatHistory(User = Undefined, ChatData = Undefined, AdditionalContext = Undefined) Export
	If ChatData = Undefined Then
		ChatDataTable = New ValueTable();
		ChatDataTable.Columns.Add("Role", New TypeDescription("String"));
		ChatDataTable.Columns.Add("Message", New TypeDescription("String"));
		ChatDataTable.Columns.Add("Predefined", New TypeDescription("Boolean"));
	Else
		ChatDataTable = ChatData.Unload();
	EndIf;
	
	If AdditionalContext = Undefined Then
		AdditionalContextTable = New ValueTable();
		
		TypesArray = New Array;
		TypesArray.Add(Documents.AllRefsType());
		TypesArray.Add(Catalogs.AllRefsType());
		TypesArray.Add(ChartsOfCharacteristicTypes.AllRefsType());
		TypesArray.Add(ChartsOfAccounts.AllRefsType());
		TypesArray.Add(ChartsOfCalculationTypes.AllRefsType());
		TypesArray.Add(BusinessProcesses.AllRefsType());
		TypesArray.Add(Tasks.AllRefsType());
	
		AdditionalContextTable.Columns.Add("Context", New TypeDescription(TypesArray));
	Else
		AdditionalContextTable = AdditionalContext.Unload();
	EndIf;
	
	If User = Undefined Then
		User = CommonClaudeAICached.GetCurrentUser();
	EndIf;
	
	ChatHistoryRecord = InformationRegisters.AIAssistantChatsHistory.CreateRecordManager();
	ChatHistoryRecord.User = User;
	ChatHistoryRecord.ChatHistory = New ValueStorage(ChatDataTable);
	ChatHistoryRecord.AdditionalContext = New ValueStorage(AdditionalContextTable);
	ChatHistoryRecord.Write(True);
EndProcedure

#EndRegion