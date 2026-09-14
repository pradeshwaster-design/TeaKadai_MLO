# ============================================================
#  export_stls.ps1
#  Exports every part + the full assembly of handwash_vanity.scad
#  to STL, once in millimeters (stl\) and once in meters
#  (stl_meters\) for GTA V MLO (GTA V: 1 unit = 1 meter).
#
#  Usage:  .\export_stls.ps1
# ============================================================

$ErrorActionPreference = "Stop"

$openscad = "C:\Program Files\OpenSCAD\openscad.exe"
if (-not (Test-Path $openscad)) {
    $cmd = Get-Command openscad -ErrorAction SilentlyContinue
    if ($cmd) { $openscad = $cmd.Source }
    else { throw "OpenSCAD not found. Edit the `$openscad path in this script." }
}

$here = $PSScriptRoot
$src  = Join-Path $here "handwash_vanity.scad"
if (-not (Test-Path $src)) { throw "Model not found: $src" }

$parts = @("assembly", "carcass", "door_left", "door_right", "countertop", "sink", "faucet", "door_handles")
$scales = @(
    @{ folder = "stl";        flag = "false" },
    @{ folder = "stl_meters"; flag = "true"  }
)

foreach ($s in $scales) {
    $outDir = Join-Path $here $s.folder
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    foreach ($p in $parts) {
        $out = Join-Path $outDir ("handwash_{0}.stl" -f $p)
        Write-Host ("Exporting {0} -> {1} ..." -f $p, $s.folder)
        & $openscad -o $out -D ("part=`"{0}`"" -f $p) -D ("gta_scale={0}" -f $s.flag) $src | Out-Null
        if ($LASTEXITCODE -ne 0) { Write-Host "  FAILED: $p" -ForegroundColor Red }
        else                     { Write-Host "  OK: $out" -ForegroundColor Green }
    }
}

Write-Host ""
Write-Host "Done. STLs are in stl\ (mm) and stl_meters\ (GTA V meters)."
