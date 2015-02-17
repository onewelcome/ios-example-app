var noop = function(){};
var SdkPlugin = {
    set: function (text, success, fail) {
    	text = text||""; // Empty is the same as issuing reset.
        cordova.exec(success||noop, fail||noop, "SdkPlugin", "set", [text]);
    },
};
module.exports = SdkPlugin;
