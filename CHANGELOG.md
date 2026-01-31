# Changelog

## [1.0.8] - 2026-01-31

### 🐛 Bug Fixes
*   **World Object & NPC Support**: Fixed styling issues where trivial NPCs and world objects (like workbenches) were not being correctly captured by the custom backdrop.
*   **Robust Layout Engine**: Re-engineered background and border anchoring using an `OnSizeChanged` hook to ensure perfect coverage even as tooltips grow dynamically.
*   **Improved Health Bar Spacing**: Refined the internal padding logic to prevent health bar overlap without introducing extra space at the top of the tooltip.

## [1.0.7] - 2026-01-31

## [1.0.6] - 2026-01-31

### 🐛 Bug Fixes
*   **Build System**: Switched to highly reliable GitHub mirrors for `LibStub` and `CallbackHandler-1.0` to resolve remaining fetch errors in the build pipeline.

## [1.0.2] - 2026-01-30

### 🐛 Bug Fixes
*   **Build System**: Switched library repository sources to official WowAce SVN URLs to fix fetch errors in the build pipeline.

## [1.0.1] - 2026-01-30

### 🐛 Bug Fixes
*   **Packaging**: Fixed missing libraries (`LibStub`, `CallbackHandler`, `LibQTip`) in the packaged addon by adding them as externals in `.pkgmeta`.
*   **Loading**: Resolved `CallbackHandler` loading error.

## [1.0.0] - 2026-01-29

### ✨ New Features
*   **Player Inspection iLevel**: Added the ability to see item levels for other players via inspection!
*   **Enhanced iLevel Display**: Item levels now feature color-coded values for better readability.
*   **Improved Options**: Changed the border color setting to use a selection of presets for easier and faster customization.
*   **Expanded iLevel Support**: Item levels are now shown on both item and player tooltips.

## [1.0.0-alpha] - 2026-01-28

### Initial Alpha Release! 🎉
Welcome to the first alpha release of NoobTacoToolTip! I've built a clean, modern replacement for the default WoW tooltips.

### ✨ New Features
*   **Fresh Look**: Custom tooltips with adjustable borders, backgrounds, and sizes.
*   **Font Control**: Pick your favorite fonts for both headers and body text (LibSharedMedia support included!).
*   **Useful Info**: 
    *   See **Item Levels** at a glance.
    *   Added **Spell IDs**, **NPC IDs**, and **Icon IDs** for the data sleuths.
    *   Displays the unit's **Target** right in the tooltip.
    *   Class colors for player names.
*   **Customization**:
    *   Scale the tooltip to your liking.
    *   Change border colors with a fancy color picker.
    *   Toggle almost every feature in the options menu.
*   **Mouse Anchor**: Option to stick the tooltip to your mouse cursor.

### 🛠 Tech Stuff
*   Built using the modern `TooltipDataProcessor` for better compatibility.
*   Supports Retail and Classic clients.
