use information_schema;
set @q = 'png';
set @t = 'wordpress';

select CONCAT('use \'',@q,'\';') as q UNION
select CONCAT('select \'', tbl.`TABLE_NAME`,'\' as TableName, \'', col.`COLUMN_NAME`,'\' as Col, `',col.`COLUMN_NAME`,'` as value  from `' , tbl.`TABLE_NAME`,'` where `' ,
        col.`COLUMN_NAME` , '` like \'%' ,@q,  '%\' UNION') AS q
from `tables` tbl
inner join `columns` col on tbl.`TABLE_NAME` = col.`TABLE_NAME`and col.DATA_TYPE='varchar'
where tbl.TABLE_SCHEMA  =  @t  ;