Página 19 -> file:///C:/Users/Luiz/Desktop/Cursos/Curso%20Postgres/Roteiro%20curso.pdf

https://www.udemy.com/course/banco-de-dados-sql-postgresql/learn/lecture/36137916/?udfrontends=true


=================================================================
1. Crie um banco de dados chamado BIBLIOTECA.


=================================================================
2. Crie uma tabela chamada EDITORA, de acordo com os dados abaixo:
Campo      | Observações
----------------------------------------------------------------------
IdEditora:   Inteiro, não nulo, chave primária e auto incremento
Nome:        Caractere, não nulo e único

create table EDITORA(
"IdEditora" int not null generated always as identity primary key,
"Nome" char(50) not null unique
);





=================================================================
3. Insira os dados abaixo na tabela EDITORA
Nome:
    Bookman
    Edgard Blusher
    Nova Terra
    Brasport

insert into EDITORA ("Nome") values ('Bookman');
insert into EDITORA ("Nome") values ('Edgard Blusher');
insert into EDITORA ("Nome") values ('Nova Terra');
insert into EDITORA ("Nome") values ('Brasport');






=================================================================
4. Crie uma tabela chamada CATEGORIA, de acordo com os dados abaixo:
Campo       | Observações
----------------------------------------------------------------------
IdCategoria   Inteiro, não nulo, chave primária e auto incremento
Nome          Caractere, não nulo e único

create table CATEGORIA (
"IdCategoria" int not null primary key generated always as identity,
"Nome" char(50) not null unique
)




=================================================================
5. Insira os dados abaixo na tabela CATEGORIA.
Nome:
    Banco de Dados
    HTML
    Java
    PHP

insert into CATEGORIA ("Nome") values ('Banco de Dados');
insert into CATEGORIA ("Nome") values ('HTML');
insert into CATEGORIA ("Nome") values ('Java');
insert into CATEGORIA ("Nome") values ('PHP');




=================================================================
6. Crie uma tabela chamada AUTOR, de acordo com os dados abaixo:
Campo       |   Observações
----------------------------------------------------------------------
IdAutor         Inteiro, não nulo, chave primária e auto incremento
Nome            Caractere e não nulo


create table AUTOR(
"IdAutor" int not null primary key generated always as identity,
"Nome" char(50) not null
)



=================================================================
7. Insira os dados abaixo na tabela AUTOR
Nome:
    Waldemar Setzer
    Flávio Soares
    John Watson
    Rui Rossi dos Santos
    Antonio Pereira de Resende
    Claudiney Calixto Lima
    Evandro Carlos Teruel
    Ian Graham
    Fabrício Xavier
    Pablo Dalloglio


insert into AUTOR ("Nome") values ('Waldemar Setzer');
insert into AUTOR ("Nome") values ('Flávio Soares');
insert into AUTOR ("Nome") values ('John Watson');
insert into AUTOR ("Nome") values ('Rui Rossi dos Santos');
insert into AUTOR ("Nome") values ('Antonio Pereira de Resende');
insert into AUTOR ("Nome") values ('Claudiney Calixto Lima');
insert into AUTOR ("Nome") values ('Evandro Carlos Teruel');
insert into AUTOR ("Nome") values ('Ian Graham');
insert into AUTOR ("Nome") values ('Fabrício Xavier');
insert into AUTOR ("Nome") values ('Pablo Dalloglio');



=================================================================
8. Crie uma tabela chamada LIVRO, de acordo com os dados abaixo:
Campo       |   Observações
----------------------------------------------------------------------
IdLivro         Inteiro, não nulo, chave primária e auto incremento
IdEditora       Inteiro, não nulo e chave estrangeira para a tabela EDITORA
IdCategoria     Inteiro, não nulo e chave estrangeira para a tabela CATEGORIA
Nome            Caractere, não nulo e único

create table LIVRO(
"IdLivro" int not null primary key generated always as identity,
"IdEditora" int not null,
"IdCategoria" int not null,
"Nome" char(50) not null unique,
constraint FK_LIVRO_Editora foreign key("IdEditora") references EDITORA ("IdEditora"),
constraint FK_LIVRO_Categoria foreign key("IdCategoria") references CATEGORIA ("IdCategoria")
)


=================================================================
9. Insira os dados abaixo na tabela LIVRO.
IdEditora:      
    1
    2
    3
    4

