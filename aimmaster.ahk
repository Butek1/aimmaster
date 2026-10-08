#Persistent
#NoEnv
SetBatchLines, -1

; --- Инициализация и загрузка настроек из INI ---
IniFile := A_ScriptDir "\config.ini"
NotesFile := A_ScriptDir "\notes.txt"
HelpFile := A_ScriptDir "\help.html"

IniRead, SavedKeyNormal, %IniFile%, Hotkeys, KeyNormal, F8
IniRead, SavedKeySlow, %IniFile%, Hotkeys, KeySlow, F7
IniRead, SavedKeyReset, %IniFile%, Hotkeys, KeyReset, F11
IniRead, SavedRotationSpeed, %IniFile%, Settings, RotationSpeed, 10
IniRead, CurrentLang, %IniFile%, Settings, Language, RU
IniRead, CurrentTheme, %IniFile%, Settings, Theme, Light ; Загружаем тему (по умолчанию Light)

RotationSpeed := SavedRotationSpeed
RunningNormal := false
RunningSlow := false
AccumulatedUnits := 0
OldFinalReset := ""

; --- Определение цветов темы ---
Theme_BgColor := (CurrentTheme == "Dark" ? "2F3542" : "F1F2F6")
Theme_TxtColor := (CurrentTheme == "Dark" ? "FFFFFF" : "000000")
Theme_GroupColor := (CurrentTheme == "Dark" ? "747D8C" : "000000")

; --- Создание Главного Меню Настроек ---
Gui, Settings:New, +AlwaysOnTop, % Lang("TitleSettings", "Настройки замера сенсы")
Gui, Settings:Color, %Theme_BgColor%
Gui, Settings:Font, s10 c%Theme_TxtColor%, Arial

; Кнопки управления в правом верхнем углу (Язык и Тема)
Gui, Settings:Add, Button, x440 y15 w75 h25 gToggleLanguage vLangBtn, % (CurrentLang == "RU" ? "🌐 RU" : "🌐 EN")
Gui, Settings:Add, Button, x395 y15 w40 h25 gToggleTheme vThemeBtn, % (CurrentTheme == "Dark" ? "☀️" : "🌙")

; КОЛОНКА 1 (Левая): Настройки всех клавиш
Gui, Settings:Font, c%Theme_GroupColor%
Gui, Settings:Add, GroupBox, x15 y15 w240 h75 vGroupKeyNormal, % Lang("GroupKeyNormal", "1. Основная клавиша (Полная)")
Gui, Settings:Font, c%Theme_TxtColor%
Gui, Settings:Add, Hotkey, vKeyNormal x27 y40 w215, %SavedKeyNormal%

Gui, Settings:Font, c%Theme_GroupColor%
Gui, Settings:Add, GroupBox, x15 y105 w240 h75 vGroupKeySlow, % Lang("GroupKeySlow", "2. Клавиша точной доводки (1/5)")
Gui, Settings:Font, c%Theme_TxtColor%
Gui, Settings:Add, Hotkey, vKeySlow x27 y130 w215, %SavedKeySlow%

Gui, Settings:Font, c%Theme_GroupColor%
Gui, Settings:Add, GroupBox, x15 y195 w240 h75 vGroupKeyReset, % Lang("GroupKeyReset", "3. Комбинация для сброса счетчика")
Gui, Settings:Font, c%Theme_TxtColor%
Gui, Settings:Add, Hotkey, vKeyReset x27 y220 w215, %SavedKeyReset%

; КОЛОНКА 2 (Правая): Управление скоростью, сброс и заметки
Gui, Settings:Font, c%Theme_GroupColor%
Gui, Settings:Add, GroupBox, x275 y45 w240 h225 vGroupControl, % Lang("GroupControl", "4. Управление и Скорость")
Gui, Settings:Font, c%Theme_TxtColor%
Gui, Settings:Add, Text, x287 y70 vTxtSpeed, % Lang("TxtSpeed", "Скорость вращения (базовая):")
Gui, Settings:Add, Slider, vRotationSpeedSlider gUpdateSpeed x287 y95 w215 Range5-50 ToolTipRight, %RotationSpeed%
Gui, Settings:Add, Button, x287 y150 w215 h40 gResetTimeBtn vBtnResetCounter, % "🔄 " Lang("BtnResetCounter", "Сбросить показатель на 0")
Gui, Settings:Add, Button, x287 y210 w215 h40 gOpenNotesBtn vBtnOpenNotes, % "📝 " Lang("BtnOpenNotes", "Открыть блокнот (Заметки)")

