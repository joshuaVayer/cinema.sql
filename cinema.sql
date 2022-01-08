CREATE DATABASE cinema;
USE cinema;

CREATE TABLE IF NOT EXISTS Addresses (
    A_id CHAR(36) PRIMARY KEY NOT NULL,
    address1 VARCHAR(120) NOT NULL,
    address2 VARCHAR(120),
    address3 VARCHAR(120),
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postalCode VARCHAR(16) NOT NULL)
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Companies (
    C_id CHAR(36) PRIMARY KEY NOT NULL,
    legal_name VARCHAR(50) NOT NULL,
    comercial_name VARCHAR(50) NOT NULL,
    identification_number CHAR(30) NOT NULL,
    A_address_id CHAR(36) NOT NULL,
    FOREIGN KEY (A_address_id) REFERENCES Addresses(A_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Facilities (
    F_id CHAR(36) PRIMARY KEY NOT NULL,
    facility_name VARCHAR(50) NOT NULL,
    C_company_id CHAR(36) NOT NULL,
    A_address_id CHAR(36) NOT NULL,
    FOREIGN KEY (C_company_id) REFERENCES Companies(C_id),
    FOREIGN KEY (A_address_id) REFERENCES Addresses(A_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Movies (
    M_id CHAR(36) PRIMARY KEY NOT NULL,
    title VARCHAR(50) NOT NULL,
    duration INT(10) NOT NULL,
    synopsis TEXT)
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Prices (
    P_id CHAR(36) PRIMARY KEY NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(4,2) NOT NULL)
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Transaction_type (
    TT_id CHAR(36) PRIMARY KEY NOT NULL,
    type VARCHAR(50))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Transactions (
    T_id CHAR(36) PRIMARY KEY NOT NULL,
    TT_type_id CHAR(36) NOT NULL,
    FOREIGN KEY (TT_type_id) REFERENCES Transaction_type(TT_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Rooms (
    R_id CHAR(36) PRIMARY KEY NOT NULL,
    room_name VARCHAR(50) NOT NULL,
    slots INT(5) NOT NULL,
    active BOOLEAN DEFAULT FALSE,
    F_facility_id CHAR(36) NOT NULL,
    CHECK (slots >= 0),
    FOREIGN KEY (F_facility_id) REFERENCES Facilities(F_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Shows (
    S_id CHAR(36) PRIMARY KEY NOT NULL,
    schedule DATETIME NOT NULL,
    remaining_slots INT(5) NOT NULL,
    R_room_id CHAR(36) NOT NULL,
    M_movie_id CHAR(36) NOT NULL,
    CHECK (remaining_slots >= 0),
    FOREIGN KEY (R_room_id) REFERENCES Rooms(R_id),
    FOREIGN KEY (M_movie_id) REFERENCES Movies(M_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Tickets (
    Ti_id CHAR(36) PRIMARY KEY NOT NULL,
    P_price_id CHAR(36) NOT NULL,
    T_transaction_id CHAR(36) NOT NULL,
    FOREIGN KEY (P_price_id) REFERENCES Prices(P_id),
    FOREIGN KEY (T_transaction_id) REFERENCES Transactions(T_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Bookings (
    B_id CHAR(36) PRIMARY KEY NOT NULL,
    book_by VARCHAR(50) NOT NULL,
    active BOOLEAN DEFAULT FALSE,
    cashed BOOLEAN DEFAULT FALSE,
    S_show_id CHAR(36) NOT NULL,
    Ti_ticket_id CHAR(36),
    FOREIGN KEY (S_show_id) REFERENCES Shows(S_id),
    FOREIGN KEY (Ti_ticket_id) REFERENCES Tickets(Ti_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Roles (
    Ro_id CHAR(36) PRIMARY KEY NOT NULL,
    role_name VARCHAR(50) NOT NULL)
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS Workers (
    W_id CHAR(36) PRIMARY KEY NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    social_security_number INT(13),
    Ro_role_id CHAR(36) NOT NULL,
    A_address_id CHAR(36) NOT NULL,
    C_company_id CHAR(36) NOT NULL,
    F_facility_id CHAR(36) NOT NULL,
    FOREIGN KEY (Ro_role_id) REFERENCES Roles(Ro_id),
    FOREIGN KEY (A_address_id) REFERENCES Addresses(A_id),
    FOREIGN KEY (C_company_id) REFERENCES Companies(C_id),
    FOREIGN KEY (F_facility_id) REFERENCES Facilities(F_id))
    ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;


INSERT INTO Roles (Ro_id, role_name)
		VALUES("2e6f5224-3b4a-11ec-b32a-ed49a254bcb5", "Manager"), (UUID(), "Administrator");
INSERT INTO Prices (P_id, category, price)
		VALUES("b7797106-6d1a-11ec-a473-392613ee6e5f", "Tarif plein", "10.00"), (UUID(), "Tarif réduit", "8.00");
INSERT INTO Transaction_type (TT_id, type)
        VALUES
        ("18a32422-6d1b-11ec-a473-392613ee6e5f", "Paiement caisse"),
        ("18a34dee-6d1b-11ec-a473-392613ee6e5f", "Paiement en ligne"),
        (UUID(), "Avoir"),
        (UUID(), "Mouvement interne");


INSERT INTO Addresses (A_id, address1, city, country, postalCode)
		VALUES("239d9222-3ba7-11ec-b32a-ed49a254bcb5", "158 Bd Haussmann", "Paris", "France", "75008");
INSERT INTO Companies (C_id, legal_name, comercial_name, identification_number, A_address_id)
		VALUES("39e78654-3ba8-11ec-b32a-ed49a254bcb5", "Circuit Georges-Raymond Ouest-Centre S.A", "CGR Ouest-Centre", "120027016", "239d9222-3ba7-11ec-b32a-ed49a254bcb5");
INSERT INTO Companies (C_id, legal_name, comercial_name, identification_number, A_address_id)
		VALUES(UUID(), "Circuit Georges-Raymond Ile-de-France S.A", "CGR Ile-de-France", "120027319", "239d9222-3ba7-11ec-b32a-ed49a254bcb5");


INSERT INTO Addresses (A_id, address1, city, country, postalCode)
		VALUES("f0e52e8e-3bac-11ec-b32a-ed49a254bcb5", "Place Henri Dunant", "Mantes-la-Jolie", "France", "78200");

INSERT INTO Facilities ( F_id, facility_name, C_company_id, A_address_id)
SELECT  "3aec3a88-3bb0-11ec-b32a-ed49a254bcb5", "CGR Mantes-la-Jolie", C_id, "f0e52e8e-3bac-11ec-b32a-ed49a254bcb5"
FROM    Companies
WHERE   comercial_name = "CGR Ile-de-France";

INSERT INTO Addresses (A_id, address1, city, country, postalCode)
		VALUES("21589d5a-4060-11ec-af4a-5a35fb4e92f3", "Promenade du 7ème Art", "Torcy", "France", "77200");

INSERT INTO Facilities ( F_id, facility_name, C_company_id, A_address_id)
SELECT  UUID(), "CGR Torcy Marne-la-vallée", C_id, "21589d5a-4060-11ec-af4a-5a35fb4e92f3"
FROM    Companies
WHERE   comercial_name = "CGR Ile-de-France";

INSERT INTO Addresses (A_id, address1, city, country, postalCode)
		VALUES("de466c66-4061-11ec-af4a-5a35fb4e92f3", "24 place du Marechal-Leclerc", "Poitier", "France", "86000");

INSERT INTO Facilities ( F_id, facility_name, C_company_id, A_address_id)
SELECT  UUID(), "CGR Poitier", C_id, "de466c66-4061-11ec-af4a-5a35fb4e92f3"
FROM    Companies
WHERE   comercial_name = "CGR Ouest-Centre";


INSERT INTO Addresses (A_id, address1, address2, city, country, postalCode)
		VALUES("ec4aa19c-4061-11ec-af4a-5a35fb4e92f3", "Boulevard de l'Avenir", "ZAC du Prado", "Bourge", "France", "18000");

INSERT INTO Facilities ( F_id, facility_name, C_company_id, A_address_id)
SELECT  UUID(), "CGR Bourges", C_id, "ec4aa19c-4061-11ec-af4a-5a35fb4e92f3"
FROM    Companies
WHERE   comercial_name = "CGR Ouest-Centre";


INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  "9eab7fa4-6bbf-11ec-a014-e1c431a9bdb7", 300, "Salle 1", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Mantes-la-Jolie";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 350, "Salle 2", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Mantes-la-Jolie";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 350, "Salle 3", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Mantes-la-Jolie";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 300, "Salle 4", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Mantes-la-Jolie";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 300, "Salle 5", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Mantes-la-Jolie";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 257, "Salle 1", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Torcy Marne-la-vallée";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 257, "Salle 1", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Poitier";

INSERT INTO Rooms (R_id, slots, room_name, active, F_facility_id)
SELECT  UUID(), 257, "Salle 1", 1, F_id
FROM    Facilities
WHERE   facility_name = "CGR Bourges";

INSERT INTO
    Movies (M_id, title, synopsis, duration)
VALUES
    ("88375780-6c6d-11ec-a014-e1c431a9bdb7", "Mais qui a tué Rosalie Pam", "Enquete sur le meurtre de la belle Rosalie", 5760),
    (UUID(), "Mon nom est tout le monde", "L'histoire d'un type qui se prenait pour tout le monde", 6360),
    (UUID(), "Jacquou le truand", "Jacquou truande le roi", 7920);


INSERT INTO
    Shows (S_id, schedule, R_room_id, M_movie_id, remaining_slots)
SELECT  "5d8687a4-6d17-11ec-a473-392613ee6e5f","2022-01-09 10:00", Rooms.R_id, "88375780-6c6d-11ec-a014-e1c431a9bdb7", Rooms.slots
FROM    Rooms
WHERE   R_id = "9eab7fa4-6bbf-11ec-a014-e1c431a9bdb7";

INSERT INTO
    Shows (S_id, schedule, R_room_id, M_movie_id, remaining_slots)
SELECT  UUID(),"2022-01-09 22:00", Rooms.R_id, "88375780-6c6d-11ec-a014-e1c431a9bdb7", Rooms.slots
FROM    Rooms
WHERE   R_id = "9eab7fa4-6bbf-11ec-a014-e1c431a9bdb7";


INSERT INTO
    Bookings (B_id, book_by, active, cashed, S_show_id)
VALUES
    ("fc95ccf0-6d18-11ec-a473-392613ee6e5f", "Mr Nobody", 1, 0, "5d8687a4-6d17-11ec-a473-392613ee6e5f");
UPDATE Shows SET remaining_slots = remaining_slots - 1 WHERE S_id = "5d8687a4-6d17-11ec-a473-392613ee6e5f";

INSERT INTO
    Bookings (B_id, book_by, active, cashed, S_show_id)
VALUES
    (UUID(), "Miss Nobody", 1, 0, "5d8687a4-6d17-11ec-a473-392613ee6e5f");
UPDATE Shows SET remaining_slots = remaining_slots - 1 WHERE S_id = "5d8687a4-6d17-11ec-a473-392613ee6e5f";


INSERT INTO
    Transactions (T_id, TT_type_id)
VALUES
    ("f9b9b9b9-6d19-11ec-a473-392613ee6e5f", "18a32422-6d1b-11ec-a473-392613ee6e5f");
INSERT INTO
    Tickets (Ti_id, P_price_id, T_transaction_id)
SELECT UUID(), Prices.P_id, "f9b9b9b9-6d19-11ec-a473-392613ee6e5f"
FROM    Prices WHERE P_id = "b7797106-6d1a-11ec-a473-392613ee6e5f";


INSERT INTO
    Transactions (T_id, TT_type_id)
VALUES
    ("01fe9948-6d22-11ec-a473-392613ee6e5f", "18a34dee-6d1b-11ec-a473-392613ee6e5f");

INSERT INTO
    Tickets (Ti_id, P_price_id, T_transaction_id)
SELECT "76e548f6-6d22-11ec-a473-392613ee6e5f", Prices.P_id, "01fe9948-6d22-11ec-a473-392613ee6e5f"
FROM    Prices WHERE P_id = "b7797106-6d1a-11ec-a473-392613ee6e5f";

INSERT INTO
    Bookings (B_id, book_by, active, cashed, S_show_id, Ti_ticket_id)
VALUES
    (UUID(), "Grandpa Nobody", 1, 1, "5d8687a4-6d17-11ec-a473-392613ee6e5f", "76e548f6-6d22-11ec-a473-392613ee6e5f");
UPDATE Shows SET remaining_slots = remaining_slots - 1 WHERE S_id = "5d8687a4-6d17-11ec-a473-392613ee6e5f";


INSERT INTO
    Workers (W_id, firstname, lastname, social_security_number, Ro_role_id, A_address_id, C_company_id, F_facility_id)
VALUES
    (UUID(),
    "John",
    "Doe",
    "123456789",
    "2e6f5224-3b4a-11ec-b32a-ed49a254bcb5",
    "f0e52e8e-3bac-11ec-b32a-ed49a254bcb5",
    "39e78654-3ba8-11ec-b32a-ed49a254bcb5",
    "3aec3a88-3bb0-11ec-b32a-ed49a254bcb5");
