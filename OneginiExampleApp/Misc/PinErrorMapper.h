// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGPinChallenge;
@class ONGCreatePinChallenge;

/**
 * @brief Class that responsible for encapsulating logic of the errors aspects evaluation.
 *
 * @discussion Most of the data-sensitive tasks requires from User to be authenticated first. Since authentication may require
 * error handling and user in may places it is useful to move this logic to a separate class to prevent duplication for some
 * basic cases.
 *
 * @remark This approach is just a sample of how hanlding can be done and not a requirement.
 */
@interface PinErrorMapper : NSObject

/// Give mapper ability to construct description for the given `error` that happend for the passed `challenge`.
+ (NSString *)descriptionForError:(NSError *)error ofPinChallenge:(ONGPinChallenge *)challenge;

+ (NSString *)descriptionForError:(NSError *)error ofCreatePinChallenge:(ONGCreatePinChallenge *)challenge;

@end