# 🍵 TeaKadai_MLO

> A parametric **OpenSCAD kit-of-parts** for a countryside **tea kadai** (tea shop) —
> modeled part-by-part, exported to STL, assembled in **Blender**, and prepared as a
> **GTA V MLO** interior.

![Tea kadai interior — rendered](references/countryside-tea-shop-3d-model-1f021a74d7.webp)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Made with OpenSCAD](https://img.shields.io/badge/parametric-OpenSCAD-blue)](components/)
[![Modeled in Blender](https://img.shields.io/badge/modeled%20in-Blender-orange?logo=blender&logoColor=white)](blender/)
[![Target: GTA V MLO](https://img.shields.io/badge/target-GTA%20V%20MLO-red)](#-gta-v-mlo-workflow)
[![Format: STL](https://img.shields.io/badge/exports-STL-green)](#-getting-started)

---

## ✨ What's inside

- **Kit-of-parts architecture** — every wall, roof piece, beam and prop is an
  independent, parametric OpenSCAD part, assembled by a dedicated `*_assemble.scad`
  file. Swap, resize or re-export any single part without touching the rest.
- **Dual-scale STL exports** — meshes in millimetres (3D printing / generic CAD)
  and, for the vanity, a PowerShell batch exporter that also emits metre-scaled
  STLs (GTA V uses 1 unit = 1 m).
- **Blender master scene, versioned** — `blender/` holds the saved iterations
  of the textured, dressed interior (`TeaKadai_V1` → `V5`, V5 is the latest).
- **Game-ready workflow** — documented path from OpenSCAD → STL → Blender →
  GIMS EV / Sollumz → `.ydr` / `.ytd` / `.ybn` for an MLO interior.

## 📁 Repository structure

```text
TeaKadai_MLO/
├── components/                    # 10 parametric model folders (110 files)
│   ├── 01_base_shell/             # floor slab, walls, front piers + sill, assembly
│   ├── 02_roof/                   # roof slab, tiles, ridge cap, eave fascias, assembly
│   ├── 03_pergola/                # posts, main/cross beams, braces, slats, assembly
│   ├── 04_chips_rack/             # snack display rack + render previews
│   ├── 05_chest_freezer/          # chest freezer + render previews
│   ├── 06_handwash_vanity/        # washbasin vanity + batch STL export script
│   ├── 07_water_can/              # 20 L water can + stand (GTA-native metres)
│   ├── 08_counter/                # service-window frame, counter ledge + legs
│   ├── 09_signage/                # hanging sign, price list, bracket (3D Tamil "டீ கடை")
│   └── 10_furniture/              # porch bench + stools (exterior furniture)
├── blender/
│   ├── TeaKadai_V1.blend          # master scene — saved iterations
│   ├── TeaKadai_V2.blend          # V2
│   ├── TeaKadai_V3.blend          # V3
│   ├── TeaKadai_V4.blend          # V4
│   └── TeaKadai_V5.blend          # latest (textured, dressed interior)
├── references/                    # 16 reference / concept renders → gallery index
├── docs/
│   └── countryside-tea-shop-3d-model.pdf   # full design document
├── LICENSE
└── README.md
```

## 🧩 Components

| # | Folder | What it contains | Highlights |
|---|--------|------------------|------------|
| 01 | [`01_base_shell`](components/01_base_shell) | Floor slab, back wall, both side walls, front-wall piers + sill, full assembly | `tea_shop_assemble.scad` puts the shell together; shared `tea_shop_parameters.scad` drives every dimension |
| 02 | [`02_roof`](components/02_roof) | Roof slab, tile layout, ridge cap, 3 × eave fascias, full assembly | `part_roof_complete.scad` previews the finished roof; own parameter/module files |
| 03 | [`03_pergola`](components/03_pergola) | 5 pergola parts (posts, main beam, cross beams, diagonal brace, slats), each with its own STL, plus assembly | Every part is pre-exported and pre-aligned at its real position |
| 04 | [`04_chips_rack`](components/04_chips_rack) | Wall-standing snack/chips display rack | Iso + front render previews included |
| 05 | [`05_chest_freezer`](components/05_chest_freezer) | Corner chest freezer with grip + vents | Iteration and close-up renders document the design |
| 06 | [`06_handwash_vanity`](components/06_handwash_vanity) | Rustic washbasin vanity (blue doors, concrete top, gooseneck tap) | Includes [`export_stls.ps1`](components/06_handwash_vanity/export_stls.ps1) batch exporter (mm **and** GTA metres) and a detailed [component README](components/06_handwash_vanity/README.md) |
| 07 | [`07_water_can`](components/07_water_can) | 20 L (5-gal) water can with dispensing tap on a box stand | Authored in **metres** — GTA-native, no scaling needed; `all`/`can`/`stand` parts with export wrappers; game-ready at `segments = 24` (~1–2 k tris), base-centre origins for easy prop placement |
| 08 | [`08_counter`](components/08_counter) | Service-window counter & frame: teal window frame (header, jambs, sill trim), counter ledge + support legs | Fills the front-wall window opening from Group 1; shares the shop's global coordinate system (mm) with Groups 1–3 |
| 09 | [`09_signage`](components/09_signage) | Signage: hanging sign board, price-list sign, wall bracket — 3D Tamil "டீ கடை" lettering | Pre-aligned to the shared coordinate system (Groups 1–4); own parameter + module files |
| 10 | [`10_furniture`](components/10_furniture) | Exterior furniture: long wooden porch bench (plank seat, post + apron-rail leg assemblies) and stools | Bench + stool parts incl. local-coordinate variants; pre-aligned to the shared coordinate system (Groups 1–5); own parameter + module files |

## 🚀 Getting started

**Prerequisites**

- [OpenSCAD](https://openscad.org/) 2019.05+ (for rendering / re-exporting parts)
- [Blender](https://www.blender.org/) 3.x+ (for assembly, texturing, MLO export)

**Render & export a part**

1. Open any `part_*.scad` or the `*_assemble.scad` file in OpenSCAD.
2. Tweak dimensions in the **Customizer** (Window → Customizer).
3. `F6` to render, then `File → Export → STL/OBJ`.

**Batch export (vanity example)**

```powershell
cd components\06_handwash_vanity
.\export_stls.ps1
```

Writes every part twice: `stl\` (millimetres) and `stl_meters\` (GTA scale).

## 🎮 GTA V MLO workflow

1. Import the metre-scaled STLs into **Blender** — parts arrive pre-aligned;
   no repositioning needed. (Or import mm meshes and scale ×0.001.)
2. Set each openable door's origin at its hinge edge (**Object → Set Origin**).
3. UV-unwrap and texture (STL carries no UVs).
4. Use **GIMS EV** or **Sollumz** to create the `.ydr` drawable + `.ytd` textures,
   and simple box collision (`.ybn`) for the carcass/countertop.
5. Keep it game-friendly: lower the `quality` parameter before exporting, or
   decimate in Blender — final meshes stay in the low thousands of tris.

> 📝 The full step-by-step (with the vanity as the worked example) is in
> [`components/06_handwash_vanity/README.md`](components/06_handwash_vanity/README.md).

## 🖼️ Gallery

| Pantry & props | Vanity · Freezer · TV |
|---|---|
| ![Component close-ups](references/countryside-tea-shop-3d-model-b8db6a50a1.webp) | ![Chips rack preview](components/04_chips_rack/preview_iso.png) |

Browse all 16 reference/concept renders in the
[`references/`](references/) gallery index.

## 📄 Documentation

The complete design document (every part, dimension and export note) is in
[`docs/countryside-tea-shop-3d-model.pdf`](docs/countryside-tea-shop-3d-model.pdf).

## 📜 License

Released under the [MIT License](LICENSE) — free to use, modify and build upon.