; Снизу слева: кнопка Помощи, справа: кнопка старта
Gui, Settings:Add, Button, x15 y335 w150 h45 gOpenHelpBtn vBtnHelp, % "❓ " Lang("BtnHelp", "Инструкция")
Gui, Settings:Add, Button, x180 y335 w335 h45 gStartProgram Default cGreen vBtnStart, % "▶ " Lang("BtnStart", "Применить настройки и Начать замер")

; --- Создание Окна Таймера ---
Gui, Timer:New, +AlwaysOnTop -Caption +ToolWindow +E0x20 +HwndTimerHwnd
Gui, Timer:Color, % (CurrentTheme == "Dark" ? "1E222B" : "Black")
Gui, Timer:Font, % (CurrentTheme == "Dark" ? "s24 cFFD200 Bold" : "s24 cYellow Bold"), Arial
Gui, Timer:Add, Text, vTimerDisplay w400 Center, % "0 " Lang("Unit", "УЕ")

; Показываем окно настроек
Gui, Settings:Show, w530 h395, % Lang("TitleSettings", "Настройки замера сенсы")
return

; --- Функция динамического перевода ---
Lang(Key, DefaultText) {
    global CurrentLang
    static EN := { "TitleSettings": "Sensitivity Measurement Settings"
                 , "GroupKeyNormal": "1. Main Key (Full speed)"
                 , "GroupKeySlow": "2. Fine Tuning Key (1/5 speed)"
                 , "GroupKeyReset": "3. Reset Counter Combination"
                 , "GroupControl": "4. Control & Speed"
                 , "TxtSpeed": "Rotation speed (base):"
                 , "BtnResetCounter": "Reset counter to 0"
                 , "BtnOpenNotes": "Open Notepad (Notes)"
                 , "BtnHelp": "User Guide"
                 , "BtnStart": "Apply settings & Start"
                 , "Unit": "Units"
                 , "Ready": "Ready to measure"
                 , "ErrKeys": "Rotation keys are not selected or match!"
                 , "ErrReset": "Select a combination for quick reset!"
                 , "ErrTitle": "Error" }
    
    if (CurrentLang == "EN" && EN.HasKey(Key))
        return EN[Key]
    return DefaultText
}

; --- Смена языка ---
ToggleLanguage:
    CurrentLang := (CurrentLang == "RU" ? "EN" : "RU")
    IniWrite, %CurrentLang%, %IniFile%, Settings, Language
    
    GuiControl, Settings:, LangBtn, % (CurrentLang == "RU" ? "🌐 RU" : "🌐 EN")
    
    WinSetTitle, ahk_id %TimerHwnd%,, % Lang("TitleSettings", "Настройки замера сенсы")
    GuiControl, Settings:, GroupKeyNormal, % Lang("GroupKeyNormal", "1. Основная клавиша (Полная)")
    GuiControl, Settings:, GroupKeySlow, % Lang("GroupKeySlow", "2. Клавиша точной доводки (1/5)")
    GuiControl, Settings:, GroupKeyReset, % Lang("GroupKeyReset", "3. Комбинация для сброса счетчика")
    GuiControl, Settings:, GroupControl, % Lang("GroupControl", "4. Управление и Скорость")
    GuiControl, Settings:, TxtSpeed, % Lang("TxtSpeed", "Скорость вращения (базовая):")
    GuiControl, Settings:, BtnResetCounter, % "🔄 " Lang("BtnResetCounter", "Сбросить показатель на 0")
    GuiControl, Settings:, BtnOpenNotes, % "📝 " Lang("BtnOpenNotes", "Открыть блокнот (Заметки)")
    GuiControl, Settings:, BtnHelp, % "❓ " Lang("BtnHelp", "Инструкция")
    GuiControl, Settings:, BtnStart, % "▶ " Lang("BtnStart", "Применить настройки и Начать замер")
    
    if (AccumulatedUnits == 0)
        GuiControl, Timer:, TimerDisplay, % Lang("Ready", "Готов к замеру")
    else
        GuiControl, Timer:, TimerDisplay, % AccumulatedUnits " " Lang("Unit", "УЕ")
return

