SELECT 
  s.name AS schema_name,
  p.name AS procedure_name
FROM 
  sys.procedures p
JOIN 
  sys.schemas s ON p.schema_id = s.schema_id
WHERE 
  UPPER(p.name) LIKE UPPER('%{{pattern}}%')
ORDER BY 
  s.name, p.name;
