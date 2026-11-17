-- COME 381 - Odev 1: Kultur ve Sanat Merkezi Atolye Yonetim Sistemi Semasi
-- Temiz bir veritabaninda bastan sona hatasiz calisir.

DROP TABLE IF EXISTS enrollment CASCADE;
DROP TABLE IF EXISTS workshop CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS instructor CASCADE;

CREATE TABLE instructor (
    instructor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(120),
    specialty VARCHAR(50),
    city VARCHAR(50),
    hourly_rate NUMERIC(8, 2),
    hire_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE room (
    room_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    room_name VARCHAR(60),
    floor_no INT,
    max_capacity INT
);

CREATE TABLE student (
    student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(120),
    city VARCHAR(50),
    membership_level VARCHAR(20) DEFAULT 'standard',
    registered_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE workshop (
    workshop_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(120),
    category VARCHAR(40),
    instructor_id INT REFERENCES instructor(instructor_id),
    room_id INT REFERENCES room(room_id),
    start_date DATE,
    end_date DATE,
    quota INT,
    fee NUMERIC(8, 2)
);

CREATE TABLE enrollment (
    enrollment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT REFERENCES student(student_id),
    workshop_id INT REFERENCES workshop(workshop_id),
    enrolled_at DATE DEFAULT CURRENT_DATE,
    attendance_status VARCHAR(20) DEFAULT 'registered',
    paid_amount NUMERIC(8, 2),
    rating INT
);
