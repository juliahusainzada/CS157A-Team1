USE StudySpotter;

-- 30 users: 10 students, 10 owners, 10 admins
INSERT INTO Users
(user_id, email, password_hash, status, is_verified)
VALUES
(1, 'maya.chen@sjsu.edu', 'hash001', 'Active', TRUE),
(2, 'liam.garcia@sjsu.edu', 'hash002', 'Active', TRUE),
(3, 'sofia.patel@sjsu.edu', 'hash003', 'Active', TRUE),
(4, 'noah.kim@sjsu.edu', 'hash004', 'Active', TRUE),
(5, 'emma.wilson@sjsu.edu', 'hash005', 'Active', TRUE),
(6, 'ethan.lee@sjsu.edu', 'hash006', 'Active', TRUE),
(7, 'ava.martinez@sjsu.edu', 'hash007', 'Active', TRUE),
(8, 'oliver.brown@sjsu.edu', 'hash008', 'Active', TRUE),
(9, 'mia.davis@sjsu.edu', 'hash009', 'Active', TRUE),
(10, 'james.thompson@sjsu.edu', 'hash010', 'Active', TRUE),

(11, 'owner1@voyagercoffee.com', 'hash011', 'Active', TRUE),
(12, 'owner2@academiccoffee.com', 'hash012', 'Active', TRUE),
(13, 'owner3@peets.com', 'hash013', 'Active', TRUE),
(14, 'owner4@philzcoffee.com', 'hash014', 'Active', TRUE),
(15, 'owner5@librarycafe.com', 'hash015', 'Active', TRUE),
(16, 'owner6@sevenleaves.com', 'hash016', 'Active', TRUE),
(17, 'owner7@chromaticcoffee.com', 'hash017', 'Active', TRUE),
(18, 'owner8@storyroad.com', 'hash018', 'Active', TRUE),
(19, 'owner9@spartanmarket.com', 'hash019', 'Active', TRUE),
(20, 'owner10@campusspot.com', 'hash020', 'Active', TRUE),

(21, 'admin1@studyspotter.com', 'hash021', 'Active', TRUE),
(22, 'admin2@studyspotter.com', 'hash022', 'Active', TRUE),
(23, 'admin3@studyspotter.com', 'hash023', 'Active', TRUE),
(24, 'admin4@studyspotter.com', 'hash024', 'Active', TRUE),
(25, 'admin5@studyspotter.com', 'hash025', 'Active', TRUE),
(26, 'admin6@studyspotter.com', 'hash026', 'Active', TRUE),
(27, 'admin7@studyspotter.com', 'hash027', 'Active', TRUE),
(28, 'admin8@studyspotter.com', 'hash028', 'Active', TRUE),
(29, 'admin9@studyspotter.com', 'hash029', 'Active', TRUE),
(30, 'admin10@studyspotter.com', 'hash030', 'Active', TRUE);

INSERT INTO Student
(user_id, student_id, institution)
VALUES
(1, '100000001', 'San Jose State University'),
(2, '100000002', 'San Jose State University'),
(3, '100000003', 'San Jose State University'),
(4, '100000004', 'San Jose State University'),
(5, '100000005', 'San Jose State University'),
(6, '100000006', 'San Jose State University'),
(7, '100000007', 'San Jose State University'),
(8, '100000008', 'San Jose State University'),
(9, '100000009', 'San Jose State University'),
(10, '100000010', 'San Jose State University');

INSERT INTO Owner
(user_id, certification, business_name)
VALUES
(11, 'Business License', 'Voyager Craft Coffee'),
(12, 'Business License', 'Academic Coffee'),
(13, 'Business License', 'Peets Coffee'),
(14, 'Business License', 'Philz Coffee'),
(15, 'Business License', 'Library Cafe'),
(16, 'Business License', '7 Leaves Cafe'),
(17, 'Business License', 'Chromatic Coffee'),
(18, 'Business License', 'Story Road Coffee'),
(19, 'Business License', 'Spartan Market'),
(20, 'Business License', 'Campus Spot Cafe');

INSERT INTO Admin
(user_id, access_level)
VALUES
(21, 'Moderator'),
(22, 'Moderator'),
(23, 'Senior Moderator'),
(24, 'Administrator'),
(25, 'Moderator'),
(26, 'Moderator'),
(27, 'Administrator'),
(28, 'Moderator'),
(29, 'Senior Moderator'),
(30, 'Administrator');

