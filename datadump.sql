CREATE TABLE "User" (
    username VARCHAR(10) NOT NULL,
    Email_ID VARCHAR(100),
    Bio VARCHAR(100),
    Full_name CHAR(50),
    Password VARCHAR(20),
    Date_of_birth DATE,
    Gender CHAR(10),
    PRIMARY KEY (username, Email_ID)
);

CREATE TABLE Threads (
    comment_id SERIAL PRIMARY KEY,
    text CHAR(500),
    date DATE
);

CREATE TABLE media (
    mediaID SERIAL PRIMARY KEY,
    Media_type VARCHAR(10)
);

CREATE TABLE post (
    text CHAR(500),
    date DATE,
    username VARCHAR(10),
    Email_ID VARCHAR(100),
    mediaID INTEGER,
    PRIMARY KEY (username, Email_ID, mediaID),
    FOREIGN KEY (username, Email_ID) REFERENCES "User" (username, Email_ID) ON DELETE CASCADE,
    FOREIGN KEY (mediaID) REFERENCES Threads (comment_id) ON DELETE CASCADE
);

CREATE TABLE repost (
    date DATE,
    username VARCHAR(10),
    Email_ID VARCHAR(100),
    mediaID INTEGER,
    PRIMARY KEY (username, Email_ID, mediaID),
    FOREIGN KEY (username, Email_ID) REFERENCES "User" (username, Email_ID) ON DELETE CASCADE,
    FOREIGN KEY (mediaID) REFERENCES Threads (comment_id) ON DELETE CASCADE
);

CREATE TABLE likes (
    date DATE,
    username VARCHAR(10),
    Email_ID VARCHAR(100),
    mediaID INTEGER,
    PRIMARY KEY (username, Email_ID, mediaID),
    FOREIGN KEY (username, Email_ID) REFERENCES "User" (username, Email_ID) ON DELETE CASCADE,
    FOREIGN KEY (mediaID) REFERENCES Threads (comment_id) ON DELETE CASCADE
);

CREATE TABLE shares (
    date DATE,
    username VARCHAR(10),
    Email_ID VARCHAR(100),
    mediaID INTEGER,
    PRIMARY KEY (username, Email_ID, mediaID),
    FOREIGN KEY (username, Email_ID) REFERENCES "User" (username, Email_ID) ON DELETE CASCADE,
    FOREIGN KEY (mediaID) REFERENCES Threads (comment_id) ON DELETE CASCADE
);

CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    text CHAR(500),
    date DATE,
    username VARCHAR(10),
    Email_ID VARCHAR(100),
    mediaID INTEGER,
    FOREIGN KEY (username, Email_ID) REFERENCES "User" (username, Email_ID) ON DELETE CASCADE,
    FOREIGN KEY (mediaID) REFERENCES Threads (comment_id) ON DELETE CASCADE
);

CREATE TABLE follow (
    follower_username VARCHAR(10) NOT NULL,
    followed_Email_ID VARCHAR(100) NOT NULL,
    PRIMARY KEY (follower_username, followed_Email_ID),
    FOREIGN KEY (follower_username, followed_Email_ID) REFERENCES "User" (username, Email_ID) ON DELETE CASCADE
);

CREATE TABLE CanLink (
    mediaID INTEGER,
    comment_id SERIAL,
    PRIMARY KEY (mediaID, comment_id),
    FOREIGN KEY (mediaID) REFERENCES media (mediaID) ON DELETE CASCADE,
    FOREIGN KEY (comment_id) REFERENCES Threads (comment_id) ON DELETE CASCADE
);

Fill in the database with data:

