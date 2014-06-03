//
//  DAMainViewController.m
//  DAPageControlViewDemo
//
//  Created by Daria Kopaliani on 5/29/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import "DAMainViewController.h"

#import "DACollectionViewCell.h"
#import "DAPageControlView.h"


@interface DAMainViewController () <DAPageControlViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DAPageControlView *pageControlView;
@property (assign, nonatomic) NSUInteger pagesCount;
@property (assign, nonatomic) BOOL loading;

@end


@implementation DAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.minimumInteritemSpacing = collectionViewLayout.minimumLineSpacing = 0.;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionViewLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [self.collectionView reloadData];
    
    self.pagesCount = 7;
    self.pageControlView = [[DAPageControlView alloc] initWithFrame:CGRectMake(40., 250., 240., 15.)];
    self.pageControlView.numberOfPages = self.pagesCount;
    self.pageControlView.currentPage = 0;
    self.pageControlView.delegate = self;
    [self.view addSubview:self.pageControlView];    
    
    self.loading = NO;
}

- (void)addMoreButtonPressed:(UIButton *)sender
{
    sender.enabled = NO;
    self.pageControlView.displaysLoadingMoreEffect = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pagesCount += 15;
        self.pageControlView.numberOfPages = self.pagesCount;
        [self.collectionView reloadData];
        sender.enabled = YES;
        self.pageControlView.displaysLoadingMoreEffect = NO;
    });
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pagesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DACollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg", indexPath.row % 16]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pagesCount - 3 && !self.pageControlView.displaysLoadingMoreEffect) {
        self.pageControlView.displaysLoadingMoreEffect = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pagesCount += 15;
            self.pageControlView.numberOfPages = self.pagesCount;
            [self.collectionView reloadData];
            self.pageControlView.displaysLoadingMoreEffect = NO;
        });
    }
}

#pragma mark - DAPageControlView Delegate

- (void)pageControlViewDidChangeCurrentPage:(DAPageControlView *)pageControlView
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageControlView.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.pageControlView updateForScrollViewContentOffset:self.collectionView.contentOffset.x pageSize:CGRectGetWidth(self.collectionView.frame)];
}

@end