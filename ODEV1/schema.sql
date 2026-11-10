-- Mahalle Kütüphanesi şeması (PostgreSQL)

CREATE TABLE member (
    member_id   integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name   text,
    email       text,
    joined_date date
);

CREATE TABLE publisher (
    publisher_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         text
);

CREATE TABLE author (
    author_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name text,
    country   text
);

CREATE TABLE book (
    book_id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    publisher_id     integer REFERENCES publisher (publisher_id),
    title            text,
    isbn             text,
    publication_year integer
);

-- M:N: bir kitabın birden fazla yazarı, bir yazarın birden fazla kitabı olabilir
CREATE TABLE book_author (
    book_id   integer REFERENCES book (book_id),
    author_id integer REFERENCES author (author_id),
    PRIMARY KEY (book_id, author_id)
);

-- Aynı kitabın raftaki fiziksel nüshaları
CREATE TABLE book_copy (
    copy_id        integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id        integer REFERENCES book (book_id),
    shelf_code     text,
    purchase_price numeric(8, 2)
);

CREATE TABLE loan (
    loan_id     integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id   integer REFERENCES member (member_id),
    copy_id     integer REFERENCES book_copy (copy_id),
    loan_date   date,
    due_date    date,
    return_date date
);
