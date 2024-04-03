SELECT meta_value
FROM `wordpress`.`wrd_postmeta` WHERE meta_value LIKE '%png%';

UPDATE wordpress.wrd_postmeta SET wordpress.wrd_postmeta.meta_value = LOWER(meta_value)
