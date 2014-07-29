//
//  ViewController.m
//  rs232
//
//  Created by Daniel Coffey on 7/21/14.
//  Copyright (c) 2014 Daniel Coffey. All rights reserved.
//

#import "mViewController.h"

@interface mViewController ()

@end

@implementation mViewController

@synthesize texty;
@synthesize connectLabel;
@synthesize debugText;
@synthesize button1;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View loaded");

    // Do any additional setup after loading the view, typically from a nib.
    
    // Create and initialize our RedparkSerialCable Manager for communicating
    // with the serial cable.
    rscMgr = [[RscMgr alloc] init];
    
    // Set this as our delegate so we can receive evevnts
    [rscMgr setDelegate:self];
    
    // set defaults for analog_way
    [rscMgr setBaud:115200];
    [rscMgr setDataSize:(DataSizeType)8];
//    [rscMgr	setParity:(ParityType)value];
    [rscMgr setStopBits:(StopBitsType)1];
    
    lastScreen1 = [NSNumber numberWithInt:1];
    lastScreen2 = [NSNumber numberWithInt:2];
    screen1Frozen = false;
    screen2Frozen = false;
    screen1Logo = false;
    screen2Logo = false;
    
    lookup = @{
         [NSNumber numberWithInt:0] : @"SWAP", // swap
         [NSNumber numberWithInt:10] : @"??10", // logo 1
         [NSNumber numberWithInt:11] : @"0,1,1,1PRinp0,1PUscu0,1GCtak",
         [NSNumber numberWithInt:12] : @"0,1,1,2PRinp0,1PUscu0,1GCtak",
         [NSNumber numberWithInt:13] : @"0,1,1,3PRinp0,1PUscu0,1GCtak",
         [NSNumber numberWithInt:14] : @"0,1,1,4PRinp0,1PUscu0,1GCtak",
         [NSNumber numberWithInt:19] : @"1GCfsc1,1PUscu1", // freeze 1
         [NSNumber numberWithInt:20] : @"??20", // logo 2
         [NSNumber numberWithInt:21] : @"1,1,1,1PRinp1,1PUscu1,1GCtak",
         [NSNumber numberWithInt:22] : @"1,1,1,2PRinp1,1PUscu1,1GCtak",
         [NSNumber numberWithInt:23] : @"1,1,1,3PRinp1,1PUscu1,1GCtak",
         [NSNumber numberWithInt:24] : @"1,1,1,4PRinp1,1PUscu1,1GCtak",
         [NSNumber numberWithInt:29] : @"??29", // freeze 2
    };
    
    
   // [self checkButtons];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
- (IBAction)buttonPress:(id)sender {
    NSString *result;
    
    NSNumber *clicked = [NSNumber numberWithInt:[sender tag]];
    // clear debug text
    debugText.text = @"";
    
    switch ([clicked integerValue]) {
        case 0: {
            // swap
            NSLog(@"Swap before, last1 = %d, last2 = %d", [lastScreen1 integerValue], [lastScreen2 integerValue]);

            NSNumber *foo = [NSNumber numberWithInt:(10 + [lastScreen2 integerValue])];

            result = [self sendCommand:lookup[foo]];
            
            NSLog(@"Swap command1, foo = %i sending %@", [foo integerValue], lookup[foo]);
            NSLog(@"result of swap1 = %@", result);
            foo = [NSNumber numberWithInt:(20 + [lastScreen1 integerValue])];
            result = [self sendCommand:lookup[foo]];
            NSLog(@"Swap command2, sending %@", lookup[foo]);
            NSLog(@"result of swap2 = %@", result);
            

            // swap our mental map
            NSNumber *temp = lastScreen1;
            lastScreen1 = lastScreen2;
            lastScreen2 = temp;
            
            NSLog(@"Swap complete, last1 = %i, last2 = %i", [lastScreen1 integerValue], [lastScreen2 integerValue]);
            
            break;
        }
        case 10: {
            // logo 1 toggle
            if (screen1Logo == false)
            {
                result = [self sendCommand:@"0,1CTqfa"];
                screen1Logo = true;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor blueColor]];
            }
            else
            {
                result = [self sendCommand:@"0,0CTqfa"];
                screen1Logo = false;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:100]];
            }
            
            break;
        }
        case 19: {
            // freeze 1 toggle
            if (screen1Frozen == false)
            {
                result = [self sendCommand:@"0,1GCfsc0,1GCfsc"];
                screen1Frozen = true;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor blueColor]];
            }
            else
            {
                result = [self sendCommand:@"0,0GCfsc0,0GCfsc"];
                screen1Frozen = false;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:100]];
            }
            break;
        }
        case 20: {
            // logo 2 toggle
            if (screen2Logo == false)
            {
                result = [self sendCommand:@"1,1CTqfa"];
                screen2Logo = true;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor blueColor]];
            }
            else
            {
                result = [self sendCommand:@"1,0CTqfa"];
                screen2Logo = false;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:100]];
            }

            break;
        }
        case 29: {
            // freeze 2 toggle
            if (screen2Frozen == false)
            {
                result = [self sendCommand:@"1,1GCfsc1,1GCfsc"];
                screen2Frozen = true;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor blueColor]];
            }
            else
            {
                result = [self sendCommand:@"1,0GCfsc1,0GCfsc"];
                screen2Frozen = false;
                UIButton *btn = (UIButton*)sender;
                [btn setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:100]];
            }
            break;
        }
        
        // handle normal inputs
        default: {
            
            // first check if we're making changes to both screens (31-34)
            if ([clicked integerValue] > 30)
            {
                // get the source number
                NSNumber *input = [NSNumber numberWithInt:([clicked integerValue] % 10)];
                
            }
            // else handle normal source changes
            else
            {
                // get the screen num and source
                NSNumber *input = [NSNumber numberWithInt:([clicked integerValue] % 10)];
                NSNumber *screen = [NSNumber numberWithInt:(([clicked integerValue] / 10) % 10)];
                
                // set the last source to the last remembered
                if ([screen integerValue] == 1)
                {
                    lastScreen1 = input;
                }
                else
                {
                    lastScreen2 = input;
                }
                
                // send the command
                result = [self sendCommand:lookup[clicked]];
                
                NSLog(@"Default Button Press.  Screen: %i, input %i", [screen integerValue], [input integerValue]);
                
            }
            break;
        }
    }
    
    NSLog(@"button pushed, screen1 == %i, screen2 == %i", [lastScreen1 integerValue], [lastScreen2 integerValue]);
    
    NSLog(@"Button clicked %d, string: %@", [clicked integerValue], lookup[clicked]);
