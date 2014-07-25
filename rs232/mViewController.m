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
    
    NSDictionary *lookup = @{
         [NSNumber numberWithInt:0] : @"??0", // swap
         [NSNumber numberWithInt:10] : @"??10", // logo 1
         [NSNumber numberWithInt:11] : @"0,1,1,1PRinp0,1PUscu0,1GCtak",
         [NSNumber numberWithInt:12] : @"??12",
         [NSNumber numberWithInt:13] : @"??13",
         [NSNumber numberWithInt:14] : @"??14",
         [NSNumber numberWithInt:19] : @"0GCfsc1", // freeze 1
         [NSNumber numberWithInt:20] : @"??20", // logo 2
         [NSNumber numberWithInt:21] : @"1,1,1,1PRinp1,1PUscu1,1GCtak",
         [NSNumber numberWithInt:22] : @"??22",
         [NSNumber numberWithInt:23] : @"??23",
         [NSNumber numberWithInt:24] : @"??24",
         [NSNumber numberWithInt:29] : @"??29", // freeze 2
    };

    NSNumber *clicked = [NSNumber numberWithInt:[sender tag]];
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
            break;
        }
        case 19: {
            // freeze 1 toggle
            break;
        }
        case 20: {
            // logo 2 toggle
            break;
        }
        case 29: {
            // freeze 2 toggle
            break;
        }
        
        // handle normal inputs
        default: {
            NSNumber *input = [NSNumber numberWithInt:([clicked integerValue] % 10)];
            
            NSNumber *screen = [NSNumber numberWithInt:(([clicked integerValue] / 10) % 10)];
            
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
            
            NSLog(@"Default Screen: %i, input %i", [screen integerValue], [input integerValue]);
            
            break;
        }
    }
    
    NSLog(@"button pushed, screen1 == %i, screen2 == %i", [lastScreen1 integerValue], [lastScreen2 integerValue]);
    
    NSLog(@"Button clicked %d, string: %@", [clicked integerValue], lookup[clicked]);
//    uint8_t *someInt = (uint8_t *)[lookup[[NSNumber numberWithInt:clicked]] UTF8String];
//    [rscMgr write:someInt Length:[lookup[[NSNumber numberWithInt:clicked]] length]];
//    [rscMgr writeString:lookup[[NSNumber numberWithInt:clicked]]];
    
     texty.text = lookup[clicked];
     debugText.text = result;
}

- (NSString *) sendCommand: (NSString *) command {
    [rscMgr writeString:command];
    return [rscMgr getStringFromBytesAvailable];
}


#pragma mark - RscMgrDelegate methods

- (void) cableConnected:(NSString *)protocol {
    connectLabel.text = @"Connected";

    [rscMgr setBaud:115200];
    [rscMgr open];
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
