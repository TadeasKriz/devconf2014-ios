//
// Created by Tadeas Kriz on 03/02/14.
// Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCTask : NSObject

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSNumber* done;

- (NSDictionary*)toDictionary;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end