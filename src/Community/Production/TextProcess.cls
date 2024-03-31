/// 1
Class Community.Production.TextProcess Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// Список слов, которые вызывают БО
/// List of words that cause BO
Property Words As %String(MAXLEN = "");

Property EmailOperation As %String;

Parameter SETTINGS = "Words:Basic,EmailOperation:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response'>
<context>
<property name='Id' type='%Integer'/>
<property name="SendEmail" type='%Boolean' initialexpression='$$$NO'/>
</context>
<sequence>
<assign property='context.Id' value='request.StringValue'/>
<sql name='Проверяем есть ли слова из списка Word в посте'><![CDATA[
SELECT 1 INTO :context.SendEmail FROM Community_Model.Post
WHERE ID = :context.Id AND
%ID %FIND search_index(TextIndex, :process.Words, 2)
]]> 
</sql>

<if condition='context.SendEmail = $$$YES'>
<true>
<call name='Oтправка почты' target='@..%Process.EmailOperation' async='0'>
<request type='Ens.StringRequest'>
<assign property="callrequest.StringValue" value='context.Id'/>
</request>
</call>
</true>
</if>
</sequence>
</process>
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	do ##class(isc.util.EnsUtils).getConnections("EmailOperation", pItem, .pArray)
}

Storage Default
{
<Data name="TextProcessDefaultData">
<Subscript>"TextProcess"</Subscript>
<Value name="1">
<Value>Words</Value>
</Value>
<Value name="2">
<Value>EmailOperation</Value>
</Value>
</Data>
<DefaultData>TextProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

