USE world_transactions;

-- NIVEL 1
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
SELECT *
FROM users AS u
WHERE EXISTS (
    SELECT 1
    FROM transactions AS t
    WHERE t.id_user = u.id_user
    GROUP BY t.id_user
    HAVING COUNT(t.id_user) > 80
);

-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT 
    cc.iban,
    ROUND(AVG(t.amount), 2) AS transaccion_media
FROM transactions AS t
JOIN credit_card AS cc 
    ON cc.id_creditCard = t.id_creditCard
JOIN company AS c 
    ON c.id_company = t.id_company
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.iban;



-- Nivell 2
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en 
-- si les tres últimes transaccions han estat declinades aleshores és inactiu, 
-- si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:
CREATE TABLE card_status AS
	WITH tres_ultimas AS (
		SELECT id_creditCard, declined, timestamp,
			ROW_NUMBER() OVER (
				PARTITION BY id_creditCard
				ORDER BY timestamp DESC
			) AS ranking_tres
		FROM transactions
		)
	SELECT id_creditCard,
		CASE
			WHEN SUM(declined) = 3 THEN 'inactiva'
			ELSE 'activa'
		END AS estado_tarjeta
	FROM tres_ultimas
	WHERE ranking_tres <= 3
	GROUP BY id_creditCard;

SELECT *
FROM card_status;

-- Exercici 1
-- Quantes targetes estan actives?

SELECT COUNT(*) AS tarjetas_activas
FROM card_status
WHERE estado_tarjeta = 'activa';


-- Nivell 3
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
-- tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

-- Se crea tabla intermedia entre transactions y products
CREATE TABLE transactions_products (
    id_transaction VARCHAR(50),
    id_product VARCHAR(255),
    PRIMARY KEY (id_transaction, id_product)
);

INSERT INTO transactions_products (id_transaction, id_product)
SELECT
    t.id_transaction,
    jt.id_product
FROM transactions AS t
CROSS JOIN JSON_TABLE( -- Por cada fila de transactions, genera varias filas (una por cada producto)
    CONCAT( -- Se concatenan los nuevos replace con la estructura del array del JSON '[' y ']' 
        '["',
        REPLACE(REPLACE(t.id_product, ' ', ''), ',', '","'),
        '"]'
    ),
    '$[*]' COLUMNS ( -- recorre el JSON ($) y todos los elementos del array (*) y añadelo a una columna
        id_product VARCHAR(255) PATH '$' -- PATH $ de cada elemento coge el valor completo y añadelo a una fila de la columna
    )
) AS jt;


SELECT *
FROM transactions_products;

-- Exercici 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT 
	product_name AS producto, 
	COUNT(*) AS cantidad_ventas
FROM products AS p
JOIN transactions_products AS tp
	ON p.id_product = tp.id_product
GROUP BY p.id_product
ORDER BY cantidad_ventas DESC;
