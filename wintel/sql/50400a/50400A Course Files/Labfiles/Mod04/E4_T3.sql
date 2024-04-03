CREATE FULLTEXT INDEX ON dbo.CallDetails_FT(additional_info) 
   KEY INDEX PK_CallDetails_FT ON (Mod04_Catalog, FILEGROUP FullTextData)
   WITH STOPLIST = SYSTEM
