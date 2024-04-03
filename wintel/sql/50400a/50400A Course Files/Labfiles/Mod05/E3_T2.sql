CREATE WORKLOAD GROUP rgProduction
WITH
(
IMPORTANCE = HIGH
)
USING rpProduction
GO
CREATE WORKLOAD GROUP rgDevelopment
WITH
(
IMPORTANCE = LOW
)
USING rpDevelopment
GO
