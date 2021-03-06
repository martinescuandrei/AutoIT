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

Func _WinWaitActivate($title,$text,$timeout=10)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	return WinWaitActive($title,$text,$timeout)
EndFunc

_AU3RecordSetup()
#endregion --- Internal functions Au3Recorder End ---

_WinWaitActivate("Program Manager","")

Local $arrayInput
Local $fileLogin = "C:\Users\Administrator\Desktop\Auto Smoke test\Regulatory Modules Config.txt"
local $flag = false

func _CheckWindowPresent($WinTitle,$error)
    if _WinWaitActivate($WinTitle,"") == 0 Then
		 _WriteLog($error)
		 WinClose(WinGetTitle("[ACTIVE]"))
	  endif

   EndFunc

func _ObtainSpecNameFromWinTitle($WinTitle,$Spec)

   Local $FirstSubstring
   Local $SecondSubstring
   Local $pos
   ;for $i=1 to UBound($WinTilte)-1 step 1
	  $pos = StringInStr($WinTitle,$Spec)
	  $FirstSubstring = StringMid($WinTitle,$pos,StringLen($WinTitle)-$pos)
	  $pos = StringInStr($FirstSubstring," ")
	  $SecondSubstring = StringMid($FirstSubstring,1,$pos-1)
   ;Next
   return $SecondSubstring
   EndFunc

 func _WriteLog($message)

	  If FileExists(@ScriptDir&"\Log"&"\Ingredient Line.txt") then
		 Local $File = FileOpen(@ScriptDir&"\Log"&"\Ingredient Line.txt",$FO_APPEND)
		 _FileWriteLog(@ScriptDir&"\Log"&"\Ingredient Line.txt",$message)
		 FileClose($File)
	  else
	   DirCreate(@ScriptDir&"\Log")
	   _FileCreate(@ScriptDir&"\Log"&"\Ingredient Line.txt")
	   _FileWriteLog(@ScriptDir&"\Log"&"\Ingredient Line.txt",$message)
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

   EndFunc

_FileReadToArray($fileLogin,$arrayInput)
 If @error then
	  _WriteLog(" - The Regulatory Modules Config file is not present!")

   Endif

for $i=1 to UBound($arrayInput)-1 step 10

   Local $file= $arrayInput[$i]
   Run($FILE)


   ;start Login menu
   _CheckWindowPresent($arrayInput[$i+1]," - The Regulatory Modules Config file is not correct!"&@CRLF&"Check :"&"'"&$arrayInput[$i+1]&"'"&" line!")

   ;User Id set
   _SetControlWithText($arrayInput[$i+1],1007,$arrayInput[$i+2]," User Id Control")

   ;Password set
   _SetControlWithText($arrayInput[$i+1],1006,$arrayInput[$i+3]," Password Control")

   ;DB set
   _SetControlWithText($arrayInput[$i+1],1003,$arrayInput[$i+4]," DB Control")

   ;OK
   _AssertCustom(ControlClick($arrayInput[$i+1],"",1005)==1," Ok Control error")

   ;Wait for PB module
   _CheckWindowPresent($arrayInput[$i+6]," - The Regulatory Modules Config file is not correct!"&@CRLF&"Check :"&"'"&$arrayInput[$i+2]&"'"&" line!"&@CRLF&"Or :"&"'"&$arrayInput[$i+3]&"'"&" line!")

   Sleep(750)

   ;Clear Spec List
   _AssertCustom(ControlClick($arrayInput[$i+6],"","[CLASS:Button; INSTANCE:30]")==1," Clear Spec List error")

   Sleep(1500)

   ;Open Regulatory Module -  Ingredient
   Send("{ALT}")

   Send("E")

   Send("{DOWN 3}")

   Send("{RIGHT}")

   Send("{DOWN 4}")

   Send("{ENTER}")

   ;Wait for Ingredient Line
    _CheckWindowPresent($arrayInput[$i+7]," - The Regulatory Modules Config file is not correct!"&@CRLF&"Check :"&"'"&$arrayInput[$i+7]&"'"&" line!")

   ;open filter
   _AssertCustom(ControlClick($arrayInput[$i+7],"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:7]")==1," Open Filter from Ingredient Line Step1 error!")

   ;Wait for filter
    _CheckWindowPresent("Quick Filter"," - The Ingredient Open Quick Filter hasn't started!")

   ;Check exact match
   _AssertCustom(ControlClick("Quick Filter","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:4]")==1," Check Exact Match from Quick Filter error!")

   Sleep(500)

   ;Send the name of spec
   _SetControlWithText("Quick Filter","[Class:WindowsForms10.EDIT.app.0.1a0e24_r9_ad1;INSTANCE:2]",$arrayInput[$i+5]," Spec Quick Filter error!")

   Sleep(500)

   Send("{ENTER}")

   _AssertCustom(ControlClick("Quick Filter","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1;INSTANCE:2]")==1," Select Spec Quick Filter error!")

   Sleep(750)

   ;Get new Ingredient Line title
   Local $WinTitle= WinGetTitle("[CLASS:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1]")

   Local $VerifySpecSelection = _ObtainSpecNameFromWinTitle($WinTitle,$arrayInput[$i+5])

   Sleep(500)

   ;Check if the correct page is loaded
   _AssertCustom($arrayinput[$i+5]==$VerifySpecSelection," Filter Selection is not in accordance with chosen Spec Name from Regulatory Modules Config!")

   ;Load headers for selected spec
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1;INSTANCE:3]")==1," Load headers error!")


