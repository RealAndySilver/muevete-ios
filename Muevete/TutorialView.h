//
//  TutorialView.h
//  Muevete
//
//  Created by Andres Abril on 12/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface TutorialView : UIView{
}
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UILabel *superTitleLabel;
@property (nonatomic,retain)UITextView *textView;
@property (nonatomic,retain)UIImageView *mainImageView;
@property (nonatomic,retain)UIImageView *topLogo;
@property (nonatomic,retain)UIImageView *bottomImageView;
@property (nonatomic,retain)UILabel *bottomLine;

@end
