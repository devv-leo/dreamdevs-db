SELECT
    c.title AS course_title,
    CONCAT(st.firstName, ' ', st.lastName) AS teacher_name,
    COUNT(e.enrollmentId) AS enrolled_students
FROM CourseSession cs
JOIN Course c  ON cs.courseId  = c.courseId
JOIN Staff st ON cs.staffId   = st.staffId
JOIN Session se ON cs.sessionId = se.sessionId
LEFT JOIN Enrollment e ON e.courseSessionId = cs.courseSessionId
WHERE cs.term = '1' AND se.sessionName = '2024/2025 Academic Year'
GROUP BY cs.courseSessionId, c.title, st.firstName, st.lastName
ORDER BY enrolled_students DESC;