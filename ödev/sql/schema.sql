DROP TABLE IF EXISTS event_registration CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS venue CASCADE;
DROP TABLE IF EXISTS member CASCADE;

CREATE TABLE member (
    member_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL
);

CREATE TABLE venue (
    venue_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    location VARCHAR(150) NOT NULL
);

CREATE TABLE event (
    event_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_date TIMESTAMP NOT NULL,
    venue_id INT NOT NULL REFERENCES venue(venue_id)
);

CREATE TABLE event_registration (
    registration_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id INT NOT NULL REFERENCES member(member_id),
    event_id INT NOT NULL REFERENCES event(event_id),
    registration_date DATE NOT NULL
);