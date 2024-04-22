//
//  ZBInputAnimationView.h
//  ZBInputAnimationView
//
//  Created by ZB on 2024/4/22.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#define WS __typeof__(self) __weak ws = self;
//#define WS(ws) __weak typeof(self) ws = self

#define ColorFromHex(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


NS_ASSUME_NONNULL_BEGIN

typedef void (^inputChangeBlock) (NSString* text);

@interface ZBInputAnimationView : UIView

/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 输入
@property (nonatomic, strong) UITextField *inputTextF;
/// 最多可输入长度
@property (nonatomic ,assign) NSInteger maxLength;

/// 开始输入
@property (nonatomic, copy) void (^beginInputCallback)(NSString* text);
/// 输入变化
@property (nonatomic, copy) void (^inputChangeCallback)(NSString* text);
/// 结束输入
@property (nonatomic, copy) void (^inputEndEditBlock)(NSString *text);

- (instancetype)initWithPlaceString:(NSString *)string title:(NSString *)title;
/// 动画向上，此时是选中的状态
- (void)startInputAnimation:(BOOL)animation;
/// 动画复原
- (void)endInputAnimation:(BOOL)animation;
/// 复原
- (void)resetAnimation;

@end

NS_ASSUME_NONNULL_END
