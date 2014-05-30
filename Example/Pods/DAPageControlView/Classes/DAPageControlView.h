//
//  DAPageControl.h
//  DAPageControl
//
//  Created by Daria Kopaliani on 5/27/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPageControlView : UIView

@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) BOOL displaysLoadingMoreEffect;
@property (assign, nonatomic) BOOL hidesForSinglePage;
@property (assign, nonatomic) NSUInteger numberOfPages;
@property (assign, nonatomic) NSUInteger numberOfPagesAllowingPerspective;

- (void)updateForScrollViewContentOffset:(CGFloat)contentOffset pageSize:(CGFloat)pageSize;

@end