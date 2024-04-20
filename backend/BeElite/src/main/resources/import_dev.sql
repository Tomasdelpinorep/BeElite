INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('c62db400-22e3-4e92-94db-1447f5688f2c', 'coach1', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'coach@beelite.com', 'Coach name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Coach(id) VALUES('c62db400-22e3-4e92-94db-1447f5688f2c');

INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('3850cdb2-04a3-4642-bc12-58f01f7187c7', 'admin', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'admin@beelite.com', 'Admin name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Admin(id) VALUES ('3850cdb2-04a3-4642-bc12-58f01f7187c7');

INSERT INTO Program(id, program_name, description, image, created_at, coach_id) VALUES ('7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'FSC', 'Weightlifting by Tomas del Pino', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfHO2ecLdHGF3zLC5jIqNTdN-7QEXVAEUYIsLLyvAePG1WoMqMxsXDsmXNk-Bg-uzwRqI&usqp=CAU', current_timestamp, 'c62db400-22e3-4e92-94db-1447f5688f2c');

INSERT INTO Week(week_number, program_id, week_name, description, created_at, span) VALUES (1, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat', 'Lets get those legs big.', '2024-02-19 12:00:00', ARRAY['2024-02-21'::date, '2024-02-22'::date, '2024-02-23'::date]);
INSERT INTO Week(week_number, program_id, week_name, description, created_at, span) VALUES (2, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat', 'Lets get those legs big.', '2024-02-26 12:00:00', ARRAY['2024-02-26'::date, '2024-02-27'::date, '2024-02-28'::date]);
INSERT INTO Week(week_number, program_id, week_name, description, created_at, span) VALUES (3, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat', 'Lets get those legs big.', '2024-03-04 12:00:00', ARRAY['2024-03-04'::date, '2024-03-05'::date, '2024-03-06'::date]);

INSERT INTO Session(date, session_number, week_number, week_name, program_id, subtitle, title, same_day_session_number) VALUES ('2024-03-03', 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614','Long ass session bruh', 'Muscle Monday', 1);
INSERT INTO Session(date, session_number, week_number, week_name, program_id, subtitle, title, same_day_session_number) VALUES ('2024-03-03', 2, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Long ass session bruh', 'Muscle Monday', 2);
INSERT INTO Session(date, session_number, week_number, week_name, program_id, subtitle, title, same_day_session_number) VALUES ('2024-03-04', 3, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Nasty ass session bruh', 'Taco Tuesday', 1);
INSERT INTO Session(date, session_number, week_number, week_name, program_id, subtitle, title, same_day_session_number) VALUES ('2024-03-05', 4, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Short ass session bruh', 'Watch Out Wednesday', 1);
INSERT INTO Session(date, session_number, week_number, week_name, program_id, subtitle, title, same_day_session_number) VALUES ('2024-03-07', 5, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Fun ass session bruh', 'Fried Legs Friday', 1);

INSERT INTO Block(block_number, session_number, week_number, week_name, program_id, movement, instructions) VALUES(1, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Back Squat', 'Fast on the way up.');
INSERT INTO Block(block_number, session_number, week_number, week_name, program_id, movement, rest_between_sets, instructions) VALUES(2, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Squat Snatch', 90, 'Must focus on a fast turnover.');
INSERT INTO Block(block_number, session_number, week_number, week_name, program_id, movement, rest_between_sets, instructions) VALUES(3, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Power clean', 90, 'Keep the bar close.');
INSERT INTO Block(block_number, session_number, week_number, week_name, program_id, movement, rest_between_sets, instructions) VALUES(4, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'Accessory', 90, 'Core and lower back work.');

INSERT INTO Set(set_number, block_number, session_number, week_number, week_name, program_id, percentage, number_of_sets,number_of_reps) VALUES (1, 1, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 60, 3, 5);
INSERT INTO Set(set_number, block_number, session_number, week_number, week_name, program_id, percentage, number_of_sets,number_of_reps) VALUES (2, 1, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 70, 3, 5);
INSERT INTO Set(set_number, block_number, session_number, week_number, week_name, program_id, percentage, number_of_sets,number_of_reps) VALUES (3, 1, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 75, 3, 5);
INSERT INTO Set(set_number, block_number, session_number, week_number, week_name, program_id, percentage, number_of_sets,number_of_reps) VALUES (4, 1, 1, 3, 'High Volume Squat', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 80, 3, 5);

INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('b031e329-d938-40ae-b37f-c8cf96cd48fa', 'athlete1', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'athlete@beelite.com', 'Athlete name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Athlete(id, completed_sessions, program_id, joined_program_date) VALUES ('b031e329-d938-40ae-b37f-c8cf96cd48fa', 0, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', '2024-01-01');
INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('d8cf53a2-6206-4fee-86fe-e8349d20d9d1', 'athlete2', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'athlete@beelite.com', 'Athlete name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Athlete(id, completed_sessions, program_id, joined_program_date) VALUES ('d8cf53a2-6206-4fee-86fe-e8349d20d9d1', 10, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', '2024-02-01');
INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('bb1b27d1-8dc6-457f-92ae-a00133adda84', 'athlete3', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'athlete@beelite.com', 'Athlete name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Athlete(id, completed_sessions, program_id, joined_program_date) VALUES ('bb1b27d1-8dc6-457f-92ae-a00133adda84', 110, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', '2024-03-01');
INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('89f342ef-ab10-4911-8ae0-25ca0056b090', 'athlete4', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'athlete@beelite.com', 'Athlete name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Athlete(id, completed_sessions, program_id, joined_program_date) VALUES ('89f342ef-ab10-4911-8ae0-25ca0056b090', 500, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', '2024-03-01');
INSERT INTO Usuario(id, username, password, email, name, profile_pic_url, account_non_expired, account_non_locked, credentials_non_expired, enabled, join_date, last_password_change_at) VALUES ('05ece707-ad2c-40cc-b09a-d7a1ef7c90ea', 'athlete5', '{bcrypt}$2a$12$.De8k7s.QaZzVr1ZmExgEuDkwyFglRmryR4Yce7PWLRNxcnCfHM9i', 'athlete@beelite.com', 'Athlete name', 'https://i.imgur.com/e4s1C4H.png', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO Athlete(id, completed_sessions, program_id, joined_program_date) VALUES ('05ece707-ad2c-40cc-b09a-d7a1ef7c90ea', 29, '7b4bfd75-ee79-4ee9-9aec-63d422aac614', '2024-04-01');

INSERT INTO Athlete_session(is_completed, athlete_session_number, session_number, week_number, athlete_id, program_id, week_name) VALUES (false, 1, 1, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa','7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO Athlete_session(is_completed, athlete_session_number, session_number, week_number, athlete_id, program_id, week_name) VALUES (false, 2, 2, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO Athlete_session(is_completed, athlete_session_number, session_number, week_number, athlete_id, program_id, week_name) VALUES (false, 3, 3, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO Athlete_session(is_completed, athlete_session_number, session_number, week_number, athlete_id, program_id, week_name) VALUES (false, 4, 4, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO Athlete_session(is_completed, athlete_session_number, session_number, week_number, athlete_id, program_id, week_name) VALUES (false, 5, 5, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');

INSERT INTO athlete_block(is_completed, athlete_block_number, athlete_session_number, block_number, session_number, week_number, athlete_id, program_id, week_name) VALUES(true, 1, 1, 1, 1, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO athlete_block(is_completed, athlete_block_number, athlete_session_number, block_number, session_number, week_number, athlete_id, program_id, week_name) VALUES(true, 2, 1, 2, 1, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO athlete_block(is_completed, athlete_block_number, athlete_session_number, block_number, session_number, week_number, athlete_id, program_id, week_name) VALUES(false, 3, 1, 3, 1, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');
INSERT INTO athlete_block(is_completed, athlete_block_number, athlete_session_number, block_number, session_number, week_number, athlete_id, program_id, week_name) VALUES(false, 4, 1, 3, 1, 3, 'b031e329-d938-40ae-b37f-c8cf96cd48fa', '7b4bfd75-ee79-4ee9-9aec-63d422aac614', 'High Volume Squat');