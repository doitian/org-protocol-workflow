on run argv
	set theApp to item 1 of argv
	set theResult to {}
	set theLines to {}
	
	if theApp = "Google Chrome" or theApp = "Chromium" then
		set theLines to linkChrome(theApp)
	else if theApp = "Finder" then
		set theLines to linkFinder(theApp)
	else if theApp = "Path Finder" then
		set theLines to linkPathFinder(theApp)
	else
		set theLines to linkApplication(theApp)
	end if
	
	repeat with aLine in theLines
		set theURL to item 1 of aLine
		set theTitle to item 2 of aLine
		set theMessage to item 3 of aLine
		
		set end of theResult to encodeURIComponent(theURL) & "/" & encodeURIComponent(theTitle) & "/" & encodeURIComponent(theMessage)
	end repeat
	
	set the text item delimiters of AppleScript to "\n"
	theResult as text
end run

on encodeURIComponent(theURI)
	set escURI to do shell script "ruby -ruri -e 'ARGV.each {|a| puts URI.escape(%Q<#{a}>, /([^-._~0-9A-Za-z])/n)}' -- " & quoted form of theURI
end encodeURIComponent

on linkApplication(theApp)
	set theURL to POSIX path of (path to application theApp)
	set theMessage to get the clipboard

	{{"file://" & theURL, theApp, theMessage}}
end linkApplication

on linkChrome(theApp)
	if theApp = "Google Chrome" then
		tell application "Google Chrome"
			tell active tab of window 1
				set theURL to URL
				set theShortTitle to title
				copy selection
			end tell
		end tell
	else
		tell application "Chromium"
			tell active tab of window 1
				set theURL to URL
				set theShortTitle to title
				copy selection
				delay 0.5
			end tell
		end tell
	end if

	set theMessage to (get the clipboard)
  set theTitle to theShortTitle & " in " & theApp
	{{theURL, theTitle, theMessage}}
end linkChrome

on linkFinder(theApp)
	set theLines to {}
	
	tell application "Finder"
		set theSelection to the selection
		repeat with aFile in theSelection
			set theURL to POSIX path of (aFile as alias)
			set theBasename to name of aFile
			set theContainerURL to POSIX path of ((container of aFile) as alias)
			set theContainerName to name of container of aFile
			
			set theMessage to ("in Finder directory [[file://" & theContainerURL & "][" & theContainerName & "]]")

			set end of theLines to {"file://" & theURL, theBasename, theMessage}
		end repeat
	end tell
	
	theLines
end linkFinder

on linkPathFinder(theApp)
  set theLines to {}

  tell application "Path Finder"
		set theSelection to the selection
		repeat with aFile in theSelection
			set theURL to POSIX path of aFile
			set theBasename to name of aFile
			set theContainerURL to POSIX path of (container of aFile)
			set theContainerName to name of container of aFile

			set theMessage to ("in Path Finder directory [[file://" & theContainerURL & "][" & theContainerName & "]]")

			set end of theLines to {"file://" & theURL, theBasename, theMessage}
		end repeat
  end tell

  theLines
end linkFinder
