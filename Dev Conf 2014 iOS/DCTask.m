//
// Created by Tadeas Kriz on 03/02/14.
// Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import "DCTask.h"


@implementation DCTask {

}
- (NSDictionary*)toDictionary {
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    if(self.id) {
        [dictionary setObject:self.id forKey:@"id"];
    }
    if(self.text) {
        [dictionary setObject:self.text forKey:@"text"];
    }
    if(self.done) {
        [dictionary setObject:self.done forKey:@"done"];
    }

    return dictionary;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.id = [dictionary objectForKey:@"id"];
        self.text = [dictionary objectForKey:@"text"];
        self.done = [dictionary objectForKey:@"done"];
    }

    return self;

}

@end