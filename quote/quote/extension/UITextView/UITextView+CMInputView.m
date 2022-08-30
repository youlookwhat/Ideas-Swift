//
//  UITextView+CMInputView.m
//  CMInputView
//
//  Created by CrabMan on 2019/4/28.
//  Copyright © 2019 CrabMan. All rights reserved.
//

#import "UITextView+CMInputView.h"
#import <objc/runtime.h>
@interface UITextView ()


@property (nonatomic,strong) UITextView *placeHolderTextView;


@property (nonatomic,assign) CGFloat originalHeight;



@end

@implementation UITextView (CMInputView)

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),class_getInstanceMethod(self.class,@selector(exchanged_dealloc)));
    
}


- (void)exchanged_dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeHolderTextView));
    if (textView) {
        for (NSString *key in self.class.observedKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                
            }
        }
    }
    [self exchanged_dealloc];
    
}


+ (NSArray *)observedKeys {
    return @[@"attributedText",@"bounds",@"font",@"frame",@"text",@"textAlignment",@"textContainerInset",@"textContainer.exclusionPaths"];
}

- (CGFloat)originalHeight {
    
    static CGFloat originalHeight;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self.superview layoutIfNeeded];
        originalHeight = self.bounds.size.height;
    });
    
    return originalHeight;
    
}

- (NSString *)cm_placeholder {
    
    return objc_getAssociatedObject(self, @selector(cm_placeholder));
    
}


- (void)setCm_placeholder:(NSString *)cm_placeholder {
    
    objc_setAssociatedObject(self, @selector(cm_placeholder), cm_placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self placeHolderTextView];
    
}


- (UIColor *)cm_placeholderColor {
    
    return objc_getAssociatedObject(self, @selector(cm_placeholderColor));
    
}


- (void)setCm_placeholderColor:(UIColor *)cm_placeholderColor {
    
    objc_setAssociatedObject(self, @selector(cm_placeholderColor), cm_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self textViewValueChanged];
    
}

- (UIFont *)cm_placeholderFont {
    
    
    return objc_getAssociatedObject(self, @selector(cm_placeholderFont));
    
}

- (void)setCm_placeholderFont:(UIFont *)cm_placeholderFont {
    
    
    objc_setAssociatedObject(self, @selector(cm_placeholderFont), cm_placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self textViewValueChanged];
    
}


- (NSUInteger)cm_maxNumberOfLines {
    return [objc_getAssociatedObject(self, @selector(cm_maxNumberOfLines)) integerValue];
    
}

- (void)setCm_maxNumberOfLines:(NSUInteger)cm_maxNumberOfLines {
    
    objc_setAssociatedObject(self, @selector(cm_maxNumberOfLines), @(cm_maxNumberOfLines), OBJC_ASSOCIATION_ASSIGN);
    [self textViewValueChanged];
    
}

- (BOOL)cm_autoLineBreak {
    
    return [objc_getAssociatedObject(self, @selector(cm_autoLineBreak)) boolValue];
    
}

- (void)setCm_autoLineBreak:(BOOL)cm_autoLineBreak {
    
    objc_setAssociatedObject(self, @selector(cm_autoLineBreak), @(cm_autoLineBreak), OBJC_ASSOCIATION_ASSIGN);
    [self textViewValueChanged];
    
}

- (UITextView *)placeHolderTextView {
    
    UITextView *placeHolderTextView = objc_getAssociatedObject(self, @selector(placeHolderTextView));
    
    if (!placeHolderTextView) {
        self.text = @"";
        placeHolderTextView = [UITextView new];
        placeHolderTextView.userInteractionEnabled = NO;
        placeHolderTextView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        objc_setAssociatedObject(self, @selector(placeHolderTextView), placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self insertSubview:placeHolderTextView atIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged) name:UITextViewTextDidChangeNotification object:self];
        
        for (NSString *key in self.class.observedKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        }
        
        [self textViewValueChanged];
        
    }
    
    
    
    return placeHolderTextView;
    
}


