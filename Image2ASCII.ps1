param([string]$pth,[int]$w,[int]$h)

function cc2c([ConsoleColor]$cc) { return [Drawing.Color]::FromName($cc.ToString()) }

function color([Drawing.Color]$c) {
  $t = 0.2
  if ($c.GetBrightness() -lt $t) {return "Black"}
  if ($c.GetSaturation() -lt $t) {return "Black"}
  $m = [Enum]::GetValues([ConsoleColor]) |
    Where-Object {(cc2c($_)).GetSaturation() -gt $t} |
    Sort-Object {([Math]::Abs(((cc2c($_)).GetHue()-$c.GetHue())))}
  return $m[0]
}

$cs = "#*+o=-:. ".ToCharArray()
[Reflection.Assembly]::LoadFrom((gci "$ENV:WinDir\assembly" -Filter *drawing.dll -R)[0].FullName) | Out-Null
$img = [Drawing.Image]::FromFile($PSScriptRoot + $pth)
$bmp = New-Object Drawing.Bitmap ($img,$w,$h)
for ([int]$y=0; $y -lt $h; $y++) {
  for ([int]$x=0; $x -lt $w - 1; $x++) {
    $p = $bmp.GetPixel($x,$y)
    $bri = $p.GetBrightness()
    $ch = $cs[([Math]::Floor($bri*$cs.count)-1)]
    if (-not $ch) { $ch = $cs[-1] }
    Write-Host $ch -NoNewLine -ForegroundColor $(color $p)
  }
  Write-Host
}
