//
//  PullAction3DButton.h
//  Muevete
//
//  Created by Andres Abril on 4/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Vibration.h"
@protocol PullAction3DButtonDelegate
@required
-(void)actionAccepted:(int)tag;
-(void)actionCanceled:(int)tag;
-(void)almostThere:(int)tag;
@end
@interface PullAction3DButton : UIScrollView<UIScrollViewDelegate>{
    UIView *button;
}
@property(nonatomic)UIColor *color;
@property(nonatomic)UIColor *hilightColor;
@property(nonatomic)UIImageView *icon;
@property(nonatomic)UIImage *mainImage;
@property(nonatomic)UIImage *hilighted;

@property(nonatomic)BOOL isOn;

@property(nonatomic,retain)id<PullAction3DButtonDelegate>the_delegate;
-(void)setButtonState;
@end