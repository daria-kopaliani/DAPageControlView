//
//  FCPageIndicatorView.h
//  FCPageControl
//
//  Created by Daria Kopaliani on 5/27/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const DAPageIndicatorViewCellIdentifier;


@interface DAPageIndicatorViewCell : UICollectionViewCell

@property (readonly, strong, nonatomic) UIButton *pageIndicatorView;

+ (instancetype)defaultCell;

@end
