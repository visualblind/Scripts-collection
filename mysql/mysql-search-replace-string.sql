# Introduction to MySQL REPLACE string function
# MySQL provides you with a useful string function called REPLACE that allows you to replace a string in a column of a table by a new string.

# The syntax of the REPLACE function is as follows:

REPLACE(str,old_string,new_string);

# Code language: SQL (Structured Query Language) (sql)
# The REPLACE function has three parameters. It replaces the old_string by the new_string in the string

# Notice there is a statement also called REPLACE used to insert or update data. You should not confuse the REPLACE statement with the REPLACE string function.

# The REPLACE function is very handy to search and replace text in a table such as updating obsolete URL, correcting a spelling mistake, etc.# 

# The syntax of using the REPLACE function in an UPDATE statement is as follows:

UPDATE tbl_name 
SET 
    field_name = REPLACE(field_name,
        string_to_find,
        string_to_replace)
WHERE
    conditions;

# Code language: SQL (Structured Query Language) (sql)
# Note that when searching for text to replace, MySQL uses the case-sensitive match to perform a search for a string to be replaced.

# MySQL REPLACE string function example
# For example, if you want to correct the spelling mistake in the products table in the sample database, you use the REPLACE function as follows:

UPDATE products 
SET 
    productDescription = REPLACE(productDescription,
        'abuot',
        'about');
		
# Code language: SQL (Structured Query Language) (sql)
# The query finds all occurrences of a spelling mistake abuot and replaces it by the correct word about in the productDescription column of the products table.

# It is very important to note that in the REPLACE function, the first parameter is the column name without quotes (“). If you put the quotes to the field name like “field_name”, the query will update the content of that column to “field_name”, which is causing unexpected data loss.

# The REPLACE function does not support regular expression so if you need to replace a text string by a pattern you need to use MySQL user-defined function (UDF) from external library, check it out here MySQL UDF with Regex