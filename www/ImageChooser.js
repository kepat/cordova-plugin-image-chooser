// Simplify some cordova functions to be used
var exec = require('cordova/exec');
var argscheck = require('cordova/argscheck');
var getValue = argscheck.getValue;

/**
 * @exports imageChooser
 */
var imageChooserExport = {};

/**
 * Get Image Function
 * @param {function} successCallback - function triggered if successful
 * @param {function} errorCallback - function triggered if failed
 * @param {object} options - options passed
 */
imageChooserExport.chooseImage = function (successCallback, errorCallback, options) {

    options = options || {};

    // Prepare the arguments to be passed to the native function
    var args = [];
    args.push(getValue(options.multiple, false)); // Enable multiple selection

    exec(successCallback, errorCallback, 'ImageChooser', 'chooseImage', args);
};

// Export the functions
module.exports = imageChooserExport;