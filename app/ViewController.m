//
//  ViewController.m
//  voucher_swap
//
//  Created by Brandon Azad on 12/7/18.
//  Copyright © 2018 Brandon Azad. All rights reserved.
//

#import "ViewController.h"
#import "kernel_slide.h"
#import "voucher_swap.h"
#import "kernel_memory.h"
#include "post.h"
#include <sys/utsname.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *RebootbtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *RespringBTNoutlet;

@end

@implementation ViewController

- (bool)voucher_swap {
#define CHECK(a, b) if (a < b) { printf("non-16k devices are unsupported.\n"); return false; }
    if ([[UIDevice currentDevice].model isEqualToString:@"iPod touch"]) {
        return false;
    }
    struct utsname u;
    uname(&u);
    char read[257];
    int ii = 0;
    for (int i = 0; i < 256; i++) {
        char chr = u.machine[i];
        long num = chr - '0';
        if (num == -4 || chr == 0) {
            break;
        }
        if (num >= 0 && num <= 9) {
            read[ii] = chr;
            ii++;
        }
    }
    read[ii + 1] = 0;
    int digits = atoi(read);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CHECK(digits, 8);
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CHECK(digits, 6);
    }
    voucher_swap();
    if (!MACH_PORT_VALID(kernel_task_port)) {
        printf("tfp0 is invalid?\n");
        return false;
    }
    return true;
#undef CHECK
}

- (void)failure {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)go:(id)sender {
    
    
    
    Post *post = [[Post alloc] init];
    static int progress = 0;
    if (progress == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Aids" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            
        });
        return;
    }
    if (progress == 1) {
	return;
    }
    progress++;
    bool success = [self voucher_swap];
    if (success) {
        sleep(1);
        [post go];
        [sender setTitle:@"Success" forState:UIControlStateNormal];
        [UIView animateWithDuration:2 animations:^{
            self.RespringBTNoutlet.alpha = 1.0;
            self.RebootbtnOutlet.alpha = 1.0;
        }];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self dismissViewControllerAnimated:YES completion:nil];
            

            
        });
    } else {
        [self failure];
    }
    progress++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _RebootbtnOutlet.alpha = 0.0;
    _RespringBTNoutlet.alpha = 0.0;
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    if (@available(iOS 12, *)) {
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unsupported" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        double delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            exit(0);
            
        });
        
       
        
    }
}

- (IBAction)RespringBTn:(id)sender {
    Post *post = [[Post alloc] init];
    [post respring];
    
    
}
- (IBAction)rebootBTN:(id)sender {
    Post *post = [[Post alloc] init];
    [post reboot];
}

@end

