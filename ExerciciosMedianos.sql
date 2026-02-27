
-- Exercício 1
-- Pergunta: Liste o nome de todos os produtos e o nome do seu subgrupo (apenas produtos ativos).

-- Solução:
select p."Nome" as "Nome Produto", psg."Nome" as "Nome Sub Grupos de Produtos" 
from "Produtos" p 
inner join "ProdutosSubGrupo" psg on p."IdSubGrupo" = psg."Codigo"
where p."Ativo" = true





-- Exercício 2
-- Pergunta: Conte quantos produtos existem em cada subgrupo (apenas subgrupos ativos) e mostre o nome do subgrupo e a contagem.

-- Solução:
select  psg."Nome" as "Sub Grupos de Produtos", count(p."Codigo") as Quantidade_Produtos 
from "Produtos" p 
right join "ProdutosSubGrupo" psg on p."IdSubGrupo" = psg."Codigo"
where psg."Ativo" = true
group by psg."Nome"
order by Quantidade_Produtos desc





-- Exercício 3
-- Pergunta: Calcule o preço médio de venda dos produtos por subgrupo, mostrando apenas subgrupos com média acima de 10.

-- Solução:
select  psg."Nome" as "Sub Grupos de Produtos", round(avg(p."PrecoVenda"),2) as "Média de Preço de Venda" 
from "Produtos" p 
inner join "ProdutosSubGrupo" psg on p."IdSubGrupo" = psg."Codigo"
where psg."Ativo"
group by psg."Nome"
having avg(p."PrecoVenda") > 10
order by "Média de Preço de Venda" asc




-- Exercício 4
-- Pergunta: Encontre o produto mais caro (maior preço de venda) de cada subgrupo. Liste o nome do subgrupo, nome do produto e preço.

-- Solução:
select psg."Nome" as "Sub grupo de Produtos", 
	   p."Nome" as "Nome do Produto",
	   p."PrecoVenda" as "Maior Preço de Venda de um Produto"
from "Produtos" p 
inner join "ProdutosSubGrupo" psg on p."IdSubGrupo" = psg."Codigo"
where (p."IdSubGrupo", p."PrecoVenda") in (select "IdSubGrupo", max("PrecoVenda") --Pegar o produto mais caro de cada subgrupo
										  from "Produtos"
										  where "Ativo" 
										  group by "IdSubGrupo")
order by psg."Nome"






-- Exercício 5
-- Pergunta: Liste todos os depósitos que pertencem à empresa de nome 'CONVENIENCIA CRUZEIRO DO SUL' (ID 1) e que estão ativos.

-- Solução:
select d."Nome" as Deposito, e."Nome" as Empresa
from "Depositos" d
left join "Empresas" e on d."IdEmpresa" = e."ID"
where e."Nome" like '%CONVENIENCIA CRUZEIRO DO SUL%' 
and d."Ativo"



AQUI
-- Exercício 6
-- Pergunta: Mostre a quantidade de produtos em cada depósito (considere que cada registro em Estoques representa um produto presente no depósito). Inclua o nome do depósito.

-- Solução:

SELECT d."Nome" AS deposito, COUNT(e."IdProduto") AS quantidade_produtos
FROM public."Estoques" e
JOIN public."Depositos" d ON e."IdDeposito" = d."Codigo"
WHERE e."Ativo" = true
GROUP BY d."Nome";





-- Exercício 7
-- Pergunta: Quais produtos estão em estoque no depósito de nome 'Depósito' (código 101) e também têm preço de venda maior que 10? Liste o nome do produto e o preço.

-- Solução:

SELECT p."Nome", p."PrecoVenda"
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
WHERE e."IdDeposito" = 101 AND p."PrecoVenda" > 10 AND e."Ativo" = true;




-- Exercício 8
-- Pergunta: Calcule o valor total do estoque (preço de custo * quantidade) – mas como não há campo de quantidade, vamos simular considerando que cada registro em Estoques representa uma unidade. Assim, some o preço de custo de todos os produtos em estoque por depósito.

-- Solução:

SELECT d."Nome" AS deposito, SUM(p."PrecoCusto") AS valor_total_estoque
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
JOIN public."Depositos" d ON e."IdDeposito" = d."Codigo"
WHERE e."Ativo" = true
GROUP BY d."Nome";






-- Exercício 9
-- Pergunta: Liste os nomes das empresas que possuem pelo menos um depósito ativo.

-- Solução:

SELECT e."Nome"
FROM public."Empresas" e
WHERE EXISTS (
    SELECT 1 FROM public."Depositos" d
    WHERE d."IdEmpresa" = e."ID" AND d."Ativo" = true
);





-- Exercício 10
-- Pergunta: Para cada empresa, mostre a quantidade de depósitos que ela possui (apenas empresas ativas).

-- Solução:

SELECT e."Nome", COUNT(d."Codigo") AS total_depositos
FROM public."Empresas" e
LEFT JOIN public."Depositos" d ON e."ID" = d."IdEmpresa" AND d."Ativo" = true
WHERE e."Ativo" = true
GROUP BY e."ID", e."Nome";




