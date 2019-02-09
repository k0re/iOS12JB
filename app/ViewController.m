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
#define hex(hex, alphaVal) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alphaVal]
#define bgDisabledColour hex(0xB8B8B8, 1.0)
#define setBgDisabledColour setBackgroundColor:hex(0xB8B8B8, 1.0)
#define bgEnabledColour setBackgroundColor:hex(0x007AFF, 1.0)
#define setBgEnabledColour setBackgroundColor:hex(0x007AFF, 1.0)

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *logs;
@property (weak, nonatomic) IBOutlet UIButton *exploitBtn;
@property (weak, nonatomic) IBOutlet UIButton *RespringBTN;

@end

@implementation ViewController
extern NSString *LOGGED;



static int progress = 0;

- (bool)voucher_swap {
    if ([[[Post alloc] init] is4K]) {
        printf("non-16k devices are unsupported.\n");
        return false;
    }
    Post *post = [[Post alloc] init];
    // Run voucher_swap
    voucher_swap();
    if (MACH_PORT_VALID(kernel_task_port)) {
        // Post exploitation
        [post go];
        [self log:@"[+] Success!\n"];
        [UIView animateWithDuration:2 animations:^{
            self->_RespringBTN.alpha = 1;
        }];
        [_exploitBtn setTitle:@"Done" forState:UIControlStateDisabled];
        [self log:[NSString stringWithFormat:@"[+] Kernel Task Port: 0x%x\n[+] User ID: %i\n[+] Group ID: %i\n[+] Is Sandboxed: %@\n[+] Done!\n", kernel_task_port, getuid(), getgid(), [post isSandboxed] ? @"Yes" : @"No"]];
        // Become mobile ([U/G]ID: 501) so Xcode can stop the process
        [post mobile];
        progress++;
    } else {
        // Failed
        [self failure];
    }
    return true;
}

- (void)log:(NSString *)what {
    [_logs setText:[_logs.text stringByAppendingString:[what stringByAppendingString:@""]]];
}

- (void)failure {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)go:(id)sender {
    
    
    if (progress == 2) {
        
        
        return;
    } else if (progress == 1) {
        return;
    } else {
        [sender setEnabled:NO];
        [sender setTitle:@"Please Wait..." forState:UIControlStateDisabled];
        progress++;
        [self log:@"[+] Running Exploit...\n"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.5f];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self voucher_swap];
            });
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _RespringBTN.alpha = 0;
    NSString *name = UIDevice.currentDevice.name;
    NSString *whatever = [name stringByAppendingString:@", Is Supported\n"];
    [self log:[NSString stringWithFormat:@"%@", whatever]];
    [self log:@"[+] Ready!\n"];
    Post *post = [[Post alloc] init];
    struct utsname u = [post uname];
    //[self log:[[@"[*] Device: " stringByAppendingString:[NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding]] stringByAppendingString:@"\n"]];
    bool is16K = [post is16K];
    if (!is16K) {
        [self log:[NSString stringWithFormat:@"[E] %s Is Unsupported\n", u.machine]];
        [_exploitBtn setBgDisabledColour];
        return;
    
   
}
}



- (IBAction)credits:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Credits" message:@"Exploit: (@_)bazad\nModifications and post-exploitation: (@)Alticha(Dev)\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)RespringBTNAction:(id)sender {
    Post *post = [[Post alloc] init];
    [post respring];
}



    @end

    
