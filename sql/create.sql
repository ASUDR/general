CREATE SCHEMA persons;
CREATE SCHEMA university;
CREATE SCHEMA objects;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE objects.countries (
    id smallserial PRIMARY KEY,
    code varchar(3) NOT NULL UNIQUE,
    name varchar(32) NOT NULL UNIQUE
);

CREATE TABLE university.faculties (
    id smallserial PRIMARY KEY,
    short_name varchar(16) NOT NULL UNIQUE,
    name varchar(64) NOT NULL UNIQUE
);

CREATE TABLE university.groups (
    id serial PRIMARY KEY,
    faculty_id smallint REFERENCES university.faculties(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    number smallint NOT NULL UNIQUE
);

CREATE TABLE university.hostels (
    id smallserial PRIMARY KEY,
    name varchar(32) NOT NULL UNIQUE
);

CREATE TABLE university.hostels_to_universities (
    id smallserial PRIMARY KEY,
    faculty_id smallint REFERENCES university.faculties(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    hostel_id smallint REFERENCES university.hostels(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
);

CREATE TABLE university.hostel_floors (
    id serial PRIMARY KEY,
    number varchar(16) NOT NULL,
    hostel_id smallint REFERENCES university.hostels(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    UNIQUE (number, hostel_id)
);

CREATE TABLE university.hostel_rooms (
    id serial PRIMARY KEY,
    number varchar(8) NOT NULL,
    floor_id smallint REFERENCES university.hostel_floors(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    places_count smallint NOT NULL,
    UNIQUE (number, floor_id)
);

CREATE TABLE persons.lodgers (
    id serial PRIMARY KEY,
    password varchar(60) DEFAULT md5(random()::text) NOT NULL,
    first_name varchar(32) NOT NULL,
    last_name varchar(32) NOT NULL,
    patronymic varchar(32),
    group_id integer REFERENCES university.groups(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    hostel_room_id integer REFERENCES university.hostel_rooms(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    own_phone_number varchar(16),
    extra_phone_number varchar(16),
    uni_contract_number integer,
    hostel_contract_number integer,
    hostel_contract_date date,
    citizenship_country_id smallint REFERENCES objects.countries(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE objects.admin_roles (
    id smallserial PRIMARY KEY,
    name varchar(16) NOT NULL UNIQUE
);

CREATE TABLE objects.admin_permissions (
    id smallserial PRIMARY KEY,
    role_id smallint REFERENCES objects.admin_roles(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    name varchar(32) NOT NULL UNIQUE,
    read boolean DEFAULT false,
    write boolean DEFAULT false
);

CREATE TABLE persons.admins (
    id smallint PRIMARY KEY,
    role_id smallint REFERENCES objects.admin_roles(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    faculty_id smallint REFERENCES university.faculties(id)
        ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    password varchar(60) DEFAULT md5(random()::text) NOT NULL,
    first_name varchar(32) NOT NULL,
    last_name varchar(32) NOT NULL,
    patronymic varchar(32)
);
