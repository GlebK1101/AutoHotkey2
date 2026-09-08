#Requires AutoHotkey v2.0

XButton1::  ; Боковая кнопка мыши (назад). Можно заменить на XButton2 или любую другую.
{
    ; Сохраняем текущее содержимое буфера обмена (картинки, файлы и т.д.)
    SavedClip := ClipboardAll()
    A_Clipboard := "" ; Очищаем буфер для надежной проверки копирования
    
    Send "^c" ; Эмулируем нажатие Ctrl+C для копирования выделенного текста
    
    ; Ждем до 0.5 секунд, пока текст не скопируется
    if !ClipWait(0.5) {
        A_Clipboard := SavedClip ; Если текст не выделен, просто возвращаем старый буфер и выходим
        return
    }

    Text := A_Clipboard

    ; Строки соответствия клавиш (включают нижний регистр, верхний регистр и спецсимволы)
    en_chars := "qwertyuiop[]asdfghjkl;'zxcvbnm,./QWERTYUIOP{}ASDFGHJKL:`"ZXCVBNM<>?``~@#$^&|"
    ru_chars := "йцукенгшщзхъфывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,ёЁ`"№;:?/"

    ConvertedText := ""
    
    ; Перебираем каждый символ скопированного текста
    Loop Parse, Text
    {
        char := A_LoopField
        
        ; Ищем символ в английской раскладке (true - с точным учетом регистра)
        posEN := InStr(en_chars, char, true)
        if posEN {
            ConvertedText .= SubStr(ru_chars, posEN, 1)
        } else {
            ; Ищем символ в русской раскладке
            posRU := InStr(ru_chars, char, true)
            if posRU {
                ConvertedText .= SubStr(en_chars, posRU, 1)
            } else {
                ; Если символ не найден (пробелы, цифры, Enter), оставляем его без изменений
                ConvertedText .= char
            }
        }
    }

    ; Помещаем измененный текст в буфер обмена
    A_Clipboard := ConvertedText
    Send "^v" ; Вставляем (Ctrl+V)
    
    ; Даем системе небольшую паузу (150 мс), чтобы текст успел вставиться до возврата старого буфера
    Sleep 150 
    A_Clipboard := SavedClip
}