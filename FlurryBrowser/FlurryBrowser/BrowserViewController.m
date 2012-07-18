//
//  BrowserViewController.m
//  FlurryBrowser
//
//  Created by Emre Ergenekon on 7/17/12.
//  Copyright (c) 2012 Bontouch AB, Codely HB. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController
@synthesize webView=_webView;
@synthesize addressField=_addressField;

#pragma mark - Actions

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addressField.text = @"www.bontouch.com";
    [self goButtonPressed];
}

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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.addressField.text]]];
}

#pragma mark -

@end


@implementation BrowserViewController (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self goButtonPressed];
    return YES;
}

@end

@implementation BrowserViewController (UIWebViewDelegate)

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
            
            break;
            
        case UIWebViewNavigationTypeFormSubmitted:
            
            break;
        case UIWebViewNavigationTypeBackForward:
            
            break;
        case UIWebViewNavigationTypeReload:
            
            break;
        case UIWebViewNavigationTypeFormResubmitted:
            
            break;
        case UIWebViewNavigationTypeOther:
            
            break;
    }
    NSLog(@"shouldStartLoadWithRequest: %@", request);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end

@implementation BrowserViewController (MFMailComposeViewControllerDelegate)

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    if(error)
        NSLog(@"mailComposeControllerdidFailLoadWithError:%@", error);
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
    
}

@end