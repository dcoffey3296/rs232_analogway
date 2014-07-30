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
//@synthesize button1;


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
    
    [self sendCommand:lookup[[NSNumber numberWithInt:11]]];
    [self turnButton:(UIButton *)[self.view viewWithTag:11] color:@"red"];
    lastScreen1 = @11;
    [self sendCommand:lookup[[NSNumber numberWithInt:22]]];
    [self turnButton:(UIButton *)[self.view viewWithTag:22] color:@"red"];
    lastScreen2 = @22;
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
//    debugText.text = @"";
    
    switch ([clicked integerValue]) {
        case 0: {
            // swap
            NSLog(@"Swap before, last1 = %d, last2 = %d", [lastScreen1 integerValue], [lastScreen2 integerValue]);
            
            // set colors to gray
            [self turnButton:(UIButton *)[self.view viewWithTag:[lastScreen1 intValue]] color:@"gray"];
            [self turnButton:(UIButton *)[self.view viewWithTag:[lastScreen2 intValue]] color:@"gray"];

            debugText.text = [NSString stringWithFormat:@" last1 = %d, last2 = %d", [lastScreen1 intValue], [lastScreen2 intValue]];
            
            // swap our mental map
            NSNumber *temp = [NSNumber numberWithInt:([lastScreen1 intValue] % 10) + 20];
            lastScreen1 = [NSNumber numberWithInt:([lastScreen2 intValue] % 10) + 10];
            lastScreen2 = temp;
            
            debugText.text = [NSString stringWithFormat:@" last1 = %d, last2 = %d", [lastScreen1 intValue], [lastScreen2 intValue]];
           
            result = [self sendCommand:lookup[lastScreen1]];
            
            NSLog(@"Swap command1, foo = %i sending %@", [lastScreen1 integerValue], lookup[lastScreen1]);
            
            result = [self sendCommand:lookup[lastScreen2]];
            NSLog(@"Swap command2, sending %@", lookup[lastScreen2]);
            
            [self turnButton:(UIButton *)[self.view viewWithTag:[lastScreen1 intValue]] color:@"red"];
            
            [self turnButton:(UIButton *)[self.view viewWithTag:[lastScreen2 intValue]] color:@"red"];
            
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
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"0,0CTqfa"];
                screen1Logo = false;
                UIButton *btn = (UIButton*)sender;
                [self turnButton:btn color:@"gray"];
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
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"0,0GCfsc0,0GCfsc"];
                screen1Frozen = false;
                UIButton *btn = (UIButton*)sender;
                [self turnButton:btn color:@"gray"];
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
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"1,0CTqfa"];
                screen2Logo = false;
                UIButton *btn = (UIButton*)sender;
                [self turnButton:btn color:@"gray"];
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
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"1,0GCfsc1,0GCfsc"];
                screen2Frozen = false;
                UIButton *btn = (UIButton*)sender;
                [self turnButton:btn color:@"gray"];
            }
            break;
        }
        case 30: {
            // logo 1 toggle
            if (screen1Logo == false)
            {
                result = [self sendCommand:@"0,1CTqfa"];
                screen1Logo = true;
                UIButton *btn = (UIButton *)[self.view viewWithTag:20];
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"0,0CTqfa"];
                screen1Logo = false;
                UIButton *btn = (UIButton *)[self.view viewWithTag:20];
                [self turnButton:btn color:@"gray"];
            }
            
            // logo 2 toggle
            if (screen2Logo == false)
            {
                result = [self sendCommand:@"1,1CTqfa"];
                screen2Logo = true;
                UIButton *btn = (UIButton *)[self.view viewWithTag:10];
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"1,0CTqfa"];
                screen2Logo = false;
                UIButton *btn = (UIButton *)[self.view viewWithTag:10];
               [self turnButton:btn color:@"gray"];
            }
            
            

            break;
        }
        case 39: {
            // freeze projector
            if (screen1Frozen == false)
            {
                result = [self sendCommand:@"0,1GCfsc0,1GCfsc"];
                screen1Frozen = true;
                UIButton *btn =(UIButton *)[self.view viewWithTag:19];
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"0,0GCfsc0,0GCfsc"];
                screen1Frozen = false;
                UIButton *btn = (UIButton *)[self.view viewWithTag:19];
                [self turnButton:btn color:@"gray"];
            }
            
            // freeze touchscreen
            if (screen2Frozen == false)
            {
                result = [self sendCommand:@"1,1GCfsc1,1GCfsc"];
                screen2Frozen = true;
                UIButton *btn = (UIButton *)[self.view viewWithTag:29];
                [self turnButton:btn color:@"blue"];
            }
            else
            {
                result = [self sendCommand:@"1,0GCfsc1,0GCfsc"];
                screen2Frozen = false;
                UIButton *btn = (UIButton *)[self.view viewWithTag:29];
                [self turnButton:btn color:@"gray"];
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
                
                // reset the previously red buttons
                [self turnButton:(UIButton *)[self.view viewWithTag: [lastScreen1 intValue]] color:@"gray"];
                [self turnButton:(UIButton *)[self.view viewWithTag: [lastScreen2 intValue]] color:@"gray"];
                
                // remember which sources
                lastScreen1 = [NSNumber numberWithInt: (10 + [input integerValue])];
                lastScreen2 = [NSNumber numberWithInt: (20 + [input integerValue])];
                
                // set the new colors as red
                [self turnButton:(UIButton *)[self.view viewWithTag:  [lastScreen1 intValue]] color:@"red"];
                [self turnButton:(UIButton *)[self.view viewWithTag: [lastScreen2 intValue]] color:@"red"];
                
                // send the button to both screens
                result = [self sendCommand:lookup[lastScreen1]];
                NSLog(@"Double Button Press.  Screen: %i, input %i", 1, [lastScreen1 integerValue]);

                result = [self sendCommand:lookup[lastScreen2]];
                NSLog(@"Double Button Press.  Screen: %i, input %i", 2, [lastScreen2 integerValue]);
                
                
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
                    [self turnButton:(UIButton *)[self.view viewWithTag:[lastScreen1 intValue]] color:@"gray"];
                    lastScreen1 = [NSNumber numberWithInteger:(10 + [input intValue])];
                }
                else
                {
                    [self turnButton:(UIButton *)[self.view viewWithTag:[lastScreen2 intValue]] color:@"gray"];
                    lastScreen2 = [NSNumber numberWithInteger:(20 + [input intValue])];
                    
                }
                
                // send the command
                result = [self sendCommand:lookup[clicked]];
                UIButton *btn = (UIButton*)sender;
                [self turnButton:btn color:@"red"];
                
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
    
   
        // hered
        debugText.text = [NSString stringWithFormat:@"command: '%@'", response];
        return true;
        NSNumber *num = [f numberFromString:[response substringFromIndex:[response length] - 1]];
        
        NSLog(@"checkInput = %i is %i", [number integerValue], [num integerValue]);
        debugText.text = @"in checkinput...";
        debugText.text = [NSString stringWithFormat:@"checkInput = %i is %i", [number integerValue], [num integerValue]];
        
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
        debugText.text = [NSString stringWithFormat:@"error: %@", e];
    }
    
}

