/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

#ifndef SDS_FIDO_BIOMETRICS_INTERFACE_BIOMETRICSMODULE_H
#define SDS_FIDO_BIOMETRICS_INTERFACE_BIOMETRICSMODULE_H

#import <UIKit/UIKit.h>

#import "BiometricsData.h"
#import "EnrollmentDelegate.h"
#import "VerificationDelegate.h"
#import "InitializationDelegate.h"

@interface BiometricsModule : NSObject
/*!
 @class BiometricsModule
 This interface is used for biometric authentication operations.
 */

/*!
* @brief To check the validation of the software license.
* @return YES if this method was successful; NO otherwise. If a company does not check its validation at all, return YES only.
*/
- (BOOL)checkLicense;

/*!
 * @brief To request the enroll operation to extract a biometric characteristics, template, from a set of the specific user's biometric raw data (srcData) defined by a speific unique ID(enrolledUID)
 * @param srcData A set of the specific user's biometric raw data
 * @param enrolledUID The unique ID of a biometric template to be assigned
 * @return The enorlled template data if this method was successful; nil otherwise.
 */
- (BiometricsData *)enroll:(NSArray *)srcData enrolledUID:(NSString *)enrolledUID;

/*!
 * @brief To request the enroll operation to extract a biometric characteristics, template, according to the control of OnEnrollmentListner(An enrollment application can use OnEnrollmentLister to acquire a biometric raw data for the enrollment by its own UI process step-by-step.)
 * @param delegate The delegate according to the enrolling operation process
 * @param enrolledUID The unique ID of a biometric template to be assigned
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)enrollWithDelegate:(id<EnrollmentDelegate>)delegate enrolledUID:(NSString *)enrolledUID;

- (BOOL)enrollWithTypeAndDelegate:(NSString *)type delegate:(id<EnrollmentDelegate>)delegate enrollData:(NSDictionary *)enrollData;

/*!
 * @brief To get the universal and unique identification of this device
 * @return A string of the universal and unique identification of this device
 */
- (NSString *)getDeviceUUID;

/*!
 * @brief To get a list of all enrolled unique ID’s
 * @return List of all enrolled unique ID’s
 */
- (NSString *)getEnrolledUniqueID;
- (NSArray *)getEnrolledUniqueIDs:(NSString *)type;

/*!
 * @brief To get predefined properties of this biometric module (See also setProperties)
 * @return A set of properties
 */
- (NSDictionary *)getProperties;

/*!
 * @brief To indicate whether the biometric enrollment has been done or not
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)hasEnrolled;

/*!
 * @brief To process an initialization process of the company’s biometric engine for starting its service (The initialization shall include applying the predefined properties of the BiometricsModule after all operations of setProperties() are done.)
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)initialize;

- (BOOL)initializeWithDelegate:(id<InitializationDelegate>)delegate;

- (BOOL)isInitialized;

/*!
 * @brief To obtain an array of all registered biometric templates
 * @param Array of all registered biometric templates
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)loadTemplates:(NSArray *)data;

/*!
 * @brief To set the universal and unique identification of this device. The engine shall keep this information in the certification file for its license
 * @param A string of the universal and unique identification of this device
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)setDeviceUUID:(NSString *)deviceUUID;

/*!
 * @brief To set predefined properties of this biometric module using given keywords
 * @param The instance of java class Properties
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)setProperties:(NSDictionary *)properties;

/*!
 * @brief To terminate the current valid license for this device. If the input parameter “deviceUUID” is different from the current device ID, the license of the current device will be valid. However, LKMS must terminate the lifetime of license for this “deviceUUID” in the server-side. Samsung SDS manages each end-user’s device changes. If an end-user does not follow the uninstallation process to exchange a new device, SDS’ server will check this incident, so that SDS commands the FIDO application terminate the license of the old device through online.
 * @param A string of the universal and unique identification of this device
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)terminateLicense:(NSString *)deviceUUID;

/*!
 * @brief To obtain the enrolled unique ID of the verification (or, authentication) operation
 * @param A particular user’s biometric raw data
 * @return The unique ID of the enrolled biometric template; null if the verification is failed
 */
- (NSString *)verify:(UIImage *)srcData;

/*!
 * @brief To obtain the matching score of the verification (or, authentication) operation with respect to a particular user’s biometric raw data given the “enrolledUID” (The matching score shall be scaled by [0.0..1.0] if it is verified.)
 * @param srcData A particular user’s biometric raw data
 * @param enrolledUID The unique ID of the enrolled biometric template
 * @return The matching score of its verification; -1.0 if the verification is failed
 */
- (double)verifyWithId:(UIImage *)srcData enrolledUID:(NSString *) enrolledUID;

/*!
 * @brief To obtain the result of the verification (or, authentication) operation with respect to a particular user’s biometric raw data obtained by the control of VerificationDelegate
 * @param The delegate for verify operation events
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)verifyWithDelegate:(id<VerificationDelegate>)delegate;

- (BOOL)verifyWithTypeAndDelegate:(NSString *)type delegate:(id<VerificationDelegate>)delegate enrollData:(NSDictionary *)enrollData;

/*!
 * @brief To obtain the result of the verification (or, authentication) operation given the “matchingUID” with respect to a particular user’s biometric raw data obtained by the control of VerificationDelegate
 * @param delegate The delegate for verify operation events
 * @param matchingUID The unique ID to match a biometric information
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)verifyWithDelegateAndId:(id<VerificationDelegate>)delegate matchingUID:(NSString *)matchingUID;

/*!
 * @brief To clear loaded or registered biometrics templates
 * @return YES if this method was successful; NO otherwise.
 */
- (BOOL)emptyEnrollment;

- (BOOL)emptyEnrollmentWithType:(NSString *)type;

- (BOOL)emptyEnrollmentWithTypeAndExtra:(NSString *)type extra:(NSDictionary *)extra;

@end

#endif /* SDS_FIDO_BIOMETRICS_INTERFACE_BIOMETRICSMODULE_H */