IdCategoria:
    1
    2
    3
    4

Nome:
    Banco de Dados – 1 Edição
    Oracle DataBase 11G Administração
    Programação de Computadores em Java
    Programação Orientada a Aspectos em Java
    

insert into LIVRO ("IdEditora","IdCategoria","Nome") values (1,1,'Banco de Dados – 1 Edição');
insert into LIVRO ("IdEditora","IdCategoria","Nome") values (2,2,'Oracle DataBase 11G Administração');
insert into LIVRO ("IdEditora","IdCategoria","Nome") values (3,3,'Programação de Computadores em Java');
insert into LIVRO ("IdEditora","IdCategoria","Nome") values (4,4,'Programação Orientada a Aspectos em Java');



=================================================================
10. Crie uma tabela chamada LIVRO_AUTOR, de acordo com os dados abaixo:
Campo       |   Observações
----------------------------------------------------------------------
IdLivro         Inteiro, não nulo e chave estrangeira para a tabela LIVRO
IdAutor         Inteiro, não nulo e chave estrangeira para a tabela AUTOR

Chave primária composta com os campos IdLivro e IdAutor

create table LIVRO_AUTOR(
"IdLivro" int not null,
"IdAutor" int not null,
CONSTRAINT PK_LIVRO_AUTOR PRIMARY KEY ("IdLivro", "IdAutor"), -- <- Chave primária composta com os campos IdLivro e IdAutor
constraint FK_LIVROAUTOR_Livro foreign key("IdLivro") references LIVRO ("IdLivro"),
constraint FK_LIVROAUTOR_Autor foreign key("IdAutor") references AUTOR ("IdAutor")
)



=================================================================
11. Insira os dados abaixo na tabela LIVRO_AUTOR.
IdLivro: 
IdAutor:

INSERT INTO LIVRO_AUTOR ("IdLivro", "IdAutor") VALUES (1, 1), (1, 2), (2, 3), (3, 4),  (3, 5),  (3, 6), (4, 7),  (4, 8),  (4, 9), (4,10); 


=================================================================
12. Crie uma tabela chamada ALUNO, de acordo com os dados abaixo:
Campo       |   Observações
----------------------------------------------------------------------
IdAluno        Inteiro, não nulo, chave primária e auto incremento
Nome           Caractere e não nulo

create table ALUNO(
"IdAluno" int not null primary key generated always as identity,
"Nome" char(50) not null
)




=================================================================
13. Insira os dados abaixo na tabela ALUNO.
Nome:
    Mario
    João
    Paulo
    Pedro
    Maria

insert into ALUNO ("Nome") values ('Mario');
insert into ALUNO ("Nome") values ('João');
insert into ALUNO ("Nome") values ('Paulo');
insert into ALUNO ("Nome") values ('Pedro');
insert into ALUNO ("Nome") values ('Maria');



=================================================================
14. Crie uma tabela chamada EMPRESTIMO, de acordo com os dados abaixo:
Campo           |   Observações
----------------------------------------------------------------------
IdEmprestimo        Inteiro, não nulo, chave primária e auto incremento
IdAluno             Inteiro, não nulo e chave estrangeira para a tabela ALUNO
Data_Emprestimo     Data, não nulo e valor padrão com a data atual do sistema
Data_Devolucao      Data e não nulo
Valor               Decimal e não nulo
Devolvido           Caractere e não nulo (somente um caractere)







=================================================================
15. Insira os dados abaixo na tabela EMPRESTIMO.
IdAluno     Emprestimo      Devolucao       Valor       Devolvido
----------------------------------------------------------------------
Mario       02/05/2012      12/05/2012       10,00       S
Mario       23/04/2012      03/05/2012       5,00        N
João        10/05/2012      20/05/2012       12,00       N
Paulo       10/05/2012      20/05/2012       8,00        S
Pedro       05/05/2012      15/05/2012       15,00       N
Pedro       07/05/2012      17/05/2012       20,00       S
Pedro       08/05/2012      18/05/2012       5,00        S





=================================================================
16. Crie uma tabela chamada EMPRESTIMO_LIVRO, de acordo com os dados abaixo:
Campo           |   Observações
----------------------------------------------------------------------
IdEmprestimo        Inteiro, não nulo, chave estrangeira para a tabela EMPRESTIMO
IdLivro             Inteiro, não nulo e chave estrangeira para a tabela LIVRO

