//
//  StartController.m
//  Muevete
//
//  Created by Andres Abril on 31/08/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "StartController.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
//191,184,50,0.98
//64,174,126
@implementation StartController
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self setClipsToBounds:NO];
        [self resetCounters];
        flag=NO;
        lastColor=kGreenColor;
        points=[[NSMutableArray alloc]init];
        container=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        topContainer=[[UIView alloc]initWithFrame:CGRectMake(-320, 0, self.frame.size.width, 60)];
        topContainer.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
        
        UIImageView *rightLogo=[[UIImageView alloc]initWithFrame:CGRectMake(topContainer.frame.size.width-100, 38, 85, 15)];
        rightLogo.image=[UIImage imageNamed:@"colpatriasmall.png"];
        [topContainer addSubview:rightLogo];
        
        middleContainer=[[UIView alloc]initWithFrame:CGRectMake(0, topContainer.frame.origin.y+topContainer.frame.size.height, self.frame.size.width, 60)];
        middleContainer.backgroundColor=[UIColor clearColor];
        bottomContainer=[[UIView alloc]initWithFrame:CGRectMake(0, middleContainer.frame.origin.y+middleContainer.frame.size.height, self.frame.size.width, 44)];
        bottomContainer.backgroundColor=[UIColor clearColor];
        [bottomContainer setClipsToBounds:YES];
        [middleContainer setClipsToBounds:YES];
        [container addSubview:bottomContainer];
        [container addSubview:topContainer];
        [container addSubview:middleContainer];
        
        
        altitudeContainer=[[UIView alloc]initWithFrame:CGRectMake(frame.size.width, -64, 200, 88)];
        altitudeContainer.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
        altitudeContainer.layer.cornerRadius=44;
        [altitudeContainer setClipsToBounds:YES];
        [bottomContainer addSubview:altitudeContainer];

        [self addSubview:container];

        mainBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, middleContainer.frame.size.width, middleContainer.frame.size.height)];
        mainBar.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
        [middleContainer addSubview:mainBar];

        scrollContainer=[[UIScrollView alloc]initWithFrame:CGRectMake(-310,0,mainBar.frame.size.width+120,mainBar.frame.size.height)];
        [scrollContainer setAlwaysBounceHorizontal:YES];
        scrollContainer.delegate=self;
        [scrollContainer setClipsToBounds:NO];
        [scrollContainer setScrollEnabled:YES];
        [scrollContainer setShowsHorizontalScrollIndicator:NO];
        scrollContainer.tag=1;
        [scrollContainer setUserInteractionEnabled:YES];
        [middleContainer addSubview:scrollContainer];
        NSLog(@"El scroll %@",scrollContainer);
        //leftBar=[[UIView alloc]initWithFrame:CGRectMake(-310,0,mainBar.frame.size.width+120,mainBar.frame.size.height)];
        leftBar=[[UIView alloc]initWithFrame:CGRectMake(0,0,mainBar.frame.size.width+120,mainBar.frame.size.height)];
        leftBar.layer.cornerRadius=leftBar.frame.size.height/2;
        leftBar.layer.shadowOffset=CGSizeMake(0.0,5.0);
        leftBar.layer.shadowOpacity=0.8;
        leftBar.layer.shadowRadius=10.0;
        leftBar.backgroundColor=kGreenColor;
        [scrollContainer addSubview:leftBar];
        leftBarActionButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [leftBarActionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        leftBarActionButton.frame=CGRectMake(leftBar.frame.size.width-130, 50, 100, 40);
        leftBarActionButton.center=CGPointMake(leftBar.frame.size.width/1.2, leftBar.frame.size.height/2);
        leftBarActionButton.backgroundColor=[UIColor clearColor];
        [leftBarActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBarActionButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [leftBarActionButton setTitle:@"Iniciar" forState:UIControlStateNormal];
        [leftBarActionButton addTarget:self action:@selector(startTrack:) forControlEvents:UIControlEventTouchUpInside];
        leftBarActionButton.tag=100;
        lastText=@"Iniciar";
        [leftBar addSubview:leftBarActionButton];
        
        UIImageView *grip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grip.png"]];
        grip.frame=CGRectMake(0, 0, 10, 20);
        grip.center=CGPointMake(leftBar.frame.size.width-20, leftBar.frame.size.height/2);
        [grip setTintColor:[UIColor redColor]];
        grip.alpha=0.3;
        [leftBar addSubview:grip];
        
        mainBarStateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        mainBarStateLabel.center=CGPointMake(mainBar.frame.size.width/2+mainBarStateLabel.frame.size.width/3,
                                             mainBar.frame.size.height/5);
        mainBarStateLabel.backgroundColor=[UIColor clearColor];
        mainBarStateLabel.textColor=[UIColor whiteColor];
        mainBarStateLabel.text=@"Listo";
        [mainBar addSubview:mainBarStateLabel];
        
        float altoLabels=18;
        
        kmLabel=[[UILabel alloc]initWithFrame:CGRectMake(mainBarStateLabel.frame.origin.x,
                                                         mainBarStateLabel.frame.origin.y+mainBarStateLabel.frame.size.height,
                                                         50, altoLabels)];
        kmLabel.text=@"0.0 Km";
        kmLabel.adjustsFontSizeToFitWidth = YES;
        kmLabel.backgroundColor=[UIColor clearColor];
        kmLabel.textColor=[UIColor whiteColor];
        [mainBar addSubview:kmLabel];
        
        separatorLabel=[[UILabel alloc]initWithFrame:CGRectMake(kmLabel.frame.origin.x+kmLabel.frame.size.width,
                                                         mainBarStateLabel.frame.origin.y+mainBarStateLabel.frame.size.height,
                                                                16, altoLabels)];
        separatorLabel.text=@"·";
        separatorLabel.textAlignment=NSTextAlignmentCenter;
        separatorLabel.backgroundColor=[UIColor clearColor];
        separatorLabel.font=[UIFont boldSystemFontOfSize:30];
        separatorLabel.textColor=[UIColor whiteColor];
        [mainBar addSubview:separatorLabel];
        
        speedLabel=[[UILabel alloc]initWithFrame:CGRectMake(separatorLabel.frame.origin.x+separatorLabel.frame.size.width,
                                                                mainBarStateLabel.frame.origin.y+mainBarStateLabel.frame.size.height, 90, altoLabels)];
        speedLabel.text=@"0 km/h";
        speedLabel.adjustsFontSizeToFitWidth = YES;
        speedLabel.backgroundColor=[UIColor clearColor];
        speedLabel.textColor=[UIColor whiteColor];
        [mainBar addSubview:speedLabel];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,10,180,50)];
        timeLabel.text=@"00h 00m 00s";
        timeLabel.font=[UIFont boldSystemFontOfSize:50];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.textColor=[UIColor whiteColor];
        [topContainer addSubview:timeLabel];
        
        altitudeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,50,67,50)];
        altitudeLabel.text=@"0m";
        altitudeLabel.textColor=kRedColor;
        altitudeLabel.font=[UIFont boldSystemFontOfSize:20];
        altitudeLabel.adjustsFontSizeToFitWidth = YES;
        altitudeLabel.backgroundColor=[UIColor clearColor];
