//
//  ViewController.m
//  flyby
//
//  Created by Don Browning on 4/5/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"


@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

@property (nonatomic, strong) UISwitch          *enterRegionSwitch;
@property (nonatomic, strong) UISwitch          *exitRegionSwitch;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Starting...");
    
    self.beaconManager = [[ESTBeaconManager alloc]init];
    self.beaconManager.delegate = self;
    //self.beaconManager.avoidUnknownStateBeacons = YES;
    NSUUID *beaconId = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    // major: 20240
    // minor: 31447
    /*
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                                 major:20240
                                                                 minor:31447
                                                            identifier:@"RegionIdentifier"];
    */
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                            identifier:@"MyRegion"];
    
    
    self.beaconRegion.notifyOnEntry = self.enterRegionSwitch.isOn;
    self.beaconRegion.notifyOnExit = self.exitRegionSwitch.isOn;
    
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    //[self.beaconManager stopMonitoringForRegion:region];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma iBeacon Stuff

-(void)beaconManager:(ESTBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(ESTBeaconRegion *)region {
    
    NSLog(@"%ld", state);
    
    if(state == CLRegionStateInside){
        NSLog(@"Inside");
        [self inside];
    } else if(state == CLRegionStateOutside) {
        NSLog(@"Outside");
        [self outside];
    } else {
        NSLog(@"State unknown");
    }
    
}


-(void)beaconManager:(ESTBeaconManager *)manager
      didEnterRegion:(ESTBeaconRegion *)region {
    
    NSLog(@"I did enter the region");
}

-(void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {
    NSLog(@"I left the region");
}

#pragma Proximity actions

-(void) inside {
    self.view.backgroundColor = [UIColor greenColor];
    UILocalNotification *notify = [UILocalNotification new];
    notify.alertBody = @"Welcome!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notify];
}

-(void) outside {
    self.view.backgroundColor = [UIColor redColor];
    UILocalNotification *notify = [UILocalNotification new];
    notify.alertBody = @"Later!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notify];
}

@end