Chave primária composta com os campos IdEmprestimo e IdLivro




=================================================================
17. Insira os dados abaixo na tabela EMPRESTIMO_LIVRO.
IdEmpréstimo:                    
        Primeiro empréstimo do Mário        
        Segundo empréstimo do Mário
        Segundo empréstimo do Mário
        Terceiro empréstimo do Pedro
        Segundo empréstimo do Pedro
        Segundo empréstimo do Pedro
        Empréstimo do João 
        Primeiro empréstimo do Pedro
        Empréstimo do Paulo 
        Empréstimo do João 

IdLivro:
        Banco de Dados – 1 Edição
        Programação Orientada a Aspectos em Java
        Programação de Computadores em Java
        Oracle DataBase 11G Administração
        PHP para Desenvolvimento Profissional
        HTML5 – Guia Prático 
        Programação Orientada a Aspectos em Java
        XHTML: Guia de Referência para Desenvolvimento na Web
        Bando de Dados – 1 Edição
        PHP com Programação Orientada a Objetos

=================================================================
18. Crie os seguintes índices:
Tabela          |   Campo
Emprestimo          Emprestimo
Emprestimo          Devolução




=================================================================
CONSULTAS SIMPLES
19. O nome dos autores em ordem alfabética.
20. O nome dos alunos que começam com a letra P.
21. O nome dos livros da categoria Banco de Dados ou Java.
22. O nome dos livros da editora Bookman.
23. Os empréstimos realizados entre 05/05/2012 e 10/05/2012.
24. Os empréstimos que não foram feitos entre 05/05/2012 e 10/05/2012
25. Os empréstimos que os livros já foram devolvidos.




=================================================================
CONSULTAS COM AGRUPAMENTO SIMPLES
26. A quantidade de livros.
27. O somatório do valor dos empréstimos.
28. A média do valor dos empréstimos.
29. O maior valor dos empréstimos.
30. O menor valor dos empréstimos.
31. O somatório do valor do empréstimo que estão entre 05/05/2012 e 10/05/2012.
32. A quantidade de empréstimos que estão entre 01/05/2012 e 05/05/2012.




=================================================================
CONSULTAS COM JOIN
33. O nome do livro, a categoria e a editora (LIVRO) – fazer uma view
34. O nome do livro e o nome do autor (LIVRO_AUTOR) – fazer uma view.
35. O nome dos livros do autor Ian Graham (LIVRO_AUTOR).
36. O nome do aluno, a data do empréstimo e a data de devolução (EMPRESTIMO).
37. O nome de todos os livros que foram emprestados (EMPRESTIMO_LIVRO).




=================================================================
CONSULTAS COM AGRUPAMENTO + JOIN
38. O nome da editora e a quantidade de livros de cada editora (LIVRO).
39. O nome da categoria e a quantidade de livros de cada categoria (LIVRO).
40. O nome do autor e a quantidade de livros de cada autor (LIVRO_AUTOR).
41. O nome do aluno e a quantidade de empréstimo de cada aluno (EMPRESTIMO_LIVRO).
42. O nome do aluno e o somatório do valor total dos empréstimos de cada aluno (EMPRESTIMO).
43. O nome do aluno e o somatório do valor total dos empréstimos de cada aluno somente daqueles que o somatório for maior do que 7,00 (EMPRESTIMO).




=================================================================
CONSULTAS COMANDOS DIVERSOS
44. O nome de todos os alunos em ordem decrescente e em letra maiúscula.
45. Os empréstimos que foram feitos no mês 04 de 2012.
46. Todos os campos do empréstimo. Caso já tenha sido devolvido, mostrar a mensagem “Devolução completa”, senão “Em atraso”.
47. Somente o caractere 5 até o caractere 10 do nome dos autores.
48. O valor do empréstimo e somente o mês da data de empréstimo. Escreva “Janeiro”, “Fevereiro”, etc




=================================================================
SUBCONSULTAS
49. A data do empréstimo e o valor dos empréstimos que o valor seja maior que a média de todos os empréstimos.
50. A data do empréstimo e o valor dos empréstimos que possuem mais de um livro.
51. A data do empréstimo e o valor dos empréstimos que o valor seja menor que a soma de todos os empréstimos.









