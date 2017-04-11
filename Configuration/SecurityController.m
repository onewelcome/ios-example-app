#import "SecurityController.h"

#ifdef DEBUG
@implementation SecurityController

+ (BOOL)rootDetection
{
    return NO;
}

+ (BOOL)debugDetection
{
    return NO;
}

+ (BOOL)debugLogs
{
    return YES;
}

@end
#endif