-- Insert data into the "User" table
INSERT INTO "User" (username, Email_ID, Bio, Full_name, Password, Date_of_birth, Gender)
VALUES
    ('user1', 'user1@email.com', 'User 1 Bio', 'User 1 Full Name', 'password1', '1990-01-01', 'Male'),
    ('user2', 'user2@email.com', 'User 2 Bio', 'User 2 Full Name', 'password2', '1991-02-02', 'Female'),
    ('user3', 'user3@email.com', 'User 3 Bio', 'User 3 Full Name', 'password3', '1992-03-03', 'Male'),
    ('user4', 'user4@email.com', 'User 4 Bio', 'User 4 Full Name', 'password4', '1993-04-04', 'Female'),
    ('user5', 'user5@email.com', 'User 5 Bio', 'User 5 Full Name', 'password5', '1994-05-05', 'Male'),
    ('user6', 'user6@email.com', 'User 6 Bio', 'User 6 Full Name', 'password6', '1995-06-06', 'Female'),
    ('user7', 'user7@email.com', 'User 7 Bio', 'User 7 Full Name', 'password7', '1996-07-07', 'Male'),
    ('user8', 'user8@email.com', 'User 8 Bio', 'User 8 Full Name', 'password8', '1997-08-08', 'Female'),
    ('user9', 'user9@email.com', 'User 9 Bio', 'User 9 Full Name', 'password9', '1998-09-09', 'Male'),
    ('user10', 'user10@email.com', 'User 10 Bio', 'User 10 Full Name', 'password10', '1999-10-10', 'Female'),
    ("snelaval", "snelaval@asu.edu", NULL, NULL, "123456", NULL, NULL),
    ("Sai", "sairoshanrao@gmail.com", NULL, NULL, "1234567", NULL, NULL),
    ("Amamil", "adi@gmail.com", NULL, NULL, "12345", NULL, NULL),
    ("Adi", "adireddy@gmail.com", NULL, NULL, "123456", NULL, NULL),
    ("sandeep", "sdeep@asu.edu", NULL, NULL, "123456", NULL, NULL),
    ("JaneDoe", "jane@gmail.com", NULL, NULL, "123456", NULL, NULL),
    ("suhas", "suhas@yahoo.com", NULL, NULL, "123456", NULL, NULL),
    ("ajay", "ajay@asu.edu", "idgaf", "ajay", "123456", "2001-01-01", "Male"),
    ("anush", "anusha@gmail.com", "cricketer, doctor, patient etc", "anush", "123456", "2023-12-04", "Male"),
    ("sunny", "bunny@gmail.com", "cricketer, doctor, patient etc", "sunny bunny", "123456", "2023-12-06", "Male"),
    ("add", "add@email.com", "cricketer, doctor, patient etc", "Sai Roshan Rao Nelavalli", "12345", "2023-12-20", "Male"),
    ("aklla", "aklla@gmail.com", "idgaf", "jane doe", "12345", "2023-11-26", "Female");



-- Insert data into the "Threads" table
INSERT INTO Threads (comment_id, text, date)
VALUES
    (1, 'Thread 1 Text', '2023-10-20'),
    (2, 'Thread 2 Text', '2023-10-21'),
    (3, 'Thread 3 Text', '2023-10-22'),
    (4, 'Thread 4 Text', '2023-10-23'),
    (5, 'Thread 5 Text', '2023-10-24'),
    (6, 'Thread 6 Text', '2023-10-25'),
    (7, 'Thread 7 Text', '2023-10-26'),
    (8, 'Thread 8 Text', '2023-10-27'),
    (9, 'Thread 9 Text', '2023-10-28'),
    (10, 'Thread 10 Text', '2023-10-29');

-- Insert data into the "media" table
INSERT INTO media (mediaID, Media_type)
VALUES
    (1, 'Image'),
    (2, 'Video'),
    (3, 'Audio'),
    (4, 'Image'),
    (5, 'Video'),
    (6, 'Audio'),
    (7, 'Image'),
    (8, 'Video'),
    (9, 'Audio'),
    (10, 'Image');


INSERT INTO Follow (follower_username, follower_email, followed_username, followed_email)
VALUES
("snelaval", "snelaval@asu.edu", "Sai", "sairoshanrao@gmail.com"),
("snelaval", "snelaval@asu.edu", "user10", "user10@email.com"),
("add", "add@email.com", "user8", "user8@email.com");
	
	
-- Insert data into the "post" table
INSERT INTO post (text, date, username, Email_ID, mediaID)
VALUES
    ('Post 1 Text', '2023-10-20', 'user1', 'user1@email.com', 1),
    ('Post 2 Text', '2023-10-21', 'user2', 'user2@email.com', 2),
    ('Post 3 Text', '2023-10-22', 'user3', 'user3@email.com', 3),
    ('Post 4 Text', '2023-10-23', 'user4', 'user4@email.com', 4),
    ('Post 5 Text', '2023-10-24', 'user5', 'user5@email.com', 5),
    ('Post 6 Text', '2023-10-25', 'user6', 'user6@email.com', 6),
    ('Post 7 Text', '2023-10-26', 'user7', 'user7@email.com', 7),
    ('Post 8 Text', '2023-10-27', 'user8', 'user8@email.com', 8),
    ('Post 9 Text', '2023-10-28', 'user9', 'user9@email.com', 9),
    ('Post 10 Text', '2023-10-29', 'user10', 'user10@email.com', 10);

