# Live Photo Feature Documentation

## Overview
The Live Photo feature allows users to select and view Live Photos from their photo library. This feature integrates seamlessly with the existing Ideas-Swift application.

## User Flow

```
Main Screen (IdeasViewController)
    ↓
[Tap ⋯ Menu Button]
    ↓
[Select "7.Live Photo选择"]
    ↓
Live Photo Screen (LivePhotoViewController)
    ↓
[Tap "选择Live Photo" Button]
    ↓
System Photo Picker (PHPickerViewController)
    ↓
[User selects a Live Photo]
    ↓
Live Photo displayed in PHLivePhotoView
    ↓
[User can long-press to play animation]
```

## Features
- Select Live Photos from the device's photo library using PHPickerViewController
- Display selected Live Photos with interactive playback
- Permission handling for photo library access
- User-friendly UI with clear instructions

## Implementation Details

### Files Added
- `LivePhotoViewController.swift`: Main view controller for Live Photo selection and display

### Files Modified
- `Info.plist`: Added `NSPhotoLibraryUsageDescription` permission
- `IdeasViewController.swift`: Added menu item to access Live Photo feature

### Key Components

#### LivePhotoViewController
- **selectButton**: Triggers the photo picker to select a Live Photo
- **livePhotoView**: PHLivePhotoView component that displays and plays the selected Live Photo
- **placeholderLabel**: Shows instructions when no photo is selected
- **instructionLabel**: Provides usage guidance for interacting with the Live Photo

#### Permission Handling
The app uses PHPickerViewController which handles photo library permissions internally. The Info.plist key `NSPhotoLibraryUsageDescription` is still required for the system permission dialog.

#### Photo Selection
Uses `PHPickerViewController` with a filter set to `.livePhotos` to ensure only Live Photos can be selected.

## Usage

### Accessing the Feature
1. Open the app
2. Tap the ellipsis menu button (⋯) in the top right corner
3. Select "7.Live Photo选择" from the menu
4. The Live Photo selection screen will appear

### Selecting a Live Photo
1. Tap the "选择Live Photo" button
2. The system photo picker will appear
3. Select a Live Photo from your library
4. The Live Photo will be displayed on the screen

### Interacting with Live Photo
- Long press on the Live Photo to play the animation
- Tap "重新选择" to select a different Live Photo

## Technical Requirements
- iOS 14.0+ (required for PHPickerViewController)
- Swift 5.0+
- PhotosUI framework
- Photos framework

## Permissions
The app requires the following permission:
- **NSPhotoLibraryUsageDescription**: "需要访问相册以选择和查看Live Photo"

## Best Practices Followed
1. **Permission Handling**: Properly requests and handles photo library permissions
2. **User Experience**: Clear UI with instructions and feedback
3. **Error Handling**: Gracefully handles errors during photo selection and loading
4. **Code Organization**: Follows the existing app architecture with proper MVC separation
5. **Localization**: Uses Chinese language strings to match the existing app
6. **UI Consistency**: Uses SnapKit for layout constraints, consistent with the existing codebase

## Future Enhancements
Potential improvements for future versions:
- Save selected Live Photos to local storage
- Share Live Photos via system share sheet
- Display multiple Live Photos in a gallery view
- Add filters or editing capabilities for Live Photos
- Support for exporting Live Photos as videos or GIFs
