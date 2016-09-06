/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

#ifndef SDS_FIDO_BIOMETRICS_INTERFACE_BIOMETRICSDATA_H
#define SDS_FIDO_BIOMETRICS_INTERFACE_BIOMETRICSDATA_H

@interface BiometricsData : NSObject
/*!
 @class BiometricsData
 This interface is used for storing biometrics data
*/

/**
 * @brief To get the biometric template whose data is a representative of biometric characteristic.
 * @return Biometric template data
 */
- (NSData *)getTemplate;

/*!
 * @brief To get a biometric type. e.g., voiceprint, fingerprint or facial-print.
 * @return Biometric type
 */
- (NSString *)getType;

/*!
 * @brief To get a provider's name. e.g., "ABC" company name as a solution provider.
 * @return Biometric solution provider's name
 */
- (NSString *)getProviderName;

/*!
 * @brief To get a unique ID of biometrics template for enrollment.
 * @return The unique ID
 */
- (NSString *)getUniqueID;

/*!
 * @brief To set the biometric template
 * @param The data of biometric properties
 * @return YES if this method was successful; NO otherwise
 */
- (BOOL)setTemplate:(NSData *)temp;

/*!
 * @brief To set the biometric type such as voiceprint, fingerprint and faceprint.
 * @param The biometric type
 * @return YES if this method was successful, NO otherwise
 */
- (BOOL)setType:(NSString *)type;

/*!
 * @brief To set the solution provider's name
 * @param The solution provider's name
 * @return YES if this method was successful; NO otherwise
 */
- (BOOL)setProviderName:(NSString *)name;

/*!
 * @brief To set the unique ID of a biometric template ofr enrollment.
 * @param The unique ID of a biometric template to set
 * @return YES if this method was successful; NO otherwise
 */
- (BOOL)setUniqueID:(NSString *)uniqueID;

/*!
 * @brief To validate all values which have been set (Alos, all templages shall be validated by company's criteria.)
 * @return YES if this method was successful; NO otherwise
 */
- (BOOL)validate;

@end

#endif /* BSDS_FIDO_BIOMETRICS_INTERFACE_BIOMETRICSDATA_H */
