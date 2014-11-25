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
/*
CREATE TRIGGER tg_chk_monitoria_insert BEFORE INSERT ON monitoria
FOR EACH ROW EXECUTE PROCEDURE chk_monitoria_insert();

CREATE OR REPLACE FUNCTION chk_monitoria_insert() 
RETURNS TRIGGER AS $tg_chk_monitoria_insert$
DECLARE 
	aluno monitoria.aluno%TYPE;
BEGIN
	SELECT monitoria.aluno into aluno
	FROM monitoria
	WHERE new.aluno = monitoria.aluno
	AND (monitoria.data_fim>new.data_ini
	OR monitoria.data_fim is NULL);
	
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui/possuia uma monitoria em andamento.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_monitoria_insert$ LANGUAGE plpgsql;*/

--********************************************************
/*
CREATE TRIGGER tg_chk_monitoria_update BEFORE UPDATE ON monitoria
FOR EACH ROW EXECUTE PROCEDURE chk_monitoria_update();

CREATE OR REPLACE FUNCTION chk_monitoria_update() 
RETURNS TRIGGER AS $tg_chk_monitoria_update$
DECLARE 
	aluno monitoria.aluno%TYPE;
BEGIN
	SELECT monitoria.aluno into aluno
	FROM monitoria
	WHERE new.aluno = monitoria.aluno
	AND monitoria.data_fim>new.data_ini
	AND monitoria.data_ini!=new.data_ini;
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui/possuia uma monitoria em andamento.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_monitoria_update$ LANGUAGE plpgsql;*/

-- ******************************************************
/*
CREATE TRIGGER tg_chk_estagiolab_insert BEFORE INSERT ON estagiolab
FOR EACH ROW EXECUTE PROCEDURE chk_estagiolab_insert();

CREATE OR REPLACE FUNCTION chk_estagiolab_insert() 
RETURNS TRIGGER AS $tg_chk_estagiolab_insert$
DECLARE 
	aluno estagiolab.aluno%TYPE;
BEGIN
	SELECT estagiolab.aluno into aluno	
	FROM estagiolab
	WHERE new.aluno=estagiolab.aluno
	AND (estagiolab.data_fim>new.data_ini
	OR estagiolab.data_fim is NULL);
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui/possuia um estagio em laboratorio em andamento.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_estagiolab_insert$ LANGUAGE plpgsql;*/

-- ******************************************************
/*
CREATE TRIGGER tg_chk_estagiolab_update BEFORE UPDATE ON estagiolab
FOR EACH ROW EXECUTE PROCEDURE chk_estagiolab_update();

CREATE OR REPLACE FUNCTION chk_estagiolab_update() 
RETURNS TRIGGER AS $tg_chk_estagiolab_update$
DECLARE 
	aluno estagiolab.aluno%TYPE;
BEGIN
	SELECT estagiolab.aluno into aluno	
	FROM estagiolab
	WHERE new.aluno=estagiolab.aluno
	AND estagiolab.data_fim>new.data_ini
	AND estagiolab.data_ini!=new.data_ini;
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui/possuia um estagio em laboratorio em andamento.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_estagiolab_update$ LANGUAGE plpgsql;*/

-- ******************************************************

CREATE TRIGGER tg_chk_brasileiro BEFORE INSERT OR UPDATE ON posgrad
FOR EACH ROW EXECUTE PROCEDURE chk_brasileiro();


CREATE OR REPLACE FUNCTION chk_brasileiro() 
RETURNS TRIGGER AS $tg_chk_brasileiro$
DECLARE 
	nacionalidade posgrad.nacionalidade%TYPE;
BEGIN
	SELECT posgrad.nacionalidade INTO nacionalidade
	FROM posgrad
	WHERE new.matricula=posgrad.matricula;
	
	IF lower(new.nacionalidade) like 'brasileir_' OR lower(nacionalidade) like 'brasileir_' THEN
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
	
	
	IF lower(new.nacionalidade) not like 'brasileir_' THEN
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