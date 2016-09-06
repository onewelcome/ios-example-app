/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

#ifndef SDS_FIDO_BIOMETRICS_INTERFACE_ENROLLMENT_DELEGATE_H
#define SDS_FIDO_BIOMETRICS_INTERFACE_ENROLLMENT_DELEGATE_H

@class BiometricsData;

@protocol EnrollmentDelegate <NSObject>

typedef NS_ENUM(NSUInteger, EnrollmentStatus)
{
    STATUS_ENROLLMENT_FAILED,
    STATUS_ENROLLMENT_SUCCESS,
    STATUS_ENROLLMENT_USER_CANCELED
};

@optional
/*!
 * @brief To be called when an enrollment operation is just finished
 * @param result The result of the enrollment operation
 * @param enrolledData The enrolled data (If the option of "secureStorate" is set to "YES", enrolledData shall set to be nil
 * @param enrolledUID The unique ID of an enrolled biometric template
 */
-(void)didFinishEnrollment:(uint16_t)result enrolledData:(BiometricsData *)enrolledData enrolledUID:(NSString *)enrolledUID;

/*!
 * @brief To be called when an enrollment operation is ready now
 */
- (void)prepareToEnroll;

@end

#endif /* SDS_FIDO_BIOMETRICS_INTERFACE_ENROLLMENT_DELEGATE_H */
