//
//  CWWebViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/8.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWWebViewController.h"

@interface CWWebViewController()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwordBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;

@end


@implementation CWWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     NSLog(@"willAppear%@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
}
- (IBAction)goForward:(UIBarButtonItem *)sender {
//    sender.enabled = self.webView.canGoForward;
    [self.webView goForward];
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
//    sender.enabled = self.webView.canGoBack;
    [self.webView goBack];
}


- (IBAction)reFresh:(UIBarButtonItem *)sender {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.goForwordBtn.enabled = webView.canGoForward;
    self.goBackBtn.enabled = webView.canGoBack;
}

@end
