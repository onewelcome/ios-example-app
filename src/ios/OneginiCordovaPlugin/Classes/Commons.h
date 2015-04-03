//
//  Commons.h
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 02.04.2015.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

typedef enum : NSUInteger {
    PINEntryModeUnknown,
    PINCheckMode,					// Ask current PIN
    PINRegistrationMode,			// Ask new PIN first entry
    PINRegistrationVerififyMode,	// Ask new PIN second entry (verification)
    PINChangeCheckMode,				// Ask current PIN for change PIN request
    PINChangeNewPinMode,			// Ask new PIN first entry for change PIN request
    PINChangeNewPinVerifyMode		// Ask new PIN second entry (verification) for change PIN request
} PINEntryModes;
