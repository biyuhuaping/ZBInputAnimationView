//
//  ViewController.m
//  ZBInputAnimationView
//
//  Created by ZB on 2024/4/22.
//

#import "ViewController.h"
#import "ZBInputAnimationView.h"

#define kScreenW ([[UIScreen mainScreen] bounds].size.width)
#define kScreenH [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentViews;

@property (nonatomic, strong) ZBInputAnimationView *acountView;//账号
@property (nonatomic, strong) ZBInputAnimationView *pictureCodeView;//图形验证码
@property (nonatomic, strong) ZBInputAnimationView *codeView;//验证码
@property (nonatomic, strong) ZBInputAnimationView *newPwdView;//新密码
@property (nonatomic, strong) ZBInputAnimationView *againPwdView;//确认密码

@property (nonatomic, strong) UIButton *imgCodeBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) NSString * userTokenForImageCode;
@property (nonatomic, assign) NSInteger timeOut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"重置密码"];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initUI];
    [self getVerificationPictureCode];
}

- (void)initUI{
    //scrollView
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.backgroundColor = UIColor.clearColor;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.layer.cornerRadius = 10;
        scrollView.alwaysBounceVertical = NO;
        scrollView;
    });
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //contentViews
    self.contentViews = ({
        UIView *aView = [[UIView alloc] init];
        aView.backgroundColor = UIColor.whiteColor;
        aView;
    });
    [self.scrollView addSubview:self.contentViews];
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH+5);
    }];
    
    
    //账号
    [self.contentViews addSubview:self.acountView];
    [self.acountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentViews).offset(64);
        make.leading.trailing.equalTo(self.contentViews);
        make.height.equalTo(@(65));
    }];
    
    //图形验证码
    [self.contentViews addSubview:self.pictureCodeView];
    [self.pictureCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acountView.mas_bottom);
        make.leading.trailing.equalTo(self.contentViews);
        make.height.equalTo(@(65));
    }];
    
    //验证码
    [self.contentViews addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureCodeView.mas_bottom);
        make.leading.trailing.equalTo(self.contentViews);
        make.height.equalTo(@(65));
    }];
    
    //新密码
    [self.contentViews addSubview:self.newPwdView];
    [self.newPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(0);
        make.leading.trailing.equalTo(self.contentViews);
        make.height.equalTo(@(65));
    }];
    
    //确认密码
    [self.contentViews addSubview:self.againPwdView];
    [self.againPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newPwdView.mas_bottom).offset(0);
        make.leading.trailing.equalTo(self.contentViews);
        make.height.equalTo(@(65));
    }];
    
    //确定
    [self.contentViews addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(20);
        make.trailing.equalTo(@-20);
        make.top.equalTo(self.againPwdView.mas_bottom).offset(40);
        make.height.equalTo(@(44));
    }];
}

#pragma mark -
//图形验证码
- (void)getVerificationPictureCode{
    
}

- (void)requestVerifyCode{
    [self.view endEditing:YES];
}

- (void)getCodeBtnAction:(UIButton *)sender{
    if (self.acountView.inputTextF.text.length != 11) {
        //显示错误提示文本
//        MBShowTextNoIcon(@"请输入正确的手机号");
        return;
    }
    [self.view endEditing:YES];
    self.getCodeBtn.userInteractionEnabled = NO;
}

//更新 确认 按钮
- (void)updateConfirmBtnUI{
    if (self.codeView.inputTextF.text.length && self.newPwdView.inputTextF.text.length && self.againPwdView.inputTextF.text.length){
        self.confirmBtn.backgroundColor = ColorFromHex(0x01B956);
        self.confirmBtn.userInteractionEnabled = YES;
    }else{
        self.confirmBtn.backgroundColor = ColorFromHex(0xC5CFD5);
        self.confirmBtn.userInteractionEnabled = NO;
    }
}

//更新 获取验证码 按钮
- (void)updateCodeBtnUI{
//    if (self.acountView.inputTextF.text.length >= 11 && self.pictureCodeView.inputTextF.text.length > 0 && self.timeOut == 0) {
//        self.getCodeBtn.userInteractionEnabled = YES;
//        self.getCodeBtn.backgroundColor = [UIColor whiteColor];
//        self.getCodeBtn.layer.borderColor = [UIColor color01B956].CGColor;
//        [self.getCodeBtn setTitleColor:[UIColor color01B956] forState:UIControlStateNormal];
//    }else{
//        self.getCodeBtn.userInteractionEnabled = NO;
//        self.getCodeBtn.backgroundColor = [UIColor colorC5CFD5];
//        self.getCodeBtn.layer.borderColor = [UIColor colorC5CFD5].CGColor;
//        [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
}

