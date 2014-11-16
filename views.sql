create view alunos_pos as
(select *
 from alunos natural join posgrad)
 
 create view alunos_doutorado as
 (select *
  from alunos natural join grad
  where tipo = 'doutorado')
  
  create view alunos_mestrado as
 (select *
  from alunos natural join grad
  where tipo = 'mestrado')
  
 create view monitores as
 (select *
  from monitoria, alunos
  where aluno = matricula)
  
  