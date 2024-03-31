Class Community.Production.UserService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

/// Обработка одного ряда данных
/// Processing one series of data
Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	#Dim Status As %Status = $$$OK
	Set Uid = pInput.Get("UID")
	Set Created = pInput.Get("Created")	
	
	Set FirstName = pInput.Get("field_first_name_value")
	Set LastName = pInput.Get("field_last_name_value")
	Set Company = pInput.Get("field_company_value")
	Set Position = pInput.Get("field_title_position_value")
	Set Email = pInput.Get("mail")
	
	/*
	Set FirstName = pInput.Get("FirstName")
	Set LastName = pInput.Get("LastName")
	Set Company = pInput.Get("Company")
	Set Position = pInput.Get("Position")
	Set Email = pInput.Get("Email")*/
	
	Set Hash = ##class(Community.Utils.Hash).Hash(Uid, FirstName, LastName, Company, Position, Email, Created) 
	If ##class(Community.Model.User).HashIndexExists(Hash)=$$$NO {
		Set Status = ##class(Community.Model.User).Upsert(Uid, FirstName, LastName, Company, Position, Email, Created, Hash)
	}
	Quit Status
}

}

