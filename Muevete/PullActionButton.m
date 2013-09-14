//
//  PullActionButton.m
//  Muevete
//
//  Created by Andres Abril on 3/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "PullActionButton.h"
#import <AudioToolbox/AudioToolbox.h>
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]

@implementation PullActionButton
@synthesize the_delegate,color,hilightColor,icon,label;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAlwaysBounceHorizontal:YES];
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setShowsHorizontalScrollIndicator:NO];
        button=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        button.layer.cornerRadius=frame.size.height/2;
        button.backgroundColor=kGreenColor;
        color=kGreenColor;
        hilightColor=kYellowColor;
        icon=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-40, 5, frame.size.height-10, frame.size.height-10)];
        icon.contentMode=UIViewContentModeScaleAspectFit;
        [icon setBackgroundColor:[UIColor clearColor]];
        [self addSubview:button];
        [button addSubview:icon];
        label=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-40-150, 1, 150, frame.size.height-10)];
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:30];
        label.textColor=[UIColor whiteColor];
        label.adjustsFontSizeToFitWidth=YES;
        [self addSubview:label];        
        
        self.delegate=self;
    }
    return self;
}
-(void)vibrate{
    [Vibration vibrate];
}
#pragma mark - scrollview delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x<-30.0) {
        [self.the_delegate actionAccepted:self.tag];
        [self vibrate];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        if (scrollView.contentOffset.x<-30) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.backgroundColor=hilightColor;
            }completion:^(BOOL finished){
            }];
        }
        else{
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.backgroundColor=color;
            }completion:^(BOOL finished){
            }];
        }
}
-(void)setColor:(UIColor *)theColor{
    color=theColor;
    button.backgroundColor=color;
}
#pragma mark -touches delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self vibrate];
}
@end