//        altitudeLabel.textColor=[UIColor whiteColor];
        [altitudeContainer addSubview:altitudeLabel];
        
        nearSpotLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,
                                                               kmLabel.frame.origin.y+kmLabel.frame.size.height,
                                                               170,
                                                               altoLabels)];
        nearSpotText=nearSpotLabel.text=@"Inicia un trayecto para encontrar el punto seguro más cercano";
        nearSpotLabel.font=[UIFont italicSystemFontOfSize:12];
        nearSpotLabel.backgroundColor=[UIColor clearColor];
        nearSpotLabel.textColor=[UIColor whiteColor];
        [mainBar addSubview:nearSpotLabel];
        [mainBar bringSubviewToFront:scrollContainer];
        [self animarBannerPuntoSeguro];
    }
    return self;
}
-(void)startTrack:(UIButton*)sender{
    nearSpotText=@"Buscando punto seguro más cercano";
    [self vibrate];
    if (sender.tag==100) {
        MBAlertView *alert=[MBAlertView alertWithBody:@"Iniciar trayecto?" cancelTitle:nil cancelBlock:nil];
        [alert addButtonWithText:@"Cancelar" type:MBAlertViewItemTypeDestructive block:^{}];
        [alert addButtonWithText:@"Empezar" type:MBAlertViewItemTypePositive block:^{
            NSLog(@"started");
            [self resetCounters];
            mainBarStateLabel.text=@"En Marcha";
            [self clockStart];
            [self animateBarIn];
            [self.delegate trackDidStart];
        }];
        [alert setBackgroundAlpha:0.9];
        [alert setAnimationType:MBAlertAnimationTypeBounce];
        [alert addToDisplayQueue];
    }
    else{
        MBAlertView *alert=[MBAlertView alertWithBody:@"Seguro qué desea terminar este trayecto?" cancelTitle:nil cancelBlock:^{}];
        [alert addButtonWithText:@"Cancelar" type:MBAlertViewItemTypeDestructive block:^{
            [leftBarActionButton setTitle:lastText forState:UIControlStateNormal];
            [leftBar setBackgroundColor:lastColor];
        }];
        [alert addButtonWithText:@"Terminar" type:MBAlertViewItemTypePositive block:^{
            [self stopTrack];
        }];
        [alert setBackgroundAlpha:0.9];
        [alert setAnimationType:MBAlertAnimationTypeBounce];
        [alert addToDisplayQueue];
        
    }
    
}
-(void)startNoPromt:(UIButton*)sender{
    [self vibrate];
    if (sender.tag==100) {
    [self resetCounters];
    mainBarStateLabel.text=@"En Marcha";
    [self clockStart];
    [self.delegate trackDidStart];
    [self animateBarIn];
    }
    else if (sender.tag==101){
        [self stopTrack];
    }
}

