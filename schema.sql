-- Greenfield Academy
-- Schema: CREATE TABLE statements only
-- Order: parent tables before child tables

CREATE TABLE year_group (
    year_group_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    staff_type ENUM('teaching', 'contract') NOT NULL
);

CREATE TABLE teacher (
    staff_id INT PRIMARY KEY,
    specialisation VARCHAR(100) NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE course (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    max_class_size INT NOT NULL
);

CREATE TABLE term (
    term_id INT AUTO_INCREMENT PRIMARY KEY,
    term_number INT NOT NULL CHECK (term_number BETWEEN 1 AND 3),
    academic_year INT NOT NULL,
    UNIQUE (term_number, academic_year)
);

CREATE TABLE student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    parent_email VARCHAR(100) NOT NULL,
    year_group_id INT NOT NULL,
    FOREIGN KEY (year_group_id) REFERENCES year_group(year_group_id) ON DELETE RESTRICT
);

CREATE TABLE course_session (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    term_id INT NOT NULL,
    staff_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE RESTRICT,
    FOREIGN KEY (term_id) REFERENCES term(term_id) ON DELETE RESTRICT,
    FOREIGN KEY (staff_id) REFERENCES teacher(staff_id) ON DELETE RESTRICT
);

CREATE TABLE club (
    club_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    meeting_day ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday') NOT NULL,
    staff_id INT NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES teacher(staff_id) ON DELETE RESTRICT
);

CREATE TABLE enrolment (
    enrolment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    session_id INT NOT NULL,
    enrol_date DATE NOT NULL,
    status ENUM('active', 'withdrawn', 'completed') NOT NULL,
    final_mark DECIMAL(5, 2) NULL,
    letter_grade VARCHAR(5) NULL,
    UNIQUE (student_id, session_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES course_session(session_id) ON DELETE CASCADE
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrolment_id INT NOT NULL,
    class_date DATE NOT NULL,
    status ENUM('present', 'absent', 'late') NOT NULL,
    UNIQUE (enrolment_id, class_date),
    FOREIGN KEY (enrolment_id) REFERENCES enrolment(enrolment_id) ON DELETE CASCADE
);

CREATE TABLE club_membership (
    student_id INT NOT NULL,
    club_id INT NOT NULL,
    term_number INT NOT NULL,
    academic_year INT NOT NULL,
    PRIMARY KEY (student_id, club_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (club_id) REFERENCES club(club_id) ON DELETE CASCADE
);
