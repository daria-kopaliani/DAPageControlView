//
//  DAPageControl.m
//  DAPageControl
//
//  Created by Daria Kopaliani on 5/27/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import "DAPageControlView.h"

#import "DAPageIndicatorViewCell.h"


static NSUInteger const FCMaximumIndicatorsCount = 21;
static CGFloat const FCMaximumIndicatorViewWidth = 14.;


@interface DAPageControlView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSUInteger _numberOfPages;
    NSUInteger _currentPage;
}

@property (strong, nonatomic) UICollectionView *indicatorsView;

@end


@implementation DAPageControlView


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// Defaults
        self.numberOfPagesAllowingPerspective = 3;
        
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionViewLayout.minimumInteritemSpacing = collectionViewLayout.minimumLineSpacing = 0.;
        self.indicatorsView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
        [self.indicatorsView registerClass:[DAPageIndicatorViewCell class] forCellWithReuseIdentifier:DAPageIndicatorViewCellIdentifier];
        self.indicatorsView.backgroundColor = [UIColor clearColor];
        self.indicatorsView.showsHorizontalScrollIndicator = NO;
        self.indicatorsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.indicatorsView.dataSource = self;
        self.indicatorsView.delegate = self;
        self.indicatorsView.scrollEnabled = NO;
        self.indicatorsView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.indicatorsView];
        
        [self.indicatorsView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
        self.currentPage = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [self.indicatorsView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - Public

- (void)updateForScrollViewContentOffset:(CGFloat)contentOffset pageSize:(CGFloat)pageSize
{
    CGFloat currentIndex = contentOffset / pageSize;
    self.currentPage = roundf(currentIndex);
    
    CGFloat x = self.indicatorsView.contentSize.width * (currentIndex - floorf(0.5 * CGRectGetWidth(self.indicatorsView.frame) / [self indicatorViewWidth])) / self.numberOfPages;
    x = MIN((self.indicatorsView.contentSize.width - CGRectGetWidth(self.indicatorsView.frame)), MAX(0, x));
    self.indicatorsView.contentOffset = CGPointMake(x, 0.);
}

#pragma mark - Convenience Methods

- (void)adjustIndicatorsViewFrame
{
    CGFloat width = MIN(self.numberOfPages, [self maximumIndicatorsCount]) * [self indicatorViewWidth];
    self.indicatorsView.frame = CGRectMake(0.5 * (CGRectGetWidth(self.frame) - width), 0., width, CGRectGetHeight(self.frame));
}

- (void)adjustIndicatorsScale
{
    CGFloat width = MIN(self.numberOfPages, [self maximumIndicatorsCount]) * [self indicatorViewWidth];
    self.indicatorsView.frame = CGRectMake(0.5 * (CGRectGetWidth(self.frame) - width), 0., width, CGRectGetHeight(self.frame));
    CGFloat offset = self.indicatorsView.contentOffset.x;
    for (DAPageIndicatorViewCell *aCell in self.indicatorsView.visibleCells) {
        if (CGRectGetMinX(aCell.frame) < offset + self.numberOfPagesAllowingPerspective * [self indicatorViewWidth]) {
            if (offset == 0) {
                [UIView animateWithDuration:0.3 delay:0. options:0 animations:^{
                    aCell.pageIndicatorView.transform = CGAffineTransformIdentity;
                } completion:nil];
            } else {
                CGFloat scale = [self scaleForIndicatorAtIndex:aCell.tag];
                aCell.pageIndicatorView.transform = CGAffineTransformMakeScale(scale, scale);
            }
        } else if (CGRectGetMaxX(aCell.frame) > offset + CGRectGetWidth(self.indicatorsView.frame) - (self.numberOfPagesAllowingPerspective * [self indicatorViewWidth])) {
            if (offset + CGRectGetWidth(self.indicatorsView.frame) == self.indicatorsView.contentSize.width) {
                [UIView animateWithDuration:0.3 delay:0. options:0 animations:^{
                    aCell.pageIndicatorView.transform = CGAffineTransformIdentity;
                } completion:nil];
            } else {
                CGFloat scale = [self scaleForIndicatorAtIndex:aCell.tag];
                aCell.pageIndicatorView.transform = CGAffineTransformMakeScale(scale, scale);
            }
        } else {
            aCell.pageIndicatorView.transform = CGAffineTransformIdentity;
        }
    }
}

- (CGFloat)indicatorViewWidth
{
    return FCMaximumIndicatorViewWidth;
}

- (CGFloat)scaleForIndicatorAtIndex:(NSUInteger)index
{
    CGFloat scale = 1.;
    CGFloat offset = self.indicatorsView.contentOffset.x;
    if (index * [self indicatorViewWidth] < offset + self.numberOfPagesAllowingPerspective * [self indicatorViewWidth]) {
        if (offset > 0) {
            CGFloat delta = index * [self indicatorViewWidth] - (offset + self.numberOfPagesAllowingPerspective * [self indicatorViewWidth]);
            scale = 1 - 0.6 * (fabsf(delta)) / (self.numberOfPagesAllowingPerspective * [self indicatorViewWidth]);
        }
    } else {
        if ((index + 1) * [self indicatorViewWidth] > offset + CGRectGetWidth(self.indicatorsView.frame) - (self.numberOfPagesAllowingPerspective * [self indicatorViewWidth])) {
            if (offset + CGRectGetWidth(self.indicatorsView.frame) < self.indicatorsView.contentSize.width) {
                CGFloat delta = (offset + CGRectGetWidth(self.indicatorsView.frame) - (self.numberOfPagesAllowingPerspective * [self indicatorViewWidth])) - (index + 1) * [self indicatorViewWidth];
                scale = 1 - 0.6 * (fabsf(delta)) / (self.numberOfPagesAllowingPerspective * [self indicatorViewWidth]);
            }
        }
    }
    
    return scale;
}

- (NSUInteger)maximumIndicatorsCount
{
    NSUInteger count = floorf(CGRectGetWidth(self.frame) / (CGFloat)[self indicatorViewWidth]);
    
    return MIN(count, FCMaximumIndicatorsCount);
}

- (DAPageIndicatorViewCell *)visibleCellForIndex:(NSUInteger)index
{
    DAPageIndicatorViewCell *cell = nil;
    for (DAPageIndicatorViewCell *aCell in self.indicatorsView.visibleCells) {
        if (aCell.tag == index) {
            cell = aCell;
            break;
        }
    }
    
    return cell;
}

#pragma mark - Overwritten Setters

- (void)setCurrentPage:(NSUInteger)currentPage
{
    if (_currentPage != currentPage && currentPage < self.numberOfPages) {
        _currentPage = currentPage;
    }
    [self.indicatorsView.visibleCells enumerateObjectsUsingBlock:^(DAPageIndicatorViewCell *cell, NSUInteger idx, BOOL *stop) {
        cell.pageIndicatorView.selected = (cell.tag == currentPage);
    }];
}

- (void)setDisplaysLoadingMoreEffect:(BOOL)displaysLoadingMoreEffect
{
    if (_displaysLoadingMoreEffect != displaysLoadingMoreEffect) {
        _displaysLoadingMoreEffect = displaysLoadingMoreEffect;
        DAPageIndicatorViewCell *cell = [self visibleCellForIndex:self.numberOfPages - 1];
        if (displaysLoadingMoreEffect) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.alpha = 0.5;
            } completion:nil];
        } else {
            cell.alpha = 1.;
            [cell.layer removeAllAnimations];
        }
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    if (_hidesForSinglePage != hidesForSinglePage) {
        _hidesForSinglePage = hidesForSinglePage;
        self.indicatorsView.hidden = (self.numberOfPages <= 1);
    }
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages
{
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        [self adjustIndicatorsViewFrame];
        [self.indicatorsView reloadData];
        
        if (numberOfPages > self.currentPage) {
            [self.indicatorsView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        } else {
            _currentPage = numberOfPages - 1;
        }
        
        self.indicatorsView.hidden = (self.numberOfPages <= 1);
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self adjustIndicatorsScale];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DAPageIndicatorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DAPageIndicatorViewCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.pageIndicatorView.selected = (indexPath.row == self.currentPage);
    CGFloat scale = [self scaleForIndicatorAtIndex:indexPath.row];
    cell.pageIndicatorView.transform = CGAffineTransformMakeScale(scale, scale);
    if (indexPath.row == self.numberOfPages - 1) {
        if (self.displaysLoadingMoreEffect) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.alpha = 0.5;
            } completion:nil];
        } else {
            cell.alpha = 1.;
            [cell.layer removeAllAnimations];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentPage:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(pageControlViewDidChangeCurrentPage:)]) {
        [self.delegate pageControlViewDidChangeCurrentPage:self];
    }
}

#pragma mark - UICollectionView Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self indicatorViewWidth], CGRectGetHeight(self.frame));
}

@end