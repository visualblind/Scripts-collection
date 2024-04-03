USE Mod09
SELECT call_date, caller, e.name AS employee_name FROM dbo.CallDetails d INNER JOIN
[NYC-SQL1\DEVELOPMENT].Mod09_2.dbo.Employee e ON d.cs_rep=e.employee_id
