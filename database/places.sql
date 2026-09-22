USE studyspotter; 

-- Create places table
CREATE TABLE places (
	place_id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	category VARCHAR(20) NOT NULL,
	address VARCHAR(255) NOT NULL,
	city VARCHAR(50) NOT NULL,
	state VARCHAR(20) NOT NULL,
	zip_code VARCHAR(10) NOT NULL,
	
	-- DECIMAL(2,1) = 2 digits, 1 to right of decimal point
	overall_rating DECIMAL(2, 1) DEFAULT 0.0,
	noise_level VARCHAR(20),
	outlet_level VARCHAR(20),
	wifi_level VARCHAR(20),
	
	image_url VARCHAR(500),
	
	PRIMARY KEY (place_id)
);

-- Seed sample data, study spots
INSERT INTO places (
    name,
    category,
    address,
    city,
    state,
    zip_code,
    overall_rating,
    noise_level,
    outlet_level,
    wifi_level,
    image_url
)

VALUES
(
    'MLK Library',
    'Library',
    '150 E San Fernando St',
    'San Jose',
    'CA',
    '95112',
    4.8,
    'Quiet',
    'Plenty',
    'Strong',
    NULL
),
(
    'Voyager Craft Coffee',
    'Cafe',
    '87 N San Pedro St',
    'San Jose',
    'CA',
    '95110',
    4.7,
    'Moderate',
    'Plenty',
    'Strong',
    NULL
),
(
    'SJSU Student Union',
    'Student Center',
    '211 S 9th St',
    'San Jose',
    'CA',
    '95112',
    4.4,
    'Moderate',
    'Plenty',
    'Strong',
    NULL
),
(
    'Academic Coffee',
    'Cafe',
    '499 S 2nd St',
    'San Jose',
    'CA',
    '95113',
    4.3,
    'Moderate',
    'Some',
    'Strong',
    NULL
),
(
    'Sample Study Spot',
    'Cafe',
    '123 Sample St',
    'San Jose',
    'CA',
    '95112',
    4.0,
    'Quiet',
    'Some',
    'Basic',
    NULL
);

-- Verify the data and homepage ordering
SELECT *
FROM places
ORDER BY overall_rating DESC;