USE transactions;

-- NIVEL 1

-- EXERCICI 1
-- A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
-- Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
-- Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

DESCRIBE company;
DESCRIBE transaction;


-- EXERCICI 2
-- Utilitzant JOIN realitzaràs les següents consultes:
-- Llistat dels països que estan generant vendes.
SELECT DISTINCT c.country
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.declined = 0; -- Para que sean son los paises con transacciones aceptadas 


-- Des de quants països es generen les vendes.
SELECT COUNT(DISTINCT c.country) AS cantidad_de_paises
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.declined = 0;


-- Identifica la companyia amb la mitjana més gran de vendes.
SELECT c.company_name, AVG(t.amount) AS media_ventas
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.declined = 0 -- Para que filtre solo los paises con transacciones aceptadas
GROUP BY c.id, c.company_name
ORDER BY media_ventas DESC
LIMIT 1;

-- EXERCICI 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT *
FROM transaction
WHERE declined = 0 AND
	company_id IN (
		SELECT id
		FROM company
        WHERE country = 'Germany'
);

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT company_name
FROM company
WHERE id IN (
	SELECT company_id
	FROM transaction
	WHERE declined = 0 AND
		amount > (
				SELECT AVG(amount)
				FROM transaction
                )
);

-- Elimina del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT company_name AS empresas_sin_transacciones
FROM company
WHERE id NOT IN (
    SELECT company_id
    FROM transaction -- No agrego WHERE company_id IS NOT NULL en la subquery porque el campo ID no admite null
);

-- CONSULTA CORRELACIONADA DATACAMP https://www.datacamp.com/es/tutorial/sql-in
-- SELECT company_name AS empresas_sin_transacciones
-- FROM company AS c
-- WHERE NOT EXISTS ( -- para evitar problemas con null
-- 		SELECT 1
--      FROM transaction AS t
-- 		WHERE c.id = t.company_id
-- );


-- NIVEL 2
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT 
    DATE(timestamp) AS dia,
    SUM(amount) AS total_ventas
FROM transaction
WHERE declined = 0 -- Para que filtre solo los paises con transacciones aceptadas
GROUP BY dia
ORDER BY total_ventas DESC
LIMIT 5;


-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT
	c.country, 
	ROUND(AVG(t.amount), 2) AS media_ventas
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.declined = 0 -- Para que filtre solo los paises con transacciones aceptadas
GROUP BY c.country
ORDER BY media_ventas DESC;

-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries 
-- per a fer competència a la companyia "Non Institute". 
-- Per a això, et demanen la llista de totes les transaccions realitzades per empreses 
-- que estan situades en el mateix país que aquesta companyia.

-- a. Mostra el llistat aplicant JOIN i subconsultes.
SELECT c.company_name,
	t.amount AS valor_de_transaccion,
    DATE (t.timestamp) AS fecha
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE c.country IN (
	SELECT country
	FROM company
	WHERE company_name = 'Non Institute'
);


-- b. Mostra el llistat aplicant solament subconsultes.
SELECT (
	SELECT company_name
    FROM company
    WHERE id = company_id) AS company_name,
    amount AS valor_de_transaccion,
    DATE(timestamp) AS fecha
FROM transaction
WHERE company_id IN (
	SELECT id
    FROM company
    WHERE country = (
		SELECT country
        FROM company
        WHERE company_name = 'Non Institute'
    )
);

-- NIVEL 3
-- Exercici 1
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions 
-- amb un valor comprès entre 350 i 400 euros 
-- i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. 
-- Ordena els resultats de major a menor quantitat.

SELECT
    c.company_name AS compañia,
    c.phone AS telefono,
    c.country AS pais,
    DATE(t.timestamp) AS fecha,
    ROUND(t.amount, 2) AS ventas
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.declined = 0 AND
	t.amount BETWEEN 350 AND 400
	AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY t.amount DESC;


-- Exercici 2
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
-- per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
-- però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis 
-- si tenen més de 400 transaccions o menys.

SELECT
	c.company_name AS compañia,
    COUNT(t.id) AS total_transacciones,
CASE
	WHEN COUNT(t.id) > 400 THEN 'Más de 400'
	ELSE '400 o menos'
END AS cantidad_de_transacciones
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
GROUP BY c.id, c.company_name
ORDER BY cantidad_de_transacciones;

