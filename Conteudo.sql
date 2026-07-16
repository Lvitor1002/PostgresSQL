

ALUNO (1) - (N) EMPRESTIMO -> 
                            Quando temos uma relação 1:N, a chave estrangeira vai sempre para o lado N.

create table "Cliente"(
    "IdCliente" int not null,
    "Nome" varchar(50) not null, 
    "Cpf" char(11),                     --Use CHAR para dados de tamanho fixo (UF, CPF formatado, sexo, cpf).
    "Rg" varchar(15),
    "DataNascimento" date,
    "Genero" char(1),
    "Profissao" varchar(30),
    "Nacionalidade" varchar(30),        --Use VARCHAR para textos variáveis (nome, email, descrição).
    
    -- Vem da tabela(cliente) | referencia a coluna IdCliente
    constraint pk_Cliente_IdCliente primary key ("IdCliente") 
)

create table "Endereco"(
    "IdEndereco" int not null,
    "Logradouro" varchar(30),
    "Numero" varchar(10),
    "Complemento" varchar(30),
    "Bairro" varchar(30),
    "Municipio" varchar(30),
    "Uf" char(2),
    "Observacoes" text,

    constraint pk_Endereco_IdEndereco primary key ("IdEndereco")
)

create table "Profissao"(
     "IdProfissao" int generated always as identity,
    "Nome" varchar(30) not null,
    constraint pk_Profissao_IdProfissao primary key ("IdProfissao")
)


-- Tornando PK em auto-incremend:

alter table "Cliente" alter column "IdCliente" add generated always as identity;

-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Add foreign key(chave estrangeira) na tabela:

alter table "Endereco" add constraint fk_Endereco_Cliente foreign key ("IdCliente") references "Cliente" ("IdCliente")

-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Add coluna na tabela:

alter table "Endereco" add column "IdClientee" int not null;

-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Atualizar dados da coluna com UPDATE

update "Cliente" set "Nome" = 'Luiz Vitor P. Da Silva' where "IdCliente" = 1

update "Cliente" set "DataNascimento" = '11-05-2025', "Profissao" = 'Desenvolvedor c#' where "IdCliente" = 1

-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Deletar dados da coluna com DELETE

delete from "Cliente" where "IdCliente" = 1

-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Renomear nome de uma coluna

alter table "nome_tabela" rename column "nome_atual_coluna" to "novo_nome_coluna" 


-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Alterar o tipo de uma coluna
ALTER TABLE "Cliente" ALTER COLUMN "IdProfissao" TYPE NOVO_TIPO;


-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Remover uma coluna
ALTER TABLE "Cliente" DROP COLUMN "IdProfissao";

-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

create table "Fornecedor"(
"IdFornecedor" int not null generated always as identity primary key,
"Nome" varchar(50) not null unique
)

create table "Vendedor"(
"IdVendedor" int not null generated always as identity primary key,
"Nome" varchar(50) not null unique 
)

create table "Municipio"(
"IdMunicipio" int not null generated always as identity primary key,
"Nome" varchar(50) not null unique 
)

create table "Transportadora"(
"IdTransportadora" int not null generated always as identity primary key,
"Nome" varchar(50) not null unique,
"IdMunicipio" int,
"Logradouro" varchar(50),
"Numero" varchar(10),
constraint FK_Transportadora_Municipio foreign key("IdMunicipio") references "Municipio"("IdMunicipio")
)

create table "Produto"(
"IdProduto" int not null generated always as identity primary key,
"Nome" varchar(50) not null,
"IdFornecedor" int not null,
"Valor" numeric(10,2) not null,
constraint FK_Produto_Fornecedor foreign key("IdFornecedor") references "Fornecedor"("IdFornecedor")
)


create table "Cliente"(
    "IdCliente" int not null generated always as identity primary key,
    "Nome" varchar(50) not null, 
    "Cpf" char(11),                     
    "Rg" varchar(15),
    "DataNascimento" date,
    "Genero" char(1),
    "Profissao" varchar(30),
    "Nacionalidade" varchar(30)        
)

create table "Pedido"(
"IdPedido" int not null generated always as identity primary key,
"IdCliente" int not null,
"IdTransportadora" int,
"IdVendedor" int not null,
"DataPedido" date not null,
"Valor" numeric(10,2) not null
)

CREATE TABLE "PedidoProduto" (
    "IdPedido" INT NOT NULL,
    "IdProduto" INT NOT NULL,
    "Quantidade" INT NOT NULL,
    "ValorUnitario" NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_PedidoProduto PRIMARY KEY ("IdPedido", "IdProduto"),

    CONSTRAINT fk_PedidoProduto_Pedido FOREIGN KEY ("IdPedido") REFERENCES "Pedido" ("IdPedido"),

    CONSTRAINT fk_PedidoProduto_Produto FOREIGN KEY ("IdProduto") REFERENCES "Produto" ("IdProduto")
)
-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-