; --- Смена цветовой темы ---
ToggleTheme:
    CurrentTheme := (CurrentTheme == "Dark" ? "Light" : "Dark")
    IniWrite, %CurrentTheme%, %IniFile%, Settings, Theme
    
    ; Обновляем иконку кнопки темы
    GuiControl, Settings:, ThemeBtn, % (CurrentTheme == "Dark" ? "☀️" : "🌙")
    
    ; Вычисляем новые цвета
    Theme_BgColor := (CurrentTheme == "Dark" ? "2F3542" : "F1F2F6")
    Theme_TxtColor := (CurrentTheme == "Dark" ? "FFFFFF" : "000000")
    Theme_GroupColor := (CurrentTheme == "Dark" ? "747D8C" : "000000")
    
    ; Применяем цвета к главному окну
    Gui, Settings:Color, %Theme_BgColor%
    
    ; Динамически обновляем шрифты и цвета существующих элементов
    Gui, Settings:Font, c%Theme_GroupColor%
    GuiControl, Settings:Font, GroupKeyNormal
    GuiControl, Settings:Font, GroupKeySlow
    GuiControl, Settings:Font, GroupKeyReset
    GuiControl, Settings:Font, GroupControl
    
    Gui, Settings:Font, c%Theme_TxtColor%
    GuiControl, Settings:Font, TxtSpeed
    
    ; Обновляем цвета окна таймера (оверлея)
    Gui, Timer:Color, % (CurrentTheme == "Dark" ? "1E222B" : "Black")
    Gui, Timer:Font, % (CurrentTheme == "Dark" ? "cFFD200" : "cYellow")
    GuiControl, Timer:Font, TimerDisplay
    
    ; Принудительно перерисовываем GUI, чтобы цвета обновились мгновенно
    Gui, Settings:Show, NoActivate
return

; --- Обработчики интерфейса ---
UpdateSpeed:
    Gui, Settings:Submit, NoHide
    RotationSpeed := RotationSpeedSlider
    return

ResetTimeBtn:
    AccumulatedUnits := 0
    Gosub, PlayRecycleSound
    
    if (CurrentTheme == "Dark")
        Gui, Timer:Font, cFFD200 Bold
    else
        Gui, Timer:Font, cYellow Bold
        
    GuiControl, Timer:Font, TimerDisplay
    GuiControl, Timer:, TimerDisplay, % "0 " Lang("Unit", "УЕ")
    return

OpenNotesBtn:
    if !FileExist(NotesFile) {
        DefaultText := "=== GAME SENSITIVITY NOTES / ЗАМЕТКИ ПО НАСТРОЙКАМ ИГР ===`n`n"
        DefaultText .= "[Game 1 / Игра 1: CS2]`n"
        DefaultText .= "Resolution / Разрешение: `n"
        DefaultText .= "Aspect Ratio / Формат экрана: `n"
        DefaultText .= "In-game FPS / FPS: `n"
        DefaultText .= "FOV: `n"
        DefaultText .= "Sensitivity / Чувствительность: `n"
        DefaultText .= "Result / Результат (Units/УЕ): `n`n"
        DefaultText .= "---------------------------------`n`n"
        DefaultText .= "[Game 2 / Игра 2: Deadlock]`n"
        DefaultText .= "Resolution / Разрешение: `n"
        DefaultText .= "Aspect Ratio / Формат экрана: `n"
        DefaultText .= "In-game FPS / FPS: `n"
        DefaultText .= "FOV: `n"
        DefaultText .= "Sensitivity / Чувствительность: `n"
        DefaultText .= "Result / Результат (Units/УЕ): `n"
        
        FileAppend, %DefaultText%, %NotesFile%, UTF-8
    }
    Run, notepad.exe "%NotesFile%"
    return

OpenHelpBtn:
    Run, "%HelpFile%"
    return

SaveToIni:
    Gui, Settings:Submit, NoHide
    IniWrite, %KeyNormal%, %IniFile%, Hotkeys, KeyNormal
    IniWrite, %KeySlow%, %IniFile%, Hotkeys, KeySlow
    IniWrite, %KeyReset%, %IniFile%, Hotkeys, KeyReset
    IniWrite, %RotationSpeedSlider%, %IniFile%, Settings, RotationSpeed
    return

StartProgram:
    Gosub, SaveToIni
    
    if (OldFinalNormal) {
        Hotkey, %OldFinalNormal%, OnPressNormal, Off, UseErrorLevel
        Hotkey, %OldFinalNormal% Up, OnReleaseNormal, Off, UseErrorLevel
    }
    if (OldFinalSlow) {
        Hotkey, %OldFinalSlow%, OnPressSlow, Off, UseErrorLevel
        Hotkey, %OldFinalSlow% Up, OnReleaseSlow, Off, UseErrorLevel
    }
    if (OldFinalReset) {
        Hotkey, %OldFinalReset%, OnFastReset, Off, UseErrorLevel
    }

    FinalNormal := KeyNormal ? "*" . KeyNormal : ""
    FinalSlow := KeySlow ? "*" . KeySlow : ""
