//
//  FCPageIndicatorView.m
//  FCPageControl
//
//  Created by Daria Kopaliani on 5/27/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import "DAPageIndicatorViewCell.h"


NSString *const DAPageIndicatorViewCellIdentifier = @"DAPageIndicatorViewCell";
CGFloat const DAPageIndicatorViewWidth = 7.;
CGFloat const DAPageIndicatorViewHeight = DAPageIndicatorViewWidth;


@interface DAPageIndicatorViewCell()

@property (strong, nonatomic) UIButton *pageIndicatorView;

@end


@implementation DAPageIndicatorViewCell

+ (instancetype)defaultCell
{
    return [[self alloc] initWithFrame:CGRectMake(0., 0., DAPageIndicatorViewWidth, DAPageIndicatorViewHeight)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageIndicatorView = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., DAPageIndicatorViewWidth, DAPageIndicatorViewHeight)];
        [self.pageIndicatorView setBackgroundImage:[UIImage imageNamed:@"DAPageIndicator"] forState:UIControlStateNormal];
        [self.pageIndicatorView setBackgroundImage:[UIImage imageNamed:@"DAPageIndicatorCurrent"] forState:UIControlStateSelected];
        self.pageIndicatorView.center = CGPointMake(0.5 * CGRectGetWidth(frame), 0.5 * CGRectGetHeight(frame));
        self.pageIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.pageIndicatorView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.pageIndicatorView];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.pageIndicatorView.transform = CGAffineTransformIdentity;
    self.alpha = 1.;
    [self.layer removeAllAnimations];
}

@end