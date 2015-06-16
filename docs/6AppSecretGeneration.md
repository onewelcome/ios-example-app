# AppSecret generation

In order to allow application to perform a successful Dynamic Client Registration a fingerprint of the app needs to be provided to the client configuration on the Token Server.


## Android

Since version 3.02.01 Android-SDK uses calculated binary checksum as a application secret when responding to OCRA challenge in DCR flow. Such approach provides additional security protecting clients app against tampering/modification.
Please note that for each platform uses its own dedicated BinaryHashCalculator instance.


#### Calculating value
Navigate to 'binaryhashcalculator' folder and from the command line execute:
```bash
java com.onegini.mobile.hashCalc.HashCalculator PATH_TO_BINARY_FILE
```

If provided path is valid the program will print calculated hash value. 
```bash
Calculated hash - a491d0374840ac684d6bcb4bf9fc93ee4d9731dbe2996b5a1db2313efb42b7e
```

### iOS

Since version 3.02.00 iOS-SDK calculates binary fingerprint and uses it as an application secret when responding to OCRA challenge in DCR flow. Such approach provides additional security protecting client's application against tampering/modification.

#### Calculating value
Navigate to 'binaryhashcalculator' folder and from the command line execute:
```bash
java -cp . com/onegini/mobile/hashCalc/iOS/HashCalculator {PATH_TO_APPLICATION_BINARY}

```

PATH_TO_APPLICATION_BINARY - path pointing to application binary equal to one ${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.app/${PROJECT_NAME} accessed from the xCode.


If provided path is valid the program will print calculated hash value. 
```bash
Calculated hash - c96de7fe7fe80a5e73b9a5af90afcc8a639506688914f1ffeb00d62f47315ea2