-(void)saveTrack{
    mainBarStateLabel.text=@"Guardando";
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%i",seconds] forKey:@"seconds"];
    [dic setObject:[NSString stringWithFormat:@"%i",minutes] forKey:@"minutes"];
    [dic setObject:[NSString stringWithFormat:@"%i",hours] forKey:@"hours"];
    [dic setObject:[NSString stringWithFormat:@"%i",globalSeconds] forKey:@"overall_seconds"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",meters] forKey:@"meters"];
    [self.delegate saveTrack:dic];
    [MBHUDView hudWithBody:@"Guardando" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:1000 show:YES];
}
-(void)saveCallback:(BOOL)success{
    [MBHUDView dismissCurrentHUD];
    if (success) {
        mainBarStateLabel.text=@"Guardado";
        [MBHUDView hudWithBody:@"Guardado exitoso!" type:MBAlertViewHUDTypeCheckmark hidesAfter:3 show:YES];
    }
    else{
        mainBarStateLabel.text=@"Error al guardar";
        MBAlertView *alert=[MBAlertView alertWithBody:@"Hubo un error al guardar el trayecto.\nRevisa tu conexión a internet y vuelve a intentarlo." cancelTitle:nil cancelBlock:nil];
        [alert addButtonWithText:@"No, Gracias" type:MBAlertViewItemTypeDestructive block:^{}];
        [alert addButtonWithText:@"Reintentar" type:MBAlertViewItemTypePositive block:^{
            [self saveTrack];
        }];
        [alert setBackgroundAlpha:0.9];
        [alert setAnimationType:MBAlertAnimationTypeBounce];
        [alert addToDisplayQueue];
        [MBHUDView hudWithBody:@"Error!" type:MBAlertViewHUDTypeExclamationMark hidesAfter:3 show:YES];
    }
}
-(void)stopTrack{
    [self clockStop];
    MBAlertView *alert2=[MBAlertView alertWithBody:@"Deseas guardar este trayecto?" cancelTitle:nil cancelBlock:nil];
    [alert2 addButtonWithText:@"No, Gracias" type:MBAlertViewItemTypeDestructive block:^{}];
    [alert2 addButtonWithText:@"Guardar" type:MBAlertViewItemTypePositive block:^{
        [self saveTrack];
    }];
    [alert2 setBackgroundAlpha:0.9];
    [alert2 setAnimationType:MBAlertAnimationTypeBounce];
    [alert2 addToDisplayQueue];
    //[self animateBarOut];
    mainBarStateLabel.text=@"Finalizado";
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%i",seconds] forKey:@"seconds"];
    [dic setObject:[NSString stringWithFormat:@"%i",minutes] forKey:@"minutes"];
    [dic setObject:[NSString stringWithFormat:@"%i",hours] forKey:@"hours"];
    [dic setObject:[NSString stringWithFormat:@"%i",globalSeconds] forKey:@"overall_seconds"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",meters] forKey:@"meters"];
    [self.delegate trackDidStop:dic];
    nearSpotText=@"Inicia un trayecto para encontrar el punto seguro más cercano";
    
}
-(void)setRunningTime{
    timeLabel.text=[self timerString];
}
#pragma mark - timer
-(void)clockStart {
    if (![timer isValid]) {
        [self animateBarColorToRed];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setRunningTime) userInfo:nil repeats:YES];
    }
}
-(void)clockStop {
    if ([timer isValid]) {
        [self animateBarColorToGreen];
        [timer invalidate];
        timer = nil;
    }
}
-(NSString*)timerString{
    seconds++;
    globalSeconds++;
    if (seconds>59){
        seconds=0;
        minutes++;
        if (minutes>59){
            minutes=0;
            hours++;
            if (hours<0){hours=0;}
        }
    }
    //NSLog(@"tiempo %@",[NSString stringWithFormat:@"%.2i:%.2i:%.2i",hours,minutes,seconds]);
    return [NSString stringWithFormat:@"%.2ih %.2im %.2is",hours,minutes,seconds];
}
-(void)resetCounters{
    seconds=0;
    minutes=0;
    hours=0;
    meters=0;
    [points removeAllObjects];
    kmLabel.text=@"0.0 Km";
    timeLabel.text=@"00h 00m 00s";
}
#pragma mark animations
-(void)animateBarColorToRed{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        leftBar.backgroundColor=kRedColor;
        leftBarActionButton.tag=101;
        [leftBarActionButton setTitle:@"Terminar" forState:UIControlStateNormal];
    }completion:^(BOOL finished){
        lastColor=leftBar.backgroundColor;
        lastText=leftBarActionButton.titleLabel.text;
    }];
}
-(void)animateBarColorToGreen{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        leftBar.backgroundColor=kGreenColor;
        leftBarActionButton.tag=100;
        [leftBarActionButton setTitle:@"Iniciar" forState:UIControlStateNormal];
    }completion:^(BOOL finished){
        lastColor=leftBar.backgroundColor;
        lastText=leftBarActionButton.titleLabel.text;
    }];
}
-(void)animateBarIn{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        topContainer.frame=CGRectMake(-0, 0, self.frame.size.width, 60);
        //topContainer.frame=CGRectMake(0, 0, 320, 40);
        altitudeContainer.frame=CGRectMake(220, -64, 200, 88);
    }completion:^(BOOL finished){
    }];
}
-(void)animateBarOut{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        topContainer.frame=CGRectMake(-320, 0, 320, 40);
        altitudeContainer.frame=CGRectMake(self.frame.size.width, -64, 200, 88);
    }completion:^(BOOL finished){
    }];
}
#pragma mark - setters
-(void)setMeters{
    meters=[StartController medidorDeMetrosRecorridos:points];
    float km=meters/1000;
    kmLabel.text=[NSString stringWithFormat:@"%.1f Km",km];
}
-(void)setPoint:(NSNumber*)point{
    [points addObject:point];
    [self setMeters];
}
-(void)setNearSpotTextWithDictionary:(NSDictionary *)dictionary{
    nearSpotText=[NSString stringWithFormat:@"El punto seguro más cercano se encuentra en %@",[dictionary objectForKey:@"address"]];
}
-(void)setSpeed:(double)speed{
    speedLabel.text=[NSString stringWithFormat:@"%.1fkm/h",(speed*3600)/1000];
}
-(void)setAltitude:(double)altitude{
    altitudeLabel.text=[NSString stringWithFormat:@"%.1fm",altitude];
}
#pragma mark - points to meters
+(float)medidorDeMetrosRecorridos:(NSMutableArray*)puntos{
    float suma= 0.0;
    float value= 0.0;
    for (int i = 0; i < [puntos count]; i++) {
        value = [[puntos objectAtIndex: i] floatValue];
		suma += value;
	}
    return suma;
}
#pragma mark - scrollview delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    switch (scrollView.tag) {
        case 1:
            if (scrollView.contentOffset.x<-80.0) {
                NSLog(@"Comenzar");
                //[self performSelector:@selector(delayedFlag) withObject:nil afterDelay:1];
                [self startNoPromt:leftBarActionButton];
            }
            break;
            
        default:
            break;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self vibrate];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    switch (scrollView.tag) {
        case 1:
            if ([scrollView isDragging]){
                if (scrollView.contentOffset.x<-80) {
                    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        leftBar.backgroundColor=kYellowColor;
                        [leftBarActionButton setTitle:@"Soltar" forState:UIControlStateNormal];
                    }completion:^(BOOL finished){
                    }];
                }
                else{
                    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        leftBar.backgroundColor=lastColor;
                        [leftBarActionButton setTitle:lastText forState:UIControlStateNormal];
                    }completion:^(BOOL finished){
                    }];
                }
            }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - banner animation
