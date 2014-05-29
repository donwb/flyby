//
//  ServiceProxy.h
//  NoSdk
//
//  Created by Don Browning on 5/21/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServiceProxy;
@protocol ServiceProxyDelegate <NSObject>

@required
- (void) currentStatus: (BOOL) status;
@optional
- (void) recievedServerResponse: (NSDictionary *) response;

@end

@interface ServiceProxy : NSObject

@property (nonatomic, weak) id <ServiceProxyDelegate> delegate;

@property NSString * User;

- (void)arrive;
- (void)leave;
- (BOOL)getStatus;
- (id)initWithUser:(NSString *)user;

@end
