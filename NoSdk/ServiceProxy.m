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
    NSString *route = [@"status/" stringByAppendingString:self.User];
    
    [self invokeURLFor:route];
    
    return NO;
}

- (void)invokeURLFor:(NSString *)route{
    NSString *url = [BASE_URL stringByAppendingString:route];
    NSLog(@"Invoking URL: %@", url);
    
    
    
    NSURL *jsonURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSLog(@"Got data");
            id temp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *result = temp;
            
            

            NSString *invokedURL = [response.URL absoluteString];
            BOOL isStatusCall = [invokedURL rangeOfString:@"status"].location != NSNotFound;
            if (isStatusCall) {
                NSString *status = result[@"user"][@"status"];
                NSLog(@"Status is: %@", status);
                [self.delegate currentStatus:[status isEqualToString:@"in"]];
            }
            
            //NSLog(@"Response: %@", status);
            
            [self.delegate recievedServerResponse:result];
            
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
