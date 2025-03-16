# Blood Boil Tracker WeakAura

A World of Warcraft WeakAura for Blood Death Knights to track Blood Plague debuff uptime on enemies.

## Features

- Tracks Blood Plague debuff on all nearby enemies
- Shows count of enemies missing the debuff
- Displays total number of trackable enemies
- Visual warnings when enemies are missing Blood Plague
- Pulsing animation when action is needed
- Only loads for Blood Death Knights in combat

## Installation

1. Copy the entire contents of `blood_boil_tracker.lua`
2. Open WeakAuras in-game (`/wa`)
3. Click "New"
4. Select "Import"
5. Paste the code
6. Click "Import"

## Display Information

The WeakAura shows:
- Fraction showing "Missing/Total" enemies
- Red text when enemies are missing the debuff
- "Missing Blood Plague!" warning text when needed
- Pulsing animation when action is required

## Technical Details

- Tracks debuff applications and removals via combat log
- Updates when nameplates appear or disappear
- Monitors debuff duration (24 seconds)
- Updates every frame for real-time accuracy

## Requirements

- World of Warcraft Retail
- WeakAuras 2 addon
- Blood Death Knight specialization

## Contributing

Feel free to submit issues and enhancement requests!