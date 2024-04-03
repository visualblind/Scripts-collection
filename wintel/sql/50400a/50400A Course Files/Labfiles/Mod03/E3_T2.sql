CREATE TABLE [CallDetails]
(
	[call_date] [datetime] NOT NULL,
	[caller] [varchar](20) NOT NULL,
	[duration] [int] NULL,
	[additional_info] [nchar](4000) NULL,
 CONSTRAINT [PK_CallDetails] PRIMARY KEY CLUSTERED 
(
	[call_date] ASC,
	[caller] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
) ON psCallDetails(call_date)
) ON psCallDetails(call_date)
GO
CREATE NONCLUSTERED INDEX IX_CallDetailsCaller ON dbo.CallDetails
	(
	caller
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON TableData
GO
