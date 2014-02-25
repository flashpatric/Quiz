//
//  ViewController.h
//  Quiz
//
//  Created by patlan on 2014-02-18.
//  Copyright (c) 2014 LBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeaconManager.h"
#import "QuizViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,QuizDelegate> {
	NSTimer *timer;
    IBOutlet UILabel *theTime;
	NSInteger time;
    NSNumber * foundMajor;
}

-(void)setupBeaconManager;
-(NSString *)beaconColor:(NSNumber *)major;
-(ESTBeacon *)getNearestBeacon:(NSArray *)beacons;
-(int)getProximityIndex:(ESTBeacon *)beacon;
-(void)userDidPassQuiz:(BOOL)flag;
-(void)countDown;

@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *proximity;
@property (strong, nonatomic) IBOutlet UILabel *searching;
@property (strong, nonatomic) IBOutlet UIImageView *beaconImage;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *theTime;

@property (retain, nonatomic) NSTimer *timer;

@end
