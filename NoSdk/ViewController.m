//
//  ViewController.m
//  NoSdk
//
//  Created by Don Browning on 4/10/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ServiceProxy.h"


@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSUUID *estimoteBeacon;
@property (nonatomic, strong) CLBeaconRegion *region;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UISwitch *stealthModeSwitch;

@property CGRect initialAvatarFrame;

@end

@implementation ViewController

CLLocationManager *locationManager;
ServiceProxy *_serviceProxy;

typedef NS_ENUM(NSInteger, UIEnabledState) {
    UIInside,
    UIOutside,
    UIDisabled
};

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self roundAvatar:100.0];
    self.initialAvatarFrame = self.avatarImageView.frame;
    
    
    // outside until proven inside
    [self outside];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    self.estimoteBeacon = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:self.estimoteBeacon identifier:@"com.donwb.beacon.region"];
    
    [self toggleBeaconState:YES];

    
    _serviceProxy = [[ServiceProxy alloc]initWithUser:@"donwb"];
    _serviceProxy.delegate = self;
    
                     
}

#pragma mark BLE Stuff

-(void)toggleBeaconState:(BOOL)enabled {
    
    
    self.region.notifyEntryStateOnDisplay = enabled;
    self.region.notifyOnEntry = enabled;
    self.region.notifyOnExit = enabled;
    
    if(enabled) {
        [self.locationManager startMonitoringForRegion:self.region];
        [self.locationManager requestStateForRegion:self.region];
    } else {
        [self.locationManager stopMonitoringForRegion:self.region];
        [self.locationManager stopMonitoringForRegion:self.region];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    NSLog(@"Determining state....");
    
    if(state == CLRegionStateInside) {
        NSLog(@"State Inside....");
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *) region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        
        [self inside];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Did enter region");
    
    if([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *) region;
        
        if([beaconRegion.identifier isEqualToString:@"com.donwb.beacon.region"]) {
            
            //[self.locationManager startRangingBeaconsInRegion:beaconRegion];
            //NSLog(@"Starting to range beacons");
            
            [self inside];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Did exit region");
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:@"com.donwb.beacon.region"]) {
            
            //[self.locationManager stopRangingBeaconsInRegion:beaconRegion];
            
            [self outside];
        }
    }
}
/*
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for(CLBeacon *beacon in beacons) {
        NSLog(@"Ranging beacon: %@", beacon.proximityUUID);
        NSLog(@"%@ - %@", beacon.major, beacon.minor);
        NSLog(@"Range: %ld", beacon.proximity);
    }
}
*/

-(void)inside {
    //self.view.backgroundColor = [UIColor greenColor];
    UILocalNotification *notify = [UILocalNotification new];
    notify.alertBody = @"Welcome!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notify];
    
    NSLog(@"notification sent...");
    
    //[self changeUIColor:true];
    
    [UIView animateWithDuration:0.5 delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.locationContainer.alpha = 0.0;
                         
                         CGRect newFrame = self.avatarImageView.frame;
                         newFrame.size.width = 150;
                         newFrame.size.height = 150;
                         newFrame.origin.x = self.avatarImageView.frame.origin.x - 10.0;
                         
                         [self.avatarImageView setFrame:newFrame];
                         
                         
                         [self changeUIColor:UIInside];
                     }
                     completion:^ (BOOL finished){
                         NSLog(@"done!");
                         [self roundAvatar:150];
                     }];
    
    [_serviceProxy arrive];
    

}

-(void)outside {
    
    UILocalNotification *notify = [UILocalNotification new];
    notify.alertBody = @"Later!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notify];
    
    NSLog(@"notification sent...");
    
    [UIView animateWithDuration:0.5 delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.locationContainer.alpha = 1.0;
                         [self.avatarImageView setFrame:self.initialAvatarFrame];
                         
                         [self changeUIColor:UIOutside];
                     }
                     completion:^ (BOOL finished){
                         NSLog(@"done!");
                         [self roundAvatar:100.0];
                     }];
    
    [_serviceProxy leave];
    

}

-(void)disabled {
    [self toggleBeaconState:NO];
    [self changeUIColor:UIDisabled];
}

-(void)enabled {
    [self toggleBeaconState:YES];
}

#pragma mark UI Goop

- (void)roundAvatar:(CGFloat) avatarSize
{
    //self.avatarImageView.layer.cornerRadius = avatarSize/2;
    self.avatarImageView.layer.cornerRadius = 10.0;
    self.avatarImageView.layer.borderWidth = 2.0f;
    self.avatarImageView.clipsToBounds = YES;
}

- (IBAction)saveButton:(id)sender {
    
}
- (IBAction)testButton:(id)sender {
    NSLog(@"here");
}

-(void)changeUIColor:(UIEnabledState)uiState {
    switch (uiState) {
        case UIInside:
            self.view.backgroundColor = [UIColor colorWithRed:0.792 green:0.835 blue:0.706 alpha:1];
            self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            self.locationContainer.backgroundColor = [UIColor colorWithRed:0.792 green:0.835 blue:0.706 alpha:1];
            
            break;
        case UIOutside:
            self.view.backgroundColor = [UIColor colorWithRed:0.918 green:0.659 blue:0.663 alpha:1];
            self.locationContainer.backgroundColor = [UIColor colorWithRed:0.918 green:0.659 blue:0.663 alpha:1];
            self.avatarImageView.layer.borderColor = [UIColor colorWithRed:0.671 green:0.875 blue:0.973 alpha:1].CGColor;
            
            break;
        case UIDisabled:
            self.view.backgroundColor = [UIColor colorWithRed:0.769 green:0.769 blue:0.769 alpha:1];
            self.locationContainer.backgroundColor = [UIColor colorWithRed:0.769 green:0.769 blue:0.769 alpha:1];
            
            self.avatarImageView.layer.borderColor = [UIColor colorWithRed:0.671 green:0.875 blue:0.973 alpha:1].CGColor;
            
            
            break;
        default:
            break;
    }
    if(uiState == UIInside) {
        
    } else {
        

    }
}

- (IBAction)stealthSwitchValueChanged:(id)sender {
    if(self.stealthModeSwitch.isOn){
        [self disabled];
    } else {
        [self enabled];
    }
    
}


#pragma mark test buttons

- (IBAction)buttonPress:(id)sender {
    [self.statusLabel setText:@"....."];
    [self inside];
}


- (IBAction)exitButtonPress:(id)sender {
    [self.statusLabel setText:@"....."];
    [self outside];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) recievedServerResponse:(NSString *) response {
    NSLog(@"Got response from server: %@", response);
    [self.statusLabel setText:[@"Response: " stringByAppendingString:response]];
}

@end
