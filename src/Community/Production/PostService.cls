Class Community.Production.PostService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

/// Обработка одного ряда данных
/// Processing one series of data
Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	#Dim Status As %Status = $$$OK
	//m ^dbg("d") = @pInput.%GblRef
	
	Set Nid = pInput.Get("entity_id")
	Set Name = pInput.Get("title")
	Set Created = pInput.Get("Created")
	Set Uid = pInput.Get("uid")
	Set Tags = pInput.Get("Tags")
	Set Type = pInput.Get("bundle")
	Set Views = pInput.Get("Views")
	Set AvgVote = pInput.Get("AvgVote")
	Set VotesAmount = pInput.Get("VotesAmount")
	Set Text = pInput.Get("field_body_value")
	Set Published = pInput.Get("status")
	
	Set Hash = ##class(Community.Utils.Hash).Hash(Nid, Name, Created, Uid, Tags, Type, Views, AvgVote, VotesAmount, Text, Published) 
	If ##class(Community.Model.Post).HashIndexExists(Hash)=$$$NO {
		Set Status = ##class(Community.Model.Post).Upsert(Nid, Name, Created, Uid, Tags, Type, Views, AvgVote, VotesAmount, Text, Published, Hash)
	}
	
	Quit Status
}

}

