
🎯 Overview

AimMaster is a tool designed to help you replicate your exact mouse sensitivity across different games by measuring your in-game sensitivity using abstract numeric values (Units).

🚀 Step-by-Step Guide

1. Launch the program, set up your hotkeys, and click Apply settings & Start.
2. In your main game, align your crosshair exactly with a sharp vertical line (e.g., a wall corner).
3. Press and hold your Main Key to spin 360 degrees. Use the Fine Tuning Key for precision at the finish line.
4. Note down the final number from the overlay into your notes.
5. Open another game, reset the counter, and adjust the in-game sensitivity until you do a perfect 360 turn exactly at your benchmark number.

💡 Pro-Tips

• 🖥️ Try to set the FOV, aspect ratio, and resolution identically across all games.
• 🛑 If the camera spins uncontrollably due to window focus loss, press Page Up to emergency stop.


### Video Tutorial  https://www.youtube.com/watch?v=ZFGSzbQt8FQ

🎯 Описание

AimMaster — это инструмент для точного переноса чувствительности мыши между различными играми с помощью подсчета абстрактных условных единиц (УЕ).

🚀 Пошаговый процесс калибровки

1. Запустите программу, настройте горячие клавиши и нажмите кнопку Применить настройки и Начать замер.
2. В исходной игре наведите прицел точно на вертикальный ориентир (например, угол стены).
3. Зажмите Основную клавишу. Когда оборот приблизится к 360°, доверните прицел Клавишей точной доводки точно в исходную точку.
4. Запишите полученное число УЕ с оверлея в свои заметки.
5. В новой игре сбросьте счетчик и подбирайте внутриигровую сенсу до тех пор, пока персонаж не сделает ровно 360° на том же значении УЕ.

💡 Полезные советы

• 🖥️ Старайтесь настраивать FOV, формат и разрешение экрана во всех играх одинаково.
• 🛑 Если игра перехватила курсор и камера бесконечно вращается, нажмите клавишу Page Up для экстренной остановки.


## 🛠️ Troubleshooting / Решение проблем

Choose your language: [English](#english) | [Русский](#русский)

---


If AimMaster is not rotating your camera or the overlay is hidden, check the common solutions below:

#### 1. The overlay is missing or invisible in game
* **Cause:** The game is running in "Exclusive Fullscreen" mode, which blocks Windows desktop layers.
* **Solution:** Go to your game's video settings and switch the display mode to **Borderless Windowed** or **Windowed**. 

#### 2. The script runs, but the camera does not rotate inside the game
* **Cause A:** The game bypasses Windows and reads mouse data directly from the hardware (Raw Input).
* **Solution A:** Open the game's control settings and temporarily **disable Raw Input** (Direct Input) during the measurement.
* **Cause B:** Insufficient Windows privileges. The game is running with administrator rights, blocking the script's inputs.
* **Solution B:** Close the script completely. Right-click `aimmaster.ahk` (or the compiled `.exe`) and select **"Run as administrator"**.

#### 3. The camera spins endlessly or uncontrollably
* **Cause:** The game lost window focus while the key was pressed, trapping the script in a rotation loop.
* **Solution:** Press the **`Page Up`** key on your keyboard. This is a hardcoded panic switch that immediately terminates all active rotation timers and resets the script state.

---


Если программа AimMaster не вращает камеру или оверлей не отображается в игре, ознакомьтесь с решениями основных проблем ниже:

#### 1. Оверлей таймера пропал или не виден поверх игры
* **Причина:** Игра запущена в режиме «Эксклюзивного полного экрана» (Fullscreen), который блокирует отображение любых окон Windows поверх себя.
* **Решение:** Зайдите в графические настройки игры и переключите режим отображения на **«Безрамочное окно» (Borderless Windowed)** или **«Оконный режим» (Windowed)**.

#### 2. Скрипт работает, но камера в самой игре не крутится
* **Причина А:** В игре активен «Прямой ввод» (Raw Input). Игра считывает движения мыши напрямую от железа в обход операционной системы.
* **Решение А:** Зайдите в настройки управления игры и временно **выключите Raw Input** (Прямой ввод) на время проведения замера.
* **Причина Б:** Недостаточно прав в системе. Игра запущена от имени администратора и блокирует команды от обычных программ.
* **Решение Б:** Полностью закройте AimMaster. Нажмите правой кнопкой мыши по файлу скрипта (или `.exe`) и выберите **«Запуск от имени администратора»**.

#### 3. Камера в игре бешено и бесконечно вращается
* **Причина:** Игра потеряла фокус окна в момент зажатия клавиши, из-за чего скрипт «зависнул» в цикле вращения.
* **Решение:** Нажмите клавишу **`Page Up`** на клавиатуре. Это встроенная «кнопка паники», которая мгновенно останавливает все таймеры вращения и возвращает оверлей в центр экрана.

