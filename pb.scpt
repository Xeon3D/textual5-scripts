-- pb - A Pastebin.com Helper Script for Textual
-- Coded by Xeon3D
-- Most of the code of the original script by ePirat.

-- 2 step Installation:
-- Copy this to ~/Library/Application Support/Textual IRC/Scripts/
-- or ~/Library/Containers/com.codeux.irc.textual/Data/Library/Application Support/Textual IRC/Scripts/ 
-- if you're using the sandbox / App Store version.
-- Run /pb or /pb help for more options.



-- | SCRIPT START | --
-- |Properties| --
property ClientName : "Textual 5"
property ScriptName : "pb"
property ScriptDescription : "A Pastebin.com Helper Script for Textual"
property ScriptHomepage : "http://github.com/Xeon3D/pb"
property ScriptAuthor : "Xeon3D"
property ScriptAuthorHomepage : "http://www.xeon3d.net"
property CurrentVersion : "0.0.7"
property SupportChannel : "irc://irc.freenode.net/#textual"
property SMHomepage : "http://github.com/Xeon3D/pb"

-- | DEBUG COMMAND | --
--set cmd to ""

on textualcmd(cmd)
	
	-- Variables.
	-- Set default name for Pastebins that don't have one.
	set PDName to "PasteBin powered by pb script for " & ClientName & " - " & ScriptHomepage
	
	-- Set if Pastebins should be private (1) or public (0).
	set Private to 1
	
	--Define API Key
	set APIKey to "fe73a6fdf93c28bf01e0198039d18856"
	
	-- Initialize Format, Output and Name Variables.
	set Format to ""
	set output to ""
	set Nome to {}
	
	-- Defines the version of Textual where it's being run from.
	set ClientVersion to version of application ClientName
	
	
	---- Reading and Setting user-defined variables.
	try
		set PDFormat to do shell script "defaults read xeon3d.pb PDFormat"
		if PDFormat is "" then
			do shell script "defaults delete xeon3d.pb PDFormat"
			set PDFormat to "text"
		end if
	on error
		try
			do shell script ("defaults write xeon3d.pb PDFormat text")
			set PDFormat to "text"
		on error
			set msg to "/echo There was an error writing defaults PDFormat"
			return msg
		end try
	end try
	
	try
		set PDOutput to do shell script "defaults read xeon3d.pb PDOutput"
		if PDOutput is "" then
			do shell script "defaults delete xeon3d.pb PDOutput"
			set PDOutput to "echo"
		end if
	on error
		try
			do shell script ("defaults write xeon3d.pb PDOutput echo")
			set PDOutput to "echo"
		on error
			set msg to "/echo There was an error writing defaults PDOutput"
			return msg
		end try
	end try
	
	try
		set APIKey to do shell script "defaults read xeon3d.pb APIKey"
		if APIKey is "" then
			do shell script "defaults delete xeon3d.pb APIKey"
			set APIKey to "fe73a6fdf93c28bf01e0198039d18856"
		end if
	on error
		try
			do shell script ("defaults write xeon3d.pb APIKey fe73a6fdf93c28bf01e0198039d18856")
			set APIKey to "fe73a6fdf93c28bf01e0198039d18856"
			set msg to "/echo There is not a key defined so the author's key is being used. Please change it to yours!"
		on error
			set msg to "/echo There was an error writing defaults APIKey"
			return msg
		end try
	end try
	
	---- Accepted formats.
	set Formats to {"applescript", "asm", "asp", "awk", "bash", "c", "c_mac", "csharp", "cpp", "cpp-qt", "cmake", Â
		"css", "delphi", "freebasic", "gambas", "haskell", "html4strict", "html5", "java", "java5", "javascript", "jquery", Â
		"llvm", "lua", "mysql", "text", "objc", "pascal", "perl", "perl6", "php", "php-brief", "postgresql", "purebasic", "python", Â
		"ruby", "sql", "tcl", "vbnet", "vb", "xml"}
	
	---- Accepted Output Types
	set Outputs to {"say", "echo"}
	
	-- Formatting Variables.
	
	---- Initializes the Simple variable.
	set Simple to ""
	
	---- Colors.
	set CBlack to (ASCII character 3) & "01"
	set CNBlue to (ASCII character 3) & "02"
	set CGreen to (ASCII character 3) & "03"
	set CRed to (ASCII character 3) & "04"
	set CBrown to (ASCII character 3) & "05"
	set CPurple to (ASCII character 3) & "06"
	set COrange to (ASCII character 3) & "07"
	set CYellow to (ASCII character 3) & "08"
	set CLGreen to (ASCII character 3) & "09"
	set CTeal to (ASCII character 3) & "10"
	set CCyan to (ASCII character 3) & "11"
	set CBlue to (ASCII character 3) & "12"
	set CPink to (ASCII character 3) & "13"
	set CGrey to (ASCII character 3) & "14"
	set CLGrey to (ASCII character 3) & "15"
	set CWhite to (ASCII character 3)
	set NoColor to (ASCII character 0)
	
	---- Formatting.
	set FBold to (ASCII character 2)
	set FItalic to (ASCII character 1)
	set NewLine to (ASCII character 10)
	
	---- No Formatting on output.
	if (cmd contains "simple") or (Simple is true or Simple is "True") then
		set UsedColor to ""
		set FreeColor to ""
		set CWhite to ""
		set FBold to ""
		set FItalic to ""
	end if
	
	-- Runtime Options.
	
	---- Option setting commands.
	
	if cmd is "format" then
		if PDFormat is not "" then
			set msg to "/echo The current default format is currently " & FBold & PDFormat & FBold & ". To set a new one type '/" & ScriptName & " setformat newformat'"
			return msg
		else if PDFormat is "" then
			set msg to "/echo The current default format is " & FBold & "NOT SET" & FBold & "!! To set one type '/" & ScriptName & " setformat newformat '"
			return msg
		end if
	end if
	
	if cmd contains "setformat" then
		set cmd to split(" ", cmd)
		try
			set PDFormat to item 2 of cmd
		end try
		do shell script "defaults write xeon3d.pb PDFormat " & PDFormat
		return "/echo The default pastebin format is now " & CRed & PDFormat & CWhite
	end if
	
	if cmd is "output" then
		if PDOutput is "echo" then
			set msg to "/echo Pastebins URLs are currently set to be " & FBold & CRed & "echoed" & FBold & CWhite & ". To set new pastebins to be written to the active channel/query at the time type '/" & ScriptName & " setoutput say'"
			return msg
		else if PDOutput is "say" then
			set msg to "Pastebins URLs are currently set to be " & FBold & CRed & "said (written)" & FBold & CWhite & " to the active channel/query at runtime. To set new pastebins to be echoed type '/" & ScriptName & " setoutput echo'"
			return msg
		end if
	end if
	
	if cmd contains "setoutput" then
		set cmd to split(" ", cmd)
		try
			set PDOutput to item 2 of cmd
		end try
		do shell script "defaults write xeon3d.pb PDOutput " & PDOutput
		if PDOutput is "say" then
			set PDOutputphrase to "written"
		else if PDOutput is "echo" then
			set PDOutputphrase to "echoed"
		end if
		return "/echo New pastebins from now on will be " & FBold & PDOutputphrase & FBold & " to the active channel or query."
	end if
	
	if cmd is "apikey" then
		if APIKey is "fe73a6fdf93c28bf01e0198039d18856" then
			set msg to "/echo The Pastebin.com API Key currently set is: " & CRed & APIKey & " (Script's Predefined Key)." & CWhite & " It's " & FBold & "STRONGLY" & FBold & " recommended to change it. To set a new one type '/" & ScriptName & " setapikey YOUR-API-KEY'"
			return msg
		else if APIKey is "" then
			set msg to "/echo There is not a Pastebin.com API Key currently set up. The script will not work without one. To set one type '/" & ScriptName & " setapikey YOUR-API-KEY'"
			return msg
		else
			set msg to "/echo The Pastebin.com API Key currently set is: " & CRed & APIKey & CGreen & " (User Defined Key)" & CWhite & ". To set a new one type '/" & ScriptName & " setapikey YOUR-API-KEY'"
			return msg
		end if
	end if
	
	if cmd contains "setapikey" then
		set cmd to split(" ", cmd)
		try
			set APIKey to item 2 of cmd
		on error
			return "/echo No API Key specified. Example: '/" & ScriptName & " setapikey 1a43de42f42c4328bf01e019803"
		end try
		do shell script "defaults write xeon3d.pb APIKey " & APIKey
		return "/echo The script will now use the " & FBold & APIKey & FBold & " API Key to communicate with Pastebin.com."
	end if
	
	---- Informational Commands.
	
	if cmd is "formats" then
		set msg to "/echo " & FBold & "Accepted Formats: " & FBold & "applescript, asm, asp, awk, bash, c, c_mac, csharp, cpp, cpp-qt, cmake, css, delphi, freebasic, gambas, haskell, html4strict, html5, java, java5, javascript, jquery," & NewLine & Â
			"/echo llvm, lua, mysql, text, objc, pascal, perl, perl6, php, php-brief, postgresql, purebasic, python, ruby, sql, tcl, vbnet, vb, xml"
		return msg
	end if
	
	if cmd is "about" then
		set msg to Â
			"/echo " & FBold & ScriptName & " " & CurrentVersion & FBold & " - " & ScriptDescription & NewLine & Â
			"/echo Homepage: " & ScriptHomepage & NewLine & Â
			"/echo Coded by " & ScriptAuthor & " - " & ScriptAuthorHomepage & NewLine
		return msg
	end if
	
	if cmd is "help" then
		set msg to "/echo " & FBold & "Usage:" & FBold & "/" & ScriptName & " <format> <output method> <'name of paste'>" & NewLine & Â
			"/echo <format> is the syntax that pastebin should use to parse the text. For a list of possible formats do /" & ScriptName & " formats" & NewLine & Â
			"/echo <output method> defines if the url should be echoed or said (written) to the current query/channel. Possible values: echo, say" & NewLine & Â
			"/echo <'name of paste'> defines the name of the paste. If the name contains spaces please enclose it with double quotes." & NewLine & Â
			"/echo see /" & ScriptName & " options to see and define the above as predefined options."
		return msg
	end if
	
	if cmd is "options" then
		set msg to "/echo " & FBold & "Usage:" & FBold & "/" & ScriptName & " <option> <value>" & NewLine & Â
			"/echo Options:" & NewLine & Â
			"/echo ¥ format - shows you the current default format for all the pastebins where one isn't supplied at runtime. " & FBold & "- Current Format: " & FBold & CRed & PDFormat & CWhite & NewLine & Â
			"/echo ¥ setformat - defines the format to be used in all future pastebins. For a list of possible values see /" & ScriptName & " formats" & NewLine & Â
			"/echo ¥ output - shows you if the URL is echoed or written to the current active channel/query. " & FBold & "- Current output: " & FBold & CRed & PDOutput & NewLine & Â
			"/echo ¥ setoutput - defines if the URL is echoed or written to the current active channel/query. Possible values: echo , say." & NewLine & Â
			"/echo ¥ apikey - Shows the currently used API Key. To change it type '/" & ScriptName & " setapikey YOUR-API-KEY'" & NewLine & Â
			"/echo ¥ setapikey - Defines the API Key to be used by the script. " & FBold & "- Current API Key: " & FBold & CRed & APIKey
		return msg
	end if
	
	if cmd is "version" then
		set msg to "Script Version: " & ScriptName & space & CurrentVersion & " for " & ClientName & " by " & ScriptAuthor & ". Get it from /sm @ " & SMHomepage
		return msg
	end if
	
	
	
	--- Actual Script Start
	
	-- Get Clipboard data
	set ClipBoardData to (the clipboard) as text
	set ClipBoardData to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1])' " & (quoted form of ClipBoardData)) as Çclass utf8È
	
	-- Split parameters.
	set Parameters to split(" ", cmd)
	
	-- Find if each parameter is a format or an output type and if none set it as the last bit of the name.
	repeat with i in Parameters
		if Formats contains i then
			if Format is "" then
				set Format to i as text
			else
				set Nome's end to i as text
			end if
		end if
		if Outputs contains i then
			if output is "" then
				set output to i as text
			else
				set Nome's end to i as text
			end if
		end if
		if Formats does not contain i then
			if Outputs does not contain i then
				set Nome's end to i as text
			end if
		end if
	end repeat
	-- If user didn't supply a format at runtime, set the format to the predefined one.
	if Format is "" then
		set Format to PDFormat
	end if
	-- If user didn't supply an output type at runtime, set the output type to the predefined one.
	if output is "" then
		set output to PDOutput
	end if
	-- If user didn't supply a name at runtime, set the name to the predefined one.
	if Nome is {} then
		set Nome to PDName as text
	end if
	-- Separate the Name's words by a space if they aren't already.
	set AppleScript's text item delimiters to " "
	set Nome to text items of Nome as text
	set AppleScript's text item delimiters to ""
	set Nome to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1])' " & (quoted form of Nome)) as Çclass utf8È
	
	--DEBUG. DO NOT UNCOMMENT.
	--set SendPBResult to "curl -d \"api_option=paste&api_user_key=''&api_paste_private=" & Private & "&api_paste_name=" & Nome & "&api_paste_format=" & Format & "&api_dev_key=" & APIKey & "&api_paste_code=" & ClipBoardData & "\" http://pastebin.com/api/api_post.php"
	--return SendPBResult & " - " & Nome
	
	try
		set SendPBResult to do shell script "curl -d \"api_option=paste&api_user_key=''&api_paste_private=" & Private & "&api_paste_name=" & Nome & "&api_paste_format=" & Format & "&api_dev_key=" & APIKey & "&api_paste_code=" & ClipBoardData & "\" http://pastebin.com/api/api_post.php"
	on error
		return "/echo Could not send to pastebin"
	end try
	if SendPBResult contains "Bad API request," then
		set AppleScript's text item delimiters to ", "
		set SendPBResult to 2nd text item of SendPBResult
		set AppleScript's text item delimiters to ""
		return "/echo An error occured: " & SendPBResult
	else
		set PasteBinUrl to SendPBResult
		if output is "echo" then
			return "/echo Pastebin URL: " & PasteBinUrl
		else if output is "say" then
			return "Pastebin URL: " & PasteBinUrl
		end if
	end if
	
end textualcmd

on split(delimiter, orig)
	set prevTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set output to text items of orig
	set AppleScript's text item delimiters to prevTIDs
	return output
end split

