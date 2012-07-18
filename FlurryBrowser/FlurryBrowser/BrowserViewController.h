//
//  BrowserViewController.h
//  FlurryBrowser
//
//  Created by Emre Ergenekon on 7/17/12.
//  Copyright (c) 2012 Bontouch AB, Codely HB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *addressField;

@end
