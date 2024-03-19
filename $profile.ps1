if (!(Get-Command 'Import-PowerShellDataFile' -ErrorAction Ignore)) {
    function Import-PowerShellDataFile {
      [CmdletBinding()]
      Param (
          [Parameter(Mandatory = $true)]
          
[Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
          [hashtable] $Path
      )
      return $Path
    } 
} 

Import-Module git-aliases -DisableNameChecking
Import-Module PoShFuck
Import-Module Terminal-Icons
Import-Module scoop-completion
# PowerToys CommandNotFound module
Import-Module "C:\Program Files\PowerToys\WinGetCommandNotFound.psd1"

# [System.Environment]::SetEnvironmentVariable("FZF_DEFAULT_OPTS" ,"--preview 'bat --color=always {}'")
$env:FZF_DEFAULT_OPTS = "--preview 'bat --color=always {}'"

# Invokes
Invoke-Expression (&starship init powershell)
Invoke-Expression (&scoop-search --hook)
# Invoke-Expression "$(direnv hook pwsh)"
# Aliases
Set-Alias cc gcc
Set-Alias rb recycle-bin
Set-Alias pn pnpm
Set-Alias py python

# ADVANCED CLIS

# @jspm - Deno Package manager lol
Function dpm {
	try {
		jspm @args -m deno.json --env deno
	}
	catch {
		jspm @args
	}
}

# @curl
Function tiny ($url){
	curl -s ("http://tinyurl.com/api-create.php?url="+ $url) 
}

# @qr
Function send($path){ qr (ffsend u -q $path --copy) -s}

Function rmf{ foreach ($path in $args) {rm -Force -Recurse $path}}

Function lsa {exa @args --icons}

Function sfs {scoop-fsearch @args}
Function sup {scoop status; scoop update; noti -t "Scoop update" -m "Scoop Update Status logged!"}

Function node-nue {node (which nue)}
Function sin ($app) {scoop info $app  -v}
Function proxy ($port, $subdomain) {ssh -R ($subdomain+':80:127.0.0.1:'+$port) serveo.net}

Function pastes ($file, $content){
   echo $content | ssh pastes.sh $file
}
Function prose ($file, $content){
  echo $content > $file;
  
   scp $file nafees@prose.sh:/
}
# Pshazz
#try { $null = gcm pshazz -ea stop; pshazz init } catch { }


# Polyfill for PowerShell 7.4+:
# Ensure that a legacy 'TabExpansion' function is still called, if defined.
if ($PSVersionTable.PSVersion -ge '7.4') {
  function TabExpansion2 {
    ### Copy of the parameter declarations from the built-in TabExpansion2 function.
    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    [OutputType([System.Management.Automation.CommandCompletion])]
    Param(
      [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
      [AllowEmptyString()]
      [string] $inputScript,
      [Parameter(ParameterSetName = 'ScriptInputSet', Position = 1)]
      [int] $cursorColumn = $inputScript.Length,
      [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
      [System.Management.Automation.Language.Ast] $ast,
      [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
      [System.Management.Automation.Language.Token[]] $tokens,
      [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
      [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,
      [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
      [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
      [Hashtable] $options = $null
    )
    ###

    Set-StrictMode -Version 1
  
    if ($function:TabExpansion) { # Legacy function present: invoke it first.
      
      # Determine the arguments expected by the legacy TabExpansion function.
      $line = $inputScript.Substring(0, $cursorColumn) # the input line to the left of the cursor position
      [string] $lastWord = & { # the token immediately preceding the cursor position, if any.
        # NOTE:
        #  * The following *emulates* what PowerShell in earlier versions did, which was apparently
        #    custom parsing that included *partial* support for recognizing *quoted* tokens.
        #  * The following uses PowerShell's language parser instead, which results in 
        #    *slightly different, but arguably IMPROVED* behavior (the old behavior is less helpful in all these cases):
        #     * If the cursor is right after a *syntactically complete* quoted
        #       string literal, $lastWord is set to '' (by definition, the argument is complete)
        #     * Similarly, *syntactically complete* $(...) / @(...) / (...) expressions result in $lastWord getting set to ''
        #     * Inside quoted string literals, *escaped* quotes are handled correctly.
        $tokens = $null
        # Note: The parser ignores incidental whitespace, so we place a dummy char. at the end.
        #       that helps us determine if a space *outside a string literal* is present.
        $null = [System.Management.Automation.Language.Parser]::ParseInput($line + [char] 1, [ref] $tokens, [ref] $null)
        if ($lastToken = $tokens[-2]) { # Get the penultimate token (the last one is always the EndOfInput token)
          if ($lastToken.Text -ne [char] 1) { # Only if the line doesn't end in a stand-alone space.
            $( 
              if ($lastToken.Value) { $lastToken.Value } # string literal: output its *content*
              else { $lastToken.Text } # otherwise (bareword, variable reference, ...): output its text.
            ).TrimEnd([char] 1) # remove the dummy char.
          }
        }
      }

      # Invoke the legacy expansion function, which returns $null, one, or multiple strings.
      $result = TabExpansion $line $lastWord
      
      # If results were received:
      if ($result) {
        # Wrap them in a [System.Management.Automation.CommandCompletion] instance, as required
        # by TabExpansion2.
  
        # Construct the completion instance and output it.
        return [System.Management.Automation.CommandCompletion]::new(
          [System.Collections.ObjectModel.Collection[System.Management.Automation.CompletionResult]] $result, 
          -1, # current match index (later used to keep track of cycling through multiple matches)
          $cursorColumn - $lastWord.Length, # the start index of the token being completed.
          $lastWord.Length # the length of the token being completed.
        )
      }
      # No results? Continue below for default tab completion.
    
    } 
    
    ###  The following is the original function body (with comments removed);
    ###  you can see the original function body in a pristine session by submitting $function:TabExpansion2)
  
    if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet') {
      return [System.Management.Automation.CommandCompletion]::CompleteInput(
        $inputScript,
        $cursorColumn,
        $options)
    }
    else { # 'AstInputSet'
      return [System.Management.Automation.CommandCompletion]::CompleteInput(
        $ast,
        $tokens,
        $positionOfCursor,
        $options)
    }
  
  }
  
}
# powershell completion for zeit                                 -*- shell-script -*-

function __zeit_debug {
    if ($env:BASH_COMP_DEBUG_FILE) {
        "$args" | Out-File -Append -FilePath "$env:BASH_COMP_DEBUG_FILE"
    }
}

filter __zeit_escapeStringWithSpecialChars {
    $_ -replace '\s|#|@|\$|;|,|''|\{|\}|\(|\)|"|`|\||<|>|&','`$&'
}

[scriptblock]$__zeitCompleterBlock = {
    param(
            $WordToComplete,
            $CommandAst,
            $CursorPosition
        )

    # Get the current command line and convert into a string
    $Command = $CommandAst.CommandElements
    $Command = "$Command"

    __zeit_debug ""
    __zeit_debug "========= starting completion logic =========="
    __zeit_debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CursorPosition location, so we need
    # to truncate the command-line ($Command) up to the $CursorPosition location.
    # Make sure the $Command is longer then the $CursorPosition before we truncate.
    # This happens because the $Command does not include the last space.
    if ($Command.Length -gt $CursorPosition) {
        $Command=$Command.Substring(0,$CursorPosition)
    }
    __zeit_debug "Truncated command: $Command"

    $ShellCompDirectiveError=1
    $ShellCompDirectiveNoSpace=2
    $ShellCompDirectiveNoFileComp=4
    $ShellCompDirectiveFilterFileExt=8
    $ShellCompDirectiveFilterDirs=16
    $ShellCompDirectiveKeepOrder=32

    # Prepare the command to request completions for the program.
    # Split the command at the first space to separate the program and arguments.
    $Program,$Arguments = $Command.Split(" ",2)

    $RequestComp="$Program __complete $Arguments"
    __zeit_debug "RequestComp: $RequestComp"

    # we cannot use $WordToComplete because it
    # has the wrong values if the cursor was moved
    # so use the last argument
    if ($WordToComplete -ne "" ) {
        $WordToComplete = $Arguments.Split(" ")[-1]
    }
    __zeit_debug "New WordToComplete: $WordToComplete"


    # Check for flag with equal sign
    $IsEqualFlag = ($WordToComplete -Like "--*=*" )
    if ( $IsEqualFlag ) {
        __zeit_debug "Completing equal sign flag"
        # Remove the flag part
        $Flag,$WordToComplete = $WordToComplete.Split("=",2)
    }

    if ( $WordToComplete -eq "" -And ( -Not $IsEqualFlag )) {
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __zeit_debug "Adding extra empty parameter"
        # PowerShell 7.2+ changed the way how the arguments are passed to executables,
        # so for pre-7.2 or when Legacy argument passing is enabled we need to use
        # `"`" to pass an empty argument, a "" or '' does not work!!!
        if ($PSVersionTable.PsVersion -lt [version]'7.2.0' -or
            ($PSVersionTable.PsVersion -lt [version]'7.3.0' -and -not [ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) -or
            (($PSVersionTable.PsVersion -ge [version]'7.3.0' -or [ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) -and
              $PSNativeCommandArgumentPassing -eq 'Legacy')) {
             $RequestComp="$RequestComp" + ' `"`"'
        } else {
             $RequestComp="$RequestComp" + ' ""'
        }
    }

    __zeit_debug "Calling $RequestComp"
    # First disable ActiveHelp which is not supported for Powershell
    $env:ZEIT_ACTIVE_HELP=0

    #call the command store the output in $out and redirect stderr and stdout to null
    # $Out is an array contains each line per element
    Invoke-Expression -OutVariable out "$RequestComp" 2>&1 | Out-Null

    # get directive from last line
    [int]$Directive = $Out[-1].TrimStart(':')
    if ($Directive -eq "") {
        # There is no directive specified
        $Directive = 0
    }
    __zeit_debug "The completion directive is: $Directive"

    # remove directive (last element) from out
    $Out = $Out | Where-Object { $_ -ne $Out[-1] }
    __zeit_debug "The completions are: $Out"

    if (($Directive -band $ShellCompDirectiveError) -ne 0 ) {
        # Error code.  No completion.
        __zeit_debug "Received error from custom completion go code"
        return
    }

    $Longest = 0
    [Array]$Values = $Out | ForEach-Object {
        #Split the output in name and description
        $Name, $Description = $_.Split("`t",2)
        __zeit_debug "Name: $Name Description: $Description"

        # Look for the longest completion so that we can format things nicely
        if ($Longest -lt $Name.Length) {
            $Longest = $Name.Length
        }

        # Set the description to a one space string if there is none set.
        # This is needed because the CompletionResult does not accept an empty string as argument
        if (-Not $Description) {
            $Description = " "
        }
        @{Name="$Name";Description="$Description"}
    }


    $Space = " "
    if (($Directive -band $ShellCompDirectiveNoSpace) -ne 0 ) {
        # remove the space here
        __zeit_debug "ShellCompDirectiveNoSpace is called"
        $Space = ""
    }

    if ((($Directive -band $ShellCompDirectiveFilterFileExt) -ne 0 ) -or
       (($Directive -band $ShellCompDirectiveFilterDirs) -ne 0 ))  {
        __zeit_debug "ShellCompDirectiveFilterFileExt ShellCompDirectiveFilterDirs are not supported"

        # return here to prevent the completion of the extensions
        return
    }

    $Values = $Values | Where-Object {
        # filter the result
        $_.Name -like "$WordToComplete*"

        # Join the flag back if we have an equal sign flag
        if ( $IsEqualFlag ) {
            __zeit_debug "Join the equal sign flag back to the completion value"
            $_.Name = $Flag + "=" + $_.Name
        }
    }

    # we sort the values in ascending order by name if keep order isn't passed
    if (($Directive -band $ShellCompDirectiveKeepOrder) -eq 0 ) {
        $Values = $Values | Sort-Object -Property Name
    }

    if (($Directive -band $ShellCompDirectiveNoFileComp) -ne 0 ) {
        __zeit_debug "ShellCompDirectiveNoFileComp is called"

        if ($Values.Length -eq 0) {
            # Just print an empty string here so the
            # shell does not start to complete paths.
            # We cannot use CompletionResult here because
            # it does not accept an empty string as argument.
            ""
            return
        }
    }

    # Get the current mode
    $Mode = (Get-PSReadLineKeyHandler | Where-Object {$_.Key -eq "Tab" }).Function
    __zeit_debug "Mode: $Mode"

    $Values | ForEach-Object {

        # store temporary because switch will overwrite $_
        $comp = $_

        # PowerShell supports three different completion modes
        # - TabCompleteNext (default windows style - on each key press the next option is displayed)
        # - Complete (works like bash)
        # - MenuComplete (works like zsh)
        # You set the mode with Set-PSReadLineKeyHandler -Key Tab -Function <mode>

        # CompletionResult Arguments:
        # 1) CompletionText text to be used as the auto completion result
        # 2) ListItemText   text to be displayed in the suggestion list
        # 3) ResultType     type of completion result
        # 4) ToolTip        text for the tooltip with details about the object

        switch ($Mode) {

            # bash like
            "Complete" {

                if ($Values.Length -eq 1) {
                    __zeit_debug "Only one completion left"

                    # insert space after value
                    [System.Management.Automation.CompletionResult]::new($($comp.Name | __zeit_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")

                } else {
                    # Add the proper number of spaces to align the descriptions
                    while($comp.Name.Length -lt $Longest) {
                        $comp.Name = $comp.Name + " "
                    }

                    # Check for empty description and only add parentheses if needed
                    if ($($comp.Description) -eq " " ) {
                        $Description = ""
                    } else {
                        $Description = "  ($($comp.Description))"
                    }

                    [System.Management.Automation.CompletionResult]::new("$($comp.Name)$Description", "$($comp.Name)$Description", 'ParameterValue', "$($comp.Description)")
                }
             }

            # zsh like
            "MenuComplete" {
                # insert space after value
                # MenuComplete will automatically show the ToolTip of
                # the highlighted value at the bottom of the suggestions.
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __zeit_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }

            # TabCompleteNext and in case we get something unknown
            Default {
                # Like MenuComplete but we don't want to add a space here because
                # the user need to press space anyway to get the completion.
                # Description will not be shown because that's not possible with TabCompleteNext
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __zeit_escapeStringWithSpecialChars), "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }
        }

    }
}

Register-ArgumentCompleter -CommandName 'zeit' -ScriptBlock $__zeitCompleterBlock
