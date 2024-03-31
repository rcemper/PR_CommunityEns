Class Community.Production.EmailOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Method SendMail(Request As Ens.StringRequest, Output Response As Ens.StringResponse) As %Status
{
	#Dim Status As %Status = $$$OK

	Set Id = Request.StringValue
	Set Post = ##class(Community.Model.Post).%OpenId(Id)

	Set Mail=##class(%Net.MailMessage).%New()
	Set Mail.Subject = "Message alert: " _ Post.Name
	Set Mail.Charset = "utf-8"
	Set Mail.IsHTML = $$$NO
	//Set Mail.ContentType = "text/html"
	Do Mail.TextData.Write(Post.WriteInfo())

	Set ..Adapter.SMTP.UseSTARTTLS = $$$YES   
	Set Status = ..Adapter.SendMail(Mail)
	Return Status
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Ens.Request">
    <Method>SendMail</Method>
  </MapItem>
</MapItems>
}

}

