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

#Region Private

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


#EndRegion