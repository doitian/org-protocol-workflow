on alfred_script(q)
  set theApp to ""
  tell application "System Events"
    set theApp to item 1 of (get short name of processes whose frontmost is true)
  end tell

  set theBrowser to "Safari"
  if theApp = "Chrome" then
    set theApp to "Google Chrome"
  end if

  set theTasks to {}

  if theApp = "Google Chrome" or theApp = "Chromium" then
    set theTasks to linkChrome(theApp)
  else if theApp = "Finder" then
    set theTasks to linkFinder(theApp)
  -- else if theApp = "Path Finder" then
  --   set theTasks to linkPathFinder(theApp)
  -- else if theApp = "Airmail" then
  --   set theTasks to linkAirmail(theApp)
  else if theApp = "Mail" then
    set theTasks to linkMail(theApp)
  else if theApp = "DEVONthink Pro" or theApp = "DEVONthink Pro Office" then
    set theTasks to linkDEVONthink(theApp)
  else if theApp = "Contacts" then
    set theTasks to linkContacts(theApp)
  else if theApp = "Dash" then
    set theTasks to linkDash(theApp, theBrowser)
  else if theApp = "Evernote" then
    set theTasks to linkEvernote(theApp)
  else if theApp = "Safari" then
    set theTasks to linkSafari(theApp)
  else
    tell application "System Events"
      tell application process theApp
        set theName to name
      end tell
    end tell

    if theName = "FluidApp" then
      set theTasks to linkFluidApp(theApp)
    else
      set theTasks to linkApplication(theApp)
    end if
  end if


  tell application "OmniFocus"

    tell quick entry
      repeat with aTask in theTasks
        make new inbox task with properties {name: (name of aTask), note: (theNote of aTask)}
      end repeat
      open
    end tell
  end tell
end alfred_script

on escapeURI(theURI)
  set escURI to do shell script "ruby -ruri -e 'ARGV.each {|a| puts URI.escape(%Q<#{a}>)}' -- " & quoted form of theURI
end escapeURI

on linkApplication(theApp)
  set theURL to POSIX path of (path to application theApp)

  {{name: theApp, theNote: "file://" & my escapeURI(theURL)}}
end linkApplication

on linkChrome(theApp)
  using terms from application "Google Chrome"
    tell application theApp
      tell active tab of front window
        set theURL to URL
        set theTitle to title
      end tell
    end tell
  end using terms from

  {{name: theTitle, theNote: theURL}}
end linkChrome

on linkSafari(theApp)
  tell application "Safari"
    tell current tab of front window
      set theURL to URL
      set theTitle to name
    end tell
  end tell

  {{name: theTitle, theNote: theURL}}
end linkSafari

on linkFinder(theApp)
  set theTasks to {}

  tell application "Finder"
    set theSelection to the selection
    repeat with aFile in theSelection
      set theURL to POSIX path of (aFile as alias)
      set theBasename to name of aFile
      set theContainerURL to POSIX path of ((container of aFile) as alias)

      set theMessage to ("in directory " & my escapeURI(theContainerURL))

      set end of theTasks to {name: "[File] " & theBasename, theNote: (my escapeURI("file://" & theURL)) & "\n" & theMessage}
    end repeat
  end tell

  theTasks
end linkFinder

-- on linkPathFinder(theApp)
--   set theTasks to {}

--   tell application "Path Finder"
--     set theSelection to the selection
--     repeat with aFile in theSelection
--       set theURL to POSIX path of aFile
--       set theBasename to name of aFile
--       set theContainerURL to POSIX path of (container of aFile)
--       set theContainerName to name of container of aFile

--       set theMessage to ("in Path Finder directory [[file://" & theContainerURL & "][" & theContainerName & "]]")

--       set end of theTasks to {"file://" & theURL, theBasename & " :file:", theMessage}
--     end repeat
--   end tell

--   theTasks
-- end linkPathFinder

on linkMail(theApp)
  set theTasks to {}

  tell application "Mail"
    set theSelection to the selection
    repeat with aMail in theSelection
      set theID to message id of aMail
      set theSubject to subject of aMail
      set theSender to sender of aMail

      set end of theTasks to {name: "[Email] " & theSubject & " from " & theSender, theNote: "message://" & theID}
    end repeat
  end tell

  theTasks
end linkMail

-- on linkAirmail(theApp)
--   set theTasks to {}

--   tell application "Airmail"
--     set theUrl to the selectedMessageUrl
--     set theMessage to the selected message
--     set theSubject to subject of theMessage
--     set theSender to sender of theMessage

--     set end of theTasks to {name: "[Email] " & theSubject & " from " & theSender, theNote: theUrl}
--   end tell

--   theTasks
-- end linkAirmail

on linkDEVONthink(theApp)
  set theTasks to {}

  tell application "DEVONthink Pro"
    set theSelection to the selection
    repeat with aFile in theSelection
      set theURL to reference URL of aFile
      set theTitle to name of aFile

      set end of theTasks to {name: "[Devon] " & theTitle, theNote: theURL}
    end repeat
  end tell

  theTasks
end linkDEVONthink

on linkContacts(theApp)
  set theTasks to {}

  tell application "Contacts"
    set theSelection to the selection
    repeat with aPerson in theSelection
      set theID to id of aPerson
      set theTitle to name of aPerson

      set end of theTasks to {name: "Contact " & theTitle, theNote: "addressbook://" & theID}
    end repeat
  end tell

  theTasks
end linkContacts

on linkFluidApp(theApp)
  -- Assume there is a fluid app Feedly in system
  using terms from application "Feedly"
    tell application theApp
      tell selected tab of front browser window
        set theURL to URL
        set theTitle to title
      end tell
    end tell
  end using terms from

  {{theNote: theURL, name: "[" & theApp & "] " & theTitle}}
end linkFluidApp

on linkBrowser(theBrowser)
  if theBrowser = "Safari" then
    linkSafari(theBrowser)
  else if theBrowser = "Google Chrome" or theBrowser = "Chromium" then
    linkChrome(theBrowser)
  else
    tell application "System Events"
      keystroke "l" using {command down}
      keystroke "c" using {command down}
      set theURL to (get the clipboard)
      {{theNote: theURL, name: theURL}}
    end tell
  end if
end linkBrowser

on linkDash(theApp, theBrowser)
  tell application "System Events"
    tell process "Dash"
      click button 1 of group 2 of splitter group 1 of front window
      delay 1
    end tell
  end tell
  linkBrowser(theBrowser)
end linkDash

on linkEvernote(theApp)
  set theTasks to {}

  tell application "Evernote"
    set theSelection to the selection
    repeat with aNote in theSelection
      set theURL to note link of aNote
      set theTitle to title of aNote
      set theNotebook to the name of notebook of aNote

      set end of theTasks to {theNote: theURL, name: "[Evernote] " & theTitle & " from " & theNotebook}
    end repeat
  end tell

  theTasks
end linkEvernote
