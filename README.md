# DisplayXR for Godot XR apps

Run Godot XR apps's OpenXR (VR) mode on a DisplayXR 3D display (glasses-free, tracked) instead of a
headset. With the DisplayXR dev runtime the 3D sits inside the app's own window, next to other
3D apps.

Status: **work in progress.** Tested: Godot XR Tools demo (xr-tools 4.5.2, Godot 4, Compatibility/GL renderer) on Windows 11 x64, on DisplayXR's simulated
display. Framing, measured depth and input are still being calibrated.

## What's here

| File | Purpose |
|---|---|
| `Launch-Godot-DisplayXR.cmd` / `.ps1` | Start the app on DisplayXR (installed runtime by default; `-Runtime dev` for the 3D in the app window, mouse hand and depth slider) |
| `coupling.ps1` | Every app / runtime internal this depends on (exe name, how the app is found, runtime registration). **Not a contract.** |
| `tools/New-TrueGeometryRig.ps1` | Seeds the DisplayXR legacy camera rig from the runtime's display info (see Depth) |
| `tools/DisplayXR-DepthSlider.ps1` | Depth / Focus slider docked in the app window (dev runtime) |
| `GodotXRToolsDemo.exe.json` | Fallback rig, used only if display info can't be read |
| `local.ps1` (yours, not committed) | Machine-specific settings, e.g. `$DevRuntimeJson = "...\DisplayXR_win64.json"; $AppExe = "..."` |

## Use

1. Install the DisplayXR runtime from https://github.com/DisplayXR/displayxr-runtime/releases,
   or build it from source for `-Runtime dev`.
2. Get the app: any Godot 4 OpenXR export, e.g. the Godot XR Tools demo from https://github.com/GodotVR/godot-xr-tools/releases.
3. `Launch-Godot-DisplayXR.cmd` (add `-AppExe <path>` if it isn't found).
   For another Godot 4 export: `-AppExe <game.exe> -ViewPx <window WxH>`.

The launcher needs PowerShell 7 (`pwsh`). It runs under the default `RemoteSigned` execution
policy. If your policy blocks local unsigned scripts, unblock the files (`Unblock-File`) or sign
them; the launcher doesn't bypass the policy.

## Depth

The launcher seeds the legacy camera rig every start with a **true-geometry rig**, the same
calibration as DisplayXR's Blender, 3D Slicer and Twinmotion integrations:

- `verticalFov` is the 3D view's angular height from the nominal viewer, so the view maps 1:1 onto
  the panel.
- `convergenceDiopters` is 1 / `-GlassM`: app metres that land on the screen (default 1.5).
- `ipdFactor` puts infinity at the behind-screen comfort budget (0.42 % of the view width, a named
  constant until the runtime publishes one). The in-front budget (0.14 %) then holds for anything
  at least 0.75 × the screen distance away.

Panel size, resolution and viewer distance come from the runtime's display info
(`displayxr-cli status --json`); the constants in the script are fallbacks only. The rig is set at
start and doesn't follow the window: re-launch after resizing. Not yet measured for this app.

## Known issues

- Godot's Compatibility (GL) renderer needs a depth swapchain format. DisplayXR's GL compositor
  doesn't advertise one yet (a fix is proposed upstream); until it lands Godot logs "No usable depth
  swap chain format available" and XR fails to start. Use `-Runtime dev` with a build that has it.
- The Godot XR Tools demo waits for a controller trigger ("Hold trigger to continue").
- Godot's default window (1152×648 px) is small on a high-DPI panel, so the true-geometry view is
  narrow. Use `-Fullscreen` or pass the window size with `-ViewPx WxH`.

## Where this is heading

DisplayXR's target for third-party apps is a host library with a texture hand-off or a dedicated
3D window: https://github.com/DisplayXR/displayxr-runtime/discussions/2331#discussioncomment-19185165. This launcher is the interim path, through the app's own OpenXR mode.

## Licence

Apache-2.0 (see LICENSE and NOTICE). The app itself is not included.
