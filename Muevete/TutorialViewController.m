//
//  TutorialViewController.m
//  Muevete
//
//  Created by Andres Abril on 12/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "TutorialViewController.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
//#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
#define kBlueColor [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1]
#define kColpatria [UIColor colorWithRed:189.0/255.0 green:13.0/255.0 blue:18.0/255.0 alpha:1]

@interface TutorialViewController (){
    UIScrollView *scrollView;
    GMSMapView *mapView;
}

@end

@implementation TutorialViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:4.700015 longitude:-74.047562];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:16];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0) camera:camera];
    mapView.myLocationEnabled = NO;
    mapView.settings.myLocationButton = NO;
    mapView.settings.compassButton = NO;
    [self.view addSubview:mapView];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setAlwaysBounceHorizontal:YES];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.85];
    self.view.backgroundColor=[UIColor whiteColor];
    scrollView.delegate=self;
    
    //Página Uno
    TutorialView *tutorialView1=[[TutorialView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tutorialView1.titleLabel.text=@"Bienvenido a";
    //tutorialView1.superTitleLabel.text=@"MUÉVETE";
    tutorialView1.bottomImageView.image=[UIImage imageNamed:@"muevetesolo.png"];
    tutorialView1.mainImageView.image=[UIImage imageNamed:@"main1st.png"];
    tutorialView1.titleLabel.frame=CGRectMake(20, tutorialView1.bottomImageView.frame.origin.y-25, 150, 30);
    tutorialView1.textView.frame=CGRectMake(tutorialView1.bottomImageView.frame.origin.x+tutorialView1.bottomImageView.frame.size.width+10,tutorialView1.titleLabel.frame.origin.y,self.view.frame.size.width-40-tutorialView1.bottomImageView.frame.size.width, 120);
    tutorialView1.textView.text=@"Muévete medirá tu trayecto y te mostrará los puntos seguros de la ciclovía.\nTambién podrás consultar tus trayectos en cualquier momento.";
    tutorialView1.bottomLine.text=@"Desliza a la izquierda para continuar";
    [scrollView addSubview:tutorialView1];
    
    //Página Dos
    TutorialView *tutorialView2=[[TutorialView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*1, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tutorialView2.titleLabel.text=@"Guarda tus trayectos";
    //tutorialView1.superTitleLabel.text=@"MUÉVETE";
    tutorialView2.mainImageView.image=[UIImage imageNamed:@"tracks.png"];
    tutorialView2.mainImageView.contentMode=UIViewContentModeScaleAspectFit;
    tutorialView2.titleLabel.frame=CGRectMake(20, tutorialView2.bottomImageView.frame.origin.y-25, 250, 30);
    tutorialView2.textView.text=@"Podrás revisar todos tus trayectos guardados cuando quieras, ver tu tiempo, ruta, velocidad máxima y altura promedio.";
    tutorialView2.bottomLine.text=@"Desliza a la izquierda para continuar";
    [scrollView addSubview:tutorialView2];
    
    //Página Tres
    TutorialView *tutorialView3=[[TutorialView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tutorialView3.titleLabel.text=@"Puntos Seguros";
    tutorialView3.mainImageView.image=[UIImage imageNamed:@"puntosseguros.png"];
    tutorialView3.mainImageView.contentMode=UIViewContentModeScaleAspectFit;
    tutorialView3.titleLabel.frame=CGRectMake(20, tutorialView3.bottomImageView.frame.origin.y-25, 250, 30);
    tutorialView3.textView.text=@"Mientras estés en la ciclovía, Muévete te mostrará los puntos seguros más cercanos. Encontrarás puntos de Salud, Estiramiento, Hidratación y Bienestar para que te sientas más seguro que nunca.";
    tutorialView3.bottomLine.text=@"Desliza a la izquierda para continuar";
    [scrollView addSubview:tutorialView3];
    
    
    //Página Cuatro
    UIButton *startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(0, 0, 220, 50);
    startButton.center=CGPointMake(scrollView.frame.size.width*3+scrollView.frame.size.width/2+20, scrollView.frame.size.height/2);
    [scrollView addSubview:startButton];
    [startButton setTitle:@"Empezar" forState:UIControlStateNormal];
    startButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:50];
    startButton.backgroundColor=[UIColor clearColor];
    [startButton setTitleColor:kRedColor forState:UIControlStateNormal];
    [startButton setTitleColor:kGreenColor forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *topContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topContainer.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
    [self.view addSubview:topContainer];
    
    UIImageView *topLogo=[[UIImageView alloc]initWithFrame:CGRectMake(190, 25, 180, 45)];
    topLogo.center=CGPointMake(topContainer.frame.size.width/2, topContainer.frame.size.height/2+10);
    [topContainer addSubview:topLogo];
    topLogo.image=[UIImage imageNamed:@"logocolpatria.png"];
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*4, self.view.frame.size.height)];
    [scrollView setPagingEnabled:YES];
    
    UIView *midBar1=[self midBar];
    midBar1.center=CGPointMake(scrollView.frame.size.width, scrollView.frame.size.height/2);
    [scrollView addSubview:midBar1];
    
    UIView *midBar2=[self midBar];
    midBar2.center=CGPointMake(scrollView.frame.size.width*2, scrollView.frame.size.height/2);
    [scrollView addSubview:midBar2];
    
    UIView *midBar3=[self midBar];
    midBar3.center=CGPointMake(scrollView.frame.size.width*3, scrollView.frame.size.height/2);
    [scrollView addSubview:midBar3];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(UIView*)midBar{
    UIView *bar=[[UIView alloc]init];
    bar.backgroundColor=kGreenColor;
    bar.frame=CGRectMake(0, 0, 100, 30);
    bar.layer.cornerRadius=15;
    UIImageView *back=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    back.image=[UIImage imageNamed:@"last.png"];
    back.center=CGPointMake(bar.frame.origin.x+15, bar.frame.size.height/2);
    [bar addSubview:back];
    
    UIImageView *next=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    next.image=[UIImage imageNamed:@"next.png"];
    next.center=CGPointMake(bar.frame.size.width-15, bar.frame.size.height/2);
    [bar addSubview:next];
    return bar;
}
-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollview{
     if (scrollview.contentOffset.x>1010) {
        [self dismissViewController];
    }
}
@end
