//
//  UITextView+CMInputView.h
//  CMInputView
//
//  Created by CrabMan on 2019/4/28.
//  Copyright © 2019 CrabMan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (CMInputView)


@property (nonatomic,copy) NSString *cm_placeholder;

@property (nonatomic,copy) UIColor *cm_placeholderColor;

@property (nonatomic,strong) UIFont *cm_placeholderFont;

@property (nonatomic,assign) NSUInteger cm_maxNumberOfLines;

@property (nonatomic,assign) BOOL cm_autoLineBreak;


@end

@interface UIView (Corners)

@property (nonatomic, assign) UIRectCorner corners;

@end

@interface CALayer (Corners)

/// Know issue: before iOS 11, layer that has set conners did not update its bounds via auto layout.
@property (nonatomic, assign) UIRectCorner corners;

+ (void)noAnimation:(__attribute__((noescape)) void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
