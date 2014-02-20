//
//  ViewController.m
//  Quiz
//
//  Created by patlan on 2014-02-18.
//  Copyright (c) 2014 LBi. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager * beaconManager;
@property (nonatomic, strong) ESTBeacon * selectedBeacon;
@property (nonatomic, strong) ESTBeacon * prevSelectedBeacon;
@property (nonatomic) int selectedProximityIndex;
@property (nonatomic, strong) NSString * proximityText;
@property (nonatomic, strong) NSString * colorText;
@property (nonatomic, strong) NSString * search;
//@property (nonatomic, strong) UIImageView * positionDot;

//@property (nonatomic) float dotMinPos;
//@property (nonatomic) float dotRange;

@property (nonatomic, strong) NSMutableArray * foundUnicorns;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation ViewController

- (void)setupBackgroundImage
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if (screenHeight > 480) {
        self.background.image = [UIImage imageNamed:@"backgroundBigRed"];
    } else {
        self.background.image = [UIImage imageNamed:@"backgroundSmallRed"];
    }
}

/*
- (void)setupDotImage
{
    self.positionDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotImage"]];
    [self.positionDot setCenter:self.view.center];
    [self.positionDot setAlpha:1.0f];
    
    [self.view addSubview:self.positionDot];
    
    self.dotMinPos = 150;
    self.dotRange = self.view.bounds.size.height  - 220;
}
 */

- (void)setupView
{
    [self setupBackgroundImage];
}

-(void)setupBeaconManager {
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    ESTBeaconRegion * region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"EstimoteRegion"];
    
    self.selectedProximityIndex = 0;
    [self.beaconManager startRangingBeaconsInRegion:region];
    
    [self setupView];
    
    self.foundUnicorns = [[NSMutableArray alloc] initWithCapacity:3];//initWithObjects:[NSString stringWithFormat:@"%i",22365] , nil];//
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupBeaconManager];
    
}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
    self.searching.text = @"rangingBeaconsDidFailForRegion";
}