INSERT INTO UserPreferences
(user_id, location, work_style, radius, default_latitude,
 default_longitude, pref_cafe, pref_library, pref_park, pref_classroom)
VALUES
(1, 'Downtown San Jose', 'Quiet', 5, 37.3352, -121.8811, TRUE, TRUE, FALSE, FALSE),
(2, 'SJSU Campus', 'Collaborative', 3, 37.3352, -121.8811, TRUE, FALSE, FALSE, TRUE),
(3, 'Japantown San Jose', 'Quiet', 8, 37.3480, -121.8947, TRUE, TRUE, TRUE, FALSE),
(4, 'Willow Glen', 'Quiet', 10, 37.3060, -121.9000, TRUE, FALSE, TRUE, FALSE),
(5, 'Santa Clara', 'Collaborative', 12, 37.3541, -121.9552, TRUE, TRUE, FALSE, TRUE),
(6, 'Milpitas', 'Quiet', 15, 37.4323, -121.8996, FALSE, TRUE, TRUE, FALSE),
(7, 'Campbell', 'Collaborative', 10, 37.2872, -121.9500, TRUE, FALSE, TRUE, FALSE),
(8, 'Downtown San Jose', 'Quiet', 5, 37.3352, -121.8811, FALSE, TRUE, FALSE, TRUE),
(9, 'Sunnyvale', 'Collaborative', 15, 37.3688, -122.0363, TRUE, FALSE, FALSE, TRUE),
(10, 'Mountain View', 'Quiet', 20, 37.3861, -122.0839, TRUE, TRUE, TRUE, FALSE);

INSERT INTO Places
(owner_user_id, category, name, address, latitude, longitude,
 avg_star_rating, avg_noise_level, avg_outlet_density,
 avg_seating_availability, avg_wifi_speed, avg_food_quality,
 avg_ambience_score)
VALUES
(11, 'Cafe', 'Voyager Craft Coffee', '87 N San Pedro Street, San Jose', 37.3390, -121.8940, 4.7, 2, 5, 4, 5, 5, 5),
(12, 'Cafe', 'Academic Coffee', '499 S 2nd Street, San Jose', 37.3300, -121.8810, 4.3, 3, 4, 4, 5, 5, 4),
(13, 'Cafe', 'Peets Coffee Santana Row', '3055 Olin Avenue, San Jose', 37.3218, -121.9470, 4.2, 3, 3, 4, 5, 4, 4),
(14, 'Cafe', 'Philz Coffee Willow Glen', '1100 Lincoln Avenue, San Jose', 37.3050, -121.9000, 4.5, 2, 3, 4, 5, 5, 5),
(15, 'Library', 'Dr. Martin Luther King Jr. Library', '150 E San Fernando Street, San Jose', 37.3354, -121.8850, 4.8, 1, 5, 5, 5, 1, 5),
(16, 'Cafe', '7 Leaves Cafe', '375 Santana Row, San Jose', 37.3210, -121.9480, 4.4, 3, 3, 4, 4, 5, 4),
(17, 'Cafe', 'Chromatic Coffee Co.', '460 Lincoln Avenue, San Jose', 37.3060, -121.9005, 4.6, 2, 4, 4, 5, 5, 5),
(18, 'Cafe', 'Story Road Coffee', '2051 Story Road, San Jose', 37.3290, -121.8370, 4.1, 3, 3, 3, 4, 4, 4),
(19, 'Classroom', 'SJSU Student Union', '211 S 9th Street, San Jose', 37.3350, -121.8800, 4.4, 2, 5, 5, 5, 1, 4),
(20, 'Park', 'Municipal Rose Garden', 'Naglee Avenue, San Jose', 37.3330, -121.9280, 4.6, 1, 1, 4, 2, 1, 5);

INSERT INTO Amenities
(name, category)
VALUES
('Free Wi-Fi', 'Infrastructure'),
('Power Outlets', 'Infrastructure'),
('Quiet Zone', 'Environment'),
('Outdoor Seating', 'Environment'),
('Study Tables', 'Infrastructure'),
('Coffee', 'Food/Drink'),
('Tea', 'Food/Drink'),
('Printing', 'Infrastructure'),
('Whiteboards', 'Infrastructure'),
('Natural Lighting', 'Environment');

INSERT INTO Reviews
(place_id, user_id, rating, noise_level, outlet_count, seating,
 wifi_speed, food_quality, ambiance, review_text)
