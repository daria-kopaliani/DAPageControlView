//
//  DACollectionViewCell.m
//  DAPageControlViewDemo
//
//  Created by Daria Kopaliani on 5/29/14.
//  Copyright (c) 2014 FactorialComplexity. All rights reserved.
//

#import "DACollectionViewCell.h"


NSString *const DACollectionViewCellIdentifier = @"DACollectionViewCell";


@interface DACollectionViewCell ()

@property (strong, nonatomic) UILabel *label;

@end


@implementation DACollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:24];
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end
