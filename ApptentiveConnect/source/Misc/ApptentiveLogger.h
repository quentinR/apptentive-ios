//
//  ApptentiveLogger.h
//  ApptentiveConnect
//
//  Created by Andrew Wooster on 3/8/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ApptentiveLogger : NSObject
+ (ApptentiveLogger *)sharedLogger;
+ (void)logWithLevel:(NSString *)level file:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ...;
+ (void)logWithLevel:(NSString *)level file:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format args:(va_list)args;
- (NSString *)currentLogText;
@end
