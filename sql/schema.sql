CREATE TABLE reader (
    reader_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL
);

CREATE TABLE category (
    category_id INTEGER PRIMARY KEY,
    name VARCHAR(80) NOT NULL
);

CREATE TABLE book (
    book_id INTEGER PRIMARY KEY,
    category_id INTEGER NOT NULL,
    title VARCHAR(150) NOT NULL,
    pages INTEGER NOT NULL
);

CREATE TABLE loan (
    loan_id INTEGER PRIMARY KEY,
    reader_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL
);
