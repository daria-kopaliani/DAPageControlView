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


@interface DAMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DAPageControlView *pageControlView;
@property (assign, nonatomic) NSUInteger pagesCount;

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
    [self.collectionView registerClass:[DACollectionViewCell class] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [self.collectionView reloadData];
    
    self.pagesCount = 10;
    self.pageControlView = [[DAPageControlView alloc] initWithFrame:CGRectMake(20., CGRectGetHeight(self.view.bounds) - 100., CGRectGetWidth(self.view.bounds) - 40., 15.)];
    self.pageControlView.numberOfPages = self.pagesCount;
    self.pageControlView.currentPage = 0;
    self.pageControlView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageControlView];
    
    
    UIButton *add5MoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 100, CGRectGetWidth(self.view.frame), 50)];
    [add5MoreButton setTitle:@"Load 5 More" forState:UIControlStateNormal];
    [add5MoreButton setTitle:@"Loading..." forState:UIControlStateDisabled];
    [add5MoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add5MoreButton addTarget:self action:@selector(addMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add5MoreButton];
}

- (void)addMoreButtonPressed:(UIButton *)sender
{
    sender.enabled = NO;
    self.pageControlView.displaysLoadingMoreEffect = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pagesCount += 5;
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
    cell.backgroundColor = [self colorForIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)indexPath.row];
    
    return cell;
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath
{
    srandom((unsigned int)indexPath.row);
    CGFloat red = (random() % 256) / 256.;
    CGFloat green = (random() % 256) / 256.;
    CGFloat blue = (random() % 256) / 256.;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.pageControlView updateForScrollViewContentOffset:self.collectionView.contentOffset.x pageSize:CGRectGetWidth(self.collectionView.frame)];
}

@end