-(void)animarBannerPuntoSeguro{
    nearSpotLabel.text=nearSpotText;
    CGSize textSize = [[nearSpotLabel text] sizeWithFont:[nearSpotLabel font]];
    CGFloat labelWidth = textSize.width;
    CGRect posInicial=CGRectMake(self.frame.size.width,
                                 kmLabel.frame.origin.y+kmLabel.frame.size.height, labelWidth, 18);
    CGRect posFinal=CGRectMake(-labelWidth,
                               kmLabel.frame.origin.y+kmLabel.frame.size.height, labelWidth, 18);
    nearSpotLabel.frame=posInicial;
    [UIView animateWithDuration:20 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        nearSpotLabel.frame=posFinal;
    }completion:^(BOOL finished){
        [self animarBannerPuntoSeguro];
    }];
}
-(void)lockChanged{
    CGRect frameInicial=CGRectMake(-310,0,mainBar.frame.size.width+120,mainBar.frame.size.height);
    CGRect frameFinal=CGRectMake(-510,0,mainBar.frame.size.width+120,mainBar.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (frameInicial.origin.x==scrollContainer.frame.origin.x) {
            scrollContainer.frame=frameFinal;
        }
        else{
            scrollContainer.frame=frameInicial;
        }
    }completion:^(BOOL finished){
    }];
}
-(void)manualLock:(BOOL)lock{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        scrollContainer.alpha=lock ? 0:1;
    }completion:^(BOOL finished){
    }];
}
//#pragma mark -touches delegate
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch=[[event allTouches] anyObject];
//    if ([touch.view isEqual:leftBarActionButton]) {
//        NSLog(@"Began in controller");
//        [self vibrate];
//    }
//}
#pragma mark - vibration
-(void)vibrate{
    [Vibration vibrate];
}
@end
