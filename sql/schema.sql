-- Veteriner Klinigi Evcil Hayvan ve Asi/Tedavi Takip Sistemi Semasi (Odev 1)

DROP TABLE IF EXISTS pet_treatment CASCADE;
DROP TABLE IF EXISTS pet CASCADE;
DROP TABLE IF EXISTS treatment CASCADE;
DROP TABLE IF EXISTS veterinarian CASCADE;
DROP TABLE IF EXISTS pet_owner CASCADE;

CREATE TABLE pet_owner (
    owner_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(120),
    district VARCHAR(60),
    registered_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE veterinarian (
    vet_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    license_no VARCHAR(30),
    specialization VARCHAR(60),
    consultation_fee NUMERIC(8, 2),
    employment_status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE pet (
    pet_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_id INT REFERENCES pet_owner(owner_id),
    primary_vet_id INT REFERENCES veterinarian(vet_id),
    pet_name VARCHAR(60),
    species VARCHAR(30),
    birth_year INT,
    weight_kg NUMERIC(5, 2)
);

CREATE TABLE treatment (
    treatment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    treatment_code VARCHAR(20),
    treatment_name VARCHAR(100),
    treatment_type VARCHAR(30),
    min_weight_kg NUMERIC(5, 2),
    max_weight_kg NUMERIC(5, 2),
    standard_cost NUMERIC(8, 2)
);

CREATE TABLE pet_treatment (
    record_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pet_id INT REFERENCES pet(pet_id),
    treatment_id INT REFERENCES treatment(treatment_id),
    vet_id INT REFERENCES veterinarian(vet_id),
    visit_date DATE DEFAULT CURRENT_DATE,
    next_due_date DATE,
    charged_amount NUMERIC(8, 2),
    follow_up_score INT
);
