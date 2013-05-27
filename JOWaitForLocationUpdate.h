//
//  JOWaitForLocationUpdate.h
//  JOWaitForLocationUpdate
//
//  Created by Hsu John on 12/5/17.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
void JOWaitForLocationUpdate(NSTimeInterval interval,void (^succeedBlock)(CLLocation *location) ,void (^timeoutBlock)(void) );

