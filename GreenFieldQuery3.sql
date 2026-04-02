SELECT
    CONCAT(s.firstName, ' ', s.lastName) AS full_name,
    s.yearGroup AS year_group,
    COUNT(a.attendanceId) AS total_absences
FROM Student s
JOIN Enrollment e  ON e.studentId  = s.studentId
JOIN Class cl ON cl.courseSessionId = e.courseSessionId
JOIN Attendance a  ON a.classId = cl.classId AND a.studentId = s.studentId AND a.attendanceStatus = 'absent'
GROUP BY s.studentId, s.firstName, s.lastName, s.yearGroup
HAVING COUNT(a.attendanceId) >= 1
ORDER BY total_absences DESC;