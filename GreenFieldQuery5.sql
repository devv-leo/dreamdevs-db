USE GreenFieldSchoolDB;

SELECT c.title AS Title, COUNT(e.studentId) AS "Number of students", ROUND(AVG(e.score), 1) AS "Average Mark"
FROM Enrollment e
JOIN CourseSession cs ON e.courseSessionId = cs.courseSessionId
JOIN Course c ON cs.courseId = c.courseId
WHERE e.enrollmentStatus = 'completed' AND e.score IS NOT NULL
GROUP BY c.courseId
HAVING COUNT(e.studentId) >= 3;