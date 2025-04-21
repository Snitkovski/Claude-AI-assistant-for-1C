#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LoadDataSourcesForAIAssitant();
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure Max_TokensOnChange(Item)
	AttributeOnChangeServer(Item.Name);
    RefreshInterface()
EndProcedure

&AtClient
Procedure ModelOnChange(Item)
	AttributeOnChangeServer(Item.Name);
    RefreshInterface()
EndProcedure

&AtClient
Procedure API_KeyOnChange(Item)
	AttributeOnChangeServer(Item.Name);
    RefreshInterface()
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlersDataSourcesForAIAssitant

&AtClient
Procedure DataSourcesForAIAssitantOnChange(Item)
	SaveDataSourcesForAIAssitant();
EndProcedure

&AtClient
Procedure DataSourcesForAIAssitantDataSourceStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	StandardProcessing = False;
	
	Handler = New NotifyDescription("MetadataSelection", ThisObject);
	OpenForm("CommonForm.SelectFromMetadata", , ThisObject, , , , Handler);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure CatalogAdditionalPrompts(Command)
	OpenForm("Catalog.AIAdditionalPrompts.ListForm");
EndProcedure

&AtClient
Procedure UsersAdditionalPrompts(Command)
	OpenForm("InformationRegister.UsersAdditionalPrompts.ListForm");
EndProcedure

&AtClient
Procedure UsageStatistics(Command)
	OpenForm("Report.ClaudeAI_UsageStatistics.Form");
EndProcedure

#EndRegion

#Region Private

#Region InternalProceduresAndFunctions

&AtClient
Procedure MetadataSelection(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	Items.DataSourcesForAIAssitant.CurrentData.DataSource = Result;
EndProcedure

#EndRegion

&AtServer
Function AttributeOnChangeServer(ItemName)	
	Result = New Structure;
	                                                                     
	DataPathAttribute = Items[ItemName].DataPath;
	
	BeginTransaction();
	Try
		WriteAttributeValue(DataPathAttribute, Result);
		CommitTransaction();
	Except
		RollbackTransaction();
		Message(ErrorDescription());
		Return Result;
	EndTry;
	
	RefreshReusableValues();			
	
	Return Result;	
EndFunction

&AtServer
Procedure WriteAttributeValue(DataPathAttribute, Result)
	If DataPathAttribute = "" Then
		Return;
	EndIf;
	
	ConstantName = "";
	If Upper(Left(DataPathAttribute, 13)) = Upper("ConstantsSet.") Then
		ConstantName = Mid(DataPathAttribute, 14);
	EndIf;
	
	// Save constant value.
	If ConstantName <> "" Then
		ConstantManager = Constants[ConstantName];
		ConstantValue   = ConstantsSet[ConstantName];
		
		If ConstantManager.Get() <> ConstantValue Then
			ConstantManager.Set(ConstantValue);
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure LoadDataSourcesForAIAssitant()
	DataSourcesForAIAssitantData = InformationRegisters.DataSourcesForAIAssitant.CreateRecordSet();
	DataSourcesForAIAssitantData.Read();
	DataSourcesForAIAssitant.Load(DataSourcesForAIAssitantData.Unload());
EndProcedure

&AtServer
Procedure SaveDataSourcesForAIAssitant()
	DataSourcesForAIAssitantRecordSet = InformationRegisters.DataSourcesForAIAssitant.CreateRecordSet();
	DataSourcesForAIAssitantRecordSet.Load(DataSourcesForAIAssitant.Unload());
	DataSourcesForAIAssitantRecordSet.Write();
EndProcedure

#EndRegion