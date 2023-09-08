/* ho deciso di creare un database per l'azienda, dove lavoro attualmente, 
che svolge installazioni di sistemi di sicurezza e videosorveglianza*/ 

create database esercizio_finale;
use esercizio_finale;
/*creazione tabelle*/
create table dipendente(
	id int unsigned,
	cod_fisc varchar (100),
	nome varchar(255) not null,
	cognome varchar (255) not null,
	eta smallint unsigned,
	residenza varchar (255),
	telefono varchar(100),
	mansione varchar(255),
	contratto varchar (255),
	data_assunzione date,
	primary key (id, cod_fisc)
);

create table stipendio(
	cod_stip int unsigned auto_increment,
	id_dip int unsigned not null,
	salario decimal(10,2),
	data_sal date,
	primary key(cod_stip),
	constraint fk_idDip_id foreign key (id_dip) references dipendente(id) on update cascade on delete no action
);

create table cliente(
	id int unsigned,
	nome varchar (255) not null,
	cognome varchar (255) not null,
	indirizzo varchar (255),
	telefono varchar(100) not null,
	primary key (id)
);

create table fornitore(
	nome varchar(255),
	sede varchar(255),
	telefono varchar(100) not null,
	primary key (nome)
);

create table prodotto(
	nome varchar(255),
	prezzo_acq decimal(10,2) not null,
	prezzo_ven decimal(10,2),
	nome_fornitore varchar(255),
	primary key(nome),
	constraint fk_nomeFornitore_nome foreign key (nome_fornitore) references fornitore(nome) on update cascade on delete cascade
);

create table impianto(
	id int unsigned auto_increment,
	prod_inst varchar(255),
	data_inst date,
	id_inst int unsigned,
	id_cliente int unsigned,
	primary key (id),
	constraint fk_prodInst_codProd foreign key (prod_inst) references prodotto(nome) on update cascade on delete no action,
	constraint fk_idInst_id foreign key (id_inst) references dipendente(id) on update cascade on delete no action,
	constraint fk_idInst_idCliente foreign key (id_cliente) references cliente(id) on update cascade on delete no action
);

/*Inserimento dati*/
insert into dipendente 
values 
(1,'AAABBB91C84', 'Mario', 'Bianchi', 31, 'Firenze', '331223344', 'Responsabile', 'Indeterminato','2001-10-13'),
(2,'CCCDDD91C85', 'Antonio', 'Verdi', 25, 'Prato', '334525211', 'Operaio', 'Determinato','2022-05-17'),
(3,'EEEFFF91C74', 'Lorenzo', 'Rossi', 51, 'Firenze', '332654714', 'Responsabile', 'Indeterminato','1995-12-20'),
(4,'GGGHHH91C84', 'Angelo', 'Belli', 29, 'Firenze', '3396512547', 'Operaio', 'Indeterminato','2019-07-10'),
(5,'IIILLL91C84', 'Matteo', 'Senna', 26, 'Prato', '3359874123', 'Operaio', 'Determinato','2021-11-21')
;

insert into stipendio (id_dip,salario,data_sal)
values
(1,1900.00,'2023-01-01') ,
(2,1200.00,'2023-01-01'),
(3,1800.00,'2023-01-01'),
(4,1300.00,'2023-01-01'),
(5,1250.00,'2023-01-01'),
(1,1950.00,'2023-02-01'),
(2,1260.00,'2023-02-01'),
(3,1950.00,'2023-02-01'),
(4,1270.00,'2023-02-01'),
(5,1320.00,'2023-02-01'),
(1,1800.00,'2023-03-01'),
(2,1300.00,'2023-03-01'),
(3,1990.00,'2023-03-01'),
(4,1150.00,'2023-03-01'),
(5,1350.00,'2023-03-01'),
(1,1940.00,'2023-04-01'),
(2,1100.00,'2023-04-01'),
(3,2000.00,'2023-04-01'),
(4,1200.00,'2023-04-01'),
(5,1400.00,'2023-04-01')
;

