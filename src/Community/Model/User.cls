Class Community.Model.User Extends (%Persistent, Community.Model.Common)
{

Property Uid As %Integer [ Required ];

Index UidIndex On Uid [ Unique ];

Property Name As %String(MAXLEN = 255) [ SqlComputeCode = {set {*} = {FirstName} _ " " _ {LastName}}, SqlComputed, SqlComputeOnChange = (FirstName, LastName) ];

Property FirstName As %String(MAXLEN = 255);

Property LastName As %String(MAXLEN = 255);

Property Email As %String(MAXLEN = 255);

Property Company As %String(MAXLEN = 255);

Property Position As %String(MAXLEN = 255);

Property Created As %TimeStamp;

Property Link As %String(MAXLEN = 255) [ SqlComputeCode = {set {*} = $$$Server _ "user/" _ {Uid}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index LinkIndex On Link [ Unique ];

Index HashIndex On Hash [ Unique ];

Relationship Posts As Community.Model.Post [ Cardinality = many, Inverse = Author ];

ClassMethod Upsert(Uid, FirstName, LastName, Company, Position, Email, Created, Hash) As %Status
{
	#Dim Status As %Status = $$$OK

	If ..UidIndexExists(Uid, .Id) {
		Set User = ..%OpenId(Id)
	} Else {
		Set User = ..%New()
		Set User.Uid = Uid
		Set User.Created = Created
	}

	Set User.FirstName = FirstName
	Set User.LastName = LastName
	Set User.Email = $ZCVT(Email, "l")
	Set User.Company = Company
	Set User.Position = Position
	Set User.Hash = Hash
	
	Set Status = User.%Save()
	Return Status
}

Storage Default
{
<Data name="UserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Hash</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>FirstName</Value>
</Value>
<Value name="5">
<Value>LastName</Value>
</Value>
<Value name="6">
<Value>Email</Value>
</Value>
<Value name="7">
<Value>Company</Value>
</Value>
<Value name="8">
<Value>Position</Value>
</Value>
<Value name="9">
<Value>Created</Value>
</Value>
<Value name="10">
<Value>Link</Value>
</Value>
<Value name="11">
<Value>Uid</Value>
</Value>
</Data>
<DataLocation>^Community.Model.UserD</DataLocation>
<DefaultData>UserDefaultData</DefaultData>
<IdLocation>^Community.Model.UserD</IdLocation>
<IndexLocation>^Community.Model.UserI</IndexLocation>
<StreamLocation>^Community.Model.UserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

