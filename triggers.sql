/*
CREATE TRIGGER tg_tem_orientador BEFORE INSERT OR UPDATE ON posgrad
FOR EACH ROW EXECUTE PROCEDURE tem_orientador();

CREATE OR REPLACE FUNCTION tem_orientador() 
RETURNS TRIGGER AS $tg_tem_orientador$
	
BEGIN
	
	IF new.tipo='doutorado' AND new.orientador is NULL THEN
		RAISE EXCEPTION 'Doutorando % deve obrigatoriamente possuir um orientador.', NEW.matricula;
		RETURN NULL;
	END IF;

	RETURN NEW;
END;
$tg_tem_orientador$ LANGUAGE plpgsql;
*/

-- ******************************************************
/*CREATE TRIGGER tg_chk_dedicacao BEFORE INSERT OR UPDATE ON posgrad
FOR EACH ROW EXECUTE PROCEDURE chk_dedicacao();

CREATE OR REPLACE FUNCTION chk_dedicacao() 
RETURNS TRIGGER AS $tg_chk_dedicacao$
	
BEGIN

	IF new.tipo='doutorado' AND new.dedicacao!='exclusiva' THEN
		RAISE EXCEPTION 'Doutorando % deve obrigatoriamente possuir dedicacao exclusiva.', NEW.matricula;
		RETURN NULL;
	END IF;

	RETURN NEW;
END;
$tg_chk_dedicacao$ LANGUAGE plpgsql;*/


-- ******************************************************

CREATE TRIGGER tg_chk_monitoria BEFORE INSERT OR UPDATE ON monitoria
FOR EACH ROW EXECUTE PROCEDURE chk_monitoria();

CREATE OR REPLACE FUNCTION chk_monitoria() 
RETURNS TRIGGER AS $tg_chk_monitoria$
DECLARE 
	aluno monitoria.aluno%TYPE;
BEGIN
	SELECT monitoria.aluno into aluno
	FROM monitoria
	WHERE monitoria.data_fim>new.data_ini
	OR monitoria.data_fim is NULL
	AND new.aluno = monitoria.aluno;
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui/possuia uma monitoria em andamento.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_monitoria$ LANGUAGE plpgsql;

--********************************************************

-- ******************************************************
/*
CREATE TRIGGER tg_chk_estagiolab BEFORE INSERT OR UPDATE ON estagiolab
FOR EACH ROW EXECUTE PROCEDURE chk_estagiolab();

CREATE OR REPLACE FUNCTION chk_estagiolab() 
RETURNS TRIGGER AS $tg_chk_estagiolab$
DECLARE 
	aluno estagiolab.aluno%TYPE;
BEGIN
	SELECT estagiolab.aluno into aluno	
	FROM estagiolab
	WHERE estagiolab.data_fim>new.data_ini
	OR estagiolab.data_fim is NULL
	AND new.aluno=estagiolab.aluno;
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui/possuia um estagio em laboratorio em andamento.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_estagiolab$ LANGUAGE plpgsql;*/

-- ******************************************************
/*
CREATE TRIGGER tg_chk_brasileiro BEFORE INSERT OR UPDATE ON posgrad
FOR EACH ROW EXECUTE PROCEDURE chk_brasileiro();


CREATE OR REPLACE FUNCTION chk_brasileiro() 
RETURNS TRIGGER AS $tg_chk_brasileiro$

BEGIN
	
	
	IF lower(new.nacionalidade)='brasileir_' THEN
		IF new.id IS NULL THEN
			RAISE EXCEPTION 'Aluno % brasileiro precisa de um número de id.', new.matricula;
			RETURN NULL;
		END IF;
		IF new.orgao_emissor IS NULL THEN
			RAISE EXCEPTION 'Aluno % brasileiro precisa de um órgão emissor.', new.matricula;
			RETURN NULL;
		END IF;
		IF new.data_emissao IS NULL THEN
			RAISE EXCEPTION 'Aluno % brasileiro precisa de uma data de emissão.', new.matricula;
			RETURN NULL;
		END IF;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_brasileiro$ LANGUAGE plpgsql;*/

-- ******************************************************
/*
CREATE TRIGGER tg_chk_estrangeiro BEFORE INSERT OR UPDATE ON posgrad
FOR EACH ROW EXECUTE PROCEDURE chk_estrangeiro();


CREATE OR REPLACE FUNCTION chk_estrangeiro() 
RETURNS TRIGGER AS $tg_chk_estrangeiro$

BEGIN
	
	
	IF lower(new.nacionalidade)!='brasileir_' THEN
		IF new.num_passaporte IS NULL THEN
			RAISE EXCEPTION 'Aluno % estrangeiro precisa de um número de passaporte.', new.matricula;
			RETURN NULL;
		END IF;
		IF new.pais_passaporte IS NULL THEN
			RAISE EXCEPTION 'Aluno % estrangeiro precisa de um país do passaporte.', new.matricula;
			RETURN NULL;
		END IF;
		IF new.validade_passaporte IS NULL THEN
			RAISE EXCEPTION 'Aluno % estrangeiro precisa de uma data de validade do passaporte.', new.matricula;
			RETURN NULL;
		END IF;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_estrangeiro$ LANGUAGE plpgsql;*/