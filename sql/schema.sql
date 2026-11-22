CREATE TABLE category (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE member (
    member_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(150),
    email VARCHAR(255),
    city VARCHAR(100),
    status VARCHAR(20)
);

CREATE TABLE event (
    event_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id INTEGER,
    title VARCHAR(200),
    start_date DATE,
    end_date DATE,
    capacity INTEGER,
    CONSTRAINT fk_event_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);

CREATE TABLE event_registration (
    registration_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id INTEGER,
    event_id INTEGER,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rating INTEGER,
    CONSTRAINT fk_registration_member
        FOREIGN KEY (member_id)
        REFERENCES member(member_id),
    CONSTRAINT fk_registration_event
        FOREIGN KEY (event_id)
        REFERENCES event(event_id)
);
