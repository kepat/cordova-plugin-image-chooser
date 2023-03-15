---
title: Image Chooser
description: Choose image(s) from the gallery.
---

# cordova-plugin-image-chooser

This is a cordova plugin that enables users to choose image(s) from the gallery.

There are existing repositories that enables this feature but this is created to cover some missing functionalities and simplify the code base.

## Installation

To install via repo url directly.

    cordova plugin add https://github.com/kepat/cordova-plugin-image-chooser

### Quirks

This requires cordova 10.0+

### iOS Quirks

This plugin uses PHPicker API which requires iOS 14 and above for it to work.

To set the default deployment target, you can use the `preference` tag in the `config.xml` like this:

```
<platform name="ios">
    <preference name="deployment-target" value="14" />
</platform>
```

This plugin uses swift code.

To set the default swift version, you can use the `preference` tag in the `config.xml` like this:

```
<platform name="ios">
    <preference name="SwiftVersion" value="4" />
</platform>
```

Note: The plugin already includes a standard permission but just in case you want to specify a more specific reason for using the photo library follow the notes below.

Since iOS 10 it's mandatory to provide an usage description in the `info.plist` if trying to access privacy-sensitive data. When the system prompts the user to allow access, this usage description string will displayed as part of the permission dialog box, but if you didn't provide the usage description, the app will crash before showing the dialog. Also, Apple will reject apps that access private data but don't provide an usage description.

This plugins requires the following usage descriptions:

- `NSPhotoLibraryUsageDescription` specifies the reason for your app to access the photo library.


To add these entries into the `info.plist`, you can use the `edit-config` tag in the `config.xml` like this:

```
<edit-config target="NSPhotoLibraryUsageDescription" file="*-Info.plist" mode="merge">
    <string>To access the photo library for app usage.</string>
</edit-config>
```

---

# API Reference

* [imageChooser](#module_imageChooser)
    * [.chooseImage(successCallback, errorCallback, options)](#module_imageChooser.chooseImage)

---

<a name="module_imageChooser"></a>

## imageChooser

<a name="module_imageChooser.chooseImage"></a>

### imageChooser.chooseImage(successCallback, errorCallback, options)
Retrieves a photo from the device's image gallery.
The image is passed to the success callback as the URI for the image file(s).

__Supported Platforms__

- Android
- iOS

__Inputs__

| Param | Type | Description |
| --- | --- | --- |
| successCallback | <code>functionn</code> | The callback for success. |
| errorCallback | <code>function</code> | Te callback for error. |
| options | <code>[ImageChooserOptions](#module_imageChooser.chooseImage.ImageChooserOptions)</code> | The options to manipulate the function. |

__ImageChooserOptions__

<a name="module_imageChooser.chooseImage.ImageChooserOptions"></a>

| Param | Type | Description |
| --- | --- | --- |
| multiple | <code>boolean</code> | Allow multiple selection. |

**Example**  
```js
imageChooser.chooseImage(
    function(data) {
        console.log(data);
    }, 
    function(error) {
        console.log(error);
    }, 
    {
        multiple: true
    }
);
```