package com.kepat.cordova.chooser;

import android.app.Activity;
import android.content.ClipData;
import android.content.Intent;
import android.net.Uri;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

public class ImageChooser extends CordovaPlugin {

    private static final String ACTION_CHOOSE_IMAGE = "chooseImage";
    private static final int REQUEST_CODE_CHOOSE_IMAGE = 1;

    private CallbackContext callbackContext; // Cordova plugin callback context

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param args              JSONArry of arguments for the plugin.
     * @param callbackContext   The callback id used when calling back into JavaScript.
     *
     * @return                  A PluginResult object with a status and message.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        // Store the callback context within this class
        this.callbackContext = callbackContext;

        // Get image file from gallery
        if (action.equals(this.ACTION_CHOOSE_IMAGE)) {
            // Get the arguments required 
            Boolean multiple = args.getBoolean(0);

            // Get the image
            this.chooseImage(multiple);
            return true;
        }

        return false;
    }

    /**
     * Get image from gallery
     * @param multiple {boolean} - Enable multiple selection
     */
    private void chooseImage(Boolean multiple) {
        // Prepare the intent
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);

        // Setup the settings for the intent
        intent.setType("image/*");
        intent.addCategory(Intent.CATEGORY_OPENABLE);
		intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, multiple);

        // Start the intent for file chooser
        Intent chooser = Intent.createChooser(intent, "Select Image");
		this.cordova.startActivityForResult(this, chooser, this.REQUEST_CODE_CHOOSE_IMAGE);
    }

    /**
     * Listener for the file chooser intent
     * - triggered from chooseImage function
     */ 
    @Override  
    public void onActivityResult(int requestCode, int resultCode, Intent data) {  
        super.onActivityResult(requestCode, resultCode, data);  
        try {

            // Skip if the request code is invalid
            if (requestCode != this.REQUEST_CODE_CHOOSE_IMAGE) {
                return;
            }

            // Process the result based on the result code
            if (resultCode == Activity.RESULT_OK) {

                // Process the data based on the data returned
                if (data.getClipData() != null) {
                    // Get the clip data
                    ClipData clipData = data.getClipData();

                    // Prepare the holder of the result 
                    JSONArray uriArray = new JSONArray();

                    // Go through all the image selected
                    for (int count = 0; count < clipData.getItemCount(); count++) {
                        Uri uri = clipData.getItemAt(count).getUri();

                        // Store the current uri
                        if (uri != null) {
                            uriArray.put(uri.toString());
                        }
                    }

                    // Make sure there are valid files
                    if (uriArray.length() > 0) {
                        this.callbackContext.success(uriArray);
                        return;
                    }
                } else if (data.getData() != null) {
                    Uri uri = data.getData();

                    // Check if there was a file selected
                    if (uri != null) {
                        this.callbackContext.success(uri.toString());
                        return;
                    }
                }

                // If there was no URI
                this.callbackContext.error("No selected files.");

            } else if (resultCode == Activity.RESULT_CANCELED) {
                this.callbackContext.error("User cancelled the action.");
            } else {
                this.callbackContext.error("Result code: " + resultCode);
            }

		} catch (Exception err) {
            this.callbackContext.error("Failed to read the file: " + err.toString());
		}
    }

}