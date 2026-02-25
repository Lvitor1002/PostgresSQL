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



-- -- Funções agregadas

-- 1. A média dos valores de vendas dos vendedores que venderam mais que R$ 200,00.
 https://www.udemy.com/course/banco-de-dados-sql-postgresql/learn/lecture/36137750#overview




-- 2. Os vendedores que venderam mais que R$ 1500,00.





-- 3. O somatório das vendas de cada vendedor.





-- 4. A quantidade de municípios.





-- 5. A quantidade de municípios que são do Paraná ou de Santa Catarina.





-- 6. A quantidade de municípios por estado.





-- 7. A quantidade de clientes que informaram o logradouro.





-- 8. A quantidade de clientes por município.





-- 9. A quantidade de fornecedores.





-- 10. A quantidade de produtos por fornecedor.





-- 11. A média de preços dos produtos do fornecedor Cap. Computadores.





-- 12. O somatório dos preços de todos os produtos.





-- 13. O nome do produto e o preço somente do produto mais caro.





-- 14. O nome do produto e o preço somente do produto mais barato.





-- 15. A média de preço de todos os produtos.





-- 16. A quantidade de transportadoras.





-- 17. A média do valor de todos os pedidos.





-- 18. O somatório do valor do pedido agrupado por cliente.





-- 19. O somatório do valor do pedido agrupado por vendedor.





-- 20. O somatório do valor do pedido agrupado por transportadora.





-- 21. O somatório do valor do pedido agrupado pela data.





-- 22. O somatório do valor do pedido agrupado por cliente, vendedor e transportadora.





-- 23. O somatório do valor do pedido que esteja entre 01/04/2008 e 10/12/2009 e que seja maior que R$ 200,00.





-- 24. A média do valor do pedido do vendedor André.





-- 25. A média do valor do pedido da cliente Jéssica.





-- 26. A quantidade de pedidos transportados pela transportadora BS. Transportes.





-- 27. A quantidade de pedidos agrupados por vendedor.





-- 28. A quantidade de pedidos agrupados por cliente.





-- 29. A quantidade de pedidos entre 15/04/2008 e 25/04/2008.





-- 30. A quantidade de pedidos que o valor seja maior que R$ 1.000,00.





-- 31. A quantidade de microcomputadores vendida.





-- 32. A quantidade de produtos vendida agrupado por produto.





-- 33. O somatório do valor dos produtos dos pedidos, agrupado por pedido.





-- 34. A quantidade de produtos agrupados por pedido.





-- 35. O somatório do valor total de todos os produtos do pedido.





-- 36. A média dos produtos do pedido 6.





-- 37. O valor do maior produto do pedido.





-- 38. O valor do menor produto do pedido.





-- 39. O somatório da quantidade de produtos por pedido.





-- 40. O somatório da quantidade de todos os produtos do pedido.








-- -=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-- -- Joins





-- 1. O nome do cliente, a profissão, a nacionalidade, o logradouro, o número, o complemento, o bairro, o município e a unidade de federação.





-- 2. O nome do produto, o valor e o nome do fornecedor.





-- 3. O nome da transportadora e o município.





-- 4. A data do pedido, o valor, o nome do cliente, o nome da transportadora e o nome do vendedor.





-- 5. O nome do produto, a quantidade e o valor unitário dos produtos do pedido.





-- 6. O nome dos clientes e a data do pedido dos clientes que fizeram algum pedido (ordenado pelo nome do cliente).





-- 7. O nome dos clientes e a data do pedido de todos os clientes, independente se tenham feito pedido (ordenado pelo nome do cliente).





-- 8. O nome da cidade e a quantidade de clientes que moram naquela cidade.





-- 9. O nome do fornecedor e a quantidade de produtos de cada fornecedor.





-- 10.O nome do cliente e o somatório do valor do pedido (agrupado por cliente).





-- 11.O nome do vendedor e o somatório do valor do pedido (agrupado por vendedor).





-- 12.O nome da transportadora e o somatório do valor do pedido (agrupado por transportadora).





-- 13.O nome do cliente e a quantidade de pedidos de cada um (agrupado por cliente).





-- 14.O nome do produto e a quantidade vendida (agrupado por produto).





-- 15.A data do pedido e o somatório do valor dos produtos do pedido (agrupado pela data do pedido).





-- 16.A data do pedido e a quantidade de produtos do pedido (agrupado pela data do pedido).








-- -=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-- -- Comandos adicionais





-- 1. O nome do cliente e somente o mês de nascimento. Caso a data de nascimento não esteja preenchida mostrar a mensagem “Não informado”.





-- 2. O nome do cliente e somente o nome do mês de nascimento (Janeiro, Fevereiro etc). Caso a data de nascimento não esteja preenchida mostrar a mensagem “Não





-- informado”.





-- 3. O nome do cliente e somente o ano de nascimento. Caso a data de nascimento não esteja preenchida mostrar a mensagem “Não informado”.





-- 4. O caractere 5 até o caractere 10 de todos os municípios.





-- 5. O nome de todos os municípios em letras maiúsculas.





-- 6. O nome do cliente e o gênero. Caso seja M mostrar “Masculino”, senão mostrar “Feminino”.





-- 7. O nome do produto e o valor. Caso o valor seja maior do que R$ 500,00 mostrar a mensagem “Acima de 500”, caso contrário, mostrar a mensagem “Abaixo de 500”.








-- -=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-


-- -- Subconsultas





-- 1. O nome dos clientes que moram na mesma cidade do Manoel. Não deve ser mostrado o Manoel.





-- 2. A data e o valor dos pedidos que o valor do pedido seja menor que a média de todos os pedidos.





-- 3. A data,o valor, o cliente e o vendedor dos pedidos que possuem 2 ou mais produtos.





-- 4. O nome dos clientes que moram na mesma cidade da transportadora BSTransportes.





-- 5. O nome do cliente e o município dos clientes que estão localizados no mesmo município de qualquer uma das transportadoras.





-- 6. Atualizar o valor do pedido em 5% para os pedidos que o somatório do valor total dos produtos daquele pedido seja maior que a média do valor total


-- de todos os produtos de todos os pedidos.





-- 7. O nome do cliente e a quantidade de pedidos feitos pelo cliente.





-- 8. Para revisar, refaça o exercício anterior (número 07) utilizando group by e mostrando somente os clientes que fizeram pelo menos um pedido.














-- -=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-- -- Views





-- 1. O nome, a profissão, a nacionalidade, o complemento, o município, a unidade de federação, o bairro, o CPF,o RG, a data de nascimento, o gênero (mostrar


-- “Masculino” ou “Feminino”), o logradouro, o número e as observações dos clientes.





-- 2. O nome do município e o nome e a sigla da unidade da federação.





-- 3. O nome do produto, o valor e o nome do fornecedor dos produtos.





-- 4. O nome da transportadora, o logradouro, o número, o nome da unidade de federação e a sigla da unidade de federação das transportadoras.





-- 5. A data do pedido, o valor, o nome da transportadora, o nome do cliente e o nome do vendedor dos pedidos.





-- 6. O nome do produto, a quantidade, o valor unitário e o valor total dos produtos do pedido.



-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-



-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-




-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-





-=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=--=-=-=-=-=-=-=-


