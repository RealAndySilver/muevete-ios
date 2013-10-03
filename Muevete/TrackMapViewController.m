//
//  TrackMapViewController.m
//  Muevete
//
//  Created by Andres Abril on 3/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "TrackMapViewController.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
//#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]

@interface TrackMapViewController (){
    CLLocation *startPoint;
    CLLocation *finishPoint;
    NSArray *pointsArray;
    
    GMSMutablePath *path;
    GMSPolyline *polyline;
}
@property GMSMapView *mapView_;

@end

@implementation TrackMapViewController
@synthesize trackDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdatingGoogleLocation:) name:@"location_on" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdatingGoogleLocation:) name:@"location_off" object:nil];

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_mapView_.myLocation.coordinate.latitude
                                                                                longitude:_mapView_.myLocation.coordinate.longitude
                                                                                     zoom:14];
    _mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0) camera:camera];
    _mapView_.myLocationEnabled = YES;
    _mapView_.settings.myLocationButton = YES;
    _mapView_.settings.compassButton = NO;
    [self.view addSubview:_mapView_];
    [self performSelector:@selector(setCameraOverLocation) withObject:nil afterDelay:0.5];
    
    
    path = [GMSMutablePath path];
    polyline = [GMSPolyline polylineWithPath:path];
    
    UIView *topBanner=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topBanner.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
    
    [self.view addSubview:topBanner];
    
    UIView *resultBanner=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    resultBanner.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
    
    [self.view addSubview:resultBanner];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,00,200,50)];
    timeLabel.text=[NSString stringWithFormat:@"%.2ih %.2im %.2is",[[trackDic objectForKey:@"hours"]intValue],[[trackDic objectForKey:@"minutes"]intValue],[[trackDic objectForKey:@"seconds"]intValue]];
    timeLabel.font=[UIFont boldSystemFontOfSize:50];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.textColor=[UIColor whiteColor];
    [resultBanner addSubview:timeLabel];
    
    UILabel *kmLabel=[[UILabel alloc]initWithFrame:CGRectMake(220,20,90,30)];
    double meters=[[trackDic objectForKey:@"meters"]doubleValue];
    kmLabel.text=[NSString stringWithFormat:@"%.1fKm",meters/1000];
    kmLabel.font=[UIFont boldSystemFontOfSize:20];
    kmLabel.textAlignment=NSTextAlignmentCenter;
    kmLabel.adjustsFontSizeToFitWidth = YES;
    kmLabel.backgroundColor=[UIColor clearColor];
    kmLabel.textColor=kRedColor;
    [resultBanner addSubview:kmLabel];

    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(60, 27, 250, 30)];
    title.backgroundColor=[UIColor clearColor];
    [self.view setClipsToBounds:YES];
    title.adjustsFontSizeToFitWidth=YES;
    title.textAlignment=NSTextAlignmentRight;
    title.font=[UIFont boldSystemFontOfSize:25];
    title.textColor=[UIColor whiteColor];
    title.text=[NSString stringWithFormat:@"Recorrido: %@",[self dateConverterFromString:[trackDic objectForKey:@"date_created"]]];
    [topBanner addSubview:title];
    
    PullActionButton *backButton=[[PullActionButton alloc]initWithFrame:CGRectMake(-100, 20, 150, 44)];
    backButton.the_delegate=self;
    backButton.tag=1;
    backButton.icon.image=[UIImage imageNamed:@"left.png"];
    [backButton setColor:kRedColor];
    [backButton setHilightColor:kYellowColor];
    [self.view addSubview:backButton];
    pointsArray=[trackDic objectForKey:@"points"];
    NSDictionary *firstObject=[pointsArray objectAtIndex:0];
    NSDictionary *lastObject=[pointsArray lastObject];
    startPoint=[[CLLocation alloc]initWithLatitude:[[firstObject objectForKey:@"l"]doubleValue] longitude:[[firstObject objectForKey:@"o"]doubleValue]];
    finishPoint=[[CLLocation alloc]initWithLatitude:[[lastObject objectForKey:@"l"]doubleValue] longitude:[[lastObject objectForKey:@"o"]doubleValue]];
    
    GMSMarker *marker1 = [GMSMarker markerWithPosition:startPoint.coordinate];
    marker1.icon=[GMSMarker markerImageWithColor:kGreenColor];
    [self reverseGeocodeWithCoordinate:marker1.position marker:marker1 andState:@"Punto de Partida"];
    marker1.animated=YES;
    marker1.map = _mapView_;
    
    
    GMSMarker *marker2 = [GMSMarker markerWithPosition:finishPoint.coordinate];
    marker2.icon=[GMSMarker markerImageWithColor:kRedColor];
    [self reverseGeocodeWithCoordinate:marker2.position marker:marker2 andState:@"Fin del Recorrido"];
    marker2.animated=YES;
    marker2.map = _mapView_;
    
    for (NSDictionary *dic in pointsArray) {
        CLLocation *location=[[CLLocation alloc]initWithLatitude:[[dic objectForKey:@"l"]doubleValue] longitude:[[dic objectForKey:@"o"]doubleValue]];
        [path addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    }
    [self setPathAndColorToPolyline:kGreenColor];

}
-(void)setCameraOverLocation{
    [_mapView_ animateToLocation:startPoint.coordinate];
    //[self reverseGeocodeWithCoordinate:_mapView_.myLocation.coordinate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)actionAccepted:(int)tag{
    if (tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - date converter
-(NSString*)dateConverterFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter2 setDateFormat:@"dd 'de' MMMM, HH:mm"];
    NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
    return strDate;
}
#pragma mark reverse geocode
-(void)reverseGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate marker:(GMSMarker*)marker andState:(NSString*)state{
    GMSGeocoder *geo=[[GMSGeocoder alloc]init];
    [geo reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *resp, NSError *error){
        //NSLog(@"%@",resp.results);
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
#pragma mark - polyline path
-(void)setPathAndColorToPolyline:(UIColor*)color{
    [polyline setPath:path];
    polyline.strokeColor = color;
    polyline.strokeWidth = 20.f;
    polyline.geodesic = YES;
    polyline.map = _mapView_;
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
@end
