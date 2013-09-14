//
//  MyLocationViewController.m
//  Muevete
//
//  Created by Development on 21/08/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "MyLocationViewController.h"
#define CONTROLLER_INITAL_FRAME CGRectMake(0, 0, 320, 144)
#define CONTROLLER_FINAL_FRAME CGRectMake(0, 0, 320, 144)
#define CONTROLLER_TEST_FRAME CGRectMake(0, self.view.frame.size.height-controller.frame.size.height, 320, 60)
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
#define kBlueColor [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1]
#define MAX_COUNT_FOR_COORDINATE_ADD 10
#define START_POINT 0

@interface MyLocationViewController (){
    GMSMarker *startMarker;
    GMSMarker *finishMarker;
    GMSMutablePath *path;
    NSMutableArray *arregloCoordenadas;
    int contadorIngresoEnArreglo;
    NSMutableDictionary *diccionarioParaServer;
    GMSPolyline *polyline;
    NSArray *safeSpotsArray;
    UIView *lockOverlay;
    PullAction3DButton *lockButton;
    BOOL firstTimeInLocationManager;
    PullActionButton *button3;
    NSMutableDictionary *trackStats;
}
@property GMSMapView *mapView_;
@property CLLocationManager *locationManager;
@end

@implementation MyLocationViewController
-(void)viewWillAppear:(BOOL)animated{
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        [controller manualLock:YES];        
    }
    else{
        [controller manualLock:NO];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setClipsToBounds:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(safeSpotsReady) name:@"safe_spots_ready" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdatingGoogleLocation:) name:@"location_on" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdatingGoogleLocation:) name:@"location_off" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"become_active" object:nil];
    path = [GMSMutablePath path];
    
    polyline = [GMSPolyline polylineWithPath:path];

    arregloCoordenadas=[[NSMutableArray alloc]init];
    contadorIngresoEnArreglo=0;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_mapView_.myLocation.coordinate.latitude
                                                            longitude:_mapView_.myLocation.coordinate.longitude
                                                                 zoom:14];

    _mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0) camera:camera];
    _mapView_.myLocationEnabled = YES;
    _mapView_.settings.myLocationButton = YES;
    _mapView_.settings.compassButton = NO;
    [self.view addSubview:_mapView_];
    
    controller=[[StartController alloc]initWithFrame:CONTROLLER_INITAL_FRAME];
    controller.delegate=self;
    
    
    UIView *leftBar=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,50)];
    leftBar.layer.shadowOffset=CGSizeMake(0.0,5.0);
    leftBar.layer.shadowOpacity=0.8;
    leftBar.layer.shadowRadius=10.0;
    leftBar.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.5];
    //[self.view addSubview:leftBar];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self performSelector:@selector(setCameraOverLocation) withObject:nil afterDelay:0.5];
    
    PullActionButton *button1=[[PullActionButton alloc]initWithFrame:CGRectMake(-200, 150, 250, 44)];
    button1.the_delegate=self;
    button1.tag=1;
    button1.icon.image=[UIImage imageNamed:@"puntos_seguros.png"];
    [button1 setHilightColor:kRedColor];
    [self.view addSubview:button1];
    
    PullActionButton *button2=[[PullActionButton alloc]initWithFrame:CGRectMake(-200,
                                                                                button1.frame.origin.y+button1.frame.size.height+20,
                                                                                250,
                                                                                44)];
    button2.the_delegate=self;
    button2.tag=2;
    button2.icon.image=[UIImage imageNamed:@"recorridos_guardados.png"];
    [button2 setColor:kYellowColor];
    [button2 setHilightColor:kRedColor];
    [self.view addSubview:button2];
    
    button3=[[PullActionButton alloc]initWithFrame:CGRectMake(-200,
                                                                                button2.frame.origin.y+button2.frame.size.height+20,
                                                                                250,
                                                                                44)];
    button3.the_delegate=self;
    button3.tag=4;
    button3.icon.image=[UIImage imageNamed:@"fb-icon.png"];
    [button3 setColor:kBlueColor];
    [button3 setHilightColor:kRedColor];
    button3.alpha=0;
    [self.view addSubview:button3];
    
    lockOverlay=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    lockOverlay.backgroundColor=[UIColor blackColor];
    lockOverlay.alpha=0;
    [self.view addSubview:lockOverlay];
    [self.view addSubview:controller];

    lockButton=[[PullAction3DButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    lockButton.the_delegate=self;
    lockButton.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-100);
    lockButton.tag=3;
    lockButton.alpha=0;
    lockButton.icon.image=[UIImage imageNamed:@"up.png"];
    [lockButton setColor:kRedColor];
    [lockButton setHilightColor:kYellowColor];
    [self.view addSubview:lockButton];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setCameraOverLocation{
    [_mapView_ animateToLocation:_mapView_.myLocation.coordinate];
}
#pragma mark - location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    double distMetros = firstTimeInLocationManager ? [newLocation distanceFromLocation:newLocation]:[newLocation distanceFromLocation:oldLocation];
    NSLog(@"Metros: %.0f",distMetros);
    firstTimeInLocationManager=NO;
    [controller setPoint:[NSNumber numberWithDouble:distMetros]];
    [controller setAltitude:newLocation.altitude];
    [controller setSpeed:newLocation.speed];
    if (distMetros<100) {
        if (contadorIngresoEnArreglo==MAX_COUNT_FOR_COORDINATE_ADD) {
            [path addCoordinate:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)];
            if (newLocation.coordinate.latitude!=oldLocation.coordinate.latitude &&
                newLocation.coordinate.longitude!=oldLocation.coordinate.longitude) {
                [arregloCoordenadas addObject:newLocation];
            }
            [self setNearestSafeSpot:newLocation];
            [self setPathAndColorToPolyline:kGreenColor];
            contadorIngresoEnArreglo=0;
        }
        else{
            contadorIngresoEnArreglo++;
        }
    }
    
    [_mapView_ animateToLocation:newLocation.coordinate];
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorized) {
        [controller manualLock:NO];
        [self performSelector:@selector(setCameraOverLocation) withObject:nil afterDelay:1.5];

    }
}
-(void)stopUpdatingGoogleLocation:(NSNotification*)notification{
    //NSLog(@"stopping");
    _mapView_.myLocationEnabled = NO;
}
-(void)startUpdatingGoogleLocation:(NSNotification*)notification{
    //NSLog(@"starting");
    _mapView_.myLocationEnabled = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [_mapView_ animateToLocation:coordinate];
}
#pragma mark reverse geocode
-(void)reverseGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate marker:(GMSMarker*)marker andState:(NSString*)state{
    GMSGeocoder *geo=[[GMSGeocoder alloc]init];
    [geo reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *resp, NSError *error){
        //NSLog(@"%@",resp.results);
        marker.animated=YES;
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
#pragma mark - polyline path
-(void)setPathAndColorToPolyline:(UIColor*)color{
    [polyline setPath:path];
    polyline.strokeColor = color;
    polyline.strokeWidth = 20.f;
    polyline.geodesic = YES;
    polyline.map = _mapView_;
}
#pragma mark controller delegate methods
-(void)trackDidStart{
    [_mapView_ clear];
    firstTimeInLocationManager=YES;
    GMSMarker *marker = [GMSMarker markerWithPosition:_mapView_.myLocation.coordinate];
    marker.icon=[GMSMarker markerImageWithColor:kGreenColor];
    [self reverseGeocodeWithCoordinate:marker.position marker:marker andState:@"Punto de Partida"];
    [path removeAllCoordinates];
    [arregloCoordenadas removeAllObjects];
    [_locationManager startUpdatingLocation];
    [self animateControllerLocation:CONTROLLER_FINAL_FRAME];
    [path addCoordinate:CLLocationCoordinate2DMake(_mapView_.myLocation.coordinate.latitude, _mapView_.myLocation.coordinate.longitude)];
    [arregloCoordenadas addObject:_mapView_.myLocation];
    [self downloadSafeSpots];
    [self animateLockButton];
    [self hideFbButton];
}
-(void)trackDidStop:(NSMutableDictionary *)result{
    NSLog(@"El resultado %@",result);
    trackStats=result;
    GMSMarker *marker = [GMSMarker markerWithPosition:_mapView_.myLocation.coordinate];
    [self reverseGeocodeWithCoordinate:marker.position marker:marker andState:@"Fin del Recorrido"];
    [self animateControllerLocation:CONTROLLER_INITAL_FRAME];
    [_locationManager stopUpdatingLocation];
    contadorIngresoEnArreglo=0;
    [path addCoordinate:CLLocationCoordinate2DMake(_mapView_.myLocation.coordinate.latitude, _mapView_.myLocation.coordinate.longitude)];
    [arregloCoordenadas addObject:_mapView_.myLocation];
    [self setPathAndColorToPolyline:kRedColor];
    [self animateLockButton];
    [self showFbButton];
}
-(void)saveTrack:(NSMutableDictionary *)result{
    
    NSMutableArray *arrayDePuntos=[[NSMutableArray alloc]init];
    for(int i = 0; i < arregloCoordenadas.count; i++) {
		CLLocation* location = [arregloCoordenadas objectAtIndex:i];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",location.coordinate.latitude],@"l",[NSString stringWithFormat:@"%f",location.coordinate.longitude],@"o",[NSString stringWithFormat:@"%f",location.altitude],@"a",[NSString stringWithFormat:@"%f",location.speed],@"s", nil];
		[arrayDePuntos addObject:dic];
	}
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayDePuntos options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    [result setObject:jsonString forKey:@"points"];
    FileSaver *file=[[FileSaver alloc]init];
    [result setObject:[[file getDictionary:@"user"] objectForKey:@"id"] forKey:@"id"];

    NSString *params=[NSString stringWithFormat:@"facebookId=%@&overall_seconds=%@&seconds=%@&minutes=%@&hours=%@&meters=%@&points=%@",
                      [[file getDictionary:@"user"] objectForKey:@"id"],
                      [result objectForKey:@"overall_seconds"],
                      [result objectForKey:@"seconds"],
                      [result objectForKey:@"minutes"],
                      [result objectForKey:@"hours"],
                      [result objectForKey:@"meters"],
                      jsonString];
    [self createTrackWithParams:params];
}
#pragma mark animate controller location
-(void)animateControllerLocation:(CGRect)frame{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        controller.frame=frame;
    }completion:^(BOOL finished){
    }];
}
-(void)animateLockButton{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        lockButton.alpha=lockButton.alpha ? 0:1;
    }completion:^(BOOL finished){
    }];
}
-(void)showFbButton{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        button3.alpha=1;
    }completion:^(BOOL finished){
    }];
}
-(void)hideFbButton{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        button3.alpha=0;
    }completion:^(BOOL finished){
    }];
}
#pragma mark - server requests
-(void)downloadSafeSpots{
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithGETMethod:@"GetSafeSpots" andParameter:@"123"];
}
-(void)createTrackWithParams:(NSString*)params{
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.tag=1;
    server.caller=self;
    [server callServerWithPOSTMethod:@"CreateTrack" andParameter:params httpMethod:@"POST"];
}
#pragma mark - server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        if ([server.dictionary objectForKey:@"_id"]) {
            //NSLog(@"Server response %@",server.dictionary);
            [controller saveCallback:YES];
        }
        else{
            [controller saveCallback:NO];
        }
    }
    else if (server.tag==2){
        FileSaver *file=[[FileSaver alloc]init];
        NSArray *spots=(NSArray*)server.dictionary;
        NSDictionary *spotsDic=[[NSDictionary alloc]initWithObjectsAndKeys:spots,@"spots", nil];
        [file setDictionary:spotsDic withKey:@"safe_spots"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"safe_spots_ready" object:nil];
    }
    
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    if (server.tag==1) {
        [controller saveCallback:NO];
    }
    else if (server.tag==2){
        
    }
}
#pragma mark - safe spots
-(BOOL)safeSpotsReady{
    FileSaver *file=[[FileSaver alloc]init];
    if ([file getDictionary:@"safe_spots"]) {
        NSDictionary *dic=[file getDictionary:@"safe_spots"];
        safeSpotsArray=[dic objectForKey:@"spots"];
        //NSLog(@"SafeSpots Array %@",safeSpotsArray);
        return YES;
    }
        return NO;
}
-(void)setNearestSafeSpot:(CLLocation*)newLocation{
    if ([self safeSpotsReady]) {
        NSMutableArray *locationArray=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in safeSpotsArray) {
            CLLocation *location=[[CLLocation alloc]initWithLatitude:[[dic objectForKey:@"lat"] doubleValue] longitude:[[dic objectForKey:@"lon"] doubleValue]];
            [locationArray addObject:location];
        }
        NSMutableArray *distanceArray=[[NSMutableArray alloc]init];
        for (CLLocation *location in locationArray) {
            double distance = [newLocation distanceFromLocation:location];
            [distanceArray addObject:[NSNumber numberWithDouble:distance]];
        }
        NSNumber* min = [distanceArray valueForKeyPath:@"@min.self"];
        NSInteger index=[distanceArray indexOfObject:min];
        [controller setNearSpotTextWithDictionary:[safeSpotsArray objectAtIndex:index]];
    }
}
#pragma mark - pull action button delegate and lock delegate
-(void)actionAccepted:(int)tag{
    NSLog(@"Aceptado por tag %i",tag);
    if (tag==1) {
        SafePointsViewController *spVC=[[SafePointsViewController alloc]init];
        spVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SafePoints"];
        [self.navigationController pushViewController:spVC animated:YES];
        //spVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        //[self presentViewController:spVC animated:YES completion:nil];
    }
    else if(tag==2){
        LogListViewController *llVC=[[LogListViewController alloc]init];
        llVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LogList"];
        [self.navigationController pushViewController:llVC animated:YES];
    }
    else if(tag==4){
//        FacebookShareViewController *fsVC=[[FacebookShareViewController alloc]init];
//        fsVC=[self.storyboard instantiateViewControllerWithIdentifier:@"FacebookShare"];
//        fsVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
//        [self presentViewController:fsVC animated:YES completion:nil];
        NSString *hours=[trackStats objectForKey:@"hours"];
        NSString *minutes=[trackStats objectForKey:@"minutes"];
        NSString *seconds=[trackStats objectForKey:@"seconds"];
        NSString *meters=[NSString stringWithFormat:@"%.2f",[[trackStats objectForKey:@"meters"]floatValue]/1000];
        NSString *message=[NSString stringWithFormat:@"Hoy he recorrido %@ metros durante %@ horas %@ minutos y %@ segundos con la aplicación Muévete de Seguros Colpatria. http://www.iamstudio.co/muevete",meters,hours,minutes,seconds];
        [self publicarEnFbConMensaje:message];
    }
    else if (tag==3){
        if (!lockButton.isOn) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                lockOverlay.alpha=1;
            }completion:^(BOOL finished){
                [self lockAlert:YES];
            }];
        }
        else{
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                lockOverlay.alpha=0;
            }completion:^(BOOL finished){
                [self lockAlert:NO];
            }];
        }
        [controller lockChanged];
        [lockButton setButtonState];
    }
}
-(void)lockAlert:(BOOL)lock{
    if (lock)
        [MBHUDView hudWithBody:@"Bloqueado" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2 show:YES];
    else
        [MBHUDView hudWithBody:@"Desbloqueado" type:MBAlertViewHUDTypeCheckmark hidesAfter:2 show:YES];

}
#pragma mark - lock button delegate

