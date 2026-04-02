CREATE DATABASE GreenFieldSchoolDB;
USE GreenFieldSchoolDB;

CREATE TABLE Student (
    studentId       INT AUTO_INCREMENT PRIMARY KEY,
    firstName       VARCHAR(100) NOT NULL,
    lastName        VARCHAR(100) NOT NULL,
    dateOfBirth     DATE NOT NULL,
    gender          ENUM('male', 'female') NOT NULL,
    parentEmail     VARCHAR(255) NOT NULL,
    yearGroup       ENUM('7', '8', '9', '10', '11') NOT NULL
);

CREATE TABLE Staff (
    staffId         INT AUTO_INCREMENT PRIMARY KEY,
    staffType       ENUM('permanent', 'contract') NOT NULL,
    firstName       VARCHAR(100) NOT NULL,
    lastName        VARCHAR(100) NOT NULL,
    phoneNumber     VARCHAR(20) NOT NULL,
    emailAddress    VARCHAR(255) NOT NULL,
    specialization  VARCHAR(255) NOT NULL
);

CREATE TABLE Course (
    courseId        	INT AUTO_INCREMENT PRIMARY KEY,
    title           	VARCHAR(255) NOT NULL,
    shortCode       	VARCHAR(50) NOT NULL,
    courseDescription   TEXT NOT NULL,
    maxClassSize    	INT NOT NULL
);

CREATE TABLE Session (
    sessionId           INT AUTO_INCREMENT PRIMARY KEY,
    sessionName         VARCHAR(100) NOT NULL,
    sessionStartDate    DATE NOT NULL,
    sessionEndDate      DATE NOT NULL
);

CREATE TABLE Club (
    clubId          INT AUTO_INCREMENT PRIMARY KEY,
    clubName        VARCHAR(255) NOT NULL,
    staffId         INT NOT NULL,
    clubDescription TEXT,
    meetingDay      ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    FOREIGN KEY (staffId) REFERENCES Staff(staffId)
);

CREATE TABLE CourseSession (
    courseSessionId INT AUTO_INCREMENT PRIMARY KEY,
    courseId        INT NOT NULL,
    term            ENUM('1', '2', '3') NOT NULL,
    staffId         INT NOT NULL,
    sessionId       INT NOT NULL,
    FOREIGN KEY (courseId)  REFERENCES Course(courseId),
    FOREIGN KEY (staffId)   REFERENCES Staff(staffId),
    FOREIGN KEY (sessionId) REFERENCES Session(sessionId)
);

CREATE TABLE Class (
    classId         INT AUTO_INCREMENT PRIMARY KEY,
    courseSessionId INT NOT NULL,
    scheduledDate   DATE NOT NULL,
    FOREIGN KEY (courseSessionId) REFERENCES CourseSession(courseSessionId)
);

CREATE TABLE Enrollment (
    enrollmentId        INT AUTO_INCREMENT PRIMARY KEY,
    studentId           INT NOT NULL,
    courseSessionId     INT NOT NULL,
    enrollmentStatus    ENUM('active', 'withdrawn', 'completed') NOT NULL,
    enrollmentDate      DATE NOT NULL,
    score               INT NULL,
    grade               ENUM('A', 'B', 'C', 'D', 'E', 'F') NULL,
    FOREIGN KEY (studentId)       REFERENCES Student(studentId),
    FOREIGN KEY (courseSessionId) REFERENCES CourseSession(courseSessionId)
);

CREATE TABLE Attendance (
    attendanceId    INT AUTO_INCREMENT PRIMARY KEY,
    studentId       INT NOT NULL,
    classId         INT NOT NULL,
    attendanceStatus          ENUM('present', 'absent', 'late') NOT NULL,
    FOREIGN KEY (studentId) REFERENCES Student(studentId),
    FOREIGN KEY (classId)   REFERENCES Class(classId)
);

CREATE TABLE ClubStudent (
    clubStudentId   INT AUTO_INCREMENT PRIMARY KEY,
    studentId       INT NOT NULL,
    clubId          INT NOT NULL,
    term            ENUM('1', '2', '3') NOT NULL,
    clubYear        YEAR NOT NULL,
    FOREIGN KEY (studentId) REFERENCES Student(studentId),
    FOREIGN KEY (clubId)    REFERENCES Club(clubId)
);