-- Insert data into the "repost" table
INSERT INTO repost (date, username, Email_ID, mediaID)
VALUES
    ('2023-10-20', 'user1', 'user1@email.com', 1),
    ('2023-10-21', 'user2', 'user2@email.com', 2),
    ('2023-10-22', 'user3', 'user3@email.com', 3),
    ('2023-10-23', 'user4', 'user4@email.com', 4),
    ('2023-10-24', 'user5', 'user5@email.com', 5),
    ('2023-10-25', 'user6', 'user6@email.com', 6),
    ('2023-10-26', 'user7', 'user7@email.com', 7),
    ('2023-10-27', 'user8', 'user8@email.com', 8),
    ('2023-10-28', 'user9', 'user9@email.com', 9),
    ('2023-10-29', 'user10', 'user10@email.com', 10);

-- Insert data into the "likes" table
INSERT INTO likes (date, username, Email_ID, mediaID)
VALUES
    ('2023-10-20', 'user1', 'user1@email.com', 1),
    ('2023-10-21', 'user2', 'user2@email.com', 2),
    ('2023-10-22', 'user3', 'user3@email.com', 3),
    ('2023-10-23', 'user4', 'user4@email.com', 4),
    ('2023-10-24', 'user5', 'user5@email.com', 5),
    ('2023-10-25', 'user6', 'user6@email.com', 6),
    ('2023-10-26', 'user7', 'user7@email.com', 7),
    ('2023-10-27', 'user8', 'user8@email.com', 8),
    ('2023-10-28', 'user9', 'user9@email.com', 9),
    ('2023-10-29', 'user10', 'user10@email.com', 10);

-- Insert data into the "shares" table
INSERT INTO shares (date, username, Email_ID, mediaID)
VALUES
    ('2023-10-20', 'user1', 'user1@email.com', 1),
    ('2023-10-21', 'user2', 'user2@email.com', 2),
    ('2023-10-22', 'user3', 'user3@email.com', 3),
    ('2023-10-23', 'user4', 'user4@email.com', 4),
    ('2023-10-24', 'user5', 'user5@email.com', 5),
    ('2023-10-25', 'user6', 'user6@email.com', 6),
    ('2023-10-26', 'user7', 'user7@email.com', 7),
    ('2023-10-27', 'user8', 'user8@email.com', 8),
    ('2023-10-28', 'user9', 'user9@email.com', 9),
    ('2023-10-29', 'user10', 'user10@email.com', 10);

-- Insert data into the "comments" table
INSERT INTO comments (text, date, username, Email_ID, mediaID)
VALUES
    ('Comment 1 Text', '2023-10-20', 'user1', 'user1@email.com', 1),
    ('Comment 2 Text', '2023-10-21', 'user2', 'user2@email.com', 2),
    ('Comment 3 Text', '2023-10-22', 'user3', 'user3@email.com', 3),
    ('Comment 4 Text', '2023-10-23', 'user4', 'user4@email.com', 4),
    ('Comment 5 Text', '2023-10-24', 'user5', 'user5@email.com', 5),
    ('Comment 6 Text', '2023-10-25', 'user6', 'user6@email.com', 6),
    ('Comment 7 Text', '2023-10-26', 'user7', 'user7@email.com', 7),
    ('Comment 8 Text', '2023-10-27', 'user8', 'user8@email.com', 8),
    ('Comment 9 Text', '2023-10-28', 'user9', 'user9@email.com', 9),
    ('Comment 10 Text', '2023-10-29', 'user10', 'user10@email.com', 10);
	

-- Insert data into the "CanLink" table
INSERT INTO CanLink (mediaID, comment_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (3, 4),
    (4, 5),
    (5, 6),
    (6, 7),
    (7, 8),
    (8, 9),
    (9, 10);
