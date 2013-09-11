//
//  StartController.h
//  Muevete
//
//  Created by Andres Abril on 31/08/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBAlertView.h"
#import "MBHUDView.h"
#import "Vibration.h"
@protocol StartControllerDelegate
@required
-(void)trackDidStart;
-(void)trackDidStop:(NSMutableDictionary*)result;
@optional
-(void)saveTrack:(NSMutableDictionary*)result;
@end
@interface StartController : UIView<UIScrollViewDelegate>{
    UIView *leftBar;
    UIView *mainBar;
    
    UIView *container;
    
    UIView *topContainer;
    UIView *middleContainer;
    UIView *bottomContainer;
    
    UILabel *speedLabel;

    UIView *altitudeContainer;
    UILabel *altitudeLabel;
    UIScrollView *scrollContainer;
    
    UIButton *leftBarActionButton;
    UILabel *mainBarStateLabel;
    UILabel *kmLabel;
    UILabel *timeLabel;
    UILabel *separatorLabel;
    UILabel *nearSpotLabel;
    
    NSString *nearSpotText;
    
    NSMutableArray *points;
    int seconds;
    int minutes;
    int hours;
    int globalSeconds;
    double meters;
    NSTimer *timer;
    MBAlertView *alertInicio;
    
    BOOL flag;
    UIColor *lastColor;
    NSString *lastText;

}
@property(nonatomic,retain)id <StartControllerDelegate> delegate;
-(void)setPoint:(NSNumber*)point;
-(void)saveCallback:(BOOL)success;
-(void)setNearSpotTextWithDictionary:(NSDictionary*)dictionary;
-(void)setAltitude:(double)altitude;
-(void)setSpeed:(double)speed;
-(void)lockChanged;
-(void)manualLock:(BOOL)lock;
@end
