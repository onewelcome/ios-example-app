/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

#import "BiometricsModule.h"
#import "FaceData.h"

@interface FaceModule : BiometricsModule

- (NSArray *)detectFace:(UIImage *)image;
- (NSArray *)normalizeFace:(UIImage *)image;
- (double)verify:(UIImage *)image faceData:(FaceData *)data;

@end