-- Consultas simples

--1. Somente o nome de todos os vendedores em ordem alfabética.
select "Nome" from "Vendedor" order by "Nome" asc



--2. Os produtos que o preço seja maior que R$200,00, em ordem crescente pelo preço.
select "Valor" from "Produto"
where "Valor" > 200
order by "Valor" asc



-- 3. O nome do produto, o preço e o preço reajustado em 10%, ordenado pelo nome do produto.
select "Nome", "Valor", ("Valor" * 1.10) as "Valor Reajustado" 
from "Produto"
order by "Nome" asc;



-- 4. As transportadoras do município do São paulo.
select t."Nome" as "Transportadora", m."Nome" as "Município"
from "Transportadora" t 
inner join "Municipio" m
on t."IdMunicipio" = m."IdMunicipio" 



-- 5. Os pedidos feitos entre 10/01/2024 e 10/02/2024 ordenado pelo valor.
select * from "Pedido"
where "DataPedido" between '10-01-2024' and '10-02-2024'  
order by "Valor" asc



-- 6. Os pedidos que o valor esteja entre R$1.000,00 e R$1.500,00.
select * from "Pedido"
where "Valor" between '1000.00' and '1500.00'
order by "Valor"



-- 7. Os pedidos que o valor não esteja entre R$100,00 e R$500,00.
select * from "Pedido"
where "Valor" not between '100.00' and '500.00'
order by "Valor" asc



-- 8. Os pedidos do vendedor Carlos ordenado pelo valor em ordem decrescente.
select v."Nome", p."DataPedido", p."Valor" 
from "Pedido" p 
inner join "Vendedor" v
on p."IdVendedor" = v."IdVendedor"
where v."Nome" ilike '%Carlos%' --ilike(case-insensitive) não diferencia maiúscula/minúscula 
order by p."Valor" asc



-- 9. Os pedidos da cliente Camila ordenado pelo valor em ordem crescente.
select c."Nome" as "Nome Cliente", p."Valor" as "Valor do Pedido" 
from "Pedido" p 
inner join "Cliente" c
on p."IdCliente" = c."IdCliente"
where c."Nome" ilike '%camila%'
order by "Valor" asc



-- 10. Os pedidos do cliente Rafael que foram feitos pelo vendedor Pedro.
select c."Nome" as "Nome Cliente", v."Nome" as "Nome Vendedor", p."Valor" as "Valor Pedido"
from "Pedido" p
inner join "Cliente" c on p."IdCliente" = c."IdCliente"
inner join "Vendedor" v on p."IdVendedor" = v."IdVendedor"
where c."Nome" ilike '%rafael%' and v."Nome" ilike '%pedro%'



-- 11. Os pedidos que foram transportados pela transportadora Entrega Fácil.
select t."Nome" as "Nome Transportadora", p."Valor" as "Valor Pedido"
from "Pedido" p
inner join "Transportadora" t on p."IdTransportadora" = t."IdTransportadora"
where t."Nome" ilike '%Entrega Fácil%'



-- 12. Os pedidos feitos pela vendedora Maria ou pela vendedora Ana.
select v."Nome" as "Nome Vendedora", p."Valor" as "Valor Pedido"
from "Pedido" p 
inner join "Vendedor" v on p."IdVendedor" = v."IdVendedor"
where v."Nome" like '%Maria%' or v."Nome" like '%Ana%'



-- 13. As transportadoras que são de União da Vitória ou Porto União.
select t."Nome" as "Nome Transportadora", m."Nome" as "Nome Município" 
from "Transportadora" t
inner join "Municipio" m on t."IdMunicipio" = m."IdMunicipio"
where m."Nome" not like '%União da Vitória%' or m."Nome" not like '%Porto União%'


-- 17. Os vendedores que o nome começa com a letra P.
select "Nome" as "Nome Vendedores" from "Vendedor"
where "Nome" like 'P%'



-- 18. Os vendedores que o nome termina com a letra A.
select "Nome" as "Nome Vendedores" from "Vendedor"
where "Nome" like '%a'



-- 19. Os vendedores que o nome não começa com a letra A.
select "Nome" as "Nome Vendedores" from "Vendedor"
where "Nome" not like 'A%'


-- Obter apenas o dia mês e ano
select "DataPedido" as "Data do Pedido",
		extract(day from "DataPedido") as "Apenas o dia",
		extract(month from "DataPedido") as "Apenas o mês",
		extract(year from "DataPedido") as "Apenas o Ano"
