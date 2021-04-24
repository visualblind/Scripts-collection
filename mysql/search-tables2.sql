## Table for storing resultant output

CREATE TABLE `temp_details` (
 `t_schema` varchar(45) NOT NULL,
 `t_table` varchar(45) NOT NULL,
 `t_field` varchar(45) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

## Procedure for search in all fields of all databases
DELIMITER $$
#Script to loop through all tables using Information_Schema
DROP PROCEDURE IF EXISTS get_table $$
CREATE PROCEDURE get_table(in_search varchar(50))
 READS SQL DATA
BEGIN
 DECLARE trunc_cmd VARCHAR(50);
 DECLARE search_string VARCHAR(250);

 DECLARE db,tbl,clmn CHAR(50);
 DECLARE done INT DEFAULT 0;
 DECLARE COUNTER INT;

 DECLARE table_cur CURSOR FOR
 SELECT concat('SELECT COUNT(*) INTO @CNT_VALUE FROM `',table_schema,'`.`',table_name,'` WHERE `', column_name,'` REGEXP ''',in_search,''';')
 ,table_schema,table_name,column_name
 FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA NOT IN ('information_schema','test','mysql');

 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

 #Truncating table for refill the data for new search.
 PREPARE trunc_cmd FROM "TRUNCATE TABLE temp_details;";
 EXECUTE trunc_cmd ;

 OPEN table_cur;
 table_loop:LOOP
 FETCH table_cur INTO search_string,db,tbl,clmn;

 #Executing the search
 SET @search_string = 'png';
 SELECT search_string;
 PREPARE search_string FROM @search_string;
 EXECUTE search_string;


 SET COUNTER = @CNT_VALUE;
 SELECT COUNTER;

 IF COUNTER>0 THEN
 # Inserting required results from search to table
 INSERT INTO temp_details VALUES(db,tbl,clmn);
 END IF;

 IF done=1 THEN
 LEAVE table_loop;
 END IF;
 END LOOP;
 CLOSE table_cur;

 #Finally Show Results
 SELECT * FROM temp_details;
END $$
DELIMITER ;