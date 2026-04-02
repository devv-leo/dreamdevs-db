INSERT INTO Session (sessionName, sessionStartDate, sessionEndDate) VALUES
('2024/2025 Academic Year', '2024-09-09', '2025-07-18'),
('2023/2024 Academic Year', '2023-09-11', '2024-07-19'),
('2025/2026 Academic Year', '2025-09-08', '2026-07-17');

INSERT INTO Staff (staffType, firstName, lastName, phoneNumber, emailAddress, specialization) VALUES
('permanent', 'Chukwuemeka', 'Okafor',  '08031001001', 'c.okafor@greenfield.edu.ng',  'Mathematics'),
('permanent', 'Ngozi',       'Bello',   '08031001002', 'n.bello@greenfield.edu.ng',   'English Language'),
('permanent', 'Taiwo',       'Adeyemi', '08031001003', 't.adeyemi@greenfield.edu.ng', 'Biology'),
('contract',  'Seun',        'Lawal',   '08031001004', 's.lawal@greenfield.edu.ng',   'ICT'),
('permanent', 'Funmilayo',   'Ibrahim', '08031001005', 'f.ibrahim@greenfield.edu.ng', 'Economics');

INSERT INTO Course (title, shortCode, courseDescription, maxClassSize) VALUES
('Mathematics',      'MATH-101', 'Core mathematics covering algebra, geometry, and statistics.',         30),
('English Language', 'ENG-201',  'Comprehension, essay writing, and oral communication skills.',         30),
('Biology',          'BIO-301',  'Introduction to living organisms, ecosystems, and cell biology.',       25),
('Economics',        'ECO-401',  'Fundamentals of micro and macroeconomics for secondary students.',      25),
('ICT',              'ICT-101',  'Computing fundamentals, spreadsheets, and basic programming concepts.', 20);

INSERT INTO Student (firstName, lastName, dateOfBirth, gender, parentEmail, yearGroup) VALUES
('Adaeze',    'Nwosu',    '2010-03-14', 'female', 'parent.nwosu@gmail.com',    '9'),
('Emeka',     'Obi',      '2009-11-22', 'male',   'parent.obi@gmail.com',      '10'),
('Fatima',    'Musa',     '2011-06-05', 'female', 'parent.musa@gmail.com',     '8'),
('Tunde',     'Afolabi',  '2009-08-30', 'male',   'parent.afolabi@gmail.com',  '10'),
('Chiamaka',  'Eze',      '2010-01-17', 'female', 'parent.eze@gmail.com',      '9'),
('Damilola',  'Salami',   '2011-09-03', 'female', 'parent.salami@gmail.com',   '8'),
('Babatunde', 'Odunsi',   '2008-12-19', 'male',   'parent.odunsi@gmail.com',   '11'),
('Nkechi',    'Onyeka',   '2008-07-25', 'female', 'parent.onyeka@gmail.com',   '11');

INSERT INTO CourseSession (courseId, term, staffId, sessionId) VALUES
(1, '1', 1, 1),  -- courseSessionId 1: Maths T1 by Okafor
(2, '1', 2, 1),  -- courseSessionId 2: English T1 by Bello
(3, '1', 3, 1),  -- courseSessionId 3: Biology T1 by Adeyemi
(4, '1', 5, 1),  -- courseSessionId 4: Economics T1 by Ibrahim
(5, '1', 4, 1),  -- courseSessionId 5: ICT T1 by Lawal
(1, '2', 1, 1),  -- courseSessionId 6: Maths T2 by Okafor
(2, '2', 2, 1);  -- courseSessionId 7: English T2 by Bello

INSERT INTO Class (courseSessionId, scheduledDate) VALUES
(1, '2024-09-16'), (1, '2024-09-23'), (1, '2024-09-30'),
(2, '2024-09-17'), (2, '2024-09-24'), (2, '2024-10-01'),
(3, '2024-09-18'), (3, '2024-09-25'), (3, '2024-10-02'),
(4, '2024-09-19'), (4, '2024-09-26'),
(5, '2024-09-20'), (5, '2024-09-27');

