//
//  ZBInputAnimationView.m
//  ZBInputAnimationView
//
//  Created by ZB on 2024/4/22.
//

#import "ZBInputAnimationView.h"

@interface ZBInputAnimationView()

@property (nonatomic, copy) NSString *hoderTitle;
@property (nonatomic, copy) NSString *anititle;
@property (nonatomic, strong) UIView *line;

@end


@implementation ZBInputAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.maxLength = 255;
        [self creatUI];
    }
    return self;
}

- (instancetype)initWithPlaceString:(NSString *)string title:(NSString *)anititle{
    self.hoderTitle = string;
    self.anititle = anititle;
    return  [self init];
}

- (void)creatUI{
    WS
    //账号
    [self addSubview:self.titleLab];
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(20);
//        make.centerY.offset(0);
//        make.width.mas_equalTo(180);
//        make.height.mas_equalTo(20);
//    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       ws.titleLab.layer.anchorPoint = CGPointMake(0, 0);
       ws.titleLab.frame = CGRectMake(30, (60-20)/2.0 + 9, 260, 20);
//    });
    
    //账号输入
    [self addSubview:self.inputTextF];
    [self.inputTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.offset(-30);
        make.height.equalTo(@(40));
        make.bottom.offset(0);
    }];
    
    //line1
    _line = [UIView new];
    _line.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.mas_equalTo(_inputTextF);
        make.right.mas_equalTo(_inputTextF);
        make.height.equalTo(@(1));
    }];
}

#pragma mark - UITextField
- (void)beginInput:(UITextField *)textField{
    if (textField.text.length > 0){
        
    }else{
        [self startInputAnimation:YES];
    }
    _line.backgroundColor = ColorFromHex(0x01B956);
    _titleLab.textColor = ColorFromHex(0x01B956);
    _titleLab.text = self.anititle;
    _titleLab.font = [UIFont systemFontOfSize:16];
    if (self.beginInputCallback){
        self.beginInputCallback(textField.text);
    }
}

- (void)changedInput:(UITextField *)textField{
    if (self.inputTextF.text.length >= self.maxLength) {
        self.inputTextF.text = [textField.text substringToIndex:self.maxLength];
    }
    if (self.inputChangeCallback){
        self.inputChangeCallback(textField.text);
    }
}

- (void)endInput:(UITextField *)textField{
    if (textField.text.length > 0){
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _titleLab.textColor = ColorFromHex(0xC5CFD5);
        _titleLab.text = self.hoderTitle;
        _titleLab.font = [UIFont systemFontOfSize:16];
    }else{
        [self resetAnimation];
    }
    if (self.inputEndEditBlock) {
        self.inputEndEditBlock(textField.text);
    }
}

#pragma mark -
- (void)resetAnimation{
    [self endInputAnimation:YES];
    _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _titleLab.textColor = ColorFromHex(0xC5CFD5);
    _titleLab.text = self.hoderTitle;
    _titleLab.font = [UIFont systemFontOfSize:16];
}

- (void)startInputAnimation:(BOOL)animation{
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    baseAnimation.cumulative = YES;
    baseAnimation.keyPath = @"transform.scale";
    baseAnimation.fromValue = @(1);
    baseAnimation.toValue = @(0.8);
    baseAnimation.duration = 0.25;
    baseAnimation.removedOnCompletion = YES;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    [_titleLab.layer addAnimation:baseAnimation forKey:@"base"];
    _titleLab.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    CABasicAnimation *yanimation = [CABasicAnimation animation];
    yanimation.cumulative = YES;
    yanimation.keyPath = @"position.y";
//    yanimation.fromValue = @(0);
//    yanimation.toValue = @(-15);
    yanimation.duration = animation ? 0.25 : 0;
    yanimation.removedOnCompletion = YES;
    yanimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    [_titleLab.layer addAnimation:yanimation forKey:@"y"];
    _titleLab.layer.position = CGPointMake(30, (CGRectGetHeight(self.frame)-20)/2.0-10);
}

- (void)endInputAnimation:(BOOL)animation{
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    baseAnimation.cumulative = YES;
    baseAnimation.keyPath = @"transform.scale";
    baseAnimation.fromValue = @(0.8);
    baseAnimation.toValue = @(1);
    baseAnimation.duration = 0.25;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    baseAnimation.removedOnCompletion = YES;
    [_titleLab.layer addAnimation:baseAnimation forKey:@"base1"];
    _titleLab.transform = CGAffineTransformMakeScale(1, 1);
    
    CABasicAnimation *yanimation = [CABasicAnimation animation];
    yanimation.cumulative = YES;
    yanimation.keyPath = @"position.y";
//    yanimation.fromValue = @(-15);
//    yanimation.toValue = @(0);
    yanimation.duration = animation ? 0.25 : 0;
    yanimation.removedOnCompletion = YES;
    yanimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    [_titleLab.layer addAnimation:yanimation forKey:@"y"];
    _titleLab.layer.position = CGPointMake(30, (CGRectGetHeight(self.frame)-20)/2.0 + 9);
}

#pragma mark - lazy
- (UILabel *)titleLab{
    if (!_titleLab){
        UILabel *lab = [UILabel new];
        lab.text = self.hoderTitle;
        lab.textColor = ColorFromHex(0xC5CFD5);
        lab.font = [UIFont systemFontOfSize:16];
        _titleLab = lab;
    }
    return _titleLab;
}

- (UITextField *)inputTextF{
    if (!_inputTextF){
        UITextField *tf = [UITextField new];
        tf.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0];
        tf.textColor = ColorFromHex(0x333333);
        [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        tf.font = [UIFont systemFontOfSize:14];
//        tf.delegate = self;
        [tf addTarget:self action:@selector(beginInput:) forControlEvents:UIControlEventEditingDidBegin];
        [tf addTarget:self action:@selector(changedInput:) forControlEvents:UIControlEventEditingChanged];
        [tf addTarget:self action:@selector(endInput:) forControlEvents:UIControlEventEditingDidEnd];
        _inputTextF = tf;
    }
    return _inputTextF;
}

@end
