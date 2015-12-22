//
//  ATWebClient.h
//  apptentive-ios
//
//  Created by Andrew Wooster on 7/28/09.
//  Copyright 2009 Apptentive, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATFeedback;
@class ATAPIRequest;

extern NSString *const ATWebClientDefaultChannelName;

/*! Singleton for generating API requests. */
@interface ATWebClient : NSObject

+ (ATWebClient *)sharedClient;

@property (readonly, nonatomic) NSURL *baseURL;
@property (readonly, nonatomic) NSString *APIKey;
@property (readonly, nonatomic) NSString *APIVersion;

- (instancetype)initWithBaseURL:(NSURL *)baseURL APIKey:(NSString *)APIKey version:(NSString *)APIVersion;

- (NSString *)commonChannelName;
- (ATAPIRequest *)requestForGettingAppConfiguration;
@end