INSERT INTO Enrollment (studentId, courseSessionId, enrollmentStatus, enrollmentDate, score, grade) VALUES
-- Adaeze (1): active in Maths T1, English T1; completed Biology T1
(1, 1, 'active',     '2024-09-09', NULL, NULL),
(1, 2, 'active',     '2024-09-09', NULL, NULL),
(1, 3, 'completed',  '2024-09-09', 78,   'B'),
-- Emeka (2): active in Maths T1, withdrawn from English T1, completed Economics T1
(2, 1, 'active',     '2024-09-09', NULL, NULL),
(2, 2, 'withdrawn',  '2024-09-09', NULL, NULL),
(2, 4, 'completed',  '2024-09-09', 65,   'C'),
-- Fatima (3): active in English T1, Biology T1, ICT T1
(3, 2, 'active',     '2024-09-09', NULL, NULL),
(3, 3, 'active',     '2024-09-09', NULL, NULL),
(3, 5, 'active',     '2024-09-09', NULL, NULL),
-- Tunde (4): completed Maths T1 and Economics T1
(4, 1, 'completed',  '2024-09-09', 91,   'A'),
(4, 4, 'completed',  '2024-09-09', 55,   'D'),
-- Chiamaka (5): active in Maths T1, English T1, Biology T1
(5, 1, 'active',     '2024-09-09', NULL, NULL),
(5, 2, 'active',     '2024-09-09', NULL, NULL),
(5, 3, 'active',     '2024-09-09', NULL, NULL),
-- Damilola (6): active in ICT T1, completed Biology T1
(6, 5, 'active',     '2024-09-09', NULL, NULL),
(6, 3, 'completed',  '2024-09-09', 82,   'A'),
-- Babatunde (7): completed Maths T1, active in Economics T1
(7, 1, 'completed',  '2024-09-09', 88,   'A'),
(7, 4, 'active',     '2024-09-09', NULL, NULL),
-- Nkechi (8): active in Maths T1 and English T1
(8, 1, 'active',     '2024-09-09', NULL, NULL),
(8, 2, 'active',     '2024-09-09', NULL, NULL);

-- Attendance (classId refs from Class table above)
-- Maths T1 classes: classId 1,2,3 | English T1: 4,5,6 | Biology T1: 7,8,9
INSERT INTO Attendance (studentId, classId, attendanceStatus) VALUES
-- Adaeze (1) — Maths T1 classes
(1, 1, 'present'), (1, 2, 'present'), (1, 3, 'late'),
-- Adaeze (1) — English T1 classes
(1, 4, 'present'), (1, 5, 'absent'), (1, 6, 'present'),
-- Emeka (2) — Maths T1 classes
(2, 1, 'present'), (2, 2, 'absent'), (2, 3, 'absent'),
-- Tunde (4) — Maths T1 classes
(4, 1, 'present'), (4, 2, 'present'), (4, 3, 'present'),
-- Chiamaka (5) — Maths T1 classes
(5, 1, 'absent'), (5, 2, 'absent'), (5, 3, 'present'),
-- Chiamaka (5) — English T1 classes
(5, 4, 'present'), (5, 5, 'present'), (5, 6, 'absent'),
-- Fatima (3) — English T1 classes
(3, 4, 'present'), (3, 5, 'present'), (3, 6, 'present'),
-- Fatima (3) — Biology T1 classes
(3, 7, 'present'), (3, 8, 'late'),   (3, 9, 'present'),
-- Damilola (6) — Biology T1 classes
(6, 7, 'present'), (6, 8, 'present'), (6, 9, 'present'),
-- Babatunde (7) — Maths T1 classes
(7, 1, 'present'), (7, 2, 'absent'), (7, 3, 'present');

INSERT INTO Club (clubName, staffId, clubDescription, meetingDay) VALUES
('Robotics Club',   3, 'Hands-on robot building and programming projects.',          'Wednesday'),
('Debate Society',  2, 'Competitive debating and public speaking training.',          'Thursday'),
('Chess Club',      1, 'Strategy and competitive chess for all levels.',              'Friday'),
('Science Society', 3, 'Experiments and science fair preparation.',                  'Tuesday');

-- Club Memberships
INSERT INTO ClubStudent (studentId, clubId, term, clubYear) VALUES
-- Robotics Club
(1, 1, '1', 2024),
(3, 1, '1', 2024),
(5, 1, '1', 2024),
(7, 1, '1', 2024),
-- Debate Society
(1, 2, '1', 2024),
(2, 2, '1', 2024),
(8, 2, '1', 2024),
-- Chess Club
(4, 3, '1', 2024),
(7, 3, '1', 2024),
(2, 3, '1', 2024),
-- Science Society (no members yet — tests Query D's LEFT JOIN)
-- Damilola joins Robotics in T2
(6, 1, '2', 2024);