create database ecommerceRefinado;
use ecommerceRefinado;

create table clients (
		idClient int auto_increment primary key,
        Fname varchar(10),
        Mint char(3),
        Lname varchar(20),
        CPF char (11) not null,
        Address varchar(30),
        constraint unique_cpf_client unique (CPF)
);

insert into clients (Fname, Mint, Lname, CPF, Address)
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
		idOrders int auto_increment primary key,
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
        id_payment int auto_increment,
        typePayment enum('Boleto','Cartão','Dois cartões'),
        limitAvaliable float,
        primary key(Idclient, id_payment)
);

insert into  payments (idclient,typePayment,limitAvaliable) values
						(1,'Boleto',200),
                        (2,'Cartão',3000),
                        (3,'Cartão',500);

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
        idPssupplier int,
        idpsProduct varchar (25),
        quantity varchar(25),
        constraint fk_productsupplier_Supplier foreign key (idPssupplier) references supplier(idSupplier),
        constraint fk_productsupplier_product foreign key (idpsProduct) references product(idProduct)
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
        constraint fk_product_product foreign key (idPOorder) references orders(idOrders)
);

insert into productOrder(idPOproduct,idPOorder,poQuantity,postStatus) values
							(1,1,2,null),
                            (2,1,1,null),
                            (3,2,1,null);
			
create table storageLocation(
		idLstorage int, 
        idLproduct int,
        idSLSupplier int,
        location varchar (255) not null,
        primary key (idLstorage),
        constraint fk_client_orders foreign key (idLproduct) references product(idProduct),
		constraint fk_Location_supplier foreign key (idSLSupplier) references supplier(idSupplier)
);

insert into storageLocation (idLproduct,idLstorage,location) values
						(1,2,'R'),
                        (2,6,'GO');
                        
                        
create table delivery(
		idDelivery int primary key auto_increment,
        deliveryOrder int,
        deliveryType enum ('Normal', 'Agendado','Express'),
        deliveryTracking varchar(25) not null,
        deadline date,
        constraint fk_product_order foreign key (deliveryOrder) references orders(idOrders)
);

insert into delivery(idDelivery,deliveryOrder,deliveryType,deliveryTracking,deadline) values
					(1,1,'Normal','N522','2022-08-30'),
                    (2,2,'Agendado','A533','2022-09-15'),
                    (3,3,'Express','E534','2022-08-27');
                    
create table deliveryStatus(
		idDeliveryStatus int auto_increment primary key,
        idDelivery int,
        deliveryStatus enum ('Pedido recebido', 'NF emitida', 'Peparando para o envio', 'Saiu para entrega'),
        constraint fk_delivery_Status foreign key (idDelivery) references delivery(idDelivery)
        
);

insert into deliveryStatus(idDelivery,deliveryStatus) values
							(1,'NF emitida'),
                            (2,'Pedido recebido'),
                            (3,'Saiu para entrega');

-- What is the type of payment most used 
select typePayment, count(*) from payments
group by typePayment;

-- What is the category of products
select category,count(*) from product
group by category;

-- Products with the best scores
select Pname,avaliação from product	
where avaliação >=3;

-- Delivery price of confirmed orders
select idOrders,ordersStatus,sendValue from Orders
having ordersStatus = 'Confirmado';

-- What is the sales platform for this product?
select product.Pname as Product_name, orders.ordersDescripition as sales_platform from product
join productOrder
on product.idProduct = productOrder.idPOproduct
join orders
on orders.idOrders = productOrder.idPOorder;

-- List of products, suppliers and inventories;
select supplier.socialName, product.Pname,storageLocation.location from supplier
inner join storageLocation
on supplier.idSupplier = storageLocation.idSLSupplier
inner join product
on product.idProduct = storageLocation.idLproduct;

-- List of supplier names and product names;
select supplier.socialName, product.Pname as Product_name from supplier
inner join productsupplier
on supplier.idSupplier = productsupplier.idPssupplier
inner join product
on product.idProduct = productsupplier.idpsProduct;

-- Products by sellers
select seller.socialName as Social_name, product.Pname as Product_name from seller
inner join productSeller
on seller.idSeller = productSeller.idPseller
inner join product
on product.idProduct = productSeller.idProduct;

-- How many orders were placed by each customer?
select concat(clients.Fname,' ',clients.Lname) as Clients_name ,clients.CPF,count(Orders.idOrdersClient) as Numbers_of_Orders from clients
inner join Orders
on clients.idClient = Orders.idOrdersClient
group by idOrdersClient;

select * from clients c, orders o where c.idClient = idOrders;

select Fname,Lname,idOrders,ordersStatus from clients c, orders o where c.idClient = idOrders;

select concat (Fname,' ',Lname) as Clients, idOrders as Request, ordersStatus as Status from clients c, orders o where c.idClient = idOrders;

-- how many orders were placed by customers ?
select c.idClient,Fname, count(*) as Number_of_orders from clients c 
						inner join orders o ON c.idClient = idOrders
						inner join productOrder p on p.idPOorder = idOrders
		group by  idClient;

select idOrdersClient from orders o
			inner join  deliveryStatus ds on o.idOrdersClient = deliveryStatus
            inner join product p on p.Pname = deliveryStatus;
	  