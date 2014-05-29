//
//  ServiceProxy.m
//  NoSdk
//
//  Created by Don Browning on 5/21/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#import "ServiceProxy.h"
#import "constants.h"


@implementation ServiceProxy
@synthesize delegate;

NSString *_baseURL;

- (void)leave{
    NSString *route = [@"out/" stringByAppendingString:self.User];
    [self invokeURLFor:route];
}

- (void)arrive{
    NSString *route = [@"in/" stringByAppendingString:self.User];
    
    [self invokeURLFor:route];
    
}

- (BOOL)getStatus{
    return NO;
}

- (void)invokeURLFor:(NSString *)route{
    NSString *url = [BASE_URL stringByAppendingString:route];
    NSLog(@"Invoking URL: %@", url);
    
    
    
    NSURL *jsonURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];
    
    __weak id weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSLog(@"Got data");
            id temp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *result = temp;
            NSString *status = [result objectForKey:@"status"];
            

            
            NSLog(@"Response: %@", status);
            [self.delegate recievedServerResponse:status];
            
        }
        
        else if (connectionError) {
            NSLog(@"ERROR: %@", connectionError);
            
        }
        
    }];
    
    
    
    
}

- (id)initWithUser:(NSString *)user{
    self = [super init];
    
    self.User = user;
    
    return self;
}


@end
