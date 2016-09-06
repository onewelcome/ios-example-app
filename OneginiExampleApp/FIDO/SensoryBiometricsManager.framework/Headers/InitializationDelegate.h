/*****************************************************************************************
 * Copyright (c) 2016. by Samsung SDS. All rights reserved.
 *
 * This software is the confidential and proprietary information of Samsung SDS, Inc.
 * ("Confidential information"). You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license agreement you
 * entered into with Samsung SDS.
 ****************************************************************************************/

#ifndef SDS_FIDO_BIOMETRICS_INTERFACE_INITIALIZATION_DELEGATE_H
#define SDS_FIDO_BIOMETRICS_INTERFACE_INITIALIZATION_DELEGATE_H

@protocol InitializationDelegate <NSObject>

extern uint16_t const STATUS_INITIALIZATION_FAILED = 0;
extern uint16_t const STATUS_INITIALIZATION_SUCCESS = 1;

- (void)didFinishInitialization:(uint16_t)result;

#endif /* SDS_FIDO_BIOMETRICS_INTERFACE_INITIALIZATION_DELEGATE_H */

@end