VALUES
(1, 1, 5, 2, 5, 4, 5, 5, 5, 'Great coffee and plenty of outlets.'),
(2, 2, 4, 3, 4, 4, 5, 5, 4, 'Good study environment during the afternoon.'),
(3, 3, 4, 3, 3, 4, 5, 4, 4, 'Comfortable location with reliable Wi-Fi.'),
(4, 4, 5, 2, 3, 4, 5, 5, 5, 'Relaxed atmosphere and good seating.'),
(5, 5, 5, 1, 5, 5, 5, 1, 5, 'Excellent quiet place for studying.'),
(6, 6, 4, 3, 3, 4, 4, 5, 4, 'Good drinks and a moderate noise level.'),
(7, 7, 5, 2, 4, 4, 5, 5, 5, 'One of my favorite places to work.'),
(8, 8, 4, 3, 3, 3, 4, 4, 4, 'Decent study spot with available seating.'),
(9, 9, 5, 2, 5, 5, 5, 1, 4, 'Lots of tables and convenient outlets.'),
(10, 10, 4, 1, 1, 4, 2, 1, 5, 'Peaceful outdoor location.');

INSERT INTO MenuItems
(place_id, name, price, description, dietary_flags)
VALUES
(1, 'Cold Brew', 5.25, 'Cold brewed coffee', 'Vegan'),
(1, 'Almond Croissant', 4.75, 'Fresh almond pastry', 'Vegetarian'),
(2, 'Latte', 5.50, 'Espresso with steamed milk', 'Vegetarian'),
(2, 'Blueberry Muffin', 3.75, 'Fresh blueberry muffin', 'Vegetarian'),
(3, 'Iced Coffee', 4.95, 'House iced coffee', 'Vegan'),
(4, 'Philtered Soul', 5.25, 'Hazelnut flavored coffee', 'Vegetarian'),
(6, 'House Milk Tea', 6.00, 'Signature milk tea', 'Vegetarian'),
(7, 'Espresso', 3.50, 'Double shot espresso', 'Vegan'),
(8, 'Matcha Latte', 5.75, 'Green tea latte', 'Vegetarian'),
(9, 'Breakfast Sandwich', 7.50, 'Egg and cheese sandwich', 'Vegetarian');

INSERT INTO ClaimRequests
(user_id, place_id, verification_document_url, status)
VALUES
(11, 1, 'docs/voyager-license.pdf', 'Approved'),
(12, 2, 'docs/academic-license.pdf', 'Approved'),
(13, 3, 'docs/peets-license.pdf', 'Approved'),
(14, 4, 'docs/philz-license.pdf', 'Approved'),
(15, 5, 'docs/library-license.pdf', 'Pending'),
(16, 6, 'docs/sevenleaves-license.pdf', 'Approved'),
(17, 7, 'docs/chromatic-license.pdf', 'Approved'),
(18, 8, 'docs/storyroad-license.pdf', 'Pending'),
(19, 9, 'docs/spartan-license.pdf', 'Approved'),
(20, 10, 'docs/campus-license.pdf', 'Pending');

INSERT INTO SavedPlaces
(user_id, place_id)
VALUES
(1, 5),
(2, 1),
(3, 2),
(4, 7),
(5, 9),
(6, 3),
(7, 4),
(8, 6),
(9, 10),
(10, 8);

INSERT INTO PlaceAmenities
(place_id, amenities_id)
VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2),
(4, 4),
(5, 3),
(5, 5),
(6, 6),
(7, 10),
(9, 8);

INSERT INTO Reports
(reporter_id, reason, status, place_id, review_id, target_user_id)
VALUES
(1, 'Incorrect place information', 'Open', 1, NULL, NULL),
(2, 'Inappropriate review content', 'Resolved', NULL, 2, NULL),
(3, 'Duplicate place listing', 'Open', 3, NULL, NULL),
(4, 'Spam review', 'Resolved', NULL, 4, NULL),
(5, 'User harassment', 'Open', NULL, NULL, 15),
(6, 'Incorrect address', 'Under Review', 6, NULL, NULL),
(7, 'Offensive language in review', 'Resolved', NULL, 7, NULL),
(8, 'False business information', 'Open', 8, NULL, NULL),
(9, 'Suspicious user activity', 'Under Review', NULL, NULL, 19),
(10, 'Duplicate review', 'Resolved', NULL, 10, NULL);
