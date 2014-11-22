create view alunos_pos as
(select *
 from aluno natural join posgrad)
 
 create view alunos_doutorado as
 (select *
  from aluno natural join posgrad
  where tipo = 'doutorado')
  
  create view alunos_mestrado as
 (select *
  from aluno natural join posgrad
  where tipo = 'mestrado')
  
 create view monitores as
 (select *
  from monitoria, aluno
  where aluno = matricula)
  
  
 create view monitores_grad_nao_eng as
 (
	SELECT *
	FROM aluno
	WHERE matricula IN ( SELECT G.matricula
                         FROM grad as G, monitoria as M
                         WHERE G.matricula = M.aluno
                         AND G.curso NOT LIKE '%Engenharia%'
                         AND M.data_fim IS NULL)
	ORDER BY nome
 )
  
  
 create view monitor_e_estagiario as
 (
	SELECT M.matricula, M.nome, E.laboratorio
    FROM monitores as M left outer join estagiolab as E on M.aluno = E.aluno
 )
 
 create view posgrad_2013 as
 (
	SELECT COUNT (*)
	FROM posgrad
	WHERE PeriodoInicio like '2013.?'
 )
 
 create view cred_sergio as
 (
	SELECT SUM(numcred)
	FROM projetoorientado INNER JOIN professor ON 	projetoorientado.matriculaprof = professor.matricula 
	WHERE professor.nome = 'Sergio Lifschitz'
 )
 
 create view orient_e_coorient as
 (
	SELECT nome
	FROM professor
	WHERE matricula IN
            (SELECT P.matricula
            FROM professor as P, posgrad as PG
            WHERE PG.coorientador=P.matricula)
            INTERSECT
            (SELECT P.matricula
            FROM professor as P, posgrad as PG
            WHERE PG.orientador=P.matricula)
 )
 
 create view monitores_progI as
 (
	SELECT aluno
	FROM monitoria
	WHERE codigo = 'INF1005'
	EXCEPT(
				SELECT aluno
				FROM monitoria
				WHERE data_fim IS NOT NULL
            )
 )
 
 create view monitor_eou_estagiario as
 (
	SELECT aluno
	FROM monitoria
	UNION (
	SELECT aluno
	FROM estagiolab
	)
 )
 
 create view projeto2014 as
 (
	SELECT P.matricula, P.nome

	FROM professor as P

	WHERE EXISTS ( SELECT *

	FROM projetoorientado as PJO

	WHERE PJO.matricula_prof = P.matricula

	AND PJO.periodo=2014.1 )
 )