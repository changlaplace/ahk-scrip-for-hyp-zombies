#Requires AutoHotkey >=2.0- <2.1
MsgBox "Here's an simple AHK script for easier gun changing in hypixel zombie games.It now provides a manual mode and an auto mode,which can be access by following keys`n1.For manual mode,press 'Ctrl' and ',' then input the fire sequence you want.It will help you switch gun when you right click to shoot.`n2.For auto mode press 'Ctrl' and '.' then input the fire sequence,Loop number and average reaction time.When you press the '`' it will shoot automatically.`nYou can exit with 'Ctrl'+'Alt'+'s' .`n这里有一个简单的AHK脚本，可以更容易地在hypixel僵尸游戏中更换枪支。它现在提供了手动模式和自动模式，可以通过按以下案件进行参数调整。`n1.对于手动模式，按“Ctrl”和“，”，然后输入你想要的射击序列。当你右击射击时，它会帮助你切换枪。`n2.对于自动模式，按“Ctrl”和“。”，然后输入开火顺序、循环次数和平均反应时间。当你按下“`”键时，它会自动开火。同时按“Ctrl”“Alt”“s”以退出脚本，也可以在右下角箭头那里退出，希望你的mc不是全屏模式"
manual_sequence:="23"
auto_sequence:="23"
manual_sequenth_length:=2
auto_sequenth_length:=2
manual_array:=[]
auto_array:=[]
Initialize_manual(manual_sequence)
{
	manual_sequenth_length:=StrLen(manual_sequence)
	k:=0
	Loop manual_sequenth_length
	{
		k:=k+1
		manual_array.Push(SubStr(manual_sequence,k,1))
	}
	return manual_sequenth_length
}
Initialize_auto(auto_sequence)
{
	auto_sequenth_length:=StrLen(auto_sequence)
	k:=0
	Loop auto_sequenth_length
	{
		k:=k+1
		auto_array.Push(SubStr(auto_sequence,k,1))
	}
	return auto_sequenth_length
}
manual_sequenth_length:=Initialize_manual(manual_sequence)
auto_sequenth_length:=Initialize_auto(auto_sequence)

;This message is for debug use
;MsgBox "The initial value is: " manual_sequenth_length

;the code following is for manual mode programming

;here's for auto_aim
auto_aim:=1
Colorstorage:=0xFF0300
Xhalfrange:=70
Yhalfrange:=70
Px:=0
Py:=0
^!o::
{
	global
	Colorstorage:=0xFF0300
}
^!l::
{
	global
	auto_aim:=auto_aim*-1
}
current_num := 1
RButton::
{
	global	
	if (auto_aim=1)
	{
		MouseGetPos &MouseX, &MouseY
		Scale_factor:=1.9
		If_found:=PixelSearch(&Px, &Py, MouseX-Xhalfrange, MouseY-Yhalfrange, MouseX+Xhalfrange, MouseY+Yhalfrange, Colorstorage,5)
		Sleep 10
		;MsgBox Px "`n" Py 
		;MsgBox MouseX "`n" MouseY
		if (If_found=1)
		{
			MouseMove Integer((Px-MouseX)/Scale_factor), Integer((Py-MouseY)/Scale_factor), 50,"R"
		}
	}
	Send "{Click Right}"
	;;;;;;;;;;;;;;;;;;
	Sleep 30
	;;;;;;;;;;;;;;;;;;
	Send manual_array[current_num]
	current_num := current_num+1
	if (current_num = manual_sequenth_length+1)
	{
		current_num := 1
	}
	return
}
;its for configuration of manual mode
^,::    
{
	global
	manual_sequence_config:=InputBox("Please send me the fire sequence.It should be a sequence of number made up by 2,3,4.Such as 2234 ", "Manual mode sequence configuration")
	manual_sequence:=manual_sequence_config.Value
	manual_array:=[]
	manual_sequenth_length:=Initialize_manual(manual_sequence)
	current_num:=1
}
;the code following is for auto mode programming
Loop_num := 5
average_reaction_time:=80
average_reaction_time_error:=20
current_num_auto:=1
q::
{
	global
	Loop Loop_num
	{
		mean:=average_reaction_time
		sigma:=average_reaction_time_error
		Loop auto_sequenth_length
		{
			if (auto_aim=1)
				{
					MouseGetPos &MouseX, &MouseY
					Scale_factor:=1.9
					If_found:=PixelSearch(&Px, &Py, MouseX-Xhalfrange, MouseY-Yhalfrange, MouseX+Xhalfrange, MouseY+Yhalfrange, Colorstorage,5)
					Sleep 10
					;MsgBox Px "`n" Py 
					;MsgBox MouseX "`n" MouseY
					if (If_found=1)
					{
						MouseMove Integer((Px-MouseX)/Scale_factor), Integer((Py-MouseY)/Scale_factor), 50,"R"
					}
				}			
			Send "{click ,Right}"
			Send auto_array[current_num_auto]
			current_num_auto := current_num_auto+1
			N := Random(1, sigma)
			Sleep mean+sigma
			if (current_num_auto = auto_sequenth_length+1)
			{
				current_num_auto := 1
			}
		}
	}
}
;its for configuration of manual mode
^.::    
{
	global
	auto_sequence_config:=InputBox("Please send me the fire sequence.When you press q, I'll help you shoot in this sequence autoly.It should be a sequence of number made up by 2,3,4.Such as 2234 ", "Auto mode sequence configuration")
	auto_sequence:=auto_sequence_config.Value
	auto_array:=[]
	auto_sequenth_length:=Initialize_auto(auto_sequence)
	current_num_auto:=1	
	auto_loopnum_config:=InputBox("Please tell me how many times you want to shoot the sequence with a key pression ", "Auto mode sequence configuration")
	Loop_num := auto_loopnum_config.Value
	auto_reaction_time_config:=InputBox("Please tell the shoot interval you want.It should be a integer representing miliseconds", "Auto mode sequence configuration")
	average_reaction_time:=auto_reaction_time_config.Value
}
^!s::ExitApp   ; Exit script with Ctrl+Alt+s