-- Exercício 11
-- Pergunta: Encontre o subgrupo com a maior média de preço de custo. Mostre o nome do subgrupo e a média.

-- Solução:

SELECT psg."Nome", AVG(p."PrecoCusto") AS media_custo
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true
GROUP BY psg."Nome"
ORDER BY media_custo DESC
LIMIT 1;




-- Exercício 12
-- Pergunta: Liste os produtos que têm preço de venda acima da média geral de preço de venda de todos os produtos ativos.

-- Solução:

SELECT "Nome", "PrecoVenda"
FROM public."Produtos"
WHERE "Ativo" = true AND "PrecoVenda" > (SELECT AVG("PrecoVenda") FROM public."Produtos" WHERE "Ativo" = true);





-- Exercício 13
-- Pergunta: Mostre o nome do produto, seu subgrupo e a diferença entre o preço de venda e o preço de custo (lucro unitário) apenas para produtos com lucro positivo.

-- Solução:

SELECT p."Nome", psg."Nome" AS subgrupo, (p."PrecoVenda" - p."PrecoCusto") AS lucro
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true AND (p."PrecoVenda" - p."PrecoCusto") > 0;




-- Exercício 14
-- Pergunta: Qual a margem de lucro média (em percentual) por subgrupo? Considere margem = (preço_venda - preço_custo)/preço_custo * 100. Exiba subgrupo e margem média.

-- Solução:

SELECT psg."Nome", AVG((p."PrecoVenda" - p."PrecoCusto") / p."PrecoCusto" * 100) AS margem_media_percent
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true AND p."PrecoCusto" > 0
GROUP BY psg."Nome";








-- Exercício 15
-- Pergunta: Liste os produtos que não estão em nenhum estoque (ou seja, não aparecem na tabela Estoques).

-- Solução:

SELECT p."Nome"
FROM public."Produtos" p
LEFT JOIN public."Estoques" e ON p."Codigo" = e."IdProduto" AND e."Ativo" = true
WHERE e."IdProduto" IS NULL AND p."Ativo" = true;






-- Exercício 16
-- Pergunta: Para cada produto, mostre quantos depósitos diferentes ele está presente (apenas estoques ativos).

-- Solução:

SELECT p."Nome", COUNT(DISTINCT e."IdDeposito") AS quantidade_depositos
FROM public."Produtos" p
LEFT JOIN public."Estoques" e ON p."Codigo" = e."IdProduto" AND e."Ativo" = true
WHERE p."Ativo" = true
GROUP BY p."Nome";






-- Exercício 17
-- Pergunta: Encontre o depósito que tem o maior número de produtos diferentes em estoque.

-- Solução:

SELECT d."Nome", COUNT(e."IdProduto") AS total_produtos
FROM public."Estoques" e
JOIN public."Depositos" d ON e."IdDeposito" = d."Codigo"
WHERE e."Ativo" = true
GROUP BY d."Nome"
ORDER BY total_produtos DESC
LIMIT 1;





-- Exercício 18
-- Pergunta: Liste os nomes dos produtos que estão no depósito 101 e cujo subgrupo é 'BEBIDAS' (código 101).

-- Solução:

SELECT p."Nome"
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
WHERE e."IdDeposito" = 101 AND p."IdSubGrupo" = 101 AND e."Ativo" = true;






-- Exercício 19
-- Pergunta: Calcule o preço médio de venda dos produtos agrupados por IdGrupo (campo em Produtos). Considere apenas produtos ativos. (Observação: IdGrupo parece ser uma classificação mais ampla que subgrupo.)

-- Solução:

SELECT p."IdGrupo", AVG(p."PrecoVenda") AS media_preco
FROM public."Produtos" p
WHERE p."Ativo" = true AND p."PrecoVenda" IS NOT NULL
GROUP BY p."IdGrupo";






-- Exercício 20
-- Pergunta: Mostre o nome do produto, seu grupo (usando IdGrupo) e subgrupo, ordenado por grupo.

-- Solução:

SELECT p."Nome", p."IdGrupo", psg."Nome" AS subgrupo
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true
ORDER BY p."IdGrupo";






-- Exercício 21
-- Pergunta: Quais são os subgrupos que têm mais de 5 produtos ativos? Liste o nome do subgrupo e a quantidade.

-- Solução:

SELECT psg."Nome", COUNT(p."Codigo") AS total
FROM public."ProdutosSubGrupo" psg
JOIN public."Produtos" p ON psg."Codigo" = p."IdSubGrupo" AND p."Ativo" = true
GROUP BY psg."Nome"
HAVING COUNT(p."Codigo") > 5;






-- Exercício 22
-- Pergunta: Encontre o produto com o menor preço de custo em cada subgrupo. Exiba subgrupo, nome do produto e preço de custo.

-- Solução:

SELECT psg."Nome" AS subgrupo, p."Nome", p."PrecoCusto"
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE (p."IdSubGrupo", p."PrecoCusto") IN (
    SELECT "IdSubGrupo", MIN("PrecoCusto")
    FROM public."Produtos"
    WHERE "Ativo" = true AND "PrecoCusto" > 0
    GROUP BY "IdSubGrupo"
);





