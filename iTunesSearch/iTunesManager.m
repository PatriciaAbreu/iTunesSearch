//
//  iTunesManager.m
//  iTunesSearch
//
//  Created by joaquim on 09/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "iTunesManager.h"
#import "Entidades/Filme.h"
#import "Entidades/Musica.h"
#import "Entidades/Podcast.h"
#import "Entidades/Ebook.h"

@implementation iTunesManager

@synthesize session;

static iTunesManager *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}


- (NSArray *)buscarMidias:(NSString *)termo {
    if (!termo) {
        termo = @"";
    }
    
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&media=all", termo];
    
    NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    NSError *error;
    NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
    if (error) {
        NSLog(@"Não foi possível fazer a busca. ERRO: %@", error);
        return nil;
    }
    
    NSArray *resultados = [resultado objectForKey:@"results"];
    NSMutableArray *filmes = [[NSMutableArray alloc] init];
    NSMutableArray *musicas = [[NSMutableArray alloc] init];
    NSMutableArray *podcasts = [[NSMutableArray alloc] init];
    NSMutableArray *eBooks = [[NSMutableArray alloc] init];
    
    Entidade *entidade;
    for (NSDictionary *item in resultados) {
        if ([[item objectForKey:@"kind"] isEqualToString:@"feature-movie"]) {
            
            entidade = [[Filme alloc] init];
            [entidade setNome:[item objectForKey:@"trackName"]];
            [entidade setTrackId:[item objectForKey:@"trackId"]];
            [entidade setArtista:[item objectForKey:@"artistName"]];
            [entidade setDuracao:[item objectForKey:@"trackTimeMillis"]];
            [entidade setGenero:[item objectForKey:@"primaryGenreName"]];
            [entidade setPais:[item objectForKey:@"country"]];
            [entidade setImagem:[item objectForKey:@"artworkUrl30"]];
            [filmes addObject:entidade];
        }
        if ([[item objectForKey:@"kind"] isEqualToString:@"song"]) {
            
            entidade = [[Musica alloc]init];
            [entidade setNome:[item objectForKey:@"trackName"]];
            [entidade setTrackId:[item objectForKey:@"trackId"]];
            [entidade setArtista:[item objectForKey:@"artistName"]];
            [entidade setDuracao:[item objectForKey:@"trackTimeMillis"]];
            [entidade setGenero:[item objectForKey:@"primaryGenreName"]];
            [entidade setPais:[item objectForKey:@"country"]];
            [entidade setImagem:[item objectForKey:@"artworkUrl30"]];
            [musicas addObject:entidade];
        }
        if ([[item objectForKey:@"kind"] isEqualToString:@"podcast"]) {
            
            entidade = [[Podcast alloc]init];
            [entidade setNome:[item objectForKey:@"trackName"]];
            [entidade setTrackId:[item objectForKey:@"trackId"]];
            [entidade setArtista:[item objectForKey:@"artistName"]];
            [entidade setDuracao:[item objectForKey:@"trackTimeMillis"]];
            [entidade setGenero:[item objectForKey:@"primaryGenreName"]];
            [entidade setPais:[item objectForKey:@"country"]];
            [entidade setImagem:[item objectForKey:@"artworkUrl30"]];
            [podcasts addObject:entidade];
        }
        if ([[item objectForKey:@"kind"] isEqualToString:@"ebook"]) {
            
           entidade= [[Ebook alloc]init];
            [entidade setNome:[item objectForKey:@"trackName"]];
            [entidade setTrackId:[item objectForKey:@"trackId"]];
            [entidade setArtista:[item objectForKey:@"artistName"]];
//            [entidade setNumPaginas:[item objectForKey:@"trackTimeMillis"]];
            [entidade setGenero:[item objectForKey:@"primaryGenreName"]];
//            [entidade setPais:[item objectForKey:@"country"]];
            [entidade setImagem:[item objectForKey:@"artworkUrl30"]];
            [eBooks addObject:entidade];
        }
    }
    


    session = [[NSMutableArray alloc] initWithObjects:filmes, musicas, podcasts, eBooks, nil];
    return session;
    
}




#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[iTunesManager alloc] init];
}

- (id)mutableCopy
{
    return [[iTunesManager alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
