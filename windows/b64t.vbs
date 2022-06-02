Const BINARY = 1
Const BASE64 = "bin.base64"

Sub help()

	WScript.Echo "" & VbCrLf & _
	"b64t" & VbCrLf & _
	"" & VbCrLf & _
	"SYNOPSIS: " & VbCrLf & _
	"	cscript.exe b64t [OPTION] [INPUT FILE] [OUTPUT FILE]" & VbCrLf & _
	"" & VbCrLf & _
	"DESCRIPTION:" & VbCrLf & _
	"	Converts file from/to Base64 using VBS only (no external programs required). Usefull if tools like Powershell and CertUtil are blocked." & VbCrLf & _
	"" & VbCrLf & _
	"OPTION:" & VbCrLf & _
	"	-h, --help" & VbCrLf & _
	"		show the manual" & VbCrLf & _
	"	-d, --decode" & VbCrLf & _
	"		Decode from Base64" & VbCrLf & _
	"	-e, --encode" & VbCrLf & _
	"		Encode from Base64" & VbCrLf

	WScript.Quit 0

End Sub

' Parameters must be 3 (options, input, output)
if not WScript.Arguments.Count = 3 then
	help()
end if

' Get parameters
inputFile = WScript.Arguments.item(1)
outputFile = WScript.Arguments.item(2)

Select case WScript.Arguments.item(0)
	case "-d", "--decode"
		' Opening Base64 payload
		Set fso = CreateObject("Scripting.Filesystemobject").OpenTextFile(inputFile, 1)
		content = fso.ReadAll()
		fso.Close
		
		' Create an XML object to use later for data type convertion
		Set xml = CreateObject("Msxml2.DOMDocument").CreateElement("base64")
		xml.dataType = BASE64
		xml.text = content

		' Write decoded file
		Set outputStream = CreateObject("ADODB.Stream")
		outputStream.Type = BINARY 
		outputStream.Open()
		outputStream.Write xml.nodeTypedValue ' Base64 decode
		outputStream.SaveToFile outputFile

	case "-e", "--encode"
		' Opening binary file
		Set inputStream = CreateObject("ADODB.Stream")
		inputStream.Open()
		inputStream.type = BINARY
		inputStream.LoadFromFile(inputFile)
		content = inputStream.Read()
		
		' Create an XML object to use for data type convertion
		Set xml = CreateObject("Msxml2.DOMDocument").CreateElement("base64")
		xml.dataType = BASE64
		xml.nodeTypedValue = content ' Encode to Base64
		contentBase64 = xml.text

		' Writes a new file containing the Base64 payload
		Set fso = CreateObject("Scripting.FileSystemObject").CreateTextFile(outputFile,1)
		fso.Write contentBase64
		fso.Close()

	case "-h", "--help"
		help()

	case else
		help()

End select



WScript.Quit 0