-(void)actionCanceled:(int)tag{
    if (!lockButton.isOn) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            lockOverlay.alpha=0;
        }completion:^(BOOL finished){
        }];
    }
    else{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            lockOverlay.alpha=1;
        }completion:^(BOOL finished){
        }];
    }

}
-(void)almostThere:(int)tag{

    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        lockOverlay.alpha=0.8;
    }completion:^(BOOL finished){
    }];
}
#pragma mark facebook share
-(void)publicarEnFbConMensaje:(NSString*)mensaje{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *fbcontroller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler block=^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
            }
            else{
            }
            [fbcontroller dismissViewControllerAnimated:YES completion:nil];
        };
        fbcontroller.completionHandler=block;
        [fbcontroller setInitialText:mensaje];
        [self saveScreenshot];
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Screenshot.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:documentsDirectory];
        NSData *imageAttachment = UIImageJPEGRepresentation(image,1);
        [fbcontroller addImage:[UIImage imageWithData:imageAttachment]];
        [self presentViewController:fbcontroller animated:YES completion:nil];
        
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Para poder compartir es necesario que tengas una cuenta de Facebook inscrita en tu dispositivo. Para hacer esto dirígete a 'Ajustes->Facebook' y agrega tu cuenta. Es muy sencillo!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
#pragma mark Guardar imagen
- (IBAction)saveScreenshot {
    
    UIGraphicsBeginImageContextWithOptions(controller.bounds.size, NO, 0.0);
    [[controller layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Screenshot.jpg"];
    [UIImageJPEGRepresentation(newImage, 1 ) writeToFile:savePath atomically:YES];
//    NSError *error;
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
}
@end
