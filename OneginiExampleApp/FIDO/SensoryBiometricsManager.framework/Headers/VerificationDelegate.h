/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

#ifndef SDS_FIDO_BIOMETRICS_INTERFACE_VERIFICATION_DELEGATE_H
#define SDS_FIDO_BIOMETRICS_INTERFACE_VERIFICATION_DELEGATE_H

typedef NS_ENUM(NSUInteger, VerificationStatus)
{
    STATUS_VERIFICATION_FAILED,
    STATUS_VERIFICATION_SUCCESS,
    STATUS_VERIFICATION_USER_CANCELED
};

@protocol VerificationDelegate <NSObject>

@optional
/*!
 * @brief To be called when an verification operation is just finished
 * @param result The result of the verification operation
 * @param matchingScore The matcing score for the verification; -1 if its verification is failed
 * @param mathcedUID The matched unique ID;nil if its verification failed
 */
- (void)didFinishVerification:(uint16_t)result matchingScore:(double) matchingScore matchedUID:(NSString *)matchedUID;

/*!
 * @brief To be called when an verify operation is ready now
 */
- (void)prepareToVerify;

@end

#endif /* SDS_FIDO_BIOMETRICS_INTERFACE_VERIFICATION_DELEGATE_H */
