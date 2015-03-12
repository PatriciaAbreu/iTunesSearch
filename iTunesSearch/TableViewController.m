//
//  ViewController.m
//  iTunesSearch
//
//  Created by joaquim on 09/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "iTunesManager.h"
#import "Entidades/Filme.h"
#import "Entidades/Musica.h"
#import "Entidades/Podcast.h"
#import "Entidades/Ebook.h"

@interface TableViewController () {
    NSArray *midias;
    NSUserDefaults *userDefault;
    NSArray *midias2;
}

@end

@implementation TableViewController

@synthesize textBuscador, buttonBuscador;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"celulaPadrao"];
    userDefault = [NSUserDefaults standardUserDefaults];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    

#warning Necessario para que a table view tenha um espaco em relacao ao topo, pois caso contrario o texto ficara atras da barra superior
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableview.bounds.size.width, 45.f)];
    
    textBuscador = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 20.0f, 230.0f, 25.0f)];
    [textBuscador setBorderStyle:UITextBorderStyleRoundedRect];
    
    buttonBuscador = [[UIButton alloc] initWithFrame:CGRectMake(240.0f, 20.0f, 60.0f, 25.0f)];
    
    [buttonBuscador addTarget:self action:@selector(buttonBuscador:) forControlEvents:UIControlEventTouchUpInside];

    [buttonBuscador setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBuscador setTitle:@"Buscar"forState: UIControlStateNormal];
    [buttonBuscador setFont:[UIFont boldSystemFontOfSize:15.0f]];

    [self.tableview.tableHeaderView addSubview:textBuscador];
    [self.tableview.tableHeaderView addSubview:buttonBuscador];
   

    //    if (userDefault == nil) {
    iTunesManager *iTunes = [iTunesManager sharedInstance];
    midias = [iTunes buscarMidias:@"Apple"];
    
//    }else{
//        iTunesManager *itunes = [iTunesManager sharedInstance];
//        NSString *aux = textBuscador.text;
//        aux = [aux stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    }
    
//    Mudança de Idioma
    NSString *idioma = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([idioma isEqualToString:@"pt"]){
        [buttonBuscador setTitle:@"Buscar" forState:UIControlStateNormal];
        textBuscador.placeholder = @"Digite aqui o que deseja procurar";
    }
    if ([idioma isEqualToString:@"en"]){
        [buttonBuscador setTitle:@"Search" forState:UIControlStateNormal];
        textBuscador.placeholder = @"Type here what you want to search";
    }
    if ([idioma isEqualToString:@"fr"]){
        [buttonBuscador setTitle:@"Recherche" forState:UIControlStateNormal];
        textBuscador.placeholder = @"Tapez ici ce que vous voulez rechercher";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Metodos do UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [midias count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[midias objectAtIndex:section]count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Filme";
            break;
        case 1:
            return @"Musica";
            break;
        case 2:
            return @"Podcast";
            break;
        case 3:
            return @"Ebook";
            break;
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *celula = [self.tableview dequeueReusableCellWithIdentifier:@"celulaPadrao"];

    Filme *filme;
    Musica *musica;
    Podcast *podcast;
    Ebook *eBook;
    
//    midias2 = [[NSArray alloc] initWithArray:[midias objectAtIndex:indexPath.section]];
    
    switch (indexPath.section) {
        case 0:
            filme =[[midias objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [celula.nome setText:filme.nome];
            [celula.tipo setText:@"Filme"];
            [celula.artista setText:filme.artista];
            return celula;
            break;
         case 1:
            musica = [[midias objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [celula.nome setText:musica.nome];
            [celula.tipo setText:@"Musica"];
            [celula.artista setText:musica.artista];
            return celula;
            break;
        case 2:
            podcast = [[midias objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [celula.nome setText:podcast.nome];
            [celula.tipo setText:@"Podcast"];
            [celula.artista setText:podcast.artista];
            return celula;
            break;
        case 3:
            eBook = [[midias objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [celula.nome setText:eBook.nome];
            [celula.tipo setText:@"eBook"];
            [celula.artista setText:eBook.autor];
            return celula;
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Metodo do botão buscador

-(IBAction)buttonBuscador:(id)sender{
    iTunesManager *itunes = [iTunesManager sharedInstance];
    _text = textBuscador.text;
    _text = [_text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    midias = [itunes buscarMidias:_text];
    
    [userDefault setObject:@"TextToSave" forKey:@"keyToLookupString"];
    
    [_tableview reloadData];
    [textBuscador resignFirstResponder];
}



@end