-- Exercício 23
-- Pergunta: Liste todas as contas contábeis do tipo 'D' (despesa) que estão ativas, ordenadas por nome.

-- Solução:

SELECT "ID", "Nome", "Tipo"
FROM public."Contas"
WHERE "Tipo" = 'D' AND "Ativo" = true
ORDER BY "Nome";





-- Exercício 24
-- Pergunta: Mostre o nome da empresa e a quantidade de contas contábeis associadas a ela (campo IdEmpresaConta). Considere apenas contas ativas.

-- Solução:

SELECT e."Nome", COUNT(c."ID") AS total_contas
FROM public."Empresas" e
LEFT JOIN public."Contas" c ON e."ID" = c."IdEmpresaConta" AND c."Ativo" = true
WHERE e."Ativo" = true
GROUP BY e."Nome";





-- Exercício 25
-- Pergunta: Quais produtos têm preço de venda maior que o dobro do preço de custo? Liste nome, preço custo e preço venda.

-- Solução:

SELECT "Nome", "PrecoCusto", "PrecoVenda"
FROM public."Produtos"
WHERE "PrecoVenda" > 2 * "PrecoCusto" AND "Ativo" = true;






-- Exercício 26
-- Pergunta: Para cada subgrupo, calcule o preço de venda máximo, mínimo e a diferença entre eles. Exiba subgrupo, máximo, mínimo e diferença.

-- Solução:

SELECT psg."Nome", MAX(p."PrecoVenda") AS max_venda, MIN(p."PrecoVenda") AS min_venda,
       MAX(p."PrecoVenda") - MIN(p."PrecoVenda") AS diferenca
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true AND p."PrecoVenda" IS NOT NULL
GROUP BY psg."Nome";






-- Exercício 27
-- Pergunta: Liste os produtos que estão em estoque (tabela Estoques) mas que estão inativos na tabela Produtos.

-- Solução:

SELECT p."Nome", p."Ativo"
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
WHERE p."Ativo" = false AND e."Ativo" = true;






-- Exercício 28
-- Pergunta: Encontre a empresa que possui o maior número de depósitos ativos.

-- Solução:

SELECT e."Nome", COUNT(d."Codigo") AS total_depositos
FROM public."Empresas" e
JOIN public."Depositos" d ON e."ID" = d."IdEmpresa" AND d."Ativo" = true
GROUP BY e."Nome"
ORDER BY total_depositos DESC
LIMIT 1;





-- Exercício 29
-- Pergunta: Liste os nomes dos produtos que não possuem subgrupo definido (campo IdSubGrupo nulo ou inexistente na tabela de subgrupos). (Na estrutura, IdSubGrupo não é obrigatório? Na criação da tabela Produtos, IdSubGrupo é integer, sem restrição NOT NULL, então pode ser nulo.)

-- Solução:

SELECT p."Nome"
FROM public."Produtos" p
LEFT JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE psg."Codigo" IS NULL AND p."Ativo" = true;





-- Exercício 30
-- Pergunta: Para cada empresa, mostre a quantidade de produtos ativos que ela possui (campo IdEmpresa em Produtos). Considere apenas empresas ativas.

-- Solução:

SELECT e."Nome", COUNT(p."Codigo") AS total_produtos
FROM public."Empresas" e
LEFT JOIN public."Produtos" p ON e."ID" = p."IdEmpresa" AND p."Ativo" = true
WHERE e."Ativo" = true
GROUP BY e."Nome";





-- Exercício 31
-- Pergunta: Quais são os 5 produtos com maior margem de lucro (preço_venda - preço_custo)? Exiba nome e margem.

-- Solução:

SELECT "Nome", ("PrecoVenda" - "PrecoCusto") AS margem
FROM public."Produtos"
WHERE "Ativo" = true AND "PrecoVenda" IS NOT NULL AND "PrecoCusto" IS NOT NULL
ORDER BY margem DESC
LIMIT 5;






-- Exercício 32
-- Pergunta: Liste os subgrupos que têm produtos com preço de custo igual a zero (ou muito baixo, como 0.01). Exiba subgrupo e a quantidade desses produtos.

-- Solução:

SELECT psg."Nome", COUNT(p."Codigo") AS qtde_custo_zero
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."PrecoCusto" <= 0.01 AND p."Ativo" = true
GROUP BY psg."Nome";






-- Exercício 33
-- Pergunta: Mostre o nome do produto, o nome do seu subgrupo e o nome do grupo (através de IdGrupo em Produtos, mas como não temos tabela de grupos, vamos considerar que IdGrupo é um identificador numérico e exibi-lo).

-- Solução:

SELECT p."Nome", psg."Nome" AS subgrupo, p."IdGrupo"
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true;





-- Exercício 34
-- Pergunta: Calcule a soma dos preços de custo de todos os produtos que estão no depósito 101, agrupados por subgrupo.

-- Solução:

