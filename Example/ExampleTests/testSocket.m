//
//  testServer.m
//  sails.ios
//
//  Created by Chris Chares on 5/19/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "SailsIOS.h"
#import "MockUser.h"
#import "MockPost.h"


@interface testSocket : XCTestCase

@property SailsIOS *sails;


@end

@implementation testSocket

- (void)setUp
{
    [super setUp];

    _sails = [[SailsIOS alloc] initWithBaseURLString:@"http://localhost:1337"];
    _sails.defaultProtocol = SailsProtocolSockets;
}

- (void)tearDown
{
    
    [_sails.socket disconnect];
    [super tearDown];
}

- (void)testHost
{
    expect(_sails.socket.host).to.equal(@"localhost");
}
- (void)testPort
{
    expect(_sails.socket.port).to.equal(1337);
}

- (void)testConnect
{
    
    __block BOOL connected = NO;
    _sails.socket.connectedBlock = ^(SocketIO *socket){
        connected = YES;
    };
    [_sails.socket connect];
    
    expect(connected).will.beTruthy();
}

- (void)testGetUsers
{
    __block NSArray *users;

    _sails.socket.connectedBlock = ^(SocketIO *socket){
        [_sails get:@"/user" data:nil callback:^(NSError *error, id response) {
            users = response;
        }];
    };
    [_sails.socket connect];
    expect(users).willNot.beNil();
}

- (void)testCreatePost
{
    MockUser *user = [MockUser testOne];
   __block  id returnedUser;
    _sails.socket.connectedBlock = ^(SocketIO *socket){
   
        
        [_sails post:@"/user" data:user callback:^(NSError *error, id response) {
            returnedUser = response;
        }];
        
        
        
    };
    [_sails.socket connect];
    expect(returnedUser).willNot.beNil();
}


@end







