//
//  JVFloatingDrawerView.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-11.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "JVFloatingDrawerView.h"

static const CGFloat kJVDefaultViewContainerWidth = 280.0;
static void *kTransformKVOContext = &kTransformKVOContext;

@interface JVFloatingDrawerView ()

@property (nonatomic, strong) NSLayoutConstraint *leftViewContainerWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightViewContainerWidthConstraint;
@property (nonatomic, strong) CALayer *shadowLayer;

@end

@implementation JVFloatingDrawerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - View Setup

- (void)setup
{
    [self setupBackgroundImageView];
    [self setupCenterViewContainer];
    [self setupLeftViewContainer];
    [self setupRightViewContainer];

    [self bringSubviewToFront:self.centerViewContainer];

    CALayer *shadowLayer = [CALayer layer];
    self.shadowLayer = shadowLayer;
    shadowLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    shadowLayer.opacity = 1.0;

    [self.centerViewContainer addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:kTransformKVOContext];
}

- (void)setupBackgroundImageView
{
    _backgroundImageView = [[UIImageView alloc] init];

    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.backgroundImageView];

    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0.0],
    ];

    [self addConstraints:constraints];
}

- (void)setupLeftViewContainer
{
    _leftViewContainer = [[UIView alloc] init];

    [self.leftViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.leftViewContainer];

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.leftViewContainer
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:kJVDefaultViewContainerWidth];
    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:self.leftViewContainer
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.leftViewContainer
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.leftViewContainer
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0],
        widthConstraint
    ];

    [self addConstraints:constraints];

    self.leftViewContainerWidthConstraint = widthConstraint;
}

- (void)setupRightViewContainer
{
    _rightViewContainer = [[UIView alloc] init];

    [self.rightViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.rightViewContainer];

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.rightViewContainer
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:kJVDefaultViewContainerWidth];
    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:self.rightViewContainer
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.rightViewContainer
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.rightViewContainer
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0],
        widthConstraint
    ];

    [self addConstraints:constraints];

    self.rightViewContainerWidthConstraint = widthConstraint;
}

- (void)setupCenterViewContainer
{
    _centerViewContainer = [[UIView alloc] init];

    [self.centerViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.centerViewContainer];

    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:self.centerViewContainer
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.centerViewContainer
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.centerViewContainer
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0],
        [NSLayoutConstraint constraintWithItem:self.centerViewContainer
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0.0],
    ];

    [self addConstraints:constraints];
}

#pragma mark - Reveal Widths

- (void)setLeftViewContainerWidth:(CGFloat)leftViewContainerWidth
{
    self.leftViewContainerWidthConstraint.constant = leftViewContainerWidth;
}

- (void)setRightViewContainerWidth:(CGFloat)rightViewContainerWidth
{
    self.rightViewContainerWidthConstraint.constant = rightViewContainerWidth;
}

- (CGFloat)leftViewContainerWidth
{
    return self.leftViewContainerWidthConstraint.constant;
}

- (CGFloat)rightViewContainerWidth
{
    return self.rightViewContainerWidthConstraint.constant;
}

-(void) setRadiusCenter: (BOOL)isRounded
{
    UIView *view = self.centerViewContainer.subviews.firstObject;
    if (isRounded) {
        view.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5.0;
    } else {
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 0.0;
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 0.0;
    }
}

-(void) setShadowCenter: (BOOL)isShow
{
    CALayer *layer = self.centerViewContainer.layer;
    if (isShow) {
        layer.shadowRadius  = 20.0;
        layer.shadowColor   = [UIColor blackColor].CGColor;
        layer.shadowOpacity = 0.4;
        layer.shadowOffset  = CGSizeMake(0.0, 0.0);
        layer.masksToBounds = false;
        
        [self updateShadowPath];
    } else {
        layer.shadowRadius  = 0.0;
        layer.shadowColor   = [UIColor clearColor].CGColor;
        layer.shadowOpacity = 0.0;
        layer.shadowOffset  = CGSizeMake(0.0, 0.0);
        layer.masksToBounds = true;
    }
}

-(void) updateShadowPath
{
    CALayer *layer = self.centerViewContainer.layer;
    CGFloat increase = layer.shadowRadius;
    CGRect rect = self.centerViewContainer.bounds;
    
    rect.origin.x -= increase;
    rect.origin.y -= increase;
    rect.size.width += increase * 2.0;
    rect.size.height += increase * 2.0;
    
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0].CGPath;
}

#pragma mark - Helpers

- (UIView *)viewContainerForDrawerSide:(JVFloatingDrawerSide)drawerSide
{
    UIView *viewContainer = nil;
    switch (drawerSide) {
        case JVFloatingDrawerSideLeft:
            viewContainer = self.leftViewContainer;
            break;
        case JVFloatingDrawerSideRight:
            viewContainer = self.rightViewContainer;
            break;
        case JVFloatingDrawerSideNone:
            viewContainer = nil;
            break;
    }
    return viewContainer;
}

#pragma mark - Open/Close Events

- (void)willOpenFloatingDrawerViewController:(JVFloatingDrawerViewController *)viewController
{
    [self setShadowCenter:YES];
    [self setRadiusCenter:YES];
    
    UIView *view = self.centerViewContainer.subviews.firstObject;
    view.userInteractionEnabled = NO;
    CALayer *layer = self.centerViewContainer.layer;
    self.shadowLayer.frame = layer.bounds;
//    [layer addSublayer:self.shadowLayer];
    
}

- (void)willCloseFloatingDrawerViewController:(JVFloatingDrawerViewController *)viewController
{
    [self setShadowCenter:NO];
    [self setRadiusCenter:NO];
    UIView *view = self.centerViewContainer.subviews.firstObject;
    view.userInteractionEnabled = YES;
//    [self.shadowLayer removeFromSuperlayer];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"transform"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
{
    if (context == kTransformKVOContext){
        CGAffineTransform value = [change[NSKeyValueChangeNewKey] CGAffineTransformValue];
        self.shadowLayer.opacity = value.tx / kJVDefaultViewContainerWidth;
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shadowLayer.frame = self.bounds;
}

@end