SELECT psg."Nome", SUM(p."PrecoCusto") AS soma_custo
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE e."IdDeposito" = 101 AND e."Ativo" = true
GROUP BY psg."Nome";





-- Exercício 35
-- Pergunta: Liste os produtos que estão em estoque em mais de um depósito.

-- Solução:

SELECT p."Nome"
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
WHERE e."Ativo" = true
GROUP BY p."Nome"
HAVING COUNT(DISTINCT e."IdDeposito") > 1;




-- Exercício 36
-- Pergunta: Encontre o subgrupo cujo produto mais barato (menor preço de venda) é o mais barato entre todos os subgrupos. Ou seja, o menor preço de venda global e a qual subgrupo pertence.

-- Solução:


SELECT psg."Nome", p."Nome" AS produto, p."PrecoVenda"
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."PrecoVenda" = (SELECT MIN("PrecoVenda") FROM public."Produtos" WHERE "Ativo" = true);





-- Exercício 37
-- Pergunta: Liste as empresas que não possuem nenhum depósito ativo.

-- Solução:

SELECT e."Nome"
FROM public."Empresas" e
LEFT JOIN public."Depositos" d ON e."ID" = d."IdEmpresa" AND d."Ativo" = true
WHERE d."Codigo" IS NULL AND e."Ativo" = true;






-- Exercício 38
-- Pergunta: Mostre a média do preço de venda por tipo de produto (TipoProduto em Produtos, que pode ser 'M' de mercadoria, etc.). Considere apenas produtos ativos.

-- Solução:

SELECT "TipoProduto", AVG("PrecoVenda") AS media_preco
FROM public."Produtos"
WHERE "Ativo" = true AND "PrecoVenda" IS NOT NULL
GROUP BY "TipoProduto";








-- Exercício 39
-- Pergunta: Para cada subgrupo, calcule o total de produtos e o total de produtos que estão inativos.

-- Solução:

SELECT psg."Nome",
       COUNT(p."Codigo") AS total,
       SUM(CASE WHEN p."Ativo" = false THEN 1 ELSE 0 END) AS inativos
FROM public."ProdutosSubGrupo" psg
LEFT JOIN public."Produtos" p ON psg."Codigo" = p."IdSubGrupo"
GROUP BY psg."Nome";





-- Exercício 40
-- Pergunta: Liste os produtos que têm o mesmo nome (duplicados) – considerando que a tabela Produtos tem constraint UN_NomeProduto unique, então não há duplicatas. Mas podemos simular procurando por nomes semelhantes (ex: contendo palavras iguais). Vamos simplificar: encontrar produtos cujo nome aparece mais de uma vez (ignorando a constraint). Como a constraint impede, não haverá. Então faremos um exercício alternativo: produtos que pertencem a mais de um subgrupo? Isso não é possível. Outra ideia: listar produtos que estão em mais de um depósito (já feito no 35). Vamos mudar: listar os subgrupos que têm produtos com preço de venda acima de 50, e contar quantos produtos em cada.

-- Solução alternativa:

SELECT psg."Nome", COUNT(p."Codigo") AS qtde
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."PrecoVenda" > 50 AND p."Ativo" = true
GROUP BY psg."Nome";







-- Exercício 41
-- Pergunta: Encontre o depósito que tem a maior soma de preços de custo dos produtos estocados (considerando cada produto uma unidade).

-- Solução:

SELECT d."Nome", SUM(p."PrecoCusto") AS soma_custo
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
JOIN public."Depositos" d ON e."IdDeposito" = d."Codigo"
WHERE e."Ativo" = true
GROUP BY d."Nome"
ORDER BY soma_custo DESC
LIMIT 1;






-- Exercício 42
-- Pergunta: Liste os produtos que estão em estoque no depósito 101, mas cujo subgrupo está inativo.

-- Solução:

SELECT p."Nome"
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE e."IdDeposito" = 101 AND e."Ativo" = true AND psg."Ativo" = false;






-- Exercício 43
-- Pergunta: Mostre o nome da empresa, o nome do depósito e a quantidade de produtos em cada depósito (apenas empresas ativas e depósitos ativos).

-- Solução:

SELECT e."Nome" AS empresa, d."Nome" AS deposito, COUNT(est."IdProduto") AS quantidade_produtos
FROM public."Empresas" e
JOIN public."Depositos" d ON e."ID" = d."IdEmpresa" AND d."Ativo" = true
LEFT JOIN public."Estoques" est ON d."Codigo" = est."IdDeposito" AND est."Ativo" = true
WHERE e."Ativo" = true
GROUP BY e."Nome", d."Nome";






-- Exercício 44
-- Pergunta: Calcule a média do preço de custo dos produtos que estão em estoque, agrupados por empresa (através do campo IdEmpresa em Produtos).

-- Solução:

SELECT p."IdEmpresa", AVG(p."PrecoCusto") AS media_custo
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
WHERE e."Ativo" = true AND p."Ativo" = true
GROUP BY p."IdEmpresa";






