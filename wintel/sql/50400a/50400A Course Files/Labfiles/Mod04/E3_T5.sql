/*Select the value stored in the /call_info/source and /call_info/dest rows of the additional info column in the CallDetailsHistory table by using an XML query function to return only records with /call_info/@to attribute value set to 1234*/

SELECT additional_info.query('
  /call_info/source
') as source_code,additional_info.query('
  /call_info/dest
') as dest_code
FROM dbo.CallDetailsHistory
WHERE additional_info.exist ('/call_info/@to[.="1234"]') = 1

/*Create a primary XML index and a secondary XML index for PATH, VALUE, and PROPERTY */


CREATE PRIMARY XML INDEX IDX_AddInfo ON CallDetailsHistory (additional_info)
GO
CREATE XML INDEX IDX_AddInfo_PATH ON CallDetailsHistory (additional_info)
USING XML INDEX IDX_AddInfo
FOR PATH
GO
CREATE XML INDEX IDX_AddInfo_VALUE ON CallDetailsHistory (additional_info)
USING XML INDEX IDX_AddInfo
FOR VALUE
GO
CREATE XML INDEX IDX_AddInfo_PROPERTY ON CallDetailsHistory (additional_info)
USING XML INDEX IDX_AddInfo
FOR PROPERTY

/*Select the value stored in the /call_info/source and /call_info/dest rows of the additional info column in the CallDetailsHistory table by using an XML query function to return only records with /call_info/@to attribute value set to 1234*/

SELECT additional_info.query('
  /call_info/source
') as source_code,additional_info.query('
  /call_info/dest
') as dest_code
FROM dbo.CallDetailsHistory
WHERE additional_info.exist ('/call_info/@to[.="1234"]') = 1
