USE GreenFieldSchoolDB;

SELECT
    cl.clubName AS club_name,
    CONCAT(st.firstName, ' ', st.lastName) AS lead_teacher,
    COUNT(cs.clubStudentId) AS member_count
FROM Club cl
JOIN Staff st ON cl.staffId = st.staffId
LEFT JOIN ClubStudent cs ON cs.clubId = cl.clubId
GROUP BY cl.clubId
ORDER BY member_count DESC;