;Step2
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1;INSTANCE:18]")==1," Perform step2 error!")
   Sleep(500)


;Step3
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1;INSTANCE:24]")==1," Perform step3 error!")

   Sleep(750)

   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1;INSTANCE:3]")==1," Perform SaveState Step3 error!")

   ;Wait for Save window
    _CheckWindowPresent("Result"," - The save confirmation message from Step3 wasn't present!")

   _AssertCustom(ControlClick("Result","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Accept SaveState Step3 error!")


;Step4
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:14]")==1," Perform step4 error!")

   ;wait for recalculate window
   _CheckWindowPresent("Information"," - The recalculate message from Step4 wasn't present!")

   ;validate recalculate
   _AssertCustom(ControlClick("Information","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform recalculate to 100% Step4 error!")

   ;push save state button
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform SaveState Step4 error!")

   ;wait for save window
    _CheckWindowPresent("Result"," - The save confirmation message from Step4 wasn't present!")

   _AssertCustom(ControlClick("Result","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform SaveState Step4 error!")


;Step5
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:12]")==1, " Perform step5 error!")

   Sleep(750)

   ;push save state button
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform SaveState Step5 error!")

   ;wait save window
    _CheckWindowPresent("Result"," - The save confirmation message from Step5 wasn't present!")

	_AssertCustom(ControlClick("Result","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Accept SaveState Step5 error!")


;Step6
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:12]")==1, " Perform step6 error!")

   Sleep(750)

   ;push save state button
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform SaveState Step6 error!")

   ;wait save window
    _CheckWindowPresent("Result"," - The save confirmation message from Step6 wasn't present!")

	_AssertCustom(ControlClick("Result","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Accept SaveState Step6 error!")

;Step7
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:13]")==1, " Perform step7 error!")

   Sleep(750)

   ;push save state button
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform SaveState Step7 error!")

   ;wait save window
    _CheckWindowPresent("Result"," - The save confirmation message from Step7 wasn't present!")

	_AssertCustom(ControlClick("Result","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Accept SaveState Step7 error!")


;Step8
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:15]")==1, " Perform step8 error!")

   Sleep(750)

   ;push save button
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:13]")==1," Perform Save Step8 error!")

   ;wait for save window
    _CheckWindowPresent("Save Panel Dialog"," - The save Panel dialog window from Step8 wasn't present!")

   _SetControlWithText("Save Panel Dialog","[Class:WindowsForms10.EDIT.app.0.1a0e24_r9_ad1; INSTANCE:1]","Rule Name"," Can't send text for save label step8!")

   _AssertCustom(ControlClick("Save Panel Dialog","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Accept save step8 error!")

    _CheckWindowPresent("Information"," - Confirm save step8 window not present!")

   _AssertCustom(ControlClick("Information","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Confirm save step8 error!")

   Sleep(750)

   ;export to spec
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:12]")==1," Perform Export to Specification step8 error!")

   _CheckWindowPresent("Import / Export"," - The Export to Specification dialog window from Step8 wasn't present!")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1; INSTANCE:13]")==1," Select Export to Specification Section step8 error!")

   Send("{DOWN}")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1; INSTANCE:8]")==1," Select Export to Specification Free Text step8 error!")

   Send("{DOWN}")

   Send("{ENTER}")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:15]")==1," Perform next step in Export to Specification step8!")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Close Export to Specification step8 error!")

   ;Save Rule Set

   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:11]")==1," Perform SaveRule step8 error!")

    _CheckWindowPresent("Save RuleSet"," - The SaveRule dialog window from Step8 wasn't present!")

   Sleep(750)

   _SetControlWithText("Save RuleSet","[Class:WindowsForms10.EDIT.app.0.1a0e24_r9_ad1; INSTANCE:1]","Rule Set"," Can't send text for save label step8!")

   _SetControlWithText("Save RuleSet","[Class:WindowsForms10.EDIT.app.0.1a0e24_r9_ad1; INSTANCE:2]","Rule Set"," Can't send text for save label step8!")

   Sleep(750)

   _AssertCustom(ControlClick("Save RuleSet","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Check IsDefaultRule from SaveRule step8 error!")

   Sleep(500)

   _AssertCustom(ControlClick("Save RuleSet","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:2]")==1," SaveRule step8 error!")

   _CheckWindowPresent("Warning"," - The overwrite dialog window from Step8 wasn't present!")

   _AssertCustom(ControlClick("Warning","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Overwrite confirm step8 error!")

;Step9
   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:24]")==1," Perform step9 error!")

   Sleep(750)

   _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:4]")==1," Perform Save Panel header step9 error!")

   ;Export to Excel
    _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:3]")==1," Perform Export to Excel step9 error!")

   ;Sleep(1000)

   Local $DirPath = @ScriptDir&"\SmokeTestExport"

   DirCreate($DirPath)

   Local $Path=$DirPath&"\Ingredient"

   _CheckWindowPresent("Save As"," - The Save Excel export dialog window from Step9 wasn't present!")

   _SetControlWithText("Save As","[CLASS:Edit; INSTANCE:1]",$Path," Can't send text for save Excel step9!")

   _AssertCustom(ControlClick("Save As","","[CLASS:Button; INSTANCE:1]")==1," Perform save Export to Excel step9 error!")

   ;Export to Spec
    _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:2]")==1," Perform Export to Specification step9 error!")

   _CheckWindowPresent("Import / Export"," - The Export to Specification dialog window from Step9 wasn't present!")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1; INSTANCE:13]")==1," Select Export to Specification Section step9 error!")

   Send("{DOWN}")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1; INSTANCE:8]")==1," Select Export to Specification Free Text step9 error!")

   Send("{DOWN 2}")

   Send("{ENTER}")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:15]")==1," Perform next step in Export to Specification step9!")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Close Export to Specification step9 error!")

   ;Export Spec Header
    _AssertCustom(ControlClick($WinTitle,"","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Perform Export Panel Header to Specification step9 error!")

   _CheckWindowPresent("Import / Export"," - The Export to Specification dialog window from Step9 wasn't present!")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1; INSTANCE:13]")==1," Select Export Panel Header to Specification Section step9 error!")

   Send("{DOWN}")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.Window.8.app.0.1a0e24_r9_ad1; INSTANCE:8]")==1," Select Export Panel Header  to Specification Free Text step9 error!")

   Send("{DOWN 3}")

   Send("{ENTER}")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:15]")==1," Perform next step in Export Panel Header to Specification step9!")

   Sleep(750)

   _AssertCustom(ControlClick("Import / Export","","[Class:WindowsForms10.BUTTON.app.0.1a0e24_r9_ad1; INSTANCE:1]")==1," Close Export Panel Header to Specification step9 error!")

   $flag = true
   ;Close
   WinClose($WinTitle)

next
if $flag == true then
   _WriteLog("Ingredient Line - ok")
EndIf

#endregion --- Au3Recorder generated code End ---
