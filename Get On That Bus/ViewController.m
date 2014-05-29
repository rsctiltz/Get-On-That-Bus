//
//  ViewController.m
//  Get On That Bus
//
//  Created by Ryan Tiltz on 5/28/14.
//  Copyright (c) 2014 Ryan Tiltz. All rights reserved.
//

#import "ViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import "RouteDetailsViewController.h"
#import "NewPointAnnotation.h"
#import "NewAnnotationView.h"

@interface ViewController () <MKMapViewDelegate>
{
    NSDictionary *busRoutes;

    IBOutlet MKMapView *myMapView;
    CLLocationCoordinate2D MMHQCOORDINATE;

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MMHQCOORDINATE = CLLocationCoordinate2DMake(41.89373984, -87.63532979);

    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(MMHQCOORDINATE, span);
    [myMapView setRegion: region animated:YES];
    //   mapView.showsUserLocation = YES;

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        busRoutes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSLog(@"routes = %@", busRoutes);
        NSArray *routeDetails = [busRoutes valueForKey:@"row"];


        for (NSDictionary *dictionary in routeDetails){

            NSString *name = dictionary [@"cta_stop_name"];
            NSString *valueLongitude = dictionary[@"longitude"];
            double longitude = [valueLongitude doubleValue];
            NSString *valueLatitude = dictionary[@"latitude"];
            double latitude = [valueLatitude doubleValue];

            NewPointAnnotation *newAnnotation = [NewPointAnnotation new];


            newAnnotation.title = name;
            newAnnotation.subtitle = dictionary[@"routes"];

            newAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            [myMapView addAnnotation:newAnnotation];
            NSString *mine = dictionary[@"inter_modal"];
            NSLog (@"name = %@", mine);
            if ([dictionary[@"inter_modal"] isEqualToString:@"Metra"] || [dictionary[@"inter_modal"] isEqualToString:@"Pace"]){
                newAnnotation.intermodalTransfers = @"";
                newAnnotation.intermodalTransfers = dictionary[@"inter_modal"];

            } else {
                newAnnotation.intermodalTransfers = @"";

            }

        }


    }];

}

//- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
//{
  //  NewPointAnnotation *annotation = view.annotation;

    //[self performSegueWithIdentifier:@"DetailSegue" sender:selectedDictionary];
    
//}

- (void)mapView:(MKMapView *)mapView annotationView:(NewAnnotationView*)view calloutAccessoryControlTapped:(UIControl *)control
{

    RouteDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Bussuck"];
    vc. title = view.annotation.title;
    vc.busRoutes = view.annotation.subtitle;
    vc.location = view.annotation.coordinate;

    vc.intermodalTransferRoutes = view.annotation.intermodalTransfers;




    [self.navigationController pushViewController:vc  animated:YES];
    
    
}
@end
