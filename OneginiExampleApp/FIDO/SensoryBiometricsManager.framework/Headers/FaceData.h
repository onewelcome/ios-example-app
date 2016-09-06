/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

@interface FaceData : NSObject

- (CGRect)getBounds;
- (CGPoint)getLeftEyePosition;
- (CGPoint)getRightEyePosition;

@end