from "Pedido"


-- Obter do nome apenas os caracteres do 1 ao 5
select "Nome", 
        substring("Nome" from 1 for 5) as "Caracteres do 1 ao 5",
        substring("Nome", 2) as "Nome a partir do 3ª char"
from "Cliente"



-- Usando o coalesce
select "Nome", "Cpf", coalesce("Cpf", 'Não Informado') from "Cliente"



-- Sigla de gênero por extenso
select
    case "Genero" when 'M' then 'Masculino' else 'Feminino'
end as "Genero"
from "Cliente"



-- O nome do cliente e somente o mês de nascimento. Caso a data de nascimento não esteja preenchida mostrar a mensagem “Não informado”.
select "Nome", 
    case when "DataNascimento" is null then 'Não informado' 
    else extract(month from "DataNascimento")::text
end as "Somente o mês de nascimento"
from "Cliente"



-- O nome do cliente e somente o nome do mês de nascimento (Janeiro, Fevereiro etc). Caso a data de nascimento não esteja preenchida mostrar a mensagem “Não informado”.
select "Nome", 
	case when "DataNascimento" is null then 'Não Informado'
	else trim(to_char("DataNascimento", 'TMMonth'))
end as "Mês de Nascimento"
from "Cliente"


-- O nome do cliente e somente o ano de nascimento. Caso a data de nascimento não esteja preenchida mostrar a mensagem “Não informado”.
select "Nome",
	case when "DataNascimento" is null then 'Não Informado'
	else extract(year from "DataNascimento")::text
end as "Ano de Nascimento"
from "Cliente"


-- O caractere 5 até o caractere 10 de todos os municípios.
select  "Nome",
		substring("Nome" from 5 for 10) as "Caractere 5 até o caractere 10 dos municípios"
from "Municipio"


-- O nome de todos os municípios em letras maiúsculas.
select upper("Nome") as "Municípios com letras maiúsculas" from "Municipio"


-- O nome do cliente e o gênero. Caso seja M mostrar “Masculino”, senão mostrar “Feminino”.
select "Nome", 
		case when "Genero" = 'M' then 'Masculino' else 'Feminino'
end as "Gênero"
from "Cliente"



-- O nome do produto e o valor. Caso o valor seja maior do que R$ 500,00 mostrar a mensagem “Acima de 500”, caso contrário, mostrar a mensagem “Abaixo de 500”.
select "Nome" as "Nome do Produto", 
		"Valor" as "Valor do Produto",
		case when "Valor" > 500 then 'Acima de 500' else 'Abaixo de 500'
end as "Descrição do Valor do Produto"
from "Produto"



-- Selecionar a data do pedido e o valor, onde o valor seja maior que a média dos valores de todos os pedidos
select "DataPedido" as "Data do Pedido", 
		"Valor"
from "Pedido"
where "Valor" > (select avg("Valor") from "Pedido")
group by "Data do Pedido","Valor"


--                                                              Subconsultas

-- A data e o valor dos pedidos que o valor do pedido seja menor que a média de todos os pedidos.
select "DataPedido" as "Data do Pedido",
		"Valor" as "Pedidos com valores menores que R$1720"
from "Pedido"
where "Valor" < (select avg("Valor") from "Pedido")




-- A data, o valor, o cliente e o vendedor dos pedidos que possuem 2 ou mais produtos.
select
		p."DataPedido" as "Data do Pedido",
		p."Valor" as "Valor do Pedido",
		c."Nome" as "Cliente",
		v."Nome" as "Vendedor",
		pr."Nome" as "Produto",
		pr."IdProduto"
from "Pedido" p
inner join "Cliente" c on p."IdCliente" = c."IdCliente"
inner join "Vendedor" v on p."IdVendedor" = v."IdVendedor"
inner join "PedidoProduto" pp on p."IdPedido" = pp."IdPedido"
inner join "Produto" pr on pp."IdProduto" = pr."IdProduto"
group by 
    p."DataPedido",
    p."Valor",
    c."Nome",
    v."Nome",
    pr."Nome",
	pr."IdProduto"
having count(pp."IdProduto") >= 2;

		


-- todos os produtos de todos os pedidos.
select pro."Nome" as "Nome dos Produtos", 
		pp."ValorUnitario" as "Valor Unitario",
		pe."Valor" as "Total do Pedido" 
from "PedidoProduto" pp 
inner join "Produto" pro on pp."IdProduto" = pro."IdProduto"
inner join "Pedido" pe on pp."IdPedido" = pe."IdPedido"




-- O nome do cliente e a quantidade de pedidos feitos pelo cliente.
select c."Nome" as "Nome do Cliente",
		count(p."IdPedido") as "Quantidade de Pedidos"
