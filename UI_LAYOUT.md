# iOS Photo Sync - UI Layout

## Main Screen Layout

```
┌─────────────────────────────────────────┐
│                                         │
│              Photo Sync                 │  <- Title (Bold, 28pt)
│                                         │
│            Ready to sync                │  <- Status Label (Gray, 16pt)
│                                         │
│                                         │
│     No storage location selected        │  <- Storage Path Label (Gray, 14pt)
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Select Storage Location          │  │  <- Button (Blue, 50pt height)
│  └───────────────────────────────────┘  │
│                                         │
│                                         │
│  ▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │  <- Progress Bar
│                                         │
│          0 / 0 photos synced            │  <- Progress Counter (Gray, 14pt)
│                                         │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │          Start Sync               │  │  <- Button (Green, 50pt height)
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │          Stop Sync                │  │  <- Button (Red, 50pt height)
│  └───────────────────────────────────┘  │
│                                         │
│                                         │
│  Auto-sync new photos           ○      │  <- Label + Switch
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

## UI Component Details

### 1. Title Label
- **Text**: "Photo Sync"
- **Font**: System Bold, 28pt
- **Alignment**: Center
- **Color**: Label color (adapts to light/dark mode)

### 2. Status Label
- **Initial Text**: "Ready to sync"
- **Font**: System, 16pt
- **Color**: System Gray
- **Alignment**: Center
- **Dynamic States**:
  - "Photo access granted"
  - "Found X photos to sync"
  - "Syncing photo X of Y"
  - "Sync completed"
  - "New photo detected, syncing..."
  - "Monitoring for new photos"

### 3. Storage Path Label
- **Initial Text**: "No storage location selected"
- **Font**: System, 14pt
- **Color**: System Gray
- **Alignment**: Center
- **Multi-line**: Yes
- **After Selection**: "Storage: [folder name]"

### 4. Select Storage Button
- **Text**: "Select Storage Location"
- **Font**: System Semibold, 17pt
- **Background**: System Blue
- **Text Color**: White
- **Height**: 50pt
- **Corner Radius**: 10pt
- **State**: Always enabled
- **Action**: Opens UIDocumentPicker

### 5. Progress View
- **Style**: Default
- **Initial Progress**: 0.0
- **Range**: 0.0 to 1.0
- **Updates**: Real-time during sync

### 6. Progress Counter Label
- **Initial Text**: "0 / 0 photos synced"
- **Font**: System, 14pt
- **Color**: System Gray
- **Alignment**: Center
- **Format**: "[current] / [total] photos synced"

### 7. Start Sync Button
- **Text**: "Start Sync"
- **Font**: System Semibold, 17pt
- **Background**: System Green
- **Text Color**: White
- **Height**: 50pt
- **Corner Radius**: 10pt
- **Initial State**: Disabled (alpha 0.5)
- **Enabled When**: Storage location selected
- **Disabled During**: Active sync

### 8. Stop Sync Button
- **Text**: "Stop Sync"
- **Font**: System Semibold, 17pt
- **Background**: System Red
- **Text Color**: White
- **Height**: 50pt
- **Corner Radius**: 10pt
- **Initial State**: Disabled (alpha 0.5)
- **Enabled During**: Active sync

### 9. Auto-sync Label & Switch
- **Label Text**: "Auto-sync new photos"
- **Label Font**: System, 16pt
- **Switch Initial State**: OFF
- **Layout**: Label on left, switch on right
- **Alignment**: Vertically centered

## User Flow Visualization

### Initial State
```
[Photo Sync]
[Ready to sync]
[No storage location selected]
[Select Storage Location] ← Can tap
[Progress: 0%]
[0 / 0 photos synced]
[Start Sync - Disabled]
[Stop Sync - Disabled]
[Auto-sync: OFF]
```

### After Storage Selection
```
[Photo Sync]
[Ready to sync]
[Storage: My Folder]
[Select Storage Location] ← Can change
[Progress: 0%]
[0 / 0 photos synced]
[Start Sync - Enabled] ← Can tap
[Stop Sync - Disabled]
[Auto-sync: OFF]
```

### During Sync
```
[Photo Sync]
[Syncing photo 15 of 100]
[Storage: My Folder]
[Select Storage Location]
[Progress: 15%] ████░░░░░░░░░░░░
[15 / 100 photos synced]
[Start Sync - Disabled]
[Stop Sync - Enabled] ← Can tap
[Auto-sync: OFF]
```

### Sync Complete
```
[Photo Sync]
[Sync completed]
[Storage: My Folder]
[Select Storage Location]
[Progress: 100%] ████████████████
[100 / 100 photos synced]
[Start Sync - Enabled]
[Stop Sync - Disabled]
[Auto-sync: OFF]
```

### Auto-sync Active
```
[Photo Sync]
[Monitoring for new photos]
[Storage: My Folder]
[Select Storage Location]
[Progress: 100%] ████████████████
[100 / 100 photos synced]
[Start Sync - Enabled]
[Stop Sync - Disabled]
[Auto-sync: ON] ← Active
```

## Spacing & Layout

### Vertical Spacing
- Top margin: 20pt
- Between title and status: 10pt
- Between status and storage path: 30pt
- Between storage path and select button: 20pt
- Between select button and progress bar: 40pt
- Between progress bar and counter: 10pt
- Between counter and start button: 30pt
- Between start and stop buttons: 15pt
- Between stop button and auto-sync: 40pt

### Horizontal Spacing
- Left/Right margins: 20pt
- All elements full width minus margins

## Responsive Design
- Works on all iOS device sizes (iPhone, iPad)
- Auto Layout constraints ensure proper scaling
- Safe area layout guides respect notch and home indicator
- Adapts to landscape and portrait orientations

## Accessibility
- All buttons have proper touch targets (50pt height)
- Labels are readable with system fonts
- Colors have sufficient contrast
- VoiceOver compatible (standard UIKit controls)
- Dynamic Type support through system fonts

## Visual States

### Button States
```
Enabled:
  - Full opacity (alpha 1.0)
  - Interactive

Disabled:
  - Reduced opacity (alpha 0.5)
  - Non-interactive
  - Dimmed appearance
```

### Progress States
```
Idle:      [░░░░░░░░░░░░░░░░] 0%
Progress:  [████░░░░░░░░░░░░] 25%
Complete:  [████████████████] 100%
```

## Color Scheme
- **Primary Action**: System Blue (Select Storage)
- **Success Action**: System Green (Start Sync)
- **Danger Action**: System Red (Stop Sync)
- **Text**: Label Color (adapts to light/dark mode)
- **Secondary Text**: System Gray
- **Background**: System Background (adapts to light/dark mode)

## Dark Mode Support
All colors and text use system colors that automatically adapt:
- System Background → Dark background in dark mode
- Label Color → Light text in dark mode
- System Gray → Adjusted gray in dark mode
- Button backgrounds maintain their semantic colors
