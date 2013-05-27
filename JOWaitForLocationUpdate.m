//
//  JOWaitForLocationUpdate.m
//  JOWaitForLocationUpdate
//
//  Created by Hsu John on 12/5/17.
//  Copyright (c) 2012  All rights reserved.
//

#import "JOWaitForLocationUpdate.h"
@interface JOWaitForLocationUpdateClass : NSObject <CLLocationManagerDelegate>
{
@private
    CLLocationManager *locationManager;
    NSTimer *countdownTimer;
}

-(void)setupTimerAndStartCountDown;
-(void)timeup;
@property(nonatomic,copy)void(^succeedBlock)(CLLocation *userLocation);
@property(nonatomic,copy)void(^timeoutBlock)(void);
@property(nonatomic,assign)NSTimeInterval maxWaitingTime;
@end

@implementation YKWaitForLocationUpdateClass
@synthesize succeedBlock,timeoutBlock,maxWaitingTime;

- (void)dealloc
{
    [locationManager release];
    [countdownTimer invalidate];
    countdownTimer = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        YKValidationCode
        locationManager = [[CLLocationManager alloc] init];
        [locationManager startUpdatingLocation];
        locationManager.delegate = self;
    }
    return self;
}

-(void)setupTimerAndStartCountDown
{
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:maxWaitingTime target:self selector:@selector(timeup) userInfo:nil repeats:NO];
}

-(void)timeup
{
    [countdownTimer invalidate];
    countdownTimer = nil;
    if (locationManager.location) {
        self.succeedBlock(locationManager.location);
    }
    else {
        self.timeoutBlock();
    }
    self.succeedBlock = nil;
    self.timeoutBlock = nil;
    [locationManager stopUpdatingLocation];
    [self autorelease];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (countdownTimer) {
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
    if (status == kCLAuthorizationStatusAuthorized) {
        [self setupTimerAndStartCountDown];
    }
    else if (status == kCLAuthorizationStatusNotDetermined) {
        //do nothing
    }
    else {
//        SimpleAlert(@"您尚未開啟定位服務，請至系統設定中開啟");
        self.timeoutBlock();
        self.succeedBlock = nil;
        self.timeoutBlock = nil;
        [self autorelease];
    }
}
@end

void YKWaitForLocationUpdate(NSTimeInterval interval,void (^succeedBlock)(CLLocation *location) ,void (^timeoutBlock)(void) )
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        YKWaitForLocationUpdateClass *instance = [[YKWaitForLocationUpdateClass alloc] init];
        instance.succeedBlock = succeedBlock;
        instance.timeoutBlock = timeoutBlock;
        instance.maxWaitingTime = interval;
        [instance setupTimerAndStartCountDown];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        YKWaitForLocationUpdateClass *instance = [[YKWaitForLocationUpdateClass alloc] init];
        instance.succeedBlock = succeedBlock;
        instance.timeoutBlock = timeoutBlock;
        instance.maxWaitingTime = interval;
        // wait for auth change and goto location manager delegate
    }
    else {
//        SimpleAlert(@"您尚未開啟定位服務，請至系統設定中開啟");
        timeoutBlock();
    }
}
