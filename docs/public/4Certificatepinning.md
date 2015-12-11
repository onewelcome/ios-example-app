# 4. Certificate pinning

In order to allow the application to communicate safely over HTTPS protocol the application performs certificate pinning.
Please note, if you pin the servers certificate itself you will need to deploy a new version of the application when you change the servers certificate. Best alternative is to use the intermediate certificate of the Certificate Authority used to get the server certificate (the second level in the certificate chain). This gives you the option to renew the server certificate without having to deploy a new version of the application.

## Exporting the certificate
You can use Firefox to export the certificate. Click on the lock of the SSL website. Choose: more information. In the security tab press View certificate. Then go to the details tab. And there you can choose which certificate in the chain you wish to export.

## Android

Certificate pinning documentation for Android Onegini Cordova Plugin located in 'src/android'.

### Creating the keystore
In order to create a keystore you need a java jdk installed to get "keytool". And for android you need bouncy castle 1.46 (newer versions of bouncy castle create a keystore with a different header which is not accepted by android) which can be downloaded here - http://mvnrepository.com/artifact/org.bouncycastle/bcprov-jdk15on/1.46.

    keytool -import -alias MYALIAS -file /PATH/TO/CERTIFICATE/FROM/EXPORT -keystore /PATH/TO/keystore.bks -storepass PASSWORD -providerpath /PATH/TO/BOUNCYCASTLE/1.46/bcprov-ext-jdk15on-1.46.jar -storetype BKS -provider org.bouncycastle.jce.provider.BouncyCastleProvider

### Keystore tampering protection
As the keystore is stored on the file system of the device, theoretically it is possible to tamper it. This is possible if the device is rooted an some malicious APP is installed. To prevent a tampered keystore, a SHA 256 hash of the keystore has to be provided by the APP. It is recommended to have the hash hardcoded and not in a separate property file or any other file on the file system. The keystore normally already is an element of the APPs binary and in that way hard coding the hash doesn't introduce any new inflexibilities.

    shasum -a 256 keystore.bks


The calculated hash should be hardcoded in Android Cordova Plugin:

    com.onegini.OneginiConstants.KEYSTORE_HASH

### Adding keystore to the project
The keystore has to be added to the "raw" directory within resources of your Android Cordova Plugin project. So the pointer to it will be reachable by:

    R.raw.keystore;


## iOS

Certificate pinning documentation for iOS Onegini Cordova Plugin located in 'src/ios'.

### Add the certificate to the bundle
Add the exported certificate encoded in DER format with a .cer file extension to the iOS Cordova Plugin workspace (resource).

If you have the certificate in PEM format (Base64 armored string) you can convert it to DER using following command:

    openssl x509 -outform der -in <filename>.pem -out <filename>.cer


### Certificate tampering protection
As the certificate is stored on the file system of the device, theoretically it is possible to change the certificate on the device. To prevent tampering or at least detect if a certificate is replaced by a different one, the certificate is also provided to the client . The DER encoded certificate must be converted to PEM format with the following command:

    openssl x509 -in <filename>.cer -inform der -out <filename>.pem -outform pem

The content of the<filename>.pem file is an armored base64 representation of the certificate.
The content of the file stripped from its armor (---Begin--- and ---End--- rows) must be provided to the client before a service request is made. To do so please hardcode the string within iOS Cordova Plugin:

    OneginiCordovaClient.m -> certificate