//查看密码
- (void)seeAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    ZBInputAnimationView *view;
    if (sender.tag == 1){
        view = _newPwdView;
    }else{
        view = _againPwdView;
    }
    
    if (!sender.selected){
        view.inputTextF.secureTextEntry = YES;
    }else{
        view.inputTextF.secureTextEntry = NO;
    }
}

//确认按钮
- (void)confirmAction{
    [self.view endEditing:YES];
//    if ([self.newPwdView.inputTextF.text isPwd] == NO){
//        MBShowTextNoIcon(@"新密码必须为8-20位数字字母组合");
//        return;
//    }
//
//    if (![self.newPwdView.inputTextF.text isEqualToString:self.againPwdView.inputTextF.text]){
//        MBShowTextNoIcon(@"两次填写的密码不一致，请重试");
//        return;
//    }
//
//    NSString *password = self.newPwdView.inputTextF.text;
//    CocoaSecurityResult *aesDefault = [CocoaSecurity aesEncrypt:password key:[@"f4k9f5w7f8g4er26" dataUsingEncoding:NSUTF8StringEncoding] iv:[@"5e8y6w45ju8w9jq8" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"AES加密后:%@",aesDefault.base64);
//    password = aesDefault.base64;
//
//    NSDictionary *dic = @{
//        @"telephone" : self.acountView.inputTextF.text,//手机号码
//        @"verifyCode" : self.codeView.inputTextF.text,//短信验证码
//        @"newPwd" : password,//新密码
//        @"newPwdAgain" : password//二次确认的新密码
//    };
//    WS
//    [LLYSServiceManager getUpdatePwd:dic success:^(id  _Nonnull responseObject) {
//        MBShowTextNoIcon(@"设置成功");
//        [ws.navigationController popViewControllerAnimated:YES];
//    } failure:^(id  _Nullable responserObject, NSString * _Nonnull errorMsg) {
//        ws.getCodeBtn.userInteractionEnabled = YES;
//        MBShowTextNoIcon(errorMsg);
//    }];
}

- (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    //倒计时时间
    self.timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    WS
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (self.timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = mColor;
//                button.layer.borderColor = [UIColor color01B956].CGColor;
//                [button setTitleColor:[UIColor color01B956] forState:UIControlStateNormal];
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        } else {
            int seconds = self.timeOut == 60 ? 60: self.timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = color;
                button.layer.borderColor = color.CGColor;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            self.timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - lazy
- (UIButton *)confirmBtn{
    if (!_confirmBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundColor:[UIColor color]];
        btn.backgroundColor = ColorFromHex(0xC5CFD5);
        [btn setTitle:@"确  认" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 22;
        btn.userInteractionEnabled = NO;
        _confirmBtn = btn;
    }
    return _confirmBtn;
}

- (ZBInputAnimationView *)acountView{
    if (!_acountView){
        WS
        ZBInputAnimationView *view = [[ZBInputAnimationView alloc]initWithPlaceString:@"手机号" title:@"手机号"];
        view.inputTextF.keyboardType = UIKeyboardTypeNumberPad;
        view.maxLength = 11;
        view.inputChangeCallback = ^(NSString * _Nonnull text) {
            [ws updateConfirmBtnUI];
            [ws updateCodeBtnUI];
        };
        _acountView = view;
    }
    return _acountView;
}

- (ZBInputAnimationView *)pictureCodeView{
    if (!_pictureCodeView){
        WS
        ZBInputAnimationView *view = [[ZBInputAnimationView alloc]initWithPlaceString:@"图形验证码" title:@"图形验证码"];
        view.maxLength = 8;
        view.inputChangeCallback = ^(NSString * _Nonnull text) {
            [ws updateConfirmBtnUI];
            [ws updateCodeBtnUI];
        };
        [view addSubview:self.imgCodeBtn];
        [self.imgCodeBtn addTarget:self action:@selector(getVerificationPictureCode) forControlEvents:UIControlEventTouchUpInside];
    //    [self.imageCodeBtn setBackgroundImage:[UIImage imageNamed:@"icon_mine_manager"] forState:UIControlStateNormal];
        [self.imgCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
        }];
        _pictureCodeView = view;
    }
    return _pictureCodeView;
}

- (ZBInputAnimationView *)codeView{
    if (!_codeView){
        WS
        ZBInputAnimationView *view = [[ZBInputAnimationView alloc]initWithPlaceString:@"验证码" title:@"验证码"];
        view.maxLength = 6;
        view.inputTextF.keyboardType = UIKeyboardTypeNumberPad;
        view.inputChangeCallback = ^(NSString * _Nonnull text) {
            [ws updateConfirmBtnUI];
        };
        [view addSubview:self.getCodeBtn];
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-24);
            make.centerY.equalTo(view.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@93);
        }];
        _codeView = view;
    }
    return _codeView;
}

