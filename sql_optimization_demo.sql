```sql
-- ============================================================
-- PROYECTO 1: Optimización de Reporte de Nómina / Gastos
-- Objetivo: Convertir Join Implícito (Legacy) a ANSI JOIN (Estándar)
-- ============================================================

-- ❌ SINTAXIS LEGADA (Lenta y propensa a errores ORA-00937)
/*
SELECT e.employee_id, e.first_name, d.department_name, SUM(p.amount)
FROM demo_employees e, demo_departments d, demo_payrolls p
WHERE e.department_id = d.department_id
  AND e.employee_id = p.employee_id
GROUP BY e.employee_id;
*/

-- ✅ SINTAXIS OPTIMIZADA (Estándar ANSI con JOINs explícitos y agregaciones correctas)
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name,
    NVL(SUM(p.amount), 0) AS total_paid
FROM demo_employees e
INNER JOIN demo_departments d 
    ON e.department_id = d.department_id
LEFT JOIN demo_payrolls p 
    ON e.employee_id = p.employee_id 
   AND p.pay_period = '2026-01'
GROUP BY 
    e.employee_id, 
    e.first_name, 
    e.last_name, 
    d.department_name
ORDER BY total_paid DESC;
