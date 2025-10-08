# === 連番リネーム PowerShell スクリプト ===
# フォルダ内のファイルを「photo_001.jpg」形式でリネームする
# 確認後に実行する安全設計

# === 設定 ===
$folder = "C:\Users\konii\OneDrive\Pictures\Screenshots"  # 対象フォルダを指定
$prefix = "photo"                            # 新しいファイル名の先頭
$padding = 3                                 # 連番の桁数（例：001, 002, 003）

# === ファイル一覧を取得してソート ===
$files = Get-ChildItem $folder -File | Sort-Object LastWriteTime

# === プレビュー ===
$i = 1
$preview = @()
foreach ($file in $files) {
    $ext = $file.Extension
    $newName = "{0}_{1:D$padding}{2}" -f $prefix, $i, $ext
    $preview += [PSCustomObject]@{
        "Old Name" = $file.Name
        "New Name" = $newName
    }
    $i++
}

Write-Host "=== 以下のようにリネームされます ===" -ForegroundColor Cyan
$preview | Format-Table -AutoSize

# === 実行確認 ===
$confirm = Read-Host "リネームを実行しますか？(y/n)"
if ($confirm -eq "y") {
    $i = 1
    foreach ($file in $files) {
        $ext = $file.Extension
        $newName = "{0}_{1:D$padding}{2}" -f $prefix, $i, $ext
        Rename-Item $file.FullName -NewName $newName
        $i++
    }
    Write-Host "✅ リネーム完了！" -ForegroundColor Green
} else {
    Write-Host "❌ キャンセルしました。" -ForegroundColor Yellow
}