insert into cliente
values
(1, 'Carlo', 'Verdi', 'Prato', '33322211'),
(2, 'Anna', 'Fenna', 'Prato', '332265445'),
(3, 'Enzo', 'Balli', 'Firenze', '332265485'),
(4, 'Giulio', 'Coralli', 'Firenze', '33322222'),
(5, 'Serena', 'Grandi', 'Prato', '33355211')
;

insert into fornitore
values
('Tecnoalarm', 'Torino', '339874210'),
('Visiotech', 'Barcellona', '15151515'),
('Hikvision', 'Cina', '44114141'),
('Paradox', 'New York', '051550005')
;

insert into prodotto
values
('Tp10-24', 500.00,null, 'Tecnoalarm'),
('nvr2050', 150.00,300.00, 'Hikvision'),
('ev50',450.00, 800.00, 'Tecnoalarm'),
('mg5050', 250.00,500.00, 'Paradox'),
('cam4mp', 150.00,null, 'Visiotech'),
('switch8p', 30.00, 100.00, 'Visiotech')
;

insert into impianto (prod_inst, data_inst,id_inst,id_cliente)
values
('nvr2050','2018-05-06',4,2),
('ev50','2018-07-06',2,3),
('nvr2050','2018-12-06',4,1),
('cam4mp','2017-01-06',4,5),
('ev50','2020-05-06',5,2)
;

/*interrogazioni*/

/*selezionare i clienti che non hanno mai installato il prodotto nvr2050*/
select *
from cliente 
where id not in (
	select id_cliente
	from impianto
	join cliente on impianto.id_cliente=cliente.id
	where prod_inst='nvr2050')
;

/*visualizzare l'impianto installato di cui non si conosce il prezzo di vendita del prodotto installato*/
select *
from impianto
join prodotto on impianto.prod_inst=prodotto.nome
where prezzo_ven is null
;

/*visualizzare la somma degli stipendi per ogni dipendente con eta' inferiore ai 30 anni*/
select dipendente.nome, sum(salario)
from stipendio
join dipendente on stipendio.id_dip=dipendente.id
where dipendente.eta<30
group by dipendente.nome

;

/*dipendente che ha ricevuto almeno una volta il salario maggiore di €1700.00*/
select distinct nome,cognome
from dipendente
join stipendio on dipendente.id=stipendio.id_dip
where salario>1700.00
;

/*visualizzare la data assunzione di ogni dipendente e il salario di marzo*/
select dipendente.nome, dipendente.cognome, dipendente.data_assunzione, stipendio.data_sal, stipendio.salario
from dipendente
join stipendio on dipendente.id=stipendio.id_dip
where month(stipendio.data_sal)=03;

/*visualizzare il salario dei responsabili nel mese di aprile*/
select dipendente.id,dipendente.nome, dipendente.cognome, stipendio.salario
from dipendente
join stipendio on dipendente.id=stipendio.id_dip
where dipendente.mansione='Responsabile' and month(stipendio.data_sal)=04;

/*selezionare per ogni dipendente la media dei salari ricevuti*/
select dipendente.nome, avg(stipendio.salario)
from dipendente
join stipendio on dipendente.id=stipendio.id_dip
group by dipendente.nome
having avg(stipendio.salario)>1300.00;

/*mostra i prodotti venduti dai fornitori la cui sede inizia con 'T'*/
select prodotto.nome, nome_fornitore
from prodotto
join fornitore on prodotto.nome_fornitore=fornitore.nome
where fornitore.sede like 'T%';

/*seleziona i clienti che hanno installato prodotti 'HIKVISION'*/
select *
from cliente
join impianto on cliente.id=impianto.id_cliente
join prodotto on impianto.prod_inst=prodotto.nome
where prodotto.nome_fornitore='Hikvision';

/*selezionare gli impianti eseguiti a Firenze e con il nome del cliente che finisce per 'A'*/
select impianto.id as imp, cliente.nome, cliente.cognome
from impianto
join cliente on impianto.id_cliente=cliente.id
where cliente.indirizzo='Prato' and cliente.nome like '%a';



