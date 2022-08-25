create database ecommerce;
use ecommerce;

create table client (
		idClient int auto_increment primary key,
        Fname varchar(10),
        Mint char(3),
        Lname varchar(20),
        CPF char (11) not null,
        Address varchar(30),
        constraint unique_cpf_client unique (CPF)
);

insert into client (Fname, Mint, Lname, CPF, Address)
values ('Maria', 'M','Silva','123456789', 'rua silva da prata 29'),
	   ('Maria2', 'M','Silva','123456788', 'rua silva da prata 22'),
       ('Maria3', 'M','Silva','123456787', 'rua silva da prata 23'),
       ('Maria4', 'M','Silva','123456786', 'rua silva da prata 24'),
       ('Maria5', 'M','Silva','123456785', 'rua silva da prata 25' ),
       ('Maria4', 'M','Silva','123456784', 'rua silva da prata 26' );

alter table client auto_increment=1;
        
create table product(
		IdProduct int auto_increment primary key,
        Pname varchar(10) not null,
        classification_kids bool default false,
        category enum('Eletronico','Vestimenta','Alimentos','Brinquedos', 'Moveis') not null,
        avaliação float default 0,
        size varchar(10)
);

insert into product (Pname, classification_kids,category, avaliação,size ) values
								('Fone',false,'Eletronico','4',null),
                                ('Barbie',true,'Brinquedos','3',null),
                                ('Microfone',false, 'Eletronico','4',null),
                                ('Sofa',false, 'Moveis','3','3x57x80'),
                                ('farinha', false, 'Alimentos','2', null),
                                ('amazon',false,'Eletronico','3',null);

create table Orders(
		idProduct int auto_increment primary key,
        idOrdersClient int,
        ordersStatus enum('Cancelado','Confirmado','Em processamento'),
        ordersDescripition varchar(255),
        sendValue float default 10,
        paymentCash bool default false,
        constraint fk_orders_client foreign key (idOrdersClient) references client(idClient)
);


insert into Orders(idOrdersClient,ordersStatus, ordersDescripition,sendValue, paymentCash) values
							(1,default,'compra via app',null,1),
                            (2,default,'compra via app',50,0),
                            (1,'Confirmado',null,null,1),
                            (4,default,'web',150,0);

create table payments(
		idclient int,
        id_payment int,
        typePayment enum('Boleto','Cartão','Dois cartões'),
        limitAvaliable float,
        primary key(Idclient, id_payment)
);

create table productStorage(
		idProductStorage int auto_increment primary key,
        storageLocation varchar(255),
        quantity int default 0
);

insert into productStorage (storageLocation,quantity)values
								('Rj',1000),
                                ('Rj',500),
                                ('SP',10),
                                ('SP',100),
                                ('SP',10),
                                ('Brasilia',60);

create table supplier(
		idSupplier int auto_increment primary key,
        socialName varchar(255) not null,
        CNPJ char (15) not null,
        contact char(11) not null,
        constraint unique_supplier unique (CNPJ)
);

insert into supplier (socialName,CNPJ,contact) values
						('Almeida filhos',123456789123456,'38537556'),
                        ('Eletronicos silva',123456789123879,'38537656'),
                        ('Almeida filhos',123456789123886,'38537576');

create table productsupplier(
		idProductSupplier int auto_increment primary key,
        idPssupplier varchar(25),
        idpsProduct varchar (25),
        quantity varchar(25)
);

insert into productsupplier (idPssupplier,idpsProduct,quantity) values
								(1,1,500),
                                (1,1,400),
                                (2,4,633),
                                (3,3,5),
                                (2,5,10);
                        
create table seller(
		idSeller int auto_increment primary key,
        socialName varchar(255) not null,
        abstName varchar(255),
        CNPJ char (15) ,
        CPF char (9),
        location varchar (255),
        contact char(11) not null,
        constraint unique_cnpj_seller unique (CNPJ),
        constraint unique_cpf_seller unique (CPF)	
);

insert into seller (socialName,abstName,CNPJ, CPF,location, contact) values
						('tech eletronic',null,123456789123456,null,'RJ',219956287),
                        ('tech eletronic2',null,123456789123452,null,'RJ',219956282),
                        ('tech eletronic3',null,123456789123453,null,'RJ',219956283);
                        
create table productSeller(
		idPseller int,
        idProduct int,
        quantity int not null default 1,
        primary key (idPseller, idProduct),
        constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
        constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

insert into productSeller(idPseller,idProduct,quantity)values
						 (1,6,80),
                         (2,7,10);

create table productOrder(
		idPOproduct int,
        idPOorder int,
        poQuantity int not null default 1,
        postStatus enum ('Disponivel', 'Sem estoque') default 'Disponivel',
        primary key (idPOproduct, idPOorder),
        constraint fk_product_seller foreign key (idPOproduct) references product(idProduct),
        constraint fk_product_product foreign key (idPOorder) references orders(idProduct)
);

insert into productOrder(idPOproduct,idPOorder,poQuantity,postStatus) values
							(1,1,2,null),
                            (2,1,1,null),
                            (3,2,1,null);

create table storageLocation(
		idLproduct int,
        idLstorage int,
        location varchar (255) not null,
        primary key (idLproduct, idLstorage),
        constraint fk_product_seller foreign key (idLproduct) references product(idProduct),
        constraint fk_product_product foreign key (idLstorage) references orders(idProduct)
);

insert into storageLocation (idLproduct,idLstorage,location) values
						(1,2,'R'),
                        (2,6,'GO');

select * from client c, orders o where c.idClient = idOrdersClient;

select Fname,Lname,idOrdersClient,ordersStatus from client c, orders o where c.idClient = idOrdersClient;

select concat (Fname,' ',Lname) as Client, idOrdersClient as Request, ordersStatus as Status from client c, orders o where c.idClient = idOrdersClient;

select * from client c, orders o
			where c.idClient = idOrdersClient;

-- how many orders were placed by customers ?
select c.idClient,Fname, count(*) as Number_of_orders from client c 
						inner join orders o ON c.idClient = idOrdersClient
						inner join productOrder p on p.idPOorder = idOrdersClient
		group by  idClient;
					

