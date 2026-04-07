-- Se crea la BBDD
CREATE DATABASE world_transactions;
USE world_transactions;

-- Se crean las tablas
-- User EUA
CREATE TABLE users_eua_raw (
	id_user VARCHAR(255) NULL,
	name VARCHAR(255) NULL,
	surname VARCHAR(255) NULL,
	phone VARCHAR(255) NULL,
	email VARCHAR(255) NULL,
	birth_date VARCHAR(255) NULL,
	country VARCHAR(255) NULL,
	city VARCHAR(255) NULL,
	postal_code VARCHAR(255) NULL,
	address VARCHAR(255) NULL    
);

-- User UE
CREATE TABLE users_ue_raw (
	id_user VARCHAR(255) NULL,
	name VARCHAR(255) NULL,
	surname VARCHAR(255) NULL,
	phone VARCHAR(255) NULL,
	email VARCHAR(255) NULL,
	birth_date VARCHAR(255) NULL,
	country VARCHAR(255) NULL,
	city VARCHAR(255) NULL,
	postal_code VARCHAR(255) NULL,
	address VARCHAR(255) NULL    
);

-- Users
CREATE TABLE users (
    id_user VARCHAR(50) NOT NULL,
    name VARCHAR(255) NULL,
    surname VARCHAR(255) NULL,
    phone VARCHAR(255) NULL,
    email VARCHAR(255) NULL,
    birth_date VARCHAR(255) NULL,
    country VARCHAR(255) NULL,
    city VARCHAR(255) NULL,
    postal_code VARCHAR(255) NULL,
    address VARCHAR(255) NULL,
    PRIMARY KEY (id_user)
);

-- Company
CREATE TABLE company (
    id_company VARCHAR(255) NULL,
    company_name VARCHAR(255) NULL,
    phone VARCHAR(255) NULL,
    email VARCHAR(255) NULL,
    country VARCHAR(255) NULL,
    website VARCHAR(255) NULL
);

-- Credit card
CREATE TABLE credit_card (
    id_creditCard VARCHAR(255) NULL,
    id_user VARCHAR(255) NULL,
    iban VARCHAR(255) NULL,
    pan VARCHAR(255) NULL,
    pin VARCHAR(255) NULL,
    cvv VARCHAR(255) NULL,
    track1 VARCHAR(255) NULL,
    track2 VARCHAR(255) NULL,
    expiring_date VARCHAR(255) NULL
);

-- Transactions (fact table)
CREATE TABLE transactions (
    id_transaction VARCHAR(255) NULL,
    id_creditCard VARCHAR(255) NULL,
    id_company VARCHAR(255) NULL,
    timestamp VARCHAR(255) NULL,
    amount VARCHAR(255) NULL,
	declined VARCHAR(255) NULL,
    id_product VARCHAR(255) NULL,
    id_user VARCHAR(255) NULL,
    lat VARCHAR(255) NULL,
    longitude VARCHAR(255) NULL
);

-- Crear la tabla productos
CREATE TABLE products (
    id_product VARCHAR(255) NULL,
    product_name VARCHAR(255) NULL,
    price VARCHAR(255) NULL,
    colour VARCHAR(255) NULL,
    weight VARCHAR(255) NULL,
    warehouse_id VARCHAR(255) NULL
);