-- Exercício 45
-- Pergunta: Liste as contas contábeis que são do tipo 'R' (receita) e que possuem pelo menos uma subconta (ou seja, que são contas pai, campo ContaPai = true).

-- Solução:

sql
SELECT "ID", "Nome"
FROM public."Contas"
WHERE "Tipo" = 'R' AND "ContaPai" = true AND "Ativo" = true;







-- Exercício 46
-- Pergunta: Para cada subgrupo, mostre o produto com maior preço de venda e o produto com menor preço de venda (em duas colunas separadas). Use subconsultas ou DISTINCT ON.

-- Solução (usando DISTINCT ON):

SELECT DISTINCT ON (psg."Nome") 
       psg."Nome" AS subgrupo,
       FIRST_VALUE(p."Nome") OVER (PARTITION BY psg."Nome" ORDER BY p."PrecoVenda" DESC) AS produto_mais_caro,
       FIRST_VALUE(p."Nome") OVER (PARTITION BY psg."Nome" ORDER BY p."PrecoVenda" ASC) AS produto_mais_barato
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true;

-- Ou de forma mais simples, mas com duas subconsultas:

SELECT psg."Nome",
       (SELECT p1."Nome" FROM public."Produtos" p1 WHERE p1."IdSubGrupo" = psg."Codigo" AND p1."Ativo" = true ORDER BY p1."PrecoVenda" DESC LIMIT 1) AS mais_caro,
       (SELECT p2."Nome" FROM public."Produtos" p2 WHERE p2."IdSubGrupo" = psg."Codigo" AND p2."Ativo" = true ORDER BY p2."PrecoVenda" ASC LIMIT 1) AS mais_barato
FROM public."ProdutosSubGrupo" psg
WHERE psg."Ativo" = true;






-- Exercício 47
-- Pergunta: Encontre produtos cujo preço de venda seja superior à média de preço de venda do seu próprio subgrupo.

-- Solução:

SELECT p."Nome", p."PrecoVenda", psg."Nome" AS subgrupo
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."PrecoVenda" > (
    SELECT AVG(p2."PrecoVenda")
    FROM public."Produtos" p2
    WHERE p2."IdSubGrupo" = p."IdSubGrupo" AND p2."Ativo" = true
) AND p."Ativo" = true;





-- Exercício 48
-- Pergunta: Liste os subgrupos que têm produtos com preço de custo acima de 10 e também produtos com preço de custo abaixo de 5. (Ou seja, que possuem produtos em ambas as faixas.)

-- Solução:

SELECT psg."Nome"
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true
GROUP BY psg."Nome"
HAVING MAX(CASE WHEN p."PrecoCusto" > 10 THEN 1 ELSE 0 END) = 1
   AND MAX(CASE WHEN p."PrecoCusto" < 5 THEN 1 ELSE 0 END) = 1;





-- Exercício 49
-- Pergunta: Para cada empresa, mostre o total de produtos ativos, o total de depósitos ativos e o total de estoques (número de registros em Estoques). Utilize joins e agregação.

-- Solução:

SELECT e."Nome",
       COUNT(DISTINCT p."Codigo") AS total_produtos,
       COUNT(DISTINCT d."Codigo") AS total_depositos,
       COUNT(est."IdProduto") AS total_estoques
FROM public."Empresas" e
LEFT JOIN public."Produtos" p ON e."ID" = p."IdEmpresa" AND p."Ativo" = true
LEFT JOIN public."Depositos" d ON e."ID" = d."IdEmpresa" AND d."Ativo" = true
LEFT JOIN public."Estoques" est ON d."Codigo" = est."IdDeposito" AND est."Ativo" = true
WHERE e."Ativo" = true
GROUP BY e."Nome";





-- Exercício 50
-- Pergunta: Crie uma consulta que retorne um ranking dos produtos por preço de venda dentro de cada subgrupo, exibindo posição (1, 2, 3...) juntamente com nome do produto, subgrupo e preço.

-- Solução:

