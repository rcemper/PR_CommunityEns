Class Community.Model.Post Extends (%Persistent, Community.Model.Common)
{

Property Nid As %Integer [ Required ];

Index NidIndex On Nid [ Unique ];

Property Type As %String(VALUELIST = ",code_package,documentation,learning_track,video,post");

Property Tags As %String(MAXLEN = 350);

Property Views As %Integer;

Property AvgVote As %Numeric;

Property VotesAmount As %Integer;

Property Name As %String(MAXLEN = 250);

Property Created As %TimeStamp;

Property Published As %Boolean;

Property PublishedDate As %TimeStamp;

Property Text As %String(MAXLEN = "");

Index TextIndex On (Text) As %iFind.Index.Basic(INDEXOPTION = 2, LANGUAGE = "en", LOWER = 1);

Property Link As %String(MAXLEN = 150) [ SqlComputeCode = {set {*} = $$$Server _ "node/" _ {Nid}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index Link On Link [ Unique ];

Index HashIndex On Hash [ Unique ];

Relationship Author As Community.Model.User [ Cardinality = one, Inverse = Posts, OnDelete = cascade, Required ];

Index AuthorIndex On Author;

ClassMethod Upsert(Nid, Name, Created, Uid, Tags, Type, Views, AvgVote, VotesAmount, Text, Published, Hash) As %Status
{
	#Dim Status As %Status = $$$OK
 	
	If ..NidIndexExists(Nid, .Id) {
		Set Post = ..%OpenId(Id)
	} Else {
		Set Post = ..%New()
		Set Post.Nid = Nid
		If ##class(Community.Model.User).UidIndexExists(Uid, .AuthorId) {
			Do Post.AuthorSetObjectId(AuthorId)
		}
	}
	
	Set Post.Hash = Hash
	Set Post.Name = Name
	Set Post.Created = Created
	Set Post.Tags = Tags
	Set Post.Views = Views
	Set Post.AvgVote = AvgVote
	Set Post.VotesAmount = VotesAmount
	Set Post.Text = ..CleanText(Text)
	Set Post.Type = Type

	If (Post.Published '= Published) {
		If Published {
			Set Post.PublishedDate = $ZDT($H, 3)	
		} Else {
			Set Post.PublishedDate = ""
		}		
		Set Post.Published = Published
	}
	
	Set Status = Post.%Save()
	
	Return Status
}

ClassMethod CleanText(Text As %String) As %String
{
	Set Text = $Replace(Text,"</p>"," ")
	Set Reg = ##class(%Regex.Matcher).%New("<(([^>]|\n)*)>")
	Set Reg.Text = Text
	Set Text = Reg.ReplaceAll("")
	Set Text = $Replace(Text,"&nbsp;"," ")
	Set Text = $Replace(Text,"&gt;",">")
	Set Text = $Replace(Text,"&lt;","<")
	Set Text = $Replace(Text,"&amp;","&")
	Set Text = $Replace(Text,"&quot;","""")
	Set Text = $Replace(Text,"&#39;","'")
	Return Text
}

Method WriteInfo() As %String
{
	Set Info = "Author: " _ ..Author.Name _ $$$NL _
				"URL: " _ ..Link _ $$$NL _ 
				"Text: " _ ..Text
	Return Info
}

Storage Default
{
<Data name="PostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Hash</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Tags</Value>
</Value>
<Value name="5">
<Value>Views</Value>
</Value>
<Value name="6">
<Value>AvgVote</Value>
</Value>
<Value name="7">
<Value>VotesAmount</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Created</Value>
</Value>
<Value name="10">
<Value>Published</Value>
</Value>
<Value name="11">
<Value>PublishedDate</Value>
</Value>
<Value name="12">
<Value>Deleted</Value>
</Value>
<Value name="13">
<Value>Text</Value>
</Value>
<Value name="14">
<Value>Link</Value>
</Value>
<Value name="15">
<Value>Author</Value>
</Value>
<Value name="16">
<Value>PostType</Value>
</Value>
<Value name="17">
<Value>Nid</Value>
</Value>
</Data>
<DataLocation>^Community.Model.PostD</DataLocation>
<DefaultData>PostDefaultData</DefaultData>
<IdLocation>^Community.Model.PostD</IdLocation>
<IndexLocation>^Community.Model.PostI</IndexLocation>
<StreamLocation>^Community.Model.PostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

