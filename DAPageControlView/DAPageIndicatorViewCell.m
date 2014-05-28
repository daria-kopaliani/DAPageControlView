//
//  FCPageIndicatorView.m
//  FCPageControl
//
//  Created by Daria Kopaliani on 5/27/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import "DAPageIndicatorViewCell.h"


NSString *const DAPageIndicatorViewCellIdentifier = @"DAPageIndicatorViewCell";


@interface DAPageIndicatorViewCell()

@property (strong, nonatomic) UIButton *pageIndicatorButton;

@end


@implementation DAPageIndicatorViewCell

+ (instancetype)defaultCell
{
    return [[self alloc] initWithFrame:CGRectMake(0., 0., 12, 12)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageIndicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 7., 7.)];
        [self.pageIndicatorButton setBackgroundImage:[UIImage imageNamed:@"DAPageIndicator"] forState:UIControlStateNormal];
        [self.pageIndicatorButton setBackgroundImage:[UIImage imageNamed:@"DAPageIndicatorCurrent"] forState:UIControlStateSelected];
        self.pageIndicatorButton.center = CGPointMake(0.5 * CGRectGetWidth(frame), 0.5 * CGRectGetHeight(frame));
        self.pageIndicatorButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.pageIndicatorButton];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.pageIndicatorButton.transform = CGAffineTransformIdentity;
    self.alpha = 1.;
    [self.layer removeAllAnimations];
}

@end