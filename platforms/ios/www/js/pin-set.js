function SetPinPage() {
  this.initialize = function() {
    var page = this;

    $("#askForPinWithVerificationForm").validate({
      rules: {
        pinWithVerification: {
          required: true,
          digits: true,
          minlength: 5,
          maxlength: 5
        },
        pinVerification: {
          required: true,
          digits: true,
          minlength: 5,
        maxlength: 5,
          equalTo: "#pinWithVerification"
        }
      },
      errorPlacement: function (error, element) {
        error.insertAfter(element.parent());
      },
      submitHandler: function (form) {
        console.log("Submitting PIN with verification form");
        var pinValue = $("#pinWithVerification").val();
        var verifyPinValue = $("#pinVerification").val();
        // clear form in case we return to this page
        form.reset();
        $("#pinWithVerificationMessage").html('').enhanceWithin();
        ogCordovaPlugin.setPin(page.handleError, pinValue, verifyPinValue);
      }
    });
  };

  this.handleError = function(error) {
    console.log('confirmPinWithVerification ' + error.reason + ' ' + error.error.NSLocalizedDescription);
  };

  this.initialize();
}
