//
//  ViewController.m
//  UIVebView
//
//  Created by Sugar on 16-5-20.
//  Copyright (c) 2016年 jieshen. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIWebViewDelegate>
//网页视图
@property (nonatomic,strong) UIWebView * webView;
//输入框
@property (nonatomic,strong) UITextField * textField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)createUI{
    NSArray * titleArr = @[@"后退",@"前进",@"刷新",@"停止",@"加载",@"html",@"HTML交互"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREEN_WIDTH / 7 * i, 20, SCREEN_WIDTH / 7, 40);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        
        [self.view addSubview:button];
        
        
    }
    //搜索框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 40)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:_textField];
    
    
    //网页视图
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, self.view.bounds.size.height - 100)];
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
    
    
    
    
}
#pragma mark -- button 点击事件
- (void)buttonClick:(UIButton *)button{
    
    if (button.tag == 100) {
       // @"后退"
        [_webView goBack];
    }else if(button.tag == 101){
        //,@"前进"
        [_webView goForward];
    }else if(button.tag == 102){
        //,@"刷新",
        [_webView reload];
    }else if(button.tag == 103){
       // @"停止",
        [_webView stopLoading];
    }else if(button.tag == 104){
        //@"加载",
        //判断输入网址是否有http字符
        if (![_textField.text hasPrefix:@"http"]) {
            //加入
            _textField.text = [NSString stringWithFormat:@"http://%@",_textField.text];
            
        }
        //1生成请求体
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_textField.text]];
        //2 webView 加载请求体
        [_webView loadRequest:request];
        
  
    }else if(button.tag == 105){
        //@"html",
        //本地HTML文件
        NSString * path = [[NSBundle mainBundle]pathForResource:@"Test" ofType:@"html"];
////        //将页面源码读出
//        NSString * htmlstr = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//
        //网络HTML文件
        NSURL * url = [NSURL URLWithString:@"http://42.121.112.183/ttdota2/api/mobile/index.php?mobile=no&version=1&module=viewthread&submodule=checkpost&tid=444&ppp=10&page=1"];
        NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
//        NSLog(@"%@",htmlstr);
        //webView加载HTML
        /*
         1 html 页面
         2 通常为本公司的网址
         
         */
        [_webView loadHTMLString:@"http://shop.boohee.com/store/pages/food_glycemic_index" baseURL:nil];
        
        
    }else{
       //@"HTML交互"
        //面试 内嵌HTML页面的能力
        //ios 操作HTML
        [_webView stringByEvaluatingJavaScriptFromString:@"show()"];
        
        //html 操作ios
        
    }
    
    
    
}
#pragma mark --webView的代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //获得当前网页网址
    //NSURL 转换 NSString
    NSString * url = request.URL.absoluteString;
    _textField.text = url;
    //HTML页面按钮->更改当前网址 - > iOS客户端在该方法代理方法中检测 -> 调用iOS内部方法
    //区分按钮点击 并区分客户端(支付宝 微信)
    //字符串分割
    NSArray * array = [url componentsSeparatedByString:@"://"];
    //进行客户端判断
    if ([array.firstObject isEqualToString:@"oc"]) {
        //执行iOS调用 array[1] aliPay wechatPay
    //将方法名转换为对应真实的方法
        SEL sel = NSSelectorFromString(array[1]);
        //调用方法
        [self performSelector:sel];
        
        
    }
    
    //[self aliPayClick];
    return YES;
}

- (void)aliPay{
    NSLog(@"调用支付宝SDK显现支付");
    
    
}
- (void)wechatPay{
    NSLog(@"微信支付");
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
