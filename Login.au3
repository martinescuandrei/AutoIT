   #region ---Au3Recorder generated code Start (v3.3.7.0)  ---

   #include <File.au3>
   #include <Array.au3>
   #include <Debug.au3>

   #region --- Internal functions Au3Recorder Start ---
   Func _Au3RecordSetup()
   Opt('WinWaitDelay',100)
   Opt('WinDetectHiddenText',1)
   Opt('MouseCoordMode',0)
   EndFunc

   Func _WinWaitActivate($title,$text,$timeout=5)
	   WinWait($title,$text,$timeout)
	   If Not WinActive($title,$text) Then WinActivate($title,$text)
	   RETURN WinWaitActive($title,$text,$timeout)
   EndFunc

   _AU3RecordSetup()
   #endregion --- Internal functions Au3Recorder End ---

   _WinWaitActivate("Program Manager","")

   Local $arrayInput
   Local $fileLogin = "C:\Users\Administrator\Desktop\Auto Smoke test\Login.txt"

   func _WriteLog($message)

	  If FileExists(@ScriptDir&"\Log"&"\Login.txt") then
		 Local $File = FileOpen(@ScriptDir&"\Log"&"\Login.txt",$FO_APPEND)
		 _FileWriteLog(@ScriptDir&"\Log"&"\Login.txt",$message)
		 FileClose($File)
	  else
	   DirCreate(@ScriptDir&"\Log")
	   _FileCreate(@ScriptDir&"\Log"&"\Login.txt")
	   _FileWriteLog(@ScriptDir&"\Log"&"\Login.txt",$message)
   endif
   EndFunc

   Func _AssertCustom($sCondition, $message, $bExit = True, $nCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $iCurERR = @error, Const $iCurEXT = @extended)
	   Local $bCondition = Execute($sCondition)
	   If Not $bCondition Then
		   _WriteLog("Assertion Failed (Line " & $sLine & "): " & $sCondition & $message & @CRLF)
		   WinClose(WinGetTitle("[ACTIVE]"))
		   If $bExit Then Exit $nCode
	   EndIf
	   Return SetError($iCurERR, $iCurEXT, $bCondition)
	EndFunc

   Func _SetControlWithText($Pagetitle,$ControlId,$Text,$Error)

	  _AssertCustom(ControlClick($Pagetitle,"",$ControlId)==1,$Error)

	  ControlSetText($Pagetitle,"",$ControlId,"")

	  ControlSetText($Pagetitle,"",$ControlId,$Text)

	  ;Sleep(500)

   EndFunc

   _FileReadToArray($fileLogin,$arrayInput)
   If @error then
	  _WriteLog(" - The Login Config file is not present!")

   Endif

   for $i=1 to UBound($arrayInput)-1 step 10

	  Local $file= $arrayInput[$i]
	  Run($FILE)

	   if _WinWaitActivate($arrayInput[$i+1],"") == 0 Then
		 _WriteLog(" - The Login Config file is not correct!"&@CRLF&"Check :"&"'"&$arrayInput[$i+1]&"'"&" line!")
		 WinClose(WinGetTitle("[ACTIVE]"))
	   endif

		 ;User Id set
		 _SetControlWithText($arrayInput[$i+1],1007,$arrayInput[$i+2]," User Id Control")

		 ;Password set
		 _SetControlWithText($arrayInput[$i+1],1006,$arrayInput[$i+3]," Password Control")

		 ;DB set
		 _SetControlWithText($arrayInput[$i+1],1003,$arrayInput[$i+4]," DB Control")

		 ;OK
		 _AssertCustom(ControlClick($arrayInput[$i+1],"",1005)==1," Ok Control error")

		 Sleep(500)

   next
#endregion --- Au3Recorder generated code End ---
