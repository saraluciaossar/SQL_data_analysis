    -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );
    
    
    -- Creamos la tabla credit_card
    CREATE TABLE IF NOT EXISTS credit_card (
		id VARCHAR(15) PRIMARY KEY,
		iban VARCHAR(100),
		pan VARCHAR(50),
		pin VARCHAR(4),
		cvv VARCHAR(3),
		expiring_date VARCHAR(8)
	);

	-- Creamos la tabla de user
    CREATE TABLE IF NOT EXISTS user (
		id INT PRIMARY KEY,
		name VARCHAR(100),
		surname VARCHAR(100),
		phone VARCHAR(150),
		email VARCHAR(150),
		birth_date VARCHAR(100),
		country VARCHAR(150),
		city VARCHAR(150),
		postal_code VARCHAR(100),
		address VARCHAR(255)    
	);

     
    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(15) PRIMARY KEY,
        credit_card_id VARCHAR(15),
        company_id VARCHAR(20), 
        user_id INT,
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        
        CONSTRAINT fk_transaction_credit_card
			FOREIGN KEY (credit_card_id) REFERENCES credit_card(id),
		
        CONSTRAINT fk_transaction_company
			FOREIGN KEY (company_id) REFERENCES company(id)
    );
    

    