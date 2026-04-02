SELECT
    c.title AS course_title,
    ROUND(AVG(e.score), 1) AS average_mark,
    COUNT(e.enrollmentId) AS result_count
FROM Enrollment e
JOIN CourseSession cs ON e.courseSessionId = cs.courseSessionId
JOIN Course c  ON cs.courseId = c.courseId
WHERE e.enrollmentStatus = 'completed' AND e.score IS NOT NULL
GROUP BY c.courseId, c.title
HAVING COUNT(e.enrollmentId) >= 3
ORDER BY average_mark DESC;