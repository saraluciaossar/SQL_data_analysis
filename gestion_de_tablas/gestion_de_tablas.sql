USE transactions;

-- NIVEL 1
-- Exercici 1

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

-- Exercici 2
-- El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit 
-- amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. 
-- Recorda mostrar que el canvi es va realitzar.

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';


UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

-- Exercici 3
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:
-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id	b-9999
-- user_id	9999
-- lat	829.999
-- longitude	-117.999
-- amount	111.11
-- declined	0

SELECT *
FROM credit_card
WHERE id = 'CcU-9999'; -- Para comprobar si existe esta PK

INSERT INTO credit_card (id)
VALUES ('CcU-9999'); -- Como no existe, la creo para que no falle la FK

SELECT *
FROM company
WHERE id = 'b-9999';

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0); 

SELECT *
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- Exercici 4
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP pan;

SELECT *
FROM credit_card;


-- NIVEL 2
-- Exercici 1
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM transaction
WHERE ID = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT *
FROM transaction
WHERE ID = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


-- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS    
    SELECT 
		c.company_name AS nombre_compania,
		c.phone AS telefono,
		c.country AS pais,
		ROUND(AVG(t.amount), 2) AS media_de_compra
	FROM company AS c
	JOIN transaction AS t
	ON c.id = t.company_id
	GROUP BY c.id;
    
SELECT *
FROM VistaMarketing
ORDER BY media_de_compra DESC;

-- Exercici 3
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT *
FROM VistaMarketing
WHERE pais = 'Germany';


-- NIVEL 3
-- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
-- Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 

SELECT *
FROM user;

SELECT t.user_id
FROM transaction AS t
LEFT JOIN user AS u
ON t.user_id = u.id
WHERE u.id IS NULL;

INSERT INTO user (id)
VALUES (9999);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id)
REFERENCES user(id);


-- Exercici 2
-- L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
-- ID de la transacció
-- Nom de l'usuari/ària
-- Cognom de l'usuari/ària
-- IBAN de la targeta de crèdit usada.
-- Nom de la companyia de la transacció realitzada.

-- Assegureu-vos d'incloure informació rellevant de les taules que coneixereu 
-- i utilitzeu àlies per canviar de nom columnes segons calgui.
-- Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.

CREATE VIEW InformeTecnico AS
	SELECT 
		t.id AS ID_transaccion,
		u.name AS nombre_usuario,
		u.surname AS apellido_usuario,
		cc.iban AS IBAN,
		c.company_name AS nombre_compañia
	FROM transaction AS t
	JOIN user AS u
	ON t.user_id = u.id
	JOIN credit_card AS cc
	ON t.credit_card_id = cc.id
	JOIN company AS c
	ON t.company_id = c.id;

SELECT *
FROM InformeTecnico
ORDER BY ID_transaccion DESC;

-- Informe técnico versión 2 con paises
CREATE VIEW InformeTecnicoTransacciones AS
	SELECT 
		t.id AS ID_transaccion,
		u.name AS nombre_usuario,
		u.surname AS apellido_usuario,
		cc.iban AS IBAN,
		c.company_name AS nombre_compañia,
		IF(u.country = c.country, 'Nacional', 'Internacional') AS tipo_transaccion
	FROM transaction AS t
	JOIN user AS u
	ON t.user_id = u.id
	JOIN credit_card AS cc
	ON t.credit_card_id = cc.id
	JOIN company AS c
	ON t.company_id = c.id;

SELECT *
FROM InformeTecnicoTransacciones
ORDER BY ID_transaccion DESC;



-- También con CASE
-- SELECT 
-- 	t.id AS ID_transaccion,
-- 	u.name AS nombre_usuario,
-- 	u.surname AS apellido_usuario,
-- 	cc.iban AS IBAN,
-- 	c.company_name AS nombre_compañia,
-- 	CASE 
-- 		WHEN u.country = c.country THEN 'Nacional'
-- 		ELSE 'Internacional'
-- 	END AS tipo_transaccion
-- FROM transaction AS t
-- JOIN user AS u
-- ON t.user_id = u.id
-- JOIN credit_card AS cc
-- ON t.credit_card_id = cc.id
-- JOIN company AS c
-- ON t.company_id = c.id
-- ORDER BY t.id DESC;



