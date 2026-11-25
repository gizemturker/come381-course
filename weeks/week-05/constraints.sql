ALTER TABLE reader ADD CONSTRAINT uq_email UNIQUE(email);

ALTER TABLE category ADD CONSTRAINT uq_category UNIQUE(name);

ALTER TABLE book ADD CONSTRAINT ck_pages CHECK(pages > 0);

ALTER TABLE book ADD CONSTRAINT fk_category FOREIGN KEY(category_id) REFERENCES category(category_id) ON DELETE RESTRICT;

ALTER TABLE loan ADD CONSTRAINT fk_reader FOREIGN KEY(reader_id) REFERENCES reader(reader_id) ON DELETE RESTRICT;

ALTER TABLE loan ADD CONSTRAINT fk_book FOREIGN KEY(book_id) REFERENCES book(book_id) ON DELETE CASCADE;

ALTER TABLE loan ADD CONSTRAINT ck_dates CHECK(due_date >= loan_date);

ALTER TABLE loan ADD CONSTRAINT uq_loan UNIQUE(reader_id, book_id, loan_date);
