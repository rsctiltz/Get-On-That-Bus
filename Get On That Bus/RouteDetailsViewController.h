//
//  BusRouteViewController.h
//  Get On That Bus
//
//  Created by Ryan Tiltz on 5/28/14.
//  Copyright (c) 2014 Ryan Tiltz. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface RouteDetailsViewController : ViewController

@property NSString *title;
@property NSString *address;
@property NSString *busRoutes;
@property NSString *intermodalTransferRoutes;
@property CLLocationCoordinate2D location;

@end
