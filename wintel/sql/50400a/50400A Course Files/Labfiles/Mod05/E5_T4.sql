INSERT INTO TestTable (id,content,create_date) VALUES (1,'Test',GETDATE())
INSERT INTO TestTable (id,content,create_date) VALUES (2,'Test',GETDATE())
GO
UPDATE TestTable SET create_date=GETDATE(), content='test2' WHERE id=1
GO
DELETE TestTable WHERE id=2
