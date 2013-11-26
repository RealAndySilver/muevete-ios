//
//  SafePointsViewController.m
//  Muevete
//
//  Created by Andres Abril on 3/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "SafePointsViewController.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
//#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]

#define kEstiramiento [UIColor colorWithRed:143.0/255 green:39.0/255 blue:142.0/255 alpha:1]
#define kBienestar [UIColor colorWithRed:119.0/255 green:191.0/255 blue:67.0/255 alpha:1]
#define kSalud [UIColor colorWithRed:245.0/255 green:144.0/255 blue:30.0/255 alpha:1]
#define kHidratacion [UIColor colorWithRed:38.0/255 green:169.0/255 blue:225.0/255 alpha:1]

//143,39,142,0.8 estiramiento
//119,191,67,0.8 bienestar
//245,144,30,0.7 salud
//38,169,225,0.3 hidratación
@interface SafePointsViewController (){
    NSArray *safeSpotsArray;
}
@property GMSMapView *mapView_;
@end

@implementation SafePointsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdatingGoogleLocation:) name:@"location_on" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdatingGoogleLocation:) name:@"location_off" object:nil];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:4.760015 longitude:-74.047562];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:10];
    _mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0) camera:camera];
    _mapView_.myLocationEnabled = YES;
    _mapView_.settings.myLocationButton = YES;
    _mapView_.settings.compassButton = NO;
    [self.view addSubview:_mapView_];
    
    UIView *topBanner=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topBanner.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
    
    [self.view addSubview:topBanner];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(30, 27, 250, 30)];
    title.backgroundColor=[UIColor clearColor];
    [self.view setClipsToBounds:YES];
    title.center=CGPointMake(topBanner.frame.size.width/2, topBanner.frame.size.height/2+10);
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont boldSystemFontOfSize:25];
    title.textColor=[UIColor whiteColor];
    title.text=@"Puntos Seguros";
    [topBanner addSubview:title];
    
    PullActionButton *backButton=[[PullActionButton alloc]initWithFrame:CGRectMake(-100, 20, 150, 44)];
    backButton.the_delegate=self;
    backButton.tag=1;
    backButton.icon.image=[UIImage imageNamed:@"left.png"];
    [backButton setColor:kRedColor];
    [backButton setHilightColor:kYellowColor];
    [self.view addSubview:backButton];
    [self downloadSafeSpots];
}
-(void)setCameraOverLocation:(CLLocation*)location{
    [_mapView_ animateToLocation:location.coordinate];
    //[self reverseGeocodeWithCoordinate:_mapView_.myLocation.coordinate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)actionAccepted:(int)tag{
    if (tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - server request
-(void)downloadSafeSpots{
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetSafeSpots" andParameter:@"123"];
}
#pragma mark - server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1){
        FileSaver *file=[[FileSaver alloc]init];
        NSArray *spots=(NSArray*)server.dictionary;
        NSDictionary *spotsDic=[[NSDictionary alloc]initWithObjectsAndKeys:spots,@"spots", nil];
        [file setDictionary:spotsDic withKey:@"safe_spots"];
        if ([self safeSpotsReady]) {
            for (NSDictionary *spotsDic in safeSpotsArray) {
                CLLocation *location=[[CLLocation alloc]initWithLatitude:[[spotsDic objectForKey:@"lat"]doubleValue]
                                                               longitude:[[spotsDic objectForKey:@"lon"]doubleValue]];
                GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
                marker.title = [spotsDic objectForKey:@"name"];
                marker.snippet = [NSString stringWithFormat:@"%@: %@",[spotsDic objectForKey:@"type"],[spotsDic objectForKey:@"address"]];
                //[self reverseGeocodeWithCoordinate:marker.position marker:marker andState:@"Punto de Partida"];
                marker.icon=[GMSMarker markerImageWithColor:kSalud];
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.map = _mapView_;
            }
        }
    }
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    if (server.tag==1){
        if ([self safeSpotsReady]) {
            for (NSDictionary *spotsDic in safeSpotsArray) {
                CLLocation *location=[[CLLocation alloc]initWithLatitude:[[spotsDic objectForKey:@"lat"]doubleValue]
                                                               longitude:[[spotsDic objectForKey:@"lon"]doubleValue]];
                GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
                marker.title = [spotsDic objectForKey:@"name"];
                marker.snippet = [NSString stringWithFormat:@"%@: %@",[spotsDic objectForKey:@"type"],[spotsDic objectForKey:@"address"]];
                //[self reverseGeocodeWithCoordinate:marker.position marker:marker andState:@"Punto de Partida"];
                marker.icon=[GMSMarker markerImageWithColor:kSalud];
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.map = _mapView_;
            }
        }
        else{
            //mostrar error
        }
    }
}
#pragma mark - safe spot ready?
-(BOOL)safeSpotsReady{
    FileSaver *file=[[FileSaver alloc]init];
    if ([file getDictionary:@"safe_spots"]) {
        NSDictionary *dic=[file getDictionary:@"safe_spots"];
        safeSpotsArray=[dic objectForKey:@"spots"];
        if (safeSpotsArray.count<2) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark - google location
-(void)stopUpdatingGoogleLocation:(NSNotification*)notification{
    NSLog(@"stopping");
    _mapView_.myLocationEnabled = NO;
}
-(void)startUpdatingGoogleLocation:(NSNotification*)notification{
    NSLog(@"starting");
    _mapView_.myLocationEnabled = YES;
}
#pragma mark reverse geocode
-(void)reverseGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate marker:(GMSMarker*)marker andState:(NSString*)state{
    GMSGeocoder *geo=[[GMSGeocoder alloc]init];
    [geo reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *resp, NSError *error){
        //NSLog(@"%@",resp.results);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView_;
        if (resp.results.count>2) {
            GMSReverseGeocodeResult *result=resp.results[2];
            marker.title = result.addressLine1;
            marker.snippet = [NSString stringWithFormat:@"%@: %@,%@",state,resp.firstResult.addressLine1,resp.firstResult.addressLine2];
        }
        else{
            marker.snippet =@"";
        }
    }];
}
@end
