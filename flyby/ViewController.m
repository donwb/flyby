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
    
    self.beaconManager = [[ESTBeaconManager alloc]init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    NSUUID *beaconId = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId identifier:@"MyRegion"];
    
    [self.beaconManager startMonitoringForRegion:region];
    
    [self.beaconManager stopMonitoringForRegion:region];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
