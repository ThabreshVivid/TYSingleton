//
//  ViewController.m
//  AFNetworkingSingleton
//
//  Created by Thabresh on 8/29/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "ViewController.h"
#import "AFSingleTon.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickToCallSinglton:(id)sender {    
    AFSingleTon * sharedClient = [AFSingleTon sharedClient];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:@"44.1" forKey:@"north"];
    [params setObject:@"-9.9" forKey:@"south"];
    [params setObject:@"-22.4" forKey:@"east"];
    [params setObject:@"55.2" forKey:@"west"];
    [params setObject:@"de" forKey:@"lang"];
    [params setObject:@"demos" forKey:@"username"];
    [sharedClient SessionCall:params MethodName:@"citiesJSON" success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response:%@",response);
        if ([[[response objectForKey:@"status"]valueForKey:@"message"]length]>0) {
            self.respondTxt.text = [NSString stringWithFormat:@"Message : %@\n\nValue : %@",[[response objectForKey:@"status"]valueForKey:@"message"],[[response objectForKey:@"status"]valueForKey:@"value"]];
        }else{
            for (int i=0; i<[[[response objectForKey:@"geonames"]valueForKey:@"toponymName"]count]; i++) {
                self.respondTxt.text = [NSString stringWithFormat:@"%@\n%@",self.respondTxt.text,[[[response objectForKey:@"geonames"]valueForKey:@"toponymName"] objectAtIndex:i]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [sharedClient.manager.requestSerializer clearAuthorizationHeader];
        NSLog(@"responseString:%@",operation.responseString);
        NSLog(@"error:%@",error.description);
        UIAlertController *controll = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:controll animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
