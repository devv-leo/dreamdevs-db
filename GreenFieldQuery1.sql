USE GreenFieldSchoolDB;

SELECT CONCAT(firstName, " ", lastName) AS "Full Name", yearGroup AS "Year Group", COUNT(enrollmentId) AS "Active sessions"
FROM Student LEFT JOIN Enrollment
ON Student.studentId = Enrollment.studentId
AND enrollmentStatus = 'active'
GROUP BY Enrollment.studentId;