-- sm - A Script Manager Script for Textual
-- Coded by Xeon3D
-- Loosely based on the script made by Nicholas Penree.

-- 2 step Installation:
-- Copy this to ~/Library/Application Support/Textual IRC/Scripts/
-- or ~/Library/Containers/com.codeux.irc.textual/Data/Library/Application Support/Textual IRC/Scripts/ 
-- if you're using the sandbox / App Store version.
-- Run /sm or /sm help for more options.

-- | SCRIPT START | --
-- |Properties| --
property ClientName : "Textual"
property ScriptName : "sm"
property ScriptDescription : "A Script Manager Script for Textual"
property ScriptHomepage : "http://xeon3d.net/textual/sm"
property ScriptDownloadFolderURL : "http://xeon3d.net/textual/sm/"
property ScriptAuthor : "Xeon3D"
property ScriptAuthorHomepage : "http://www.xeon3d.net"
property CurrentVersion : "1.0.1"
property SupportChannel : "irc://irc.freenode.org/#textual"
property RepositoryURL : "http://xeon3d.net/textual/scripts/"
property RepositoryContentsURL : RepositoryURL & "scripts.lst"

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
property Echo : "/echo "

-- | DEBUG COMMAND | --
--set cmd to ""

on textualcmd(cmd)
	
	-- |Variables| --
	
	-- Defines the version of Textual where it's being run from.
	set ClientVersion to version of application ClientName
	
	-- Defines the path for the Scripts folder inside the ~/Library/ folder according to the version of Textual.
	if ClientName is "Textual" then
		if ClientVersion > "2.0.99" then
			set ExternalScriptsPath to (the POSIX path of (path to application support from the user domain) & "Textual IRC/Scripts/") as string
			set QExternalScriptsPath to the quoted form of (the POSIX path of (path to application support from the user domain) & "Textual IRC/Scripts/")
		else
			set ExternalScriptsPath to (the POSIX path of (path to application support from the user domain) & "Textual/Scripts/") as string
			set QExternalScriptsPath to the quoted form of (the POSIX path of (path to application support from the user domain) & "Textual/Scripts/")
		end if
	end if
	
	-- Defines the temporary working directory path.
	set TempDirPath to the quoted form of (the POSIX path of (path to temporary items from the user domain))
	
	-- Defines the path where the files for the updates will be temporarily stored
	set UpdateZipPath to the quoted form of (the POSIX path of (path to temporary items from the user domain) & "update.zip")
	
	-- Initializing various variables..
	set Report to ""
	set ScriptsInstalled to 0
	set ScriptsRemoved to 0
	
	--- Not So Variables.. :ExternalScriptsPath
	--- Formatting
	set FBold to (ASCII character 2)
	set FItalic to (ASCII character 1)
	set NewLine to (ASCII character 10)
	
	--- User Options --
	
	-- UpdaterNG 0.1
	if cmd is "update" then
		
		do shell script "defaults write xeon3d.sd LatestURL " & ScriptDownloadFolderURL & "latest"
		do shell script "defaults write xeon3d.sd LatestMD5URL " & ScriptDownloadFolderURL & "latestmd5"
		
		set LatestVersionURL to do shell script "defaults read xeon3d.sd LatestURL"
		set LatestChecksum to do shell script "defaults read xeon3d.sd LatestMD5URL"
		
		--- Defines the latest available script version
		set LatestVersion to do shell script "curl " & LatestVersionURL
		
		--- Defines the latest available script version's zip file checksum
		set LatestChecksum to do shell script "curl " & LatestChecksum
		
		--- Defines the zip file URL of the latest version
		set LatestZip to ScriptDownloadFolderURL & ScriptName & "-" & LatestVersion & ".zip"
		
		-- When the file isn't there, it'll get an error HTML page.
		if LatestVersion contains "DOCTYPE" then
			return "/debug echo Error getting the latest " & ScriptName & " version number. Please try again later or visit " & ScriptHomepage & " for more information."
		end if
		if LatestVersion is greater than CurrentVersion then
			--	return UpdateZipPath
			do shell script "rm -f " & UpdateZipPath
			do shell script "curl -C - " & LatestZip & " -o " & UpdateZipPath
			if LatestChecksum is not (do shell script "md5 -q " & UpdateZipPath) then
				if LatestChecksum contains "DOCTYPE" then
					return "/debug echo Error getting the online checksum for the latest  " & ScriptName & " version. Please try again later or download newest version here: " & ScriptHomepage
				end if
				return "/debug echo The " & ScriptName & " download was corrupted. Local MD5: " & (do shell script "md5 -q " & UpdateZipPath) & " - Online MD5: " & LatestChecksum & " . Please try again later or visit " & ScriptHomepage & " for more info."
			end if
			set DownloadedUpdateCheck to do shell script "unzip -t " & UpdateZipPath
			if DownloadedUpdateCheck contains "No errors detected" then
				do shell script "rm -f " & QExternalScriptsPath & "/sd*.scpt"
				do shell script "unzip -o " & UpdateZipPath & " -d " & QExternalScriptsPath
				do shell script "rm -f " & UpdateZipPath
				set ResultMessage to "/echo Successfully updated " & ScriptName & " to version " & LatestVersion & " from " & CurrentVersion & "."
				return ResultMessage
			else if DownloadedUpdateCheck contains "cannot find" then
				set ResultMessage to "/echo Error extracting " & ScriptName & ". Try again later or download a previous version from " & ScriptHomepage
				return ResultMessage
			end if
		else if LatestVersion is equal to CurrentVersion then
			set ResultMessage to "/echo " & ScriptName & " is already up to date. (Your script version: " & CurrentVersion & "; Latest released script version: " & LatestVersion & ")"
			return ResultMessage
		else if CurrentVersion is greater than LatestVersion then
			set ResultMessage to "/echo Your copy of " & ScriptName & " is newer than the last released version. (Your script version: " & CurrentVersion & "; Latest released script version: " & LatestVersion & ")"
			return ResultMessage
		end if
	end if
	
	
	if cmd is "version" then
		set msg to " • Script Version: " & ScriptName & space & CurrentVersion & " for " & ClientName & " by " & ScriptAuthor & ". Get it @ " & ScriptHomepage & " •"
		return msg
	end if
	
	if cmd is "options" then
		set msg to "/echo  • Possible Options:" & NewLine & ¬
			"/echo • To change an option type '/" & ScriptName & " <option name> toggle'. Example: /" & ScriptName & " simple toggle " & NewLine & ¬
			"/echo • Sadly there are no options at the moment for SM"
		return msg
	end if
	
	if cmd is "list" then
		set msg to ¬
			"/echo To install or update a script type '/" & ScriptName & "install <script name>'. Example: /" & ScriptName & " install si" & NewLine & ¬
			"/echo Available Scripts:" & NewLine
		set AppleScript's text item delimiters to return
		do shell script "curl " & RepositoryContentsURL
		set allScripts to result
		set AppleScript's text item delimiters to ""
		set AvailableScripts to the paragraphs of allScripts
		repeat with i from 1 to the count of AvailableScripts
			set currentItem to get item i of AvailableScripts as string
			set AppleScript's text item delimiters to ";"
			set ItemName to first word of currentItem
			set ItemVersion to second word of currentItem
			set ItemDescription to text items 3 thru -2 of currentItem
			set ItemChecksum to the last text item of currentItem
			set AppleScript's text item delimiters to ""
			set msg to msg & Echo & " • " & ItemName & tab & tab & ItemVersion & " : " & ItemDescription & NewLine
		end repeat
		return msg
	end if
	
	
	if cmd is "help" then
		set msg to ¬
			"/echo  • " & FBold & "Usage:" & FBold & " /" & ScriptName & " [option] [parameter]" & NewLine & ¬
			"/echo  • To install a script type '/" & ScriptName & "install 'scriptname'" & NewLine & ¬
			"/echo  • To get all of the available scripts type '/" & ScriptName & "install all" & NewLine & ¬
			"/echo  • There are also some special labels: 'about' shows some info about the script; " & NewLine & ¬
			"/echo  • The 'list' label will show you a list of available scripts…" & NewLine & ¬
			"/echo  • The 'option' label will show you a list of available options…" & NewLine & ¬
			"/echo  • The 'help' label erm …  I'd guess you just discovered what it does... " & NewLine & ¬
			"/echo  • The 'version' label shows information about the version."
		return msg
	end if
	
	if cmd is "about" then
		set msg to ¬
			"/echo  • " & FBold & ScriptName & " " & CurrentVersion & FBold & " - " & ScriptDescription & NewLine & ¬
			"/echo  • Homepage: " & ScriptHomepage & NewLine & ¬
			"/echo  • Coded by " & ScriptAuthor & " - " & ScriptAuthorHomepage & NewLine
		return msg
	end if
	
	
	-- If Growl is used, notify it of what we're doing...
	
	if cmd is "install all" or cmd is "remove all" then
		set Report to Report & Echo & "Multiple Scripts Report:" & NewLine
	else if cmd contains "install" or cmd contains "remove" then
		set Report to Report & Echo & " Report:" & NewLine
	end if
	
	if cmd contains "install" then
		set ChosenScript to the last word of cmd
		if ChosenScript is "all" then
			set AppleScript's text item delimiters to return
			do shell script "curl " & RepositoryContentsURL
			set allScripts to result
			set AppleScript's text item delimiters to ""
			set AvailableScripts to the paragraphs of allScripts
		else
			try
				set AppleScript's text item delimiters to return
				do shell script "curl -s " & RepositoryContentsURL & " | grep " & ChosenScript
				set allScripts to result
				set AppleScript's text item delimiters to ""
				set AvailableScripts to the paragraphs of allScripts
			end try
			
		end if
		repeat with i from 1 to the count of AvailableScripts
			set currentItem to get item i of AvailableScripts as string
			set AppleScript's text item delimiters to ";"
			set ItemName to first word of currentItem
			set OnlineVersion to second word of currentItem
			set ItemDescription to text items 3 thru -2 of currentItem
			set OnlineChecksum to the last text item of currentItem
			set AppleScript's text item delimiters to ""
			set CurrentItemPath to ExternalScriptsPath & ItemName & ".scpt"
			set IsItInstalled to FileExists(CurrentItemPath)
			if IsItInstalled then
				set CurrentAction to "updated"
			else
				set CurrentAction to "installed"
			end if
			set InstalledVersion to do shell script "grep -m 1 CurrentVersion " & quoted form of CurrentItemPath & " | awk -F\\\" {'print $2'}"
			if OnlineVersion > InstalledVersion then
				-- Enters the Temp folder, removes any previous download of currentscript and downloads the currentscript from the repository.
				do shell script "cd " & TempDirPath & ";rm -f " & ItemName & ".zip && curl -o " & ItemName & ".zip " & RepositoryURL & ItemName & "/download/" & ItemName & "-" & OnlineVersion & ".zip"
				-- Outputs 1st header line.
				do shell script "head -n1 " & TempDirPath & ItemName & ".zip"
				-- Check if it's a zip file and if it is...
				if items 1 thru 2 of result as string is "PK" then
					-- uncompresses the zip file and removes the .zip and any extra folders.
					do shell script "cd " & TempDirPath & " && unzip " & ItemName & ".zip && rm " & ItemName & ".zip && rm -Rf __MACOSX"
					-- Removes the previous version of the script if there is one and moves the new one in.
					do shell script "cd " & QExternalScriptsPath & "; mv -f " & TempDirPath & ItemName & ".scpt ./"
					
					-- Add it to the report that'll be outputted to the IRC Client
					if CurrentAction is "updated" then
						set Report to Report & Echo & "     ✓ " & ItemName & " was updated successfully from " & InstalledVersion & " to " & OnlineVersion & "." & NewLine
					else if CurrentAction is "installed" then
						set Report to Report & Echo & "     ✓ " & ItemName & " was installed successfully. (Version: " & OnlineVersion & ")" & NewLine
					end if
					-- Increment count of installed scripts.
					set ScriptsInstalled to ScriptsInstalled + 1
					
				else
					
					-- If it's an HTML page remove downloaded page (which has a .zip extension due to the code above)
					do shell script "cd " & TempDirPath & "; rm -rf " & ItemName & ".zip"
					
					-- and add it to the report on the client.
					set Report to Report & Echo & "     ✕ " & ItemName & " not installed (doesn't exist)" & NewLine
					
				end if
			else if OnlineVersion = InstalledVersion then
				-- If we use growl tell the user the versions match.
				set Report to Report & Echo & "     - There is not any update available for " & ItemName & "." & NewLine
			else if OnlineVersion < InstalledVersion then
				-- If we use growl tell the user the local version is newer.
				set Report to Report & Echo & "     - The installed version of " & ItemName & " (" & InstalledVersion & ") is newer than the online version. (" & OnlineVersion & ")" & NewLine
				
			end if
		end repeat
	end if
	
	if cmd contains "remove" then
		set ChosenScript to the last word of cmd
		if ChosenScript is "all" then
			set AllInstalledScripts to the paragraphs of (do shell script "ls " & QExternalScriptsPath & "*.scpt")
			set InstalledScripts to {}
			repeat with i from 1 to the count of AllInstalledScripts
				set currentItem to get item i of AllInstalledScripts as string
				if currentItem contains "/sd.scpt" then
				else
					set the InstalledScripts's end to the AllInstalledScripts's item i
				end if
			end repeat
			repeat with i from 1 to the count of InstalledScripts
				set currentItem to get item i of InstalledScripts as string -- REPETICAO SE FOREM MUITOS
				try
					do shell script "rm '" & currentItem & "'"
					set ScriptsRemoved to ScriptsRemoved + 1
					set Report to Report & Echo & "     ✓ The Script " & currentItem & " was removed sucessfully." & NewLine
				on error
					set Report to Report & Echo & "     ✕ The Script " & currentItem & " was not removed because of an error." & NewLine
				end try
			end repeat
		else if ChosenScript is "sm" then
			return "/echo No no no no.. there's no removing SM from itself. No trolling! Leave that for Parth!"
		else
			set CurrentItemPath to ExternalScriptsPath & ChosenScript & ".scpt"
			set IsScriptInstalled to FileExists(CurrentItemPath)
			if IsScriptInstalled is false then
				set Report to Report & Echo & "     ✕ The script " & ChosenScript & " was not removed because it's not installed." & NewLine
				return Report
			else
				try
					do shell script "rm '" & ExternalScriptsPath & ChosenScript & ".scpt'"
					set ScriptsRemoved to ScriptsRemoved + 1
					set Report to Report & Echo & "     ✓ The script " & ChosenScript & " was removed sucessfully." & NewLine
				on error
					set Report to Report & Echo & "     ✕ The script " & ChosenScript & " was not removed because of an error." & NewLine
				end try
			end if
		end if
	end if
	
	
	set NrOfScripts to 0
	set plural to ""
	set actiondone to ""
	
	
	if cmd contains "install" then
		set actiondone to " installed"
		if ScriptsInstalled is greater than 1 or ScriptsInstalled is 0 then
			set plural to "s"
		end if
		set NrOfScripts to ScriptsInstalled
	else if cmd contains "remove" then
		set actiondone to " removed"
		if ScriptsRemoved is greater than 1 or ScriptsRemoved is 0 then
			set plural to "s"
		end if
		set NrOfScripts to ScriptsRemoved
	end if
	
	if actiondone is "" then
		set Report to "/echo Error: Please provide a valid command… (about, help, install, remove, list)"
	else
		set Report to Report & Echo & "➤ " & NrOfScripts & " script" & plural & actiondone & " successfully." & NewLine
	end if
	
	return Report
	
	
end textualcmd

on FileExists(theFile) -- (String) as Boolean
	tell application "System Events"
		if exists file theFile then
			return true
		else
			return false
		end if
	end tell
end FileExists


