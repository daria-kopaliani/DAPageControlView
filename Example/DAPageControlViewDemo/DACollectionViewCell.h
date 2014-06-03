//
//  DACollectionViewCell.h
//  DAPageControlViewDemo
//
//  Created by Daria Kopaliani on 5/29/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const DACollectionViewCellIdentifier;


@interface DACollectionViewCell : UICollectionViewCell

@property (readonly, strong, nonatomic) IBOutlet UIImageView *itemImageView;

@end
