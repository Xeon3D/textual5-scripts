-- ns - A DNS Script for Textual 5 
-- Coded by Xeon3D on request from Alex`
-- 

-- 1 step Installation:
-- Right click file and choose Open With -> Textual 5 to install the script.



-- | SCRIPT START | --
-- |Properties| --
property scriptname : "ns"
property ScriptDescription : "A DNS Script for Textual 5"
property ScriptHomepage : "https://raw.githubusercontent.com/Xeon3D/textual5-scripts/master/ns.scpt"
property ScriptAuthor : "Xeon3D"
property ScriptContributors : ""
property ScriptAuthorHomepage : "http://www.github.com/Xeon3D/"
property CurrentVersion : "0.0.2"
property CodeName : "The Proper Version"
property SupportChannel : "irc://irc.freenode.org/#textual"

---  Colors
property CBlack : (ASCII character 3) & "01"
property CNBlue : (ASCII character 3) & "02"
property CGreen : (ASCII character 3) & "03"
property CRed : (ASCII character 3) & "04"
property CBrown : (ASCII character 3) & "05"
property CPurple : (ASCII character 3) & "06"
property COrange : (ASCII character 3) & "07"
property CYellow : (ASCII character 3) & "08"
property CLGreen : (ASCII character 3) & "09"
property CTeal : (ASCII character 3) & "10"
property CCyan : (ASCII character 3) & "11"
property CBlue : (ASCII character 3) & "12"
property CPink : (ASCII character 3) & "13"
property CGrey : (ASCII character 3) & "14"
property CLGrey : (ASCII character 3) & "15"
property CWhite : (ASCII character 3)
property NoColor : (ASCII character 0)


on textualcmd(cmd)
	
-- DEBUG CODE	-- set cmd to "textual@187-177-41-69.dynamic.axtel.net"
set ipaddr to cmdif cmd contains "@" then	set AppleScript's text item delimiters to "@"	set ipaddr to cmd's text item 2	set AppleScript's text item delimiters to "."	set ipaddr to ipaddr's text item 1	set AppleScript's text item delimiters to "-"	set ipaddr to words of ipaddr as list	set AppleScript's text item delimiters to "."	set ipaddr to items of ipaddr as textend ifset results to do shell script "curl http://ip-api.com/csv/" & ipaddrset AppleScript's text item delimiters to ","if results starts with "fail" then	return "Error."end iftry	set country to do shell script "echo " & results's text item 2 & " | tr -d '\"'"on error	set country to results's text item 2end tryset state to results's text item 4try	set city to do shell script "echo " & results's text item 6 & " | tr -d '\"'"on error	set city to results's text item 6end trytry	set isp to do shell script "echo " & results's text item 11 & " | tr -d '\"'"on error	set isp to results's text item 11end tryset msg to "The IP Address " & ipaddr & " is from " & city & ", " & state & ", " & country & ". The ISP is:" & isp
return "/debug " & msgend