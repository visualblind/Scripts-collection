-- update wordpress.wrd_postmeta set wordpress.wrd_postmeta.meta_value = LOWER(meta_value);
SELECT meta_value
FROM `wordpress`.`wrd_postmeta` WHERE meta_value LIKE '%png%';

select * from wrd_postmeta where meta_key LIKE '%post%'