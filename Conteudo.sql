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