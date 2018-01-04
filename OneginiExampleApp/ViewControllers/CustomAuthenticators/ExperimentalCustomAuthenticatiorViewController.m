//  Copyright © 2018 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ExperimentalCustomAuthenticatiorViewController.h"
#import "OneginiSDK.h"

@interface ExperimentalCustomAuthenticatiorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ExperimentalCustomAuthenticatiorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.customAuthFinishRegistrationChallenge = self.customAuthFinishRegistrationChallenge;
    self.customAuthFinishAuthenticationChallenge = self.customAuthFinishAuthenticationChallenge;
}

- (void)setCustomAuthFinishRegistrationChallenge:(ONGCustomAuthFinishRegistrationChallenge *)customAuthFinishRegistrationChallenge
{
    _customAuthFinishRegistrationChallenge = customAuthFinishRegistrationChallenge;
    self.titleLabel.text = @"Registration";
}

- (void)setCustomAuthFinishAuthenticationChallenge:(ONGCustomAuthFinishAuthenticationChallenge *)customAuthFinishAuthenticationChallenge
{
    _customAuthFinishAuthenticationChallenge = customAuthFinishAuthenticationChallenge;
    self.titleLabel.text = @"Authentication";
}

- (IBAction)success:(id)sender
{
    if (self.customAuthFinishAuthenticationChallenge) {
        [self.customAuthFinishAuthenticationChallenge.sender respondWithData:@"data" challenge:self.customAuthFinishAuthenticationChallenge];
    } else if (self.customAuthFinishRegistrationChallenge) {
        [self.customAuthFinishRegistrationChallenge.sender respondWithData:@"data" challenge:self.customAuthFinishRegistrationChallenge];
    }
}

- (IBAction)failure:(id)sender
{
    if (self.customAuthFinishAuthenticationChallenge) {
        [self.customAuthFinishAuthenticationChallenge.sender cancelChallenge:self.customAuthFinishAuthenticationChallenge underlyingError:nil];
    } else if (self.customAuthFinishRegistrationChallenge) {
        [self.customAuthFinishRegistrationChallenge.sender cancelChallenge:self.customAuthFinishRegistrationChallenge underlyingError:nil];
    }
}


- (IBAction)error:(id)sender
{
    NSError *error = [NSError new];
    if (self.customAuthFinishAuthenticationChallenge) {
        [self.customAuthFinishAuthenticationChallenge.sender cancelChallenge:self.customAuthFinishAuthenticationChallenge underlyingError:error];
    } else if (self.customAuthFinishRegistrationChallenge) {
        [self.customAuthFinishRegistrationChallenge.sender cancelChallenge:self.customAuthFinishRegistrationChallenge underlyingError:error];
    }
}

@end
