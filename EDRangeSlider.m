//
//  EDRangeSlider.m
//  Hunted
//
//  Created by Edward Anthony on 2/12/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "EDRangeSlider.h"

#define kHandleViewDiameter 23.5f

@interface EDRangeSlider ()
{
    CGFloat _distanceFromCenter;

    CGFloat _minHandleViewActive;
    CGFloat _maxHandleViewActive;
}

@property (nonatomic, strong) UIImageView *trackView;
@property (nonatomic, strong) UIImageView *trackHighlightView;
@property (nonatomic, strong) UIImageView *minHandleView;
@property (nonatomic, strong) UIImageView *maxHandleView;
    
@end

@implementation EDRangeSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trackView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"slider-bar-bg"]
                                                         resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 5.0f, 1.0f, 5.0f)]];
        _trackView.center = self.center;
        _trackView.userInteractionEnabled = NO;
        
        _trackHighlightView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"slider-bar-bg-highlighted"]
                                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 5.0f,
                                                                                                               1.0f, 5.0f)]];
        _trackHighlightView.center = self.center;
        _trackHighlightView.userInteractionEnabled = NO;
        
        // Min handle
        _minHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider-handle-bg"]];
        _minHandleView.contentMode = UIViewContentModeCenter;
        _minHandleView.backgroundColor = [UIColor clearColor];
        
        // Max handle
        _maxHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider-handle-bg"]];
        _maxHandleView.contentMode = UIViewContentModeCenter;
        _maxHandleView.backgroundColor = [UIColor clearColor];
        
        // Min label
        _minimumLabel = [[UILabel alloc] init];
        _minimumLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
        _minimumLabel.textColor = [UIColor blackColor];
        _minimumLabel.textAlignment = NSTextAlignmentLeft;
        _minimumLabel.numberOfLines = 1;
        
        // Max label
        _maximumLabel = [[UILabel alloc] init];
        _maximumLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
        _maximumLabel.textColor = [UIColor blackColor];
        _maximumLabel.textAlignment = NSTextAlignmentRight;
        _maximumLabel.numberOfLines = 1;
        
        [self firstLayout];
        
        [self addSubview:_trackView];
        [self addSubview:_trackHighlightView];
        [self addSubview:_minHandleView];
        [self addSubview:_maxHandleView];
        [self addSubview:_minimumLabel];
        [self addSubview:_maximumLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.trackView.frame = CGRectMake(0, 6.5f, CGRectGetWidth(self.frame), 10.5f);
    self.minimumLabel.frame = CGRectMake(0, kHandleViewDiameter + 2.0f, CGRectGetWidth(self.frame) / 2,
                                         [self.minimumLabel sizeThatFits:CGSizeZero].height);
    self.maximumLabel.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, kHandleViewDiameter + 2.0f,
                                         CGRectGetWidth(self.frame) / 2, [self.maximumLabel sizeThatFits:CGSizeZero].height);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self firstLayout];
}

- (void)firstLayout
{
    self.minHandleView.frame = CGRectMake(0, 0, kHandleViewDiameter, kHandleViewDiameter);
    self.maxHandleView.frame = CGRectMake(CGRectGetWidth(self.frame) - kHandleViewDiameter, 0, kHandleViewDiameter, kHandleViewDiameter);
    
    [self layoutHighlightView];
}

- (void)layoutHighlightView
{
    self.trackHighlightView.frame = CGRectMake(CGRectGetMinX(self.minHandleView.frame), 6.5f,
                                               CGRectGetMaxX(self.maxHandleView.frame) - CGRectGetMinX(self.minHandleView.frame), 10.5f);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.minimumLabel.text.length > 0 || self.maximumLabel.text.length > 0) {
        size.height = MAX(CGRectGetMaxY(self.minimumLabel.frame), CGRectGetMaxY(self.maximumLabel.frame));
    } else {
        size.height = kHandleViewDiameter;
    }
    size.width = CGRectGetWidth(self.frame);
    return size;
}


#pragma mark - Tracking event

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.minHandleView.frame, touchPoint)) {
        _minHandleViewActive = YES;
        _distanceFromCenter = touchPoint.x - self.minHandleView.center.x;
    } else if (CGRectContainsPoint(self.maxHandleView.frame, touchPoint)) {
        _maxHandleViewActive = YES;
        _distanceFromCenter = touchPoint.x - self.maxHandleView.center.x;
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!_minHandleViewActive && !_maxHandleViewActive) {
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat noOutboundOriginX = MAX(MIN(touchPoint.x - _distanceFromCenter, CGRectGetWidth(self.frame) - kHandleViewDiameter / 2), kHandleViewDiameter / 2);
    
    if (_minHandleViewActive) {
        CGFloat noCollideOriginX = MIN(noOutboundOriginX, CGRectGetMinX(self.maxHandleView.frame) - kHandleViewDiameter);
        self.minHandleView.center = CGPointMake(noCollideOriginX, self.minHandleView.center.y);
        [self layoutHighlightView];
    } else if (_maxHandleViewActive ) {
        CGFloat noCollideOriginX = MAX(noOutboundOriginX, CGRectGetMaxX(self.minHandleView.frame) + kHandleViewDiameter);
        self.maxHandleView.center = CGPointMake(noCollideOriginX, self.maxHandleView.center.y);
        [self layoutHighlightView];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _minHandleViewActive = NO;
    _maxHandleViewActive = NO;
}

@end
