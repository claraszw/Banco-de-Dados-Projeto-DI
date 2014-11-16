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

-- ******************************************************
CREATE TRIGGER tg_chk_dedicacao BEFORE INSERT OR UPDATE ON posgrad
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
$tg_chk_dedicacao$ LANGUAGE plpgsql;


-- ******************************************************

