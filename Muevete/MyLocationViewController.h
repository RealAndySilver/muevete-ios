//
//  MyLocationViewController.h
//  Muevete
//
//  Created by Development on 21/08/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "StartController.h"
#import "ServerCommunicator.h"
#import "FileSaver.h"
#import "RNGridMenu.h"
#import "PullActionButton.h"
#import "SafePointsViewController.h"
#import "LogListViewController.h"
#import "PullAction3DButton.h"
#import "MBHUDView.h"
#import "FacebookShareViewController.h"
@interface MyLocationViewController : UIViewController <CLLocationManagerDelegate,StartControllerDelegate,GMSMapViewDelegate,PullActionButtonDelegate,PullAction3DButtonDelegate,UIAlertViewDelegate>{
    StartController *controller;
}

@end
