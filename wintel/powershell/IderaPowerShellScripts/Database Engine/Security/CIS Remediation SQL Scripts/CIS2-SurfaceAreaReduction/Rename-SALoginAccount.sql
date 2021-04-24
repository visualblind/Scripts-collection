-- Rename SA Login Account
-- CIS 2.14 Check (Surface Area Reduction)

ALTER LOGIN sa WITH NAME = "$(UserName)"

