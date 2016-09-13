// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGPinChallenge;

/**
 * Assume that for each PIN error (i.e. authentication) there might be several handling scenarious:
 *  - Ignore
 *  - Dislay error
 *  - Logout user
 */
typedef NS_ENUM(NSInteger, PinErrorReaction) {
    /// General errors such as network connectivity failures, unknown errors and similar can be ignored since they do not affect on the SDK state.
    PinErrorReactionIgnore.
    /// Typical reaction for invalid PIN. This increase attempts count and may lead to User's deregistration. Therefore we need to notify User.
    PinErrorReactionDefault,
    /// In case of too many PIN attemps SDK has deregistered user. Developer has to "logout" UI, shutdown services, etc.
    PinErrorReactionLogout
};

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

/// Find out how we should react on a specific PIN error: ignore, perform default handling or logout user.
+ (PinErrorReaction)reactionForError:(NSError *)error;

/// Give mapper ability to construct description for the given `error` that happend for the passed `challenge`.
+ (NSString *)descriptionForError:(NSError *)error ofChallenge:(ONGPinChallenge *)challenge;

@end