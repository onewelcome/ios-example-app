// Copyright (c) 2016 Onegini. All rights reserved.

#import "PinErrorMapper.h"
#import "ONGPinChallenge.h"
#import "ONGErrors.h"
#import "ONGCreatePinChallenge.h"

@implementation PinErrorMapper

+ (NSString *)descriptionForError:(NSError *)error ofPinChallenge:(ONGPinChallenge *)challenge
{
    // Error is going to be either within ONGPinAuthenticationErrorDomain or ONGGenericErrorDomain.
    // However since error codes from different domains are not intersects we can skip domains check (optional)
    // Moreover not all of the errors can happen during PIN challenge, therefore we're not handling all of them
    // (e.g. ONGGenericErrorActionCancelled or ONGGenericErrorDeviceDeregistered and similar).
    NSString *reason = nil;
    switch (error.code) {
        // Typical error for invalid PIN
        case ONGPinChangeErrorUserNotAuthenticated:
            reason = @"Invalid pin";
            break;

            // Device is not connected to the internet or server is not reachable.
        case ONGGenericErrorNetworkConnectivityFailure:
        case ONGGenericErrorServerNotReachable:
            reason = @"Failed to connect to the server. Please try again";
            break;

            // Such errors breaks pin change and leads to its finishing.
            // They will be propagated to the -userClient:didFailToChangePinForUser:error: instead
            // case ONGGenericErrorDeviceDeregistered:
            // case ONGGenericErrorUserDeregistered:

            // Some undefined error occurred. This not a typical situation but worth to display at least something.
        case ONGGenericErrorUnknown:
        default:
            reason = @"Something went wrong. Please try again";
            break;
    }

    // As mentioned above attempts counter may remain untouched for non-ONGPinChangeErrorUserNotAuthenticated,
    // however we still want to give a hint to the User.
    NSString *description = [NSString stringWithFormat:@"%@. You have still %@ attempts left", reason, @(challenge.remainingFailureCount)];
    return description;
}

+ (NSString *)descriptionForError:(NSError *)error ofCreatePinChallenge:(ONGCreatePinChallenge *)challenge
{
    switch (error.code) {
        // For security reasons some PINs can be blacklisted on the Token Server.
        case ONGPinValidationErrorPinBlackListed:
            return @"PIN you've entered is blacklisted. Try a different one";

        // PIN can not be a sequence: 1234 and similar.
        case ONGPinValidationErrorPinShouldNotBeASequence:
            return @"PIN you've entered appears to be a sequence. Try a different one";

        // PIN is either too long or too short. Error's user info provides required length.
        // For more information about how to deal with PIN length please follow "PIN Handling Recommendations" guide.
        case ONGPinValidationErrorWrongPinLength: {
            NSNumber *requiredLength = challenge.error.userInfo[ONGPinValidationErrorRequiredLengthKey];
            return [NSString stringWithFormat:@"PIN has to be of %@ characters length", requiredLength];
        }

        // PIN uses too many similar digits and insecure (1113, 0000 and similar).
        // SDK provides recommended max of similar digits within `error.userInfo`.
        case ONGPinValidationErrorPinShouldNotUseSimilarDigits: {
            NSNumber *maxSimilarDigits = challenge.error.userInfo[ONGPinValidationErrorMaxSimilarDigitsKey];
            return [NSString stringWithFormat:@"PIN should not use more that %@ similar digits", maxSimilarDigits];
        }

        // Rest of the errors most are most likely about network connectivity issues.
        default:
            // Onegini provides reach description for every error. It may not be the case for Production use,
            // however useful during development.
            return challenge.error.localizedDescription;
    }
}

@end