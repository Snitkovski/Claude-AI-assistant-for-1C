#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillMetaDataTree();
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlersMetaDataTree

&AtClient
Procedure MetaDataTreeSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	Selection();	
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Select(Command)
	Selection();
EndProcedure

#EndRegion

#Region Private

#Region Add
&AtServer
Procedure AddMetaDataBranch(Val MetaDataTree, Branch, Val MetadataName, Val Name, Val Presentation, Val PicBranch=0, Val PicObj=0)	
	RowBranch = MetaDataTree.Rows.Add();
	RowBranch.Presentation = Presentation;
	RowBranch.Name = Name;
	RowBranch.PictureIndex = PicBranch;	
	RowsBranch = RowBranch.Rows;
	
	For Each Metadat In Branch Do
		AddMetadataObject(RowsBranch, Metadat, MetadataName, Name, PicObj);
	EndDo;
EndProcedure

&AtServer
Procedure AddMetadataObject(RowsBranch, Metadat, MetadataName, Name, PicObj)
	RowObject = RowsBranch.Add();
	RowObject.Name = Name + "." + Metadat.Name;
	RowObject.Presentation  = ?(ValueIsFilled(Metadat.Synonym), Metadat.Synonym, Metadat.Name);
	RowObject.PictureIndex = PicObj;
EndProcedure

#EndRegion

#Region InternalProceduresAndFunctions
&AtClient
Procedure Selection()
	CurrentData = Items.MetaDataTree.CurrentData;
	If CurrentData = Undefined Then
		Close(Undefined);
	Else
		Close(CurrentData.Name);
	EndIf;
EndProcedure

&AtServer
Procedure FillMetaDataTree(Filter = Undefined)
	ValMetaDataTree = FormDataToValue(MetaDataTree, Type("ValueTree"));
	
	If Filter = Undefined Then
		AddMetaDataBranch(ValMetaDataTree, Metadata.Catalogs, "Catalogs", "Catalog", "Catalogs", 24, 24);
		AddMetaDataBranch(ValMetaDataTree, Metadata.Documents, "Documents", "Document", "Documents", 25, 25);
		AddMetaDataBranch(ValMetaDataTree, Metadata.DocumentJournals, "DocumentJournals", "DocumentJournal", "Document journals", 33, 33);
		AddMetaDataBranch(ValMetaDataTree, Metadata.ChartsOfAccounts, "ChartsOfAccounts", "ChartOfAccounts", "Charts of accounts", 40, 40);
		AddMetaDataBranch(ValMetaDataTree, Metadata.InformationRegisters, "InformationRegisters", "InformationRegister", "Information registers", 44, 44);
		AddMetaDataBranch(ValMetaDataTree, Metadata.AccumulationRegisters, "AccumulationRegisters", "AccumulationRegister", "Accumulation registers", 47, 47);
		AddMetaDataBranch(ValMetaDataTree, Metadata.AccountingRegisters, "AccountingRegisters", "AccountingRegister", "Accounting registers", 48, 48);	
	Else
		For Each MetadataKind In Filter Do
			If MetadataKind = "Catalogs" Then
				AddMetaDataBranch(ValMetaDataTree, Metadata.Catalogs, "Catalogs", "Catalog", "Catalogs", 24, 24);
			ElsIf MetadataKind = "Documents" Then 
				AddMetaDataBranch(ValMetaDataTree, Metadata.Documents, "Documents", "Document", "Documents", 25, 25);
			ElsIf MetadataKind = "DocumentJournals" Then 
				AddMetaDataBranch(ValMetaDataTree, Metadata.DocumentJournals, "DocumentJournals", "DocumentJournal", "Document journals", 33, 33);
			ElsIf MetadataKind = "ChartsOfAccounts" Then 
				AddMetaDataBranch(ValMetaDataTree, Metadata.ChartsOfAccounts, "ChartsOfAccounts", "ChartOfAccounts", "Charts of accounts", 40, 40);
			ElsIf MetadataKind = "InformationRegisters" Then 
				AddMetaDataBranch(ValMetaDataTree, Metadata.InformationRegisters, "InformationRegisters", "InformationRegister", "Information registers", 44, 44);
			ElsIf MetadataKind = "AccumulationRegisters" Then 
				AddMetaDataBranch(ValMetaDataTree, Metadata.AccumulationRegisters, "AccumulationRegisters", "AccumulationRegister", "Accumulation registers", 47, 47);
			ElsIf MetadataKind = "AccountingRegisters" Then 
				AddMetaDataBranch(ValMetaDataTree, Metadata.AccountingRegisters, "AccountingRegisters", "AccountingRegister", "Accounting registers", 48, 48);									
			EndIf;
		EndDo;
	EndIf;
	
	ValueToFormData(ValMetaDataTree, MetaDataTree);
EndProcedure

#EndRegion

#EndRegion