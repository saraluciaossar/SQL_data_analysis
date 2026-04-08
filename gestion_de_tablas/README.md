# Project under review

### Overview

This project focuses on designing and structuring a relational database that simulates a marketplace environment, similar to platforms like Amazon.
The goal is to transform raw transactional data into a clean, structured, and analysis-ready database, enabling insights on user activity, company performance, and payment behavior.

### Database Structure

The database includes the following main tables:

users - user personal and location data
companies - company information (country, contact details, etc.)
credit_cards - card-related data (IBAN, expiration, etc.)
transactions - purchase records, including amount, location, and status

Relationships are defined through foreign keys between transactions and the other entities.


### What Was Done
- Designed and created new tables (credit_card, users)
- Cleaned and transformed data (updates, deletions, column removal)
- Ensured data integrity through relationships
- Built analytical views:
  - VistaMarketing: company-level metrics (avg transaction value)
  - InformeTecnico: detailed transaction traceability


### Skills Applied
- SQL (joins, aggregations, views)
- Relational data modeling
- Data integrity (primary & foreign keys)

