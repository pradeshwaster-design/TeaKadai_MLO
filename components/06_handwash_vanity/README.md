# Rustic Washbasin Vanity — OpenSCAD model (real-life size)

Modeled from the reference photo: wooden cupboard with two blue doors,
concrete countertop, dark undermount basin, tall gooseneck faucet.

## Files

| File | What it is |
|---|---|
| `handwash_vanity.scad` | Parametric OpenSCAD model (1 unit = 1 mm) |
| `export_stls.ps1` | Batch-exports every part + full assembly to STL |
| `stl\` | Exported meshes in millimeters (3D-print / generic) |
| `stl_meters\` | Exported meshes scaled to meters — import these for GTA V |

## Real-life dimensions (assembled)

| Item | Size |
|---|---|
| Overall (W × D × H) | 620 × 530 × 885 mm |
| Cabinet carcass | 560 × 480 × 850 mm |
| Countertop slab | 620 × 530 × 35 mm (30 mm side / 35 mm front overhang) |
| Sink cut-out | 420 × 300 mm, basin 130 mm deep |
| Faucet | ~266 mm above countertop, 110 mm spout reach |
| Each door | 232 × 694 × 18 mm |
| Toe kick | 70 mm high, 35 mm setback |

## How to use

1. Open `handwash_vanity.scad` in **OpenSCAD** (2019.05 or newer).
2. In the Customizer (Window → Customizer) tweak any dimension you want.
3. Press **F6** to render, then **File → Export → STL** (or OBJ).

### Choosing what you export

The `part` dropdown in the Customizer selects what is shown / exported:

- `assembly` — everything in place (one mesh)
- `carcass` — cabinet box + face frame
- `door_left` / `door_right` — the blue doors as separate meshes
  (keep these separate in your MLO if you want doors that can open)
- `countertop`, `sink`, `faucet`, `door_handles` — individual meshes

## Batch export (PowerShell)

```powershell
cd components\06_handwash_vanity
.\export_stls.ps1
```

Writes every part twice: `stl\` (mm) and `stl_meters\` (GTA scale).
Requires OpenSCAD at `C:\Program Files\OpenSCAD\openscad.exe` (default install).

## GTA 5 MLO workflow

GTA V world units are **meters** (1 unit = 1 m); the model is authored in mm.

1. Import the meshes from `stl_meters\` into **Blender** (File → Import → STL)
   — they come in at GTA scale 1:1. (Or import the mm versions and scale ×0.001.)
2. Parts exported separately are already aligned at their real positions —
   no repositioning needed. For openable doors, set each door's origin at its
   hinge edge (Object → Set Origin).
3. UV-unwrap and texture (STL carries no UVs):
   - weathered brown wood — frame / carcass
   - distressed blue painted wood — doors
   - grey concrete — countertop
   - near-black — basin
   - dark gunmetal — faucet + faucet handles
   - bronze — door bar handles
4. Use **GIMS EV** or **Sollumz** in Blender to create the `.ydr` drawable +
   `.ytd` textures, and simple box collision (`.ybn`) for carcass + countertop.
5. Keep it game-friendly: set `quality = 24` before exporting (lower poly),
   or decimate in Blender — final counts stay in the low thousands of tris.
