---@brief
---
--- https://github.com/Myriad-Dreamin/tinymist
--- An integrated language service for Typst [taɪpst]. You can also call it "微霭" [wēi ǎi] in Chinese.
---
--- Currently some of Tinymist's workspace commands are supported, namely:
--- `LspTinymistExportSvg`, `LspTinymistExportPng`, `LspTinymistExportPdf`,
--- `LspTinymistExportMarkdown`, `LspTinymistExportText`, `LspTinymistExportQuery`,
--- `LspTinymistExportAnsiHighlight`, `LspTinymistGetServerInfo`,
--- `LspTinymistGetDocumentTrace`, `LspTinymistGetWorkspaceLabels`,
--- `LspTinymistGetDocumentMetrics`, and `LspTinymistPinMain`.

---@type vim.lsp.Config
return {
  settings = {
    exportPdf = 'onType',
  },
}
