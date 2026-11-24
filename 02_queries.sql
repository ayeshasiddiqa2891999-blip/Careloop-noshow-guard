---task 2.1:

SELECT COUNT (*), SUM(no_show) FROM appointments;

INSERT INTO appointments VALUES('A0001','P509','C05',
      '2025-01-24','2025-01-25',60,18.0,850,'F','Phone',
      'Consultation','Yes',1,'No-Show',1,1);
--SQLITE_CONSTRAINT_PRIMARYKEY: sqlite3 result code 1555: UNIQUE constraint failed: appointments.appointment_id


--task 2.2:
SELECT s.clinic_name, s.city,COUNT(*) AS appointments,SUM(o.no_show) As no_shows, ROUND(100.0 * SUM(o.no_show)/ COUNT(*),1) AS no_show_pct
FROM appointments o
join clinics s ON o.clinic_id = s.clinic_id
GROUP BY s.clinic_id, s.clinic_name,s.city
ORDER BY no_show_pct DESC;
-- without HAVING , Gomti nagar carepoin(Lucknow) has the highest no-show rate(33.3%)
-- but only 90 appontments. With a small sample, a few no-shows change the percentage a lot
-- so this is less eelaible than those of larger clinics


--task 2.3:
--with having
--task 2.2 (with HAVING):
SELECT s.clinic_name, s.city, COUNT(*) AS appointments, SUM(o.no_show) AS no_shows,
ROUND(100.0 * SUM(o.no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments o
JOIN clinics s ON o.clinic_id = s.clinic_id
GROUP BY s.clinic_id, s.clinic_name, s.city
HAVING COUNT(*) >= 95
ORDER BY no_show_pct DESC;

-- without having
SELECT CASE  WHEN lead_days <= 7 THEN '1-7'
             WHEN lead_days <= 14 THEN '8-14'
             WHEN lead_days <= 30 THEn '15-30'
             ELSE '31+'
       END As band,
             COUNT(*) AS appointments,
             SUM(no_show) AS returns,
             ROUND(100.0 * SUM(no_show)/ COUNT(*),1) AS no_show_pct
             
   FROM appointments
   Group  by band
   ORDER BY MIN(lead_days);
--task 2.4

WITH monthly AS (
     SELECT SUBSTR(appt_date,1.7) AS month,
            COUNT(*) AS appointments,
            ROUND (100.0 * SUM(no_show)/ COUNT(*),1) AS no_show_pct
     FROM appointments
     GROUP BY month
     )
     SELECT month, appointments, no_show_pct,
            ROUND(no_show_pct - LAG(no_show_pct) OVER(ORDER BY month),1) AS change_pts
     FROM monthly;
---task 2.5:
WITH clinic_rates as( SELECT s.clinic_name, s.city,
                      ROUND(100.0*Sum(o.no_show)/ COUNT(*),1) AS no_show_pct
  FROM appointments O
  JOIN clinics s ON o.clinic_id = s.clinic_id
  GROUP BY s.clinic_id, s.clinic_name , s.city
  )
  SELECT clinic_name,city, no_show_pct,
         RANK() OVER (PARTITION BY city ORDER BY no_show_pct DESC) AS rank_in_city,
         CASE
           WHEN no_show_pct > ( SELECT 100.0* SUM(no_show)/ COUNT(*) FROM appointments) THEn'above'
           WHEN no_show_pct < (SELECT 100.0* SUM(no_show)/ COUNT(*) FROM appointments) THEN 'below'
           ELSE 'equal'
         END AS vs_overall
  FROM clinic_rates
 ORDER BY city, rank_in_city;



