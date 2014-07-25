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
        
        // default
        UIImage* normalImage = [self imageByDrawingCircleWithColor:[UIColor lightGrayColor] withSize:self.pageIndicatorView.bounds.size];
        UIImage* selectImage = [self imageByDrawingCircleWithColor:[UIColor whiteColor] withSize:self.pageIndicatorView.bounds.size];
        [self.pageIndicatorView setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self.pageIndicatorView setBackgroundImage:selectImage forState:UIControlStateSelected];
        
//        [self.pageIndicatorView setBackgroundImage:[UIImage imageNamed:@"DAPageIndicator"] forState:UIControlStateNormal];
//        [self.pageIndicatorView setBackgroundImage:[UIImage imageNamed:@"DAPageIndicatorCurrent"] forState:UIControlStateSelected];

        self.pageIndicatorView.center = CGPointMake(0.5 * CGRectGetWidth(frame), 0.5 * CGRectGetHeight(frame));
        self.pageIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.pageIndicatorView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.pageIndicatorView];
    }
    
    return self;
}

-(void)setNormalColor:(UIColor *)normalColor {
    
    if ( _normalColor != normalColor )
    {
        UIImage* normalImage = [self imageByDrawingCircleWithColor:normalColor withSize:self.pageIndicatorView.bounds.size];
        [self.pageIndicatorView setBackgroundImage:normalImage forState:UIControlStateNormal];
        _normalColor = normalColor;
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor {
    
    if ( _selectedColor != selectedColor ) {
        UIImage* selectImage = [self imageByDrawingCircleWithColor:selectedColor withSize:self.pageIndicatorView.bounds.size];
        [self.pageIndicatorView setBackgroundImage:selectImage forState:UIControlStateSelected];
        _selectedColor = selectedColor;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.pageIndicatorView.transform = CGAffineTransformIdentity;
    self.alpha = 1.;
    [self.layer removeAllAnimations];
}

-(UIImage *)imageByDrawingCircleWithColor:(UIColor *)color withSize:(CGSize)size {
    
    UIImage* img = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextRestoreGState(ctx);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end