- (NSString *) sendCommand: (NSString *) command {
    NSLog(@"In send command, sending: %@", command);
    texty.text = command;
    // clear buffer
    [rscMgr getReadBytesAvailable];
    [rscMgr writeString:command];
//    [NSThread sleepForTimeInterval:0.5f];

    NSString *response = [NSString stringWithFormat:@"response: '%@'",[rscMgr getStringFromBytesAvailable]];
    NSLog(@"Response from Analog Way: '%@'", response);
//    debugText.text = response;
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

- (void) turnButton: (UIButton*) button color:(NSString*) color
{
    if ([color isEqualToString:@"red"])
    {
        // red
        [button setBackgroundColor:[UIColor colorWithRed:0.89 green:0.0 blue:0.0 alpha:90]];
    }
    else if ([color isEqualToString:@"gray"])
    {
        // gray
        [button setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:100]];
    }
    else if ([color isEqualToString:@"blue"])
    {
        // blue
        [button setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.89 alpha:100]];
        
    }
}

#pragma mark - RscMgrDelegate methods

- (void) cableConnected:(NSString *)protocol {
    connectLabel.text = @"Connected";

    [rscMgr setBaud:115200];
    [rscMgr open];
    //[self checkButtons];

    
    [self sendCommand:lookup[[NSNumber numberWithInt:11]]];
    [self turnButton:(UIButton *)[self.view viewWithTag:11] color:@"red"];
    lastScreen1 = @11;
    [self sendCommand:lookup[[NSNumber numberWithInt:22]]];
    [self turnButton:(UIButton *)[self.view viewWithTag:22] color:@"red"];
    lastScreen2 = @22;
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
