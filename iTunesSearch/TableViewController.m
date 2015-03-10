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

@interface TableViewController () {
    NSArray *midias;
}

@end

@implementation TableViewController

@synthesize textBuscador, buttonBuscador;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"celulaPadrao"];
    
    

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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Metodos do UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [midias count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *celula = [self.tableview dequeueReusableCellWithIdentifier:@"celulaPadrao"];
    
    Filme *filme = [midias objectAtIndex:indexPath.row];
    
    [celula.nome setText:filme.nome];
    [celula.tipo setText:@"Filme"];
    [celula.artista setText:filme.artista];
    
    return celula;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(IBAction)buttonBuscador:(id)sender{
    iTunesManager *itunes = [iTunesManager sharedInstance];
    _text = textBuscador.text;
    _text = [_text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    midias = [itunes buscarMidias:_text];
    
    [_tableview reloadData];
    
}
@end
