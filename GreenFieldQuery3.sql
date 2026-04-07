SELECT
    CONCAT(s.firstName, ' ', s.lastName) AS full_name,
    s.yearGroup AS year_group,
    COUNT(a.attendanceId) AS total_absences
FROM Student s
JOIN Attendance a  ON a.studentId = s.studentId AND a.attendanceStatus = 'absent'
GROUP BY s.studentId
HAVING COUNT(a.attendanceId) >= 1
ORDER BY total_absences DESC;