SELECT psg."Nome" AS subgrupo, p."Nome" AS produto, p."PrecoVenda",
        RANK() OVER (PARTITION BY p."IdSubGrupo ORDER BY p."PrecoVenda" DESC) AS ranking
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true
ORDER BY psg."Nome", ranking;








--                                              Nível avançado:





-- Pergunta: Liste a hierarquia completa das contas contábeis (tabela Contas), exibindo o caminho completo (ex: "1.1.1 – Nome da conta") e o nível (1 a 4). Utilize uma CTE recursiva para percorrer a árvore.
-- Solução:


WITH RECURSIVE hierarquia AS (
    -- âncora: contas de nível 1 (Nivel1 > 0, Nivel2 = Nivel3 = Nivel4 = 0)
    SELECT 
        "ID",
        "Nome",
        "Nivel1",
        "Nivel2",
        "Nivel3",
        "Nivel4",
        CAST("Nivel1" AS VARCHAR) || ' – ' || "Nome" AS caminho,
        1 AS nivel
    FROM public."Contas"
    WHERE "Nivel1" > 0 AND "Nivel2" = 0 AND "Nivel3" = 0 AND "Nivel4" = 0
    UNION ALL
    -- recursão: filhos
    SELECT 
        c."ID",
        c."Nome",
        c."Nivel1",
        c."Nivel2",
        c."Nivel3",
        c."Nivel4",
        h.caminho || ' > ' || CAST(
            CASE 
                WHEN c."Nivel2" > 0 AND c."Nivel3" = 0 AND c."Nivel4" = 0 THEN c."Nivel2"
                WHEN c."Nivel3" > 0 AND c."Nivel4" = 0 THEN c."Nivel3"
                ELSE c."Nivel4"
            END AS VARCHAR) || ' – ' || c."Nome",
        h.nivel + 1
    FROM public."Contas" c
    JOIN hierarquia h ON 
        (c."Nivel1" = h."Nivel1") AND
        (c."Nivel2" = h."Nivel2" + 1 AND h."Nivel2" > 0 AND c."Nivel3" = 0 AND c."Nivel4" = 0) OR
        (c."Nivel1" = h."Nivel1" AND c."Nivel2" = h."Nivel2" AND c."Nivel3" = h."Nivel3" + 1 AND c."Nivel4" = 0) OR
        (c."Nivel1" = h."Nivel1" AND c."Nivel2" = h."Nivel2" AND c."Nivel3" = h."Nivel3" AND c."Nivel4" = h."Nivel4" + 1)
)
SELECT * FROM hierarquia
ORDER BY "Nivel1", "Nivel2", "Nivel3", "Nivel4";






-- Nota: A condição de junção recursiva precisa ser ajustada conforme a lógica exata de hierarquia (níveis). Acima é uma tentativa; pode ser simplificada assumindo que cada conta aponta para seu pai via combinação de níveis.

-- Exercício 52 (Avançado)
-- Pergunta: Calcule o percentual de participação de cada produto no valor total do estoque (soma de preço de custo considerando cada registro de Estoques como uma unidade) no depósito 101. Exiba nome do produto, valor individual e percentual.

-- Solução:


WITH total_estoque AS (
    SELECT SUM(p."PrecoCusto") AS total
    FROM public."Estoques" e
    JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
    WHERE e."IdDeposito" = 101 AND e."Ativo" = true
)
SELECT 
    p."Nome",
    SUM(p."PrecoCusto") AS valor_estoque,
    ROUND(100.0 * SUM(p."PrecoCusto") / (SELECT total FROM total_estoque), 2) AS percentual
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
WHERE e."IdDeposito" = 101 AND e."Ativo" = true
GROUP BY p."Nome";






-- Exercício 53 (Avançado)
-- Pergunta: Para cada subgrupo, liste o produto com maior preço de venda e o produto com menor preço de venda, exibindo ambos em uma única linha por subgrupo, juntamente com a diferença de preço entre eles.

-- Solução (usando FIRST_VALUE e DISTINCT):

SELECT DISTINCT
    psg."Nome" AS subgrupo,
    FIRST_VALUE(p."Nome") OVER w_asc AS produto_mais_barato,
    FIRST_VALUE(p."PrecoVenda") OVER w_asc AS preco_mais_barato,
    FIRST_VALUE(p."Nome") OVER w_desc AS produto_mais_caro,
    FIRST_VALUE(p."PrecoVenda") OVER w_desc AS preco_mais_caro,
    FIRST_VALUE(p."PrecoVenda") OVER w_desc - FIRST_VALUE(p."PrecoVenda") OVER w_asc AS diferenca
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."Ativo" = true AND p."PrecoVenda" IS NOT NULL
WINDOW 
    w_desc AS (PARTITION BY p."IdSubGrupo" ORDER BY p."PrecoVenda" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
    w_asc  AS (PARTITION BY p."IdSubGrupo" ORDER BY p."PrecoVenda" ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);





-- Exercício 54 (Avançado)
-- Pergunta: Encontre produtos cujo preço de venda é maior que a média dos preços de venda dos produtos do mesmo subgrupo, mas menor que a média geral de todos os produtos. Liste nome, subgrupo e preço.

-- Solução:

WITH medias AS (
    SELECT 
        p."IdSubGrupo",
        AVG(p."PrecoVenda") AS media_subgrupo,
        (SELECT AVG("PrecoVenda") FROM public."Produtos" WHERE "Ativo" = true) AS media_geral
    FROM public."Produtos" p
    WHERE p."Ativo" = true
    GROUP BY p."IdSubGrupo"
)
SELECT p."Nome", psg."Nome" AS subgrupo, p."PrecoVenda"
FROM public."Produtos" p
JOIN medias m ON p."IdSubGrupo" = m."IdSubGrupo"
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
WHERE p."PrecoVenda" > m.media_subgrupo
  AND p."PrecoVenda" < m.media_geral
  AND p."Ativo" = true;





-- Exercício 55 (Avançado)
-- Pergunta: Crie uma consulta que mostre, para cada empresa, a quantidade de produtos, a quantidade de depósitos e a razão produtos/depósitos. Use COALESCE para tratar divisão por zero.

-- Solução:

SELECT 
    e."Nome",
    COUNT(DISTINCT p."Codigo") AS total_produtos,
    COUNT(DISTINCT d."Codigo") AS total_depositos,
    ROUND(
        COUNT(DISTINCT p."Codigo")::numeric / 
        NULLIF(COUNT(DISTINCT d."Codigo"), 0), 
        2
    ) AS razao_prod_dep
FROM public."Empresas" e
LEFT JOIN public."Produtos" p ON e."ID" = p."IdEmpresa" AND p."Ativo" = true
LEFT JOIN public."Depositos" d ON e."ID" = d."IdEmpresa" AND d."Ativo" = true
WHERE e."Ativo" = true
GROUP BY e."Nome";





-- Exercício 56 (Avançado)
-- Pergunta: Liste os produtos que estão em estoque (em qualquer depósito) e cujo preço de custo é maior que o preço de custo médio dos produtos do mesmo subgrupo. Exiba produto, subgrupo, preço custo e média do subgrupo.

-- Solução:

WITH media_subgrupo AS (
    SELECT 
        "IdSubGrupo", 
        AVG("PrecoCusto") AS media_custo
    FROM public."Produtos"
    WHERE "Ativo" = true
    GROUP BY "IdSubGrupo"
)
SELECT 
    p."Nome", 
    psg."Nome" AS subgrupo,
    p."PrecoCusto",
    ms.media_custo
FROM public."Produtos" p
JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
JOIN media_subgrupo ms ON p."IdSubGrupo" = ms."IdSubGrupo"
WHERE p."PrecoCusto" > ms.media_custo
  AND p."Ativo" = true
  AND EXISTS (
      SELECT 1 FROM public."Estoques" e 
      WHERE e."IdProduto" = p."Codigo" AND e."Ativo" = true
  );




-- Exercício 57 (Avançado)
-- Pergunta: Para cada depósito, calcule o preço médio de venda dos produtos estocados e compare com a média geral de todos os depósitos. Exiba nome do depósito, média do depósito, média geral e a diferença percentual.

-- Solução:

WITH media_geral AS (
    SELECT AVG(p."PrecoVenda") AS geral
    FROM public."Estoques" e
    JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
    WHERE e."Ativo" = true
)
SELECT 
    d."Nome",
    AVG(p."PrecoVenda") AS media_deposito,
    (SELECT geral FROM media_geral) AS media_geral,
    ROUND(100.0 * (AVG(p."PrecoVenda") - (SELECT geral FROM media_geral)) / (SELECT geral FROM media_geral), 2) AS dif_percentual
FROM public."Estoques" e
JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
JOIN public."Depositos" d ON e."IdDeposito" = d."Codigo"
WHERE e."Ativo" = true
GROUP BY d."Nome";




-- Exercício 58 (Avançado)
-- Pergunta: Determine o produto que mais aparece em estoques (maior número de registros em Estoques). Em caso de empate, liste todos. Exiba nome do produto e quantidade de estoques.

-- Solução (usando RANK):

WITH contagem AS (
    SELECT 
        p."Nome",
        COUNT(*) AS total_estoques,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM public."Estoques" e
    JOIN public."Produtos" p ON e."IdProduto" = p."Codigo"
    WHERE e."Ativo" = true
    GROUP BY p."Nome"
)
SELECT "Nome", total_estoques
FROM contagem
WHERE rank = 1;




-- Exercício 59 (Avançado)
-- Pergunta: Crie uma consulta que retorne, para cada empresa, o total de produtos ativos, o total de produtos inativos, e o percentual de inativos em relação ao total.

-- Solução:

SELECT 
    e."Nome",
    COUNT(p."Codigo") AS total_produtos,
    SUM(CASE WHEN p."Ativo" = true THEN 1 ELSE 0 END) AS ativos,
    SUM(CASE WHEN p."Ativo" = false THEN 1 ELSE 0 END) AS inativos,
    ROUND(100.0 * SUM(CASE WHEN p."Ativo" = false THEN 1 ELSE 0 END) / NULLIF(COUNT(p."Codigo"), 0), 2) AS perc_inativos
FROM public."Empresas" e
LEFT JOIN public."Produtos" p ON e."ID" = p."IdEmpresa"
GROUP BY e."Nome";





-- Exercício 60 (Avançado)
-- Pergunta: Encontre subgrupos onde todos os produtos ativos têm preço de venda acima de 5. Liste os subgrupos.

-- Solução:

SELECT psg."Nome"
FROM public."ProdutosSubGrupo" psg
WHERE psg."Ativo" = true
AND NOT EXISTS (
    SELECT 1 FROM public."Produtos" p
    WHERE p."IdSubGrupo" = psg."Codigo"
      AND p."Ativo" = true
      AND (p."PrecoVenda" <= 5 OR p."PrecoVenda" IS NULL)
);





-- Exercício 61 (Avançado)
-- Pergunta: Para cada subgrupo, exiba o nome, o número de produtos e o número de produtos que estão em falta (ou seja, não possuem nenhum registro em Estoques ativo). Calcule também a proporção de falta.

-- Solução:

SELECT 
    psg."Nome",
    COUNT(p."Codigo") AS total_produtos,
    SUM(CASE WHEN e."IdProduto" IS NULL THEN 1 ELSE 0 END) AS produtos_sem_estoque,
    ROUND(100.0 * SUM(CASE WHEN e."IdProduto" IS NULL THEN 1 ELSE 0 END) / COUNT(p."Codigo"), 2) AS perc_sem_estoque
FROM public."ProdutosSubGrupo" psg
LEFT JOIN public."Produtos" p ON psg."Codigo" = p."IdSubGrupo" AND p."Ativo" = true
LEFT JOIN public."Estoques" e ON p."Codigo" = e."IdProduto" AND e."Ativo" = true
GROUP BY psg."Nome";




-- Exercício 62 (Avançado)
-- Pergunta: Liste os 3 produtos com maior preço de venda e os 3 com menor preço de venda dentro de cada subgrupo. Exiba subgrupo, tipo (MAIOR ou MENOR), nome e preço.

-- Solução (usando UNION ALL de duas queries com window functions):

WITH ranked AS (
    SELECT 
        psg."Nome" AS subgrupo,
        p."Nome",
        p."PrecoVenda",
        ROW_NUMBER() OVER (PARTITION BY p."IdSubGrupo" ORDER BY p."PrecoVenda" DESC) AS rank_desc,
        ROW_NUMBER() OVER (PARTITION BY p."IdSubGrupo" ORDER BY p."PrecoVenda" ASC) AS rank_asc
    FROM public."Produtos" p
    JOIN public."ProdutosSubGrupo" psg ON p."IdSubGrupo" = psg."Codigo"
    WHERE p."Ativo" = true AND p."PrecoVenda" IS NOT NULL
)
SELECT subgrupo, 'MAIOR' AS tipo, nome, "PrecoVenda" FROM ranked WHERE rank_desc <= 3
UNION ALL
SELECT subgrupo, 'MENOR', nome, "PrecoVenda" FROM ranked WHERE rank_asc <= 3
ORDER BY subgrupo, tipo DESC, "PrecoVenda" DESC;



-- Exercício 63 (Avançado)
-- Pergunta: Crie uma consulta que mostre um "cubo" de dados: total de produtos por empresa e por situação (ativo/inativo), com subtotais e total geral. Use GROUPING SETS ou ROLLUP.

-- Solução:

SELECT 
    COALESCE(e."Nome", 'Todas empresas') AS empresa,
    CASE 
        WHEN p."Ativo" IS NULL THEN 'Todos'
        WHEN p."Ativo" = true THEN 'Ativo'
        ELSE 'Inativo'
    END AS situacao,
    COUNT(p."Codigo") AS quantidade
FROM public."Empresas" e
LEFT JOIN public."Produtos" p ON e."ID" = p."IdEmpresa"
GROUP BY GROUPING SETS (
    (e."Nome", p."Ativo"),
    (e."Nome"),
    ()
)
ORDER BY e."Nome", situacao;



-- Exercício 64 (Avançado)
-- Pergunta: Encontre produtos que têm o mesmo preço de venda que outro produto de subgrupo diferente. Liste os pares (produto A, subgrupo A, produto B, subgrupo B) com preço comum.

-- Solução (autojunção):

SELECT 
    p1."Nome" AS produto_a,
    psg1."Nome" AS subgrupo_a,
    p2."Nome" AS produto_b,
    psg2."Nome" AS subgrupo_b,
    p1."PrecoVenda"
FROM public."Produtos" p1
JOIN public."Produtos" p2 ON p1."PrecoVenda" = p2."PrecoVenda"
                         AND p1."IdSubGrupo" != p2."IdSubGrupo"
                         AND p1."Codigo" < p2."Codigo"
JOIN public."ProdutosSubGrupo" psg1 ON p1."IdSubGrupo" = psg1."Codigo"
JOIN public."ProdutosSubGrupo" psg2 ON p2."IdSubGrupo" = psg2."Codigo"
WHERE p1."Ativo" = true AND p2."Ativo" = true;



-- Exercício 65 (Avançado)
-- Pergunta: Gere um ranking dos subgrupos por média de preço de venda, mas considerando apenas os produtos que estão em estoque (pelo menos um registro em Estoques). Exiba posição, subgrupo e média.

-- Solução:

WITH produtos_estoque AS (
    SELECT DISTINCT p."IdSubGrupo", p."PrecoVenda"
    FROM public."Produtos" p
    JOIN public."Estoques" e ON p."Codigo" = e."IdProduto" AND e."Ativo" = true
    WHERE p."Ativo" = true
)
SELECT 
    RANK() OVER (ORDER BY AVG(pe."PrecoVenda") DESC) AS posicao,
    psg."Nome" AS subgrupo,
    AVG(pe."PrecoVenda") AS media_preco
FROM produtos_estoque pe
JOIN public."ProdutosSubGrupo" psg ON pe."IdSubGrupo" = psg."Codigo"
GROUP BY psg."Nome";