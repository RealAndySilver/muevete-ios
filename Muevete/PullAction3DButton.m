//
//  PullAction3DButton.m
//  Muevete
//
//  Created by Andres Abril on 4/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "PullAction3DButton.h"

#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]

@implementation PullAction3DButton

@synthesize the_delegate,color,hilightColor,icon,isOn,mainImage,hilighted;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAlwaysBounceHorizontal:YES];
        [self setAlwaysBounceVertical:YES];
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setShowsHorizontalScrollIndicator:NO];
        button=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        button.layer.cornerRadius=frame.size.height/2;
        button.backgroundColor=kGreenColor;
        color=kGreenColor;
        hilightColor=kYellowColor;
        icon=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-40, 7, frame.size.width-0, frame.size.height-0-10)];
        icon.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        icon.contentMode=UIViewContentModeScaleAspectFit;
        [icon setBackgroundColor:[UIColor clearColor]];
        [self addSubview:button];
        [button addSubview:icon];
        isOn=NO;
        self.delegate=self;
    }
    return self;
}
#pragma mark - scrollview delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x<-30.0 || scrollView.contentOffset.y<-30 ||
        scrollView.contentOffset.x>30.0 || scrollView.contentOffset.y>30) {
        [self.the_delegate actionAccepted:self.tag];
        [self vibrate];
    }
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        button.backgroundColor=color;
    }completion:^(BOOL finished){
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isDragging]) {
    if (scrollView.contentOffset.x<-30.0 || scrollView.contentOffset.y<-30 ||
        scrollView.contentOffset.x>30.0 || scrollView.contentOffset.y>30) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            button.backgroundColor=hilightColor;
        }completion:^(BOOL finished){
        }];
        [self.the_delegate almostThere:self.tag];
    }
    else{
        
        [self.the_delegate actionCanceled:self.tag];
    }
    }
}
-(void)setColor:(UIColor *)theColor{
    color=theColor;
    button.backgroundColor=color;
}
-(void)setButtonState{
    isOn=isOn ? NO:YES;
    icon.image=isOn ? hilighted:mainImage;
    NSLog(@"State %i",(int)isOn);
}
#pragma mark -touches delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self vibrate];
}
-(void)vibrate{
    [Vibration vibrate];
}
@end
