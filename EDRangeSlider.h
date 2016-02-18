//
//  EDRangeSlider.h
//  Hunted
//
//  Created by Edward Anthony on 2/12/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDRangeSlider : UIControl

@property(nonatomic, assign) CGFloat minimumValue;
@property(nonatomic, assign) CGFloat maximumValue;
@property(nonatomic, assign) CGFloat minimumRange;

@property (nonatomic, assign) CGFloat selectedMinimumValue;
@property (nonatomic, assign) CGFloat selectedMaximumValue;

@property (nonatomic, strong) UILabel *minimumLabel;
@property (nonatomic, strong) UILabel *maximumLabel;

@end
