import UIKit
import PhotosUI

@objc(ImageChooser) class ImageChooser : CDVPlugin, PHPickerViewControllerDelegate {  

    private var mCommand: CDVInvokedUrlCommand! // Command

    /**
     * Cordova callback result function
     */
    func callback(_ pluginResult: CDVPluginResult?) {
        // Execute the cordova result
        self.commandDelegate!.send(
            pluginResult,
            callbackId: self.mCommand.callbackId
        )
    }

    /**
     * Get image from gallery
     */
    @objc(chooseImage:)
    func chooseImage(_ command: CDVInvokedUrlCommand) {
        // Store the command in a global variable
        mCommand = command

        // Get the arguments required 
        let multiple = command.arguments[0] as! Bool

        // Get the image
        self.chooseImage(multiple)
    }

    /**
     * Get image from gallery
     * @param multiple {Bool} - Enable multiple selection
     */ 
    private func chooseImage(_ multiple: Bool) {
        // Prepare the configuration for the picker
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = PHPickerFilter.images

        // Set to multiple photo selection
        if (multiple == true) {
            configuration.selectionLimit = 0
        }
 
        // Prepare the picker view controller
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        // Start the image picker
        self.viewController.present(picker, animated: true, completion: nil)
    }

    /**
     * Listener for the file chooser intent
     * - triggered from chooseImage function
     */ 
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Close the image picker
        picker.dismiss(animated: true, completion: nil)
        
        // Check if there was any selected images
        if (results.count == 0) {
            // Prepare the result
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: "No selected files."
            )
            self.callback(pluginResult)
            return
        }

        // Prepare the holder of the result
        var uriArray : [String] = [];

        // Go through the selected files
        for result in results {
            // Load the image
            result.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.item") { (object, error)  in
                if let image = object as? NSData {
                    DispatchQueue.main.async {
                        // Write the image
                        // @TODO: Handle different type of images
                        if let filePath = self.generateTempFilePath("jpg") {
                            // Write the file
                            try? image.write(to: filePath)
                            // Store to result
                            uriArray.append(filePath.absoluteString)
                        }

                        // Check if it is already the same size
                        if results.count == uriArray.count {
                            // Check if there is only one result then directly return it
                            if uriArray.count == 1 {
                                let pluginResult = CDVPluginResult(
                                    status: CDVCommandStatus_OK,
                                    messageAs: uriArray[0]
                                )
                                self.callback(pluginResult)
                                return
                            }

                            let pluginResult = CDVPluginResult(
                                status: CDVCommandStatus_OK,
                                messageAs: uriArray
                            )
                            self.callback(pluginResult)
                        }
                    }
                }
            };
		}
    }

    /**
     * Generate a file path towards the temporary directory
     * @param fileExtension {String} - the extension to be added to the file path
     * @return {URL}
     */
    func generateTempFilePath(_ fileExtension: String) -> URL? {
        // Get the temporay directory path
        let tempFolderPath = URL(fileURLWithPath: NSTemporaryDirectory()).standardized.path

        // Generate a unique number through time stamp plus random int
        let timeStamp = Date().timeIntervalSince1970
        let timeStampObj = NSNumber(value: timeStamp)
        let randomInteger = Int.random(in: 1..<1000) 

        // Create the full temporary file path
        let filePathString = String(format: "%@/%ld%ld.%@", arguments: [tempFolderPath, timeStampObj.intValue, randomInteger, fileExtension])

        // Get the URL of the file path
        let filePath = URL(fileURLWithPath: filePathString)

        return filePath
    }

}