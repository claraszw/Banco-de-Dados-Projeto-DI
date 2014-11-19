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
	data_fim monitoria.data_fim%TYPE;
BEGIN
	SELECT monitoria.aluno into aluno, monitoria.data_fim into data_fim
	FROM monitoria
	WHERE monitoria.data_fim>new.data_ini
	OR monitoria.data_fim is NULL;
	
	IF aluno IS NOT NULL THEN
		IF data_fim IS NULL THEN
				RAISE EXCEPTION 'Aluno % já possui uma monitoria em andamento.', new.aluno;
		ELSE
				RAISE EXCEPTION 'Aluno % possuia uma monitoria até %',data_fim;
		END IF;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_monitoria$ LANGUAGE plpgsql;

--********************************************************

-- ******************************************************

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
	OR estagiolab.data_fim is NULL;
	
	IF aluno IS NOT NULL THEN
		RAISE EXCEPTION 'Aluno % já possui um estagio em laboratorio.', new.aluno;
		RETURN NULL;
	END IF;
	

	RETURN NEW;
END;
$tg_chk_estagiolab$ LANGUAGE plpgsql;

