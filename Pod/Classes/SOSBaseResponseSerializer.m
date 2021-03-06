//
//  SailsBaseResponseSerializer.m
//  sails.ios
//
//  Created by Chris Chares on 5/15/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "SOSBaseResponseSerializer.h"
#import "SOSSerializable.h"

@implementation SOSBaseResponseSerializer

- (id)init
{
    self = [super init];
    if ( self ) {
        self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
        self.removesKeysWithNullValues = YES;
    }
    
    return self;

}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    id JSON = [super responseObjectForResponse:response data:data error:error];
    
    if ( JSON ) {
        if ( [JSON isKindOfClass:[NSDictionary class]] && [[JSON objectForKey:@"data"] isKindOfClass:[NSArray class]] ) {
            NSMutableArray *models = [[NSMutableArray alloc] init];
            for ( id object in JSON[@"data"] ) {
                id model = [self modelForDictionary:object];
                [models addObject:model];
            }
            return models;
        } else if ( [JSON isKindOfClass:[NSDictionary class]] ) {
            return [self modelForDictionary:JSON];
        } else {
            
            NSLog(@"json object isn't a dictionary or an array %@", JSON);
            return nil;
        }
    } else {
        NSLog(@"Error parsing json %@", [*error localizedDescription]);
        return nil;
    }

}
- (BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    return [super validateResponse:response data:data error:error];
}

- (id)modelForDictionary:(NSDictionary *)dictionary
{
   
    if ( _modelClass ) {
        return [_modelClass fromDictionary:dictionary];
    } else {
        return dictionary;

    }
}
@end