- (void)updateHight {
    
    self.placeHolderTextView.hidden = self.text.length;
    
    CGFloat maxHeight =  ceil(self.font.lineHeight * self.cm_maxNumberOfLines +  self.textContainerInset.top + self.textContainerInset.bottom);
    CGFloat height = self.text.length ? ceil([self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height) : self.originalHeight;
    
    self.scrollEnabled = !self.cm_autoLineBreak;
    
    if (self.cm_autoLineBreak && !self.cm_maxNumberOfLines && height > self.originalHeight) {
        CGRect newFrame = self.frame;
        
        newFrame.size.height = height;
        
        self.frame = newFrame;
        
    }
    
    self.scrollEnabled = height > maxHeight && self.cm_maxNumberOfLines;
    if (maxHeight >= height && height >= self.originalHeight) {
        
        CGRect newFrame = self.frame;
        
        newFrame.size.height = height;
        
        self.frame = newFrame;
        
    } else if (height > maxHeight) {
        CGRect newFrame = self.frame;
        
        newFrame.size.height = maxHeight;
        
        self.frame = newFrame;
    }
    
}


- (void)textViewValueChanged {
    
    
    self.placeHolderTextView.hidden = self.text.length;
    
    if(!self.text.length) {
        
        
        self.placeHolderTextView.text = self.cm_placeholder;
        self.placeHolderTextView.textColor = self.cm_placeholderColor ?: [UIColor lightGrayColor];
        self.placeHolderTextView.font = self.cm_placeholderFont?:self.font;
        
        self.placeHolderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
        
        self.placeHolderTextView.textAlignment = self.textAlignment;
//        self.placeHolderTextView.frame = CGRectMake(5, 0, kScreenWidth - 40, 44);
        self.placeHolderTextView.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 40, 44);
    }
    
    [self updateHight];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object != self.placeHolderTextView && [keyPath isEqualToString:@"text"]) {
        [self updateHight];
    }
    
}


@end

char *kMaskedCorners;

@implementation UIView (Corners)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        
    } else {
        // 处理ios 11 以下
//        [UIView bp_swizzlingInstanceMethod:@selector(setFrame:) withMethod:@selector(bp_setFrame:)];
    }
}

/// iOS 10 以下, UIView 的 frame 变动后, 需要重新设置 corners
/// 2022-05-25
- (void)bp_setFrame:(CGRect)frame API_DEPRECATED("iOS 10 Only", macosx(10.4,10.12), ios(2.0,11.0), watchos(2.0,3.0), tvos(9.0,10.0)) {
    [self bp_setFrame:frame];
    self.layer.corners = self.layer.corners;
}

- (void)setCorners:(UIRectCorner)corners {
    self.layer.corners = corners;
}

- (UIRectCorner)corners {
    return self.layer.corners;
}

@end

@implementation CALayer (Corners)

- (void)setCorners:(UIRectCorner)corners {
    objc_setAssociatedObject(self, &kMaskedCorners, @(corners), OBJC_ASSOCIATION_COPY_NONATOMIC);
    CGFloat cornerRadius = self.cornerRadius > 0.0 ? self.cornerRadius : CGRectGetHeight(self.frame) / 2.0f;
    if (@available(iOS 11.0, *)) {
    
        CACornerMask maskedCorners = 0U;

        if ((corners & UIRectCornerTopLeft) == UIRectCornerTopLeft) {
            maskedCorners |= kCALayerMinXMinYCorner;
        }

        if ((corners & UIRectCornerTopRight) == UIRectCornerTopRight) {
            maskedCorners |= kCALayerMaxXMinYCorner;
        }

        if ((corners & UIRectCornerBottomLeft) == UIRectCornerBottomLeft) {
            maskedCorners |= kCALayerMinXMaxYCorner;
        }

        if ((corners & UIRectCornerBottomRight) == UIRectCornerBottomRight) {
            maskedCorners |= kCALayerMaxXMaxYCorner;
        }
        // 按钮圆角
        self.cornerRadius = cornerRadius;
        self.maskedCorners = maskedCorners;
        self.masksToBounds = true;
    } else {
        // 按钮圆角
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                           byRoundingCorners:corners
                                                 cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
        self.mask = layer;
        self.cornerRadius = 0;
        self.needsDisplayOnBoundsChange = true;
    }
}

- (UIRectCorner)corners {
    return [objc_getAssociatedObject(self, &kMaskedCorners) unsignedIntegerValue];
}

+ (void)noAnimation:(__attribute__((noescape)) void(^)(void))block; {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (block) {
        block();
    }
    [CATransaction commit];
}

@end
