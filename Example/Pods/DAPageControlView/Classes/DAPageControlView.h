//
//  DAPageControl.h
//  DAPageControl
//
//  Created by Daria Kopaliani on 5/27/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DAPageControlView;

@protocol DAPageControlViewDelegate <NSObject>

@optional
- (void)pageControlViewDidChangeCurrentPage:(DAPageControlView *)pageControlView;

@end


@interface DAPageControlView : UIView

@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) BOOL displaysLoadingMoreEffect;
@property (assign, nonatomic) BOOL hidesForSinglePage;
@property (assign, nonatomic) NSUInteger numberOfPages;
@property (assign, nonatomic) NSUInteger numberOfPagesAllowingPerspective;

@property (weak, nonatomic) id<DAPageControlViewDelegate> delegate;

- (void)updateForScrollViewContentOffset:(CGFloat)contentOffset pageSize:(CGFloat)pageSize;

@end