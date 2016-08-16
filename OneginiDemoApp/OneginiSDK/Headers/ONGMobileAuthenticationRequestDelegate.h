//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGPinChallenge;
@class ONGFingerprintChallenge;
@class ONGMobileAuthenticationRequest;
@class ONGUserProfile;

@protocol ONGMobileAuthenticationRequestDelegate<NSObject>

/**
 *  Asks the user for confirmation on a mobile authentication request.
 *  The implementor should present a confirmation dialog with the message specified in `request` instance.
 *
 *  @param userClient user client that received mobile authentication request
 *  @param confirmation confirmation block that needs to be invoked upon confirmation flag.
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthenticationRequest
 */
- (void)userClient:(ONGUserClient *)userClient awaitsConfirmation:(void (^)(BOOL confirmRequest))confirmation forRequest:(ONGMobileAuthenticationRequest *)request;

/**
 *  Method called when mobile authentication request requires PIN code for confirmation.
 *
 *  @param userClient user client performing authentication
 *  @param challenge pin challenge used to complete authentication
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthenticationRequest
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request;

@optional

/**
 *  Method called when authentication action requires TouchID to continue. Its called before asking user for fingerprint.
 *  If its not implemented SDK will fallback to PIN code confirmation.
 *
 *  @param userClient user client performing authentication
 *  @param challenge fingerprint challenge used to complete authentication
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthenticationRequest, ONGFingerprintChallenge
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request;

/**
 *  Method called when mobile authentication request handling did fail.
 *
 *  @param userClient user client performing authentication
 *  @param request mobile authentication request received by the SDK
 *  @param error error describing failure reason. Possible error domains are: ONGPinValidationErrorDomain, ONGGenericErrorDomain.
 *
 *  @see ONGMobileAuthenticationRequest
 */
- (void)userClient:(ONGUserClient *)userClient didFailToHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request error:(NSError *)error;

/**
 *  Method called when mobile authentication request handled successfully.
 *
 *  @param userClient user client performing authentication
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthenticationRequest
 */
- (void)userClient:(ONGUserClient *)userClient didHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request;

@end