from "Pedido" p
inner join "Cliente" c on c."IdCliente" = p."IdCliente"
group by "Nome do Cliente"




-- Para revisar, refaça o exercício anterior (número 07) utilizando group by e mostrando somente os clientes que fizeram pelo menos um pedido.
select c."Nome" as "Nome do Cliente",
		count(p."IdPedido") as "Quantidade de Pedidos"
from "Pedido" p
inner join "Cliente" c on c."IdCliente" = p."IdCliente"
group by "Nome do Cliente"
having count(p."IdPedido") >= 1;





-- Atualizar o valor do pedido em 5% para os pedidos que o somatório do valor total dos produtos daquele pedido seja maior que a média do valor total de todos os produtos de todos os pedidos

update "Pedido" set "Valor" = "Valor" + ("Valor" * 0.05)
where
(
	select sum(pp."ValorUnitario") as "Soma dos valores unitários"
	from "PedidoProduto" pp
	where pp."IdPedido" = "Pedido"."IdPedido"

) > (select round(avg("ValorUnitario"),2) from "PedidoProduto")



-- Views

create view "Cliente_profissao" as
select c."Nome" as "Cliente"
        p."Nome" as "Profissão"
from "Cliente" c  
inner join "Profissao" p on c."IdProfissao" = p."IdProfissao"

select * from "Cliente_profissao";



-- Índices no PostgreSQL são utilizados para otimizar consultas frequentes, aumentando a velocidade de busca e recuperação de dados.
-- exemplo: 
            create index idx_cli_nome on "Cliente" (nome)



_________________________________________________________________________________________
FUNÇÕES

--Criação da Função: formatada moeda
create function formata_moeda("Valor" float) returns varchar(20) LANGUAGE plpgsql as 
$$
begin
	return concat('R$ ', round(cast("Valor" as numeric),2));
end;
$$;


--Chamada da função
select "Valor" as "Valor Original", 
		formata_moeda("Valor") as "Valor Formatado" 
from "Pedido"



_________________________________________________________________________________________

--Criação da Função: get nome by id
create function get_nome_by_id(idc integer) returns varchar(50) language plpgsql as
$$

declare r varchar(50);

begin
    select "Nome" into r from "Cliente"
    where "IdCliente" = idc;
	return r;
end;

$$;


--Chamada da função
select "Valor", get_nome_by_id("IdCliente") from "Pedido"



_________________________________________________________________________________________

--Crie uma função que receba como parâmetro o ID do pedido e retorne o valor total deste pedido
create function valor_total_pedido_por_id(idc integer) returns varchar(50) language plpgsql as
$$

declare valor_total decimal;

begin
	select sum("Valor") into valor_total from "Pedido"
	where "IdCliente" = idc;
	return valor_total;
end;

$$;

--Chamada da função
select valor_total_pedido_por_id("IdCliente") as "Valor total" from "Pedido";



_________________________________________________________________________________________

--Crie uma função chamada "maior", que quando executada retorne o pedido com o maior valor
create or replace function maior() returns integer language plpgsql as 
$$

begin
	return (select max("Valor") into maior_valor from "Pedido") ;
end;

$$;


-- Chamando a função
select maior() as "Maior Valor" from "Pedido" limit 1




_________________________________________________________________________________________
StoredProcedures


create procedure sp_insere_cliente(nome_cliente varchar(50)) language sql as
$$
	insert into "Cliente"("Nome")values(nome_cliente);
$$;


--Chamando a procedure
call sp_insere_cliente('Pedro Miguel');



_________________________________________________________________________________________

-- 1. Crie uma stored procedure que receba como parâmetro o ID do produto e o percentual de aumento, e reajuste o preço somente deste produto de acordo com o valor passado como parâmetro

create procedure sp_reajustar_preco_produto(id_produto integer, percentual_produto NUMERIC) language sql as 
$$
	update "Produto" set "Valor" = "Valor" * (1 + percentual_produto / 100.0) where "IdProduto" = id_produto
$$;


--Chamando a procedure
call sp_reajustar_preco_produto(1,10)


_________________________________________________________________________________________

-- 2. Crie uma stored procedure que receba como parâmetro o ID do produto e exclua da base de dados somente o produto com o ID correspondente

create procedure sp_exclui_produto_by_id(id_produto integer) language sql as
$$
	delete from "Produto" where "IdProduto" = id_produto;
$$;


--Chamando
call sp_exclui_produto_by_id(10)





_________________________________________________________________________________________

https://www.udemy.com/course/banco-de-dados-sql-postgresql/learn/lecture/36229924#overview