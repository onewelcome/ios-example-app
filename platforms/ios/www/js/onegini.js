cordova.define("com.onegini", function(require, exports, module) {
module.exports = {
			   
    /**
     * Initialize the OneginiClient. This should called first before any interaction with the Onegini SDK
     *
     * @param {JSON} config					JSON object with all configuration parameters
	 * @param {Array} certificates          Array with base64 encoded X509 certificates used for SSL pinning.
     * @param {Function} completeCallback
     */
    initWithConfig: function(config, certificates, completeCallback) {
		exec(completeCallback, null, 'OneginiCordovaClient', 'initWithConfig', [config, certificates]);
    }
};

});
