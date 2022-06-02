path = "C:\Winwdos\System32\cmd.exe"

Sub help()

	WScript.Echo "" & VbCrLf & _
	"wsum" & VbCrLf & _
	"" & VbCrLf & _
	"SYNOPSIS: " & VbCrLf & _
	"	cscript.exe wsum [OPTION] [PATH]" & VbCrLf & _
	"" & VbCrLf & _
	"DESCRIPTION:" & VbCrLf & _
	"	wsum is the Windows alternative for xsum."  & VbCrLf & _
    "   Calculates (in order) md5, sha1 and sha256 of a file. Prints results without format or additional informaions: this is usefull when putting hashes in a report." & VbCrLf & VbCrLf & _
    "   Note: since the Windows Shell doesn't perform parameter expansion the option -r is added to this script" & VbCrLf & _
	"" & VbCrLf & _
	"OPTION:" & VbCrLf & _
	"	-h, --help" & VbCrLf & _
	"		Show the manual" & VbCrLf & _
	"	-r, --recursive" & VbCrLf & _
    "       Calculates hash of every file i nthe selected folder"  & VbCrLf

	WScript.Quit 0
End Sub

Select case WScript.Arguments.item(0)
	case "-h", "--help"
		help()

    case "-r", "--recursive"
        Set fso = CreateObject("Scripting.FileSystemObject")
		For Each file In fso.GetFolder(WScript.Arguments.item(1)).Files
            sum(file)
        Next

	case else
		sum(WScript.Arguments.item(0))

End select

function getMD5(bytes)
    Dim MD5
    set MD5 = CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider")
    MD5.Initialize()
    getMD5 = MD5.ComputeHash_2( (bytes) )
end function

function getSHA1(bytes)
    Dim SHA1
    set SHA1 = CreateObject("System.Security.Cryptography.SHA1Managed")
    SHA1.Initialize()
    getSHA1 = SHA1.ComputeHash_2( (bytes) )
end function

function getSHA256(bytes)
    Dim SHA256
    set SHA256 = CreateObject("System.Security.Cryptography.SHA256Managed")
    SHA256.Initialize()
    getSHA256 = SHA256.ComputeHash_2( (bytes) )
end function

Function getBytes(path)
    With CreateObject("Adodb.Stream")
        .Type = 1 ' adTypeBinary
        .Open
        .LoadFromFile path
        .Position = 0
        GetBytes = .Read
        .Close
    End With
End Function

function bytesToHex(bytes)
    dim hexStr, x
    for x=1 to lenb(bytes)
        hexStr= hex(ascb(midb( (bytes),x,1)))
        if len(hexStr)=1 then hexStr="0" & hexStr
        bytesToHex=bytesToHex & hexStr
    next
end function

function sum(file)
    Set fso = CreateObject("Scripting.FileSystemObject")
    'Set fso = fso.GetFile(file)

    name = fso.GetFileName(file)
    md5=bytesToHex(getMD5(getBytes(file)))
    sha1=bytesToHex(getSHA1(getBytes(file)))
    sha256=bytesToHex(getSHA256(getBytes(file)))

    Wscript.Echo name & vbCrLf & md5 & vbCrLf & sha1 & vbCrLf & sha256
end function