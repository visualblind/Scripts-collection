/* Create two resource pools with maximum CPU percent = 100 and minimum CPU percent = 50 */

USE master
GO
CREATE RESOURCE POOL rpProduction
WITH
(
MAX_CPU_PERCENT = 100,
MIN_CPU_PERCENT = 50
)
GO
CREATE RESOURCE POOL rpDevelopment
WITH
(
MAX_CPU_PERCENT = 50,
MIN_CPU_PERCENT = 0
)
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create two workload groups with high and low importance */

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

--------------------------------------------------------------------------------------------------------------------------------------------

/* Load the configuration into memory */

ALTER RESOURCE GOVERNOR RECONFIGURE
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a classification function */

CREATE FUNCTION fnGroupClassifier()
RETURNS sysname
WITH SCHEMABINDING
AS
BEGIN
IF IS_MEMBER ('SQL-VAN\developers') = 1
RETURN N'rgDevelopment'
RETURN N'rgProduction'
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Enable resource governor to use the Use the fnGroupClassifier function and apply the configuration changes */

ALTER RESOURCE GOVERNOR with (CLASSIFIER_FUNCTION = dbo.fnGroupClassifier)
ALTER RESOURCE GOVERNOR RECONFIGURE
GO

--------------------------------------------------------------------------------------------------------------------------------------------