-(void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {
    self.searching.text = @"didExitRegion";
}

-(void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {
    self.searching.text = @"didEnterRegion";
}

-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    if ([beacons count] > 0) {
        
        self.selectedBeacon = [self getNearestBeacon:beacons];
        self.colorText = [self beaconColor:self.selectedBeacon.major];
        self.selectedProximityIndex = [self getProximityIndex:self.selectedBeacon];
        
        [self.beaconImage setAlpha:1.0f];
        switch (self.selectedProximityIndex) {
            case 3: {
                self.proximityText = @"immediate";
                NSNumber * major = self.selectedBeacon.major;
                if(![self findId:major]) {
                    NSString * color = [self beaconColor:[NSNumber numberWithInt:[major intValue]]];
                    NSLog(@"found %@, adding",color);
                    [self.foundUnicorns addObject:[NSString stringWithFormat:@"%i",[major intValue]]];
                    [self.tableView reloadData];
                }
                break;
            }
                
            case 2: {
                self.proximityText = @"near";
                NSNumber * major = self.selectedBeacon.major;
                if(![self findId:major]) {
                    //NSString * color = [self beaconColor:[NSNumber numberWithInt:[major intValue]]];
                    [self.foundUnicorns addObject:[NSString stringWithFormat:@"%i",[major intValue]]];
                    [self.tableView reloadData];
                }
                break;
            }
                
            case 1: {
                self.proximityText = @"nearest but far away";
                break;
            }
                
            case 0:
                self.proximityText = @"nearest but very far away";
                [self.beaconImage setAlpha:0.2f];
                break;
                
            default:
                self.proximityText = @"Unknown";
                [self.beaconImage setAlpha:0.0f];
                break;
        }
        
        float distFactor = ((float)self.selectedBeacon.rssi + 30) / -70;
        self.distance.text = [NSString stringWithFormat:@"Distance: %f",distFactor];
        self.proximity.text = [NSString stringWithFormat:@"%@ is %@",[self beaconColor:self.selectedBeacon.major], self.proximityText];
        self.searching.text = @"";
        //float newYPos = self.dotMinPos + distFactor * self.dotRange - 50;
        //self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
        
        NSString *regEx = [NSString stringWithFormat:@".*%@.*", @"Unknown"];
        NSRange range = [self.colorText rangeOfString:regEx options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            UIImage * img = [UIImage imageNamed:[self getUnicorn:self.selectedProximityIndex]];
            if (self.beaconImage.image == img) {
                NSLog(@"samma bild!");
            }
            self.beaconImage.image = img;
            //[self.positionDot setAlpha:1.0f];
        } else {
            self.beaconImage.image = nil;
            //[self.positionDot setAlpha:0.0f];
        }
        
    }
}

-(BOOL)findId:(NSNumber *)major {
    return [self.foundUnicorns containsObject:[NSString stringWithFormat:@"%i",[major intValue]]];
}

-(NSString *)beaconColor:(NSNumber *)major {
    NSString * color;
    if ([major isEqualToNumber:[NSNumber numberWithInt:22365]]) {
        color = @"Gwen";
    } else if ([major isEqualToNumber:[NSNumber numberWithInt:13438]]) {
        color = @"Brandy";
    } else if ([major isEqualToNumber:[NSNumber numberWithInt:15456]]) {
        color = @"Lee";
    } else {
        color = @"Unknown";
    }
    return color;
}

-(NSString *)getUnicorn:(int)index {
    NSString * unicorn;
    switch (index) {
        case 0:
            unicorn = @"unicorn-0";
            break;
        case 1:
            unicorn = @"unicorn-30";
            break;
        case 2:
            unicorn = @"unicorn-60";
            break;
        case 3:
            unicorn = @"unicorn-90";
            break;
    }
    return unicorn;
}

-(ESTBeacon *)getNearestBeacon:(NSArray *)beacons {
    ESTBeacon * beacon;
    int cProximityIndex = 0;
    int prevProximityIndex = 0;
    for (ESTBeacon* cBeacon in beacons) {
        cProximityIndex = [self getProximityIndex:cBeacon];
        
        // select the first beacon in list
        if (!beacon) {
            beacon = cBeacon;
        }
        
        // select the closest beacon. The higher proximityIndex, the closer to beacon
        if (cProximityIndex > prevProximityIndex && [beacon.major unsignedShortValue] != [cBeacon.major unsignedShortValue] && [beacon.minor unsignedShortValue] != [cBeacon.minor unsignedShortValue] && cProximityIndex > 0) {
           
            beacon = cBeacon;
        }
        
        prevProximityIndex = cProximityIndex;
    }
    
    self.prevSelectedBeacon = self.selectedBeacon;
    NSString * prevBeaconColor = [self beaconColor:self.prevSelectedBeacon.major];
    NSString * beaconColor = [self beaconColor:beacon.major];
    if (![beaconColor isEqualToString:prevBeaconColor]) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    return beacon;
}

-(int)getProximityIndex:(ESTBeacon *)beacon {
    int index;
    switch (beacon.proximity) {
        case CLProximityUnknown:
            index = 0;
            break;
            
        case CLProximityImmediate:
            index = 3;
            break;
            
        case CLProximityNear:
            index = 2;
            break;
            
        case CLProximityFar:
            index = 1;
            break;
    }
    
    return index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSections
{
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Number of found unicorns (%i/3)",[self.foundUnicorns count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        if (indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row < [self.foundUnicorns count]) {
        NSString * color = [self beaconColor:[NSNumber numberWithInt:[[self.foundUnicorns objectAtIndex:indexPath.row] intValue]]];
        cell.textLabel.text = [NSString  stringWithFormat:@"You've found %@", color];
    } else {
        cell.textLabel.text = @"Unicorn missing";
    }
    
    return cell;
}

@end
