// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGPinChallenge;
@class ONGCreatePinChallenge;

/**
 * @brief Class that is responsible for encapsulating the logic evaulating PIN error situations.
 *
 * @discussion Most of the data-sensitive tasks requires the user to be authenticated first. Since authentication may require
 * error handling and the user in many places it is useful to move this logic to a separate class to prevent duplication for some
 * basic cases.
 *
 * @remark This approach is just a sample of how handling can be done but it's not a requirement.
 */
@interface PinErrorMapper : NSObject

/// Give the mapper the ability to construct description for the given `error` that happend for the provided `challenge`.
+ (NSString *)descriptionForError:(NSError *)error ofPinChallenge:(ONGPinChallenge *)challenge;

+ (NSString *)descriptionForError:(NSError *)error ofCreatePinChallenge:(ONGCreatePinChallenge *)challenge;

@end