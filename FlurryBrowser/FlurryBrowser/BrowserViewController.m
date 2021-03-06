/*
 Copyright 2012 Bontouch AB
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
//
//  BrowserViewController.m
//  FlurryBrowser
//
//  Created by Emre Berge Ergenekon on 7/17/12.
//

#import "BrowserViewController.h"
#import "FlurryAnalytics.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController
@synthesize webView=_webView;
@synthesize addressField=_addressField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addressField.text = @"www.bontouch.com";
    [self goButtonPressed];
}

#pragma mark - Actions

- (IBAction)actionButtonPressed:(id)sender {
    NSLog(@"actionButtonPressed");

    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"Check this site!"];
    [mailer setMessageBody:[NSString stringWithFormat:@"You have to see this web site: <a href=\"%@\">%@</ a>", self.addressField.text, self.addressField.text] isHTML:YES];
    [self presentModalViewController:mailer animated:YES];
}

- (void)goButtonPressed
{
    NSLog(@"goButtonPressed");
    if(![self.addressField.text hasPrefix:@"http://"])
        self.addressField.text = [@"http://" stringByAppendingString:self.addressField.text];

    NSURL *URL = [NSURL URLWithString:self.addressField.text];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    
    [FlurryAnalytics logEvent:@"WEB_VIEW_USER_REQUEST" withParameters:[NSDictionary dictionaryWithObject:URL.host forKey:@"Host"]];
}

@end

#pragma mark - UITextFieldDelegate

@implementation BrowserViewController (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self goButtonPressed];
    return YES;
}

@end

#pragma mark - UIWebViewDelegate

@implementation BrowserViewController (UIWebViewDelegate)

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *resultString = nil;
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
            resultString = @"LinkClicked";
            break;
            
        case UIWebViewNavigationTypeFormSubmitted:
            resultString = @"FormSubmitted";
            break;
            
        case UIWebViewNavigationTypeBackForward:
            resultString = @"BackForward";
            break;
            
        case UIWebViewNavigationTypeReload:
            resultString = @"TypeReload";
            break;
            
        case UIWebViewNavigationTypeFormResubmitted:
            resultString = @"FormResubmitted";
            break;
            
        case UIWebViewNavigationTypeOther:
            resultString = @"TypeOther";
            break;
            
        default:
            resultString = @"Unknown";
            break;
    }
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:resultString, @"Result", request.URL.host, @"Host", nil];
    [FlurryAnalytics logEvent:@"WEB_VIEW_SHOULD_LOAD_PAGE" withParameters:params];

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FlurryAnalytics logEvent:@"WEB_VIEW_LOADING_TIME" timed:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [FlurryAnalytics endTimedEvent:@"WEB_VIEW_LOADING_TIME" withParameters:nil];
    self.addressField.text = self.webView.request.URL.absoluteString;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FlurryAnalytics logEvent:@"WEB_VIEW_ERROR" withParameters:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@:%ld", error.domain, (long)error.code] forKey:@"Error"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end

#pragma mark - MFMailComposeViewControllerDelegate

@implementation BrowserViewController (MFMailComposeViewControllerDelegate)

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *resultString = nil;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            resultString = @"Cancelled";
            break;
        case MFMailComposeResultSaved:
            resultString = @"Saved";
            break;
        case MFMailComposeResultSent:
            resultString = @"Sent";
            break;
        case MFMailComposeResultFailed:
            resultString = @"Failed";
            break;
        default:
            resultString = @"Unknown";
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:resultString forKey:@"Result"];
    if(error)
        [params setObject:[NSString stringWithFormat:@"%@:%ld", error.domain, (long)error.code] forKey:@"Error"];
        
    [FlurryAnalytics logEvent:@"SEND_EMAIL" withParameters:params];

    [self dismissModalViewControllerAnimated:YES];
}

@end