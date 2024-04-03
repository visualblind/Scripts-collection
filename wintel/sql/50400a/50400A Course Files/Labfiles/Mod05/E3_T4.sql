CREATE FUNCTION fnGroupClassifier()
RETURNS sysname
WITH SCHEMABINDING
AS
BEGIN
IF IS_MEMBER ('NYC-SQL1\developers') = 1
RETURN N'rgDevelopment'

RETURN N'rgProduction'

END
GO