FinalReset := KeyReset ? "*" . KeyReset : ""
if (FinalNormal = "" || FinalSlow = "" || FinalNormal = FinalSlow) {
MsgBox, 48, % Lang("ErrTitle", "Ошибка"), % Lang("ErrKeys", "Клавиши вращения не выбраны или совпадают!")
return
}
if (FinalReset = "") {
MsgBox, 48, % Lang("ErrTitle", "Ошибка"), % Lang("ErrReset", "Выберите комбинацию для быстрого сброса!")
return
}
Hotkey, %FinalNormal%, OnPressNormal, On
Hotkey, %FinalNormal% Up, OnReleaseNormal, On
Hotkey, %FinalSlow%, OnPressSlow, On
Hotkey, %FinalSlow% Up, OnReleaseSlow, On
Hotkey, %FinalReset%, OnFastReset, On
OldFinalNormal := FinalNormal
OldFinalSlow := FinalSlow
OldFinalReset := FinalReset
Gui, Timer:Show, xCenter y100 NoActivate
if (AccumulatedUnits = 0) {
if (CurrentTheme == "Dark")
Gui, Timer:Font, cFFD200 Bold
else
Gui, Timer:Font, cYellow Bold
GuiControl, Timer:Font, TimerDisplay
GuiControl, Timer:, TimerDisplay, % Lang("Ready", "Готов к замеру")
} else {
Gui, Timer:Font, cGreen Bold
GuiControl, Timer:Font, TimerDisplay
GuiControl, Timer:, TimerDisplay, % AccumulatedUnits " " Lang("Unit", "УЕ")
}
return
; --- Логика для ОСНОВНОЙ скорости ---
OnPressNormal:
if (RunningNormal || RunningSlow)
return
RunningNormal := true
SetTimer, RotateNormal, 10
return
OnReleaseNormal:
if (!RunningNormal)
return
SetTimer, RotateNormal, Off
Gui, Timer:Font, cGreen Bold
GuiControl, Timer:Font, TimerDisplay
GuiControl, Timer:, TimerDisplay, % AccumulatedUnits " " Lang("Unit", "УЕ")
RunningNormal := false
return
RotateNormal:
DllCall("mouse_event", "UInt", 0x0001, "Int", RotationSpeed, "Int", 0, "UInt", 0, "UPtr", 0)
AccumulatedUnits += RotationSpeed
GuiControl, Timer:, TimerDisplay, % AccumulatedUnits " " Lang("Unit", "УЕ")
return
; --- Логика для МЕДЛЕННОЙ скорости (Деление на 5) ---
OnPressSlow:
if (RunningNormal || RunningSlow)
return
RunningSlow := true
SetTimer, RotateSlow, 10
return
OnReleaseSlow:
if (!RunningSlow)
return
SetTimer, RotateSlow, Off
Gui, Timer:Font, cGreen Bold
GuiControl, Timer:Font, TimerDisplay
GuiControl, Timer:, TimerDisplay, % AccumulatedUnits " " Lang("Unit", "УЕ")
RunningSlow := false
return
RotateSlow:
SlowSpeed := Max(1, RotationSpeed // 5)
DllCall("mouse_event", "UInt", 0x0001, "Int", SlowSpeed, "Int", 0, "UInt", 0, "UPtr", 0)
AccumulatedUnits += SlowSpeed
GuiControl, Timer:, TimerDisplay, % AccumulatedUnits " " Lang("Unit", "УЕ")
return
; --- Сервисные функции ---
OnFastReset:
SetTimer, RotateNormal, Off
SetTimer, RotateSlow, Off
RunningNormal := false
RunningSlow := false
AccumulatedUnits := 0
Gosub, PlayRecycleSound
if (CurrentTheme == "Dark")
Gui, Timer:Font, cFFD200 Bold
else
Gui, Timer:Font, cYellow Bold
GuiControl, Timer:Font, TimerDisplay
GuiControl, Timer:, TimerDisplay, % "0 " Lang("Unit", "УЕ")
return
PlayRecycleSound:
DllCall("winmm\PlaySound", "Str", "EmptyRecycleBin", "Ptr", 0, "UInt", 0x00010001)
return
~PgUp::
SetTimer, RotateNormal, Off
SetTimer, RotateSlow, Off
RunningNormal := false
RunningSlow := false
Gui, Timer:Show, xCenter y100 NoActivate
return
SettingsGuiClose:
Gosub, SaveToIni
ExitApp