//    uint8_t *someInt = (uint8_t *)[lookup[[NSNumber numberWithInt:clicked]] UTF8String];
//    [rscMgr write:someInt Length:[lookup[[NSNumber numberWithInt:clicked]] length]];
//    [rscMgr writeString:lookup[[NSNumber numberWithInt:clicked]]];
    
    
}

- (BOOL) checkInput: (NSNumber *) number {
    // try catch to avoid error if analog way is not connected
    @try {
        NSString *temp = [NSString stringWithFormat:@"%d,1,ISsva", [number integerValue]];
        NSString *response = [self sendCommand:temp];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
   
        // here
        NSNumber *num = [f numberFromString:[response substringFromIndex:[response length] - 1]];
        
        NSLog(@"checkInput = %i is %i", [number integerValue], [num integerValue]);
        
        if ([number integerValue] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    @catch (NSException *e ){
        return false;
    }
    
}

- (NSString *) sendCommand: (NSString *) command {
    NSLog(@"In send command, sending: %@", command);
    texty.text = command;
    [rscMgr writeString:command];
    NSString *response = [rscMgr getStringFromBytesAvailable];
    NSLog(@"Response from Analog Way: '%@'", response);
    debugText.text = response;
    return response;
}

// check inputs to see if the buttons should be on the screen
- (void) checkButtons
{
    NSArray *buttonsToCheck = @[@1, @2, @3, @4];
    
    for (NSNumber *num in buttonsToCheck)
    {
        NSLog(@"Checking %i", [num integerValue]);
        if ([self checkInput:num] == false)
        {
            NSLog(@"removing %i", 10 + [num integerValue]);
            UIView *aView = [self.view viewWithTag:10 + [num integerValue]];
            [aView removeFromSuperview];
            NSLog(@"removing %i", 20 + [num integerValue]);
            aView = [self.view viewWithTag:20 + [num integerValue]];
            [aView removeFromSuperview];
        }
    }
}

#pragma mark - RscMgrDelegate methods

- (void) cableConnected:(NSString *)protocol {
    connectLabel.text = @"Connected";

    [rscMgr setBaud:115200];
    [rscMgr open];
        
    [self sendCommand:lookup[[NSNumber numberWithInt:11]]];
    [self sendCommand:lookup[[NSNumber numberWithInt:22]]];
}

- (void) cableDisconnected {
    connectLabel.text = @"Not Connected";
}

- (void) portStatusChanged {
    
}

- (void) readBytesAvailable:(UInt32)numBytes {
}

- (BOOL) rscMessageReceived:(UInt8 *)msg TotalLength:(int)len {
    return FALSE;
}

- (void) didReceivePortConfig {
}


@end
