function PinPage() {

  this.initialize = function () {
    var page = this;

    $("#askForPinForm").validate({
      rules: {
        pin: {
          required: true,
          digits: true,
          minlength: 5,
          maxlength: 5
        }
      },
      errorPlacement: function (error, element) {
        error.insertAfter(element.parent());
      },
      submitHandler: function (form) {
        console.log("Submitting PIN form");
        var pinValue = $("#pin").val();
        // clear form in case we return to this page
        form.reset();
        $("#pinMessage").html('').enhanceWithin();
        ogCordovaPlugin.checkPin(page.handleError, pinValue);
      }
    });

  };

  this.handleError = function (error) {
    if (error && error.remainingAttempts > 0) {
      $("#pinMessage").html('Invalid pin').enhanceWithin();
      return;
    }
    if (error && error.reason == "authorizationErrorTooManyPinFailures") {
      alert("Too many PIN attempts");
    }
    // For now, if something goes wrong and there are no "remainingattempts", go home
    $.mobile.navigate("#home");

  };

  this.initialize();
}
