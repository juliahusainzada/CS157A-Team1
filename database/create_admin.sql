/* 
To use this SQL file, register a new student account with the email 'admintest@sjsu.edu' 
and use a password of your choosing. Then run this code to remove this account from 
students and turn it into an administrator account. You are then free to log in with 
the password you chose! 
*/

START TRANSACTION;
DELETE FROM Student
WHERE user_id = (SELECT user_id
			FROM Users
			WHERE email = 'admintest@sjsu.edu');

INSERT INTO Admin (user_id, access_level)
SELECT user_id, 'Administrator'
FROM Users
WHERE email = 'admintest@sjsu.edu';

UPDATE Users
SET status = 'Active', is_verified = TRUE
WHERE email ='admintest@sjsu.edu';

COMMIT;