USE world_transactions;

-- NIVEL 0 
-- Preparar la carga (antes activar comando en terminal)
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- Estructura para cargar datos user europeos
LOAD DATA LOCAL INFILE '/Users/saraluciaossa/Downloads/european_users.csv'
INTO TABLE users_ue_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_user, name, surname, phone, email, birth_date, country, city, postal_code, address);

SELECT *
FROM users_ue_raw;

-- Estructura para cargar datos user americanos
LOAD DATA LOCAL INFILE '/Users/saraluciaossa/Downloads/american_users.csv'
INTO TABLE users_eua_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_user, name, surname, phone, email, birth_date, country, city, postal_code, address);

SELECT *
FROM users_eua_raw;

-- Contar si hay duplicados o nulos en los id_user
WITH users AS (
    SELECT id_user FROM users_eua_raw
    UNION ALL
    SELECT id_user FROM users_ue_raw
)
SELECT id_user, COUNT(*)
FROM users
GROUP BY id_user
HAVING COUNT(*) > 1;

SELECT id_user
FROM users
WHERE id_user IS NULL 
	OR TRIM(id_user) = ' '; -- TRIM para eliminar espacios vacíos en caso de que venga más de uno

-- Unir las dos tablas de users (eua y ue) en la nueva tabla "Users"
INSERT INTO Users (id_user, name, surname, phone, email, birth_date, country, city, postal_code, address)
SELECT id_user, name, surname, phone, email, birth_date, country, city, postal_code, address
FROM users_eua_raw
UNION ALL
SELECT id_user, name, surname, phone, email, birth_date, country, city, postal_code, address
FROM users_ue_raw;

SELECT *
FROM users;

-- Cargar datos de company
LOAD DATA LOCAL INFILE '/Users/saraluciaossa/Downloads/companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_company, company_name, phone, email, country, website);

SELECT *
FROM company;

-- Cargar datos de Credit Card
LOAD DATA LOCAL INFILE '/Users/saraluciaossa/Downloads/credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_creditCard, id_user, iban, pan, pin, cvv, track1, track2, expiring_date);

SELECT *
FROM credit_card;

-- Cargar datos de transactions
LOAD DATA LOCAL INFILE '/Users/saraluciaossa/Downloads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_transaction, id_creditCard, id_company, timestamp, amount, declined, id_product, id_user, lat, longitude);

SELECT *
FROM transactions;


-- Revisar si hay duplicados en los id (futuras PK) de cada de las tablas transactions, credit_card y company
SELECT id_company, COUNT(*)
FROM company
GROUP BY id_company
HAVING COUNT(id_company) > 1;

SELECT id_creditCard, COUNT(*)
FROM credit_card
GROUP BY id_creditCard
HAVING COUNT(id_creditCard) > 1;

SELECT id_transaction, COUNT(*)
FROM transactions
GROUP BY id_transaction
HAVING COUNT(id_transaction) > 1;

-- Revisar si hay valores nulos en los id (futuras PK) de cada de las tablas transactions, credit_card y company
SELECT *
FROM company
WHERE id_company IS NULL 
	OR TRIM(id_company) = ' '; -- TRIM para eliminar espacios vacíos en caso de que venga más de uno

SELECT *
FROM credit_card
WHERE id_creditCard IS NULL 
	OR TRIM(id_creditCard) = ' ';

SELECT *
FROM transactions
WHERE id_transaction IS NULL 
	OR TRIM(id_transaction) = ' ';
    

-- Modificar campos y añadir las PK de las tablas transactions, credit_card y company 

ALTER TABLE company
MODIFY id_company VARCHAR(10) NOT NULL,
MODIFY company_name VARCHAR(255) NOT NULL,
ADD CONSTRAINT pk_company PRIMARY KEY (id_company);

ALTER TABLE credit_card
MODIFY id_creditCard VARCHAR(10) NOT NULL,
MODIFY id_user VARCHAR(50) NULL,
ADD CONSTRAINT pk_credit_card PRIMARY KEY (id_creditCard);

ALTER TABLE transactions
MODIFY id_transaction VARCHAR(255) NOT NULL,
MODIFY id_user VARCHAR(50) NULL,
MODIFY id_company VARCHAR(10) NULL,
MODIFY id_creditCard VARCHAR(10) NULL,
MODIFY amount DECIMAL(10,2) NULL,
ADD CONSTRAINT pk_transactions PRIMARY KEY (id_transaction);

ALTER TABLE transactions
MODIFY declined BOOLEAN NULL;


-- Validación fact table con dimensiones (antes de añadir FK a transactions)
SELECT *
FROM transactions AS t
WHERE NOT EXISTS (
    SELECT 1
    FROM company AS c
    WHERE c.id_company = t.id_company
);

SELECT *
FROM transactions AS t
WHERE NOT EXISTS (
    SELECT 1
    FROM credit_card AS cc
    WHERE cc.id_creditCard = t.id_creditCard
);

SELECT *
FROM transactions AS t
WHERE NOT EXISTS (
    SELECT 1
    FROM users AS u
    WHERE u.id_user = t.id_user
);


-- Añadir las FK a la factTable (transactions)
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_user
    FOREIGN KEY (id_user) REFERENCES users(id_user),
ADD CONSTRAINT fk_transactions_company
    FOREIGN KEY (id_company) REFERENCES company(id_company),
ADD CONSTRAINT fk_transactions_creditcard
    FOREIGN KEY (id_creditCard) REFERENCES credit_card(id_creditCard);


-- Limpieza de tablas y datos más profunda
SELECT *
FROM company;

SELECT *
FROM credit_card;

SELECT *
FROM transactions;

SELECT *
FROM users;

DESCRIBE company;
DESCRIBE credit_card;
DESCRIBE transactions;
DESCRIBE users;

-- Arreglar timestamp en transactions
-- Verificar si hay formato nulo o vacíos
SELECT timestamp
FROM transactions
WHERE timestamp IS NULL
   OR timestamp = '';
   
-- Se modifica la columna timestamp de transactions en formato DATETIME
ALTER TABLE transactions
MODIFY COLUMN timestamp DATETIME;

-- Se eliminan las tablas RAW de users_eua y users_ue
DROP TABLE IF EXISTS users_eua_raw, users_ue_raw;

-- Se eliminan los campos track 1 y track 2 de credit_card
ALTER TABLE credit_card
DROP track1;

ALTER TABLE credit_card
DROP track2;

SELECT *
FROM credit_card;


-- Estructura para cargar datos user europeos
LOAD DATA LOCAL INFILE '/Users/saraluciaossa/Downloads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_product, product_name, price, colour, weight, warehouse_id);

SELECT *
FROM products;


-- Revisar si hay duplicados en los ID de products
SELECT id_product, COUNT(*)
FROM products
GROUP BY id_product
HAVING COUNT(id_product) > 1;

-- Revisar si hay valores nulos en los id (futuras PK) de la tabla products
SELECT *
FROM products
WHERE id_product IS NULL 
	OR TRIM(id_product) = ' ';

-- Añadir PK a products
ALTER TABLE products
MODIFY id_product VARCHAR(255) NOT NULL,
ADD CONSTRAINT pk_product PRIMARY KEY (id_product);




