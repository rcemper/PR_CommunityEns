Class Community.Utils.Hash
{

ClassMethod Hash(Arg...) As %String
{
	Set Delimiter = $c(255)
	Set String = Delimiter
	For i=1:1:Arg {
		Set String = String _ Arg(i) _ Delimiter
	}
	Return $System.Encryption.Base64Encode($system.Encryption.MD5Hash(String))
}

}