- (ZBInputAnimationView *)newPwdView{
    if (!_newPwdView){
        WS
        ZBInputAnimationView *view = [[ZBInputAnimationView alloc]initWithPlaceString:@"重置密码8-20位大小写+数字" title:@"新密码"];
        view.maxLength = 20;
        view.inputTextF.secureTextEntry = YES;
        view.inputChangeCallback = ^(NSString * _Nonnull text) {
//            [ws isShowErrorTip:NO showStr:@"提示：密码必须为8-20位数字字母组合"];
            [ws updateConfirmBtnUI];
        };
        //密码是否可见
        UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [seeBtn setImage:[UIImage imageNamed:@"eyesClose"] forState:UIControlStateNormal];
        [seeBtn setImage:[UIImage imageNamed:@"eyesOpen"] forState:UIControlStateSelected];
        [seeBtn addTarget:self action:@selector(seeAction:) forControlEvents:UIControlEventTouchUpInside];
        seeBtn.tag = 1;
        [view addSubview:seeBtn];
        [seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-20);
            make.width.height.equalTo(@(40));
            make.centerY.equalTo(view.inputTextF.mas_centerY).offset(0);
        }];
        _newPwdView = view;
    }
    return _newPwdView;
}

- (ZBInputAnimationView *)againPwdView{
    if (!_againPwdView){
        WS
        ZBInputAnimationView *view = [[ZBInputAnimationView alloc]initWithPlaceString:@"请再次输入密码" title:@"确认密码"];
        view.inputTextF.secureTextEntry = YES;
        view.maxLength = 20;
        view.inputChangeCallback = ^(NSString * _Nonnull text) {
//            [ws isShowErrorTip:NO showStr:@"提示：密码必须为8-20位数字字母组合"];
            [ws updateConfirmBtnUI];
        };
        //密码是否可见
        UIButton *seeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [seeBtn2 setImage:[UIImage imageNamed:@"eyesClose"] forState:UIControlStateNormal];
        [seeBtn2 setImage:[UIImage imageNamed:@"eyesOpen"] forState:UIControlStateSelected];
        [seeBtn2 addTarget:self action:@selector(seeAction:) forControlEvents:UIControlEventTouchUpInside];
        seeBtn2.tag = 2;
        [view addSubview:seeBtn2];
        [seeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-20);
            make.width.height.equalTo(@(40));
            make.centerY.equalTo(view.inputTextF.mas_centerY).offset(0);
        }];
        _againPwdView = view;
    }
    return _againPwdView;
}

- (UIButton *)imgCodeBtn{
    if(!_imgCodeBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;//按下的时候，不显示按下效果
        _imgCodeBtn = btn;
    }
    return _imgCodeBtn;
}

- (UIButton *)getCodeBtn{
    if (!_getCodeBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor color999999] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        [btn addTarget:self action:@selector(getCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        btn.layer.borderColor = [UIColor color01B956].CGColor;
//        btn.layer.borderWidth = 1;
//        btn.layer.cornerRadius = 16;
//
//        btn.userInteractionEnabled = NO;
//        btn.backgroundColor = [UIColor colorC5CFD5];
//        btn.layer.borderColor = [UIColor colorC5CFD5].CGColor;
//        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        _getCodeBtn = btn;
    }
    return _getCodeBtn;
}

@end
