#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

#HotIf WinActive("ahk_exe EXCEL.EXE")
^+q::AddPrefixToExcelSelection()
#HotIf

AddPrefixToExcelSelection() {
    try xl := ComObjActive("Excel.Application")
    catch {
        MsgBox("没有找到正在运行的 Excel。请先打开 Excel 并选中单元格。", "Excel 批量添加前缀", "Icon!")
        return
    }

    try selection := xl.Selection
    catch {
        MsgBox("无法读取当前 Excel 选区。请先选中一个或多个单元格。", "Excel 批量添加前缀", "Icon!")
        return
    }

    try cells := selection.Cells
    catch {
        MsgBox("当前选区不是单元格区域。请选中一个或多个单元格后再按 Ctrl+Shift+Q。", "Excel 批量添加前缀", "Icon!")
        return
    }

    input := InputBox("请输入要添加到每个选中单元格前面的文字：", "Excel 批量添加前缀", "w420 h135")
    if (input.Result != "OK")
        return

    prefix := input.Value
    if (prefix = "")
        return

    processed := 0
    skippedBlank := 0
    skippedFormula := 0
    failed := 0

    oldScreenUpdating := xl.ScreenUpdating
    oldEnableEvents := xl.EnableEvents

    try {
        xl.ScreenUpdating := false
        xl.EnableEvents := false

        for area in selection.Areas {
            for cell in area.Cells {
                try {
                    if (cell.HasFormula) {
                        skippedFormula += 1
                        continue
                    }

                    value := cell.Value
                    if (value = "") {
                        skippedBlank += 1
                        continue
                    }

                    cell.Value := prefix . value
                    processed += 1
                } catch {
                    failed += 1
                }
            }
        }
    } finally {
        xl.ScreenUpdating := oldScreenUpdating
        xl.EnableEvents := oldEnableEvents
    }

    message := "已添加前缀：" . processed . " 个单元格"
    if (skippedBlank > 0)
        message .= "`n跳过空白单元格：" . skippedBlank . " 个"
    if (skippedFormula > 0)
        message .= "`n跳过公式单元格：" . skippedFormula . " 个"
    if (failed > 0)
        message .= "`n处理失败：" . failed . " 个"

    MsgBox(message, "Excel 批量添加前缀")
}
