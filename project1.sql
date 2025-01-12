
-- Creating the university_professor table 
CREATE TABLE university_professor(
firstname varchar(200),
lastname varchar(200),
university varchar(200),
university_shortname varchar(200),
university_city varchar(200),
function varchar(200),
organization varchar(200),
organization_sector varchar(200)
)

-- importing data into university_professor table
COPY university_professor(firstname, lastname, university, university_shortname, university_city, function, organization, organization_sector)
FROM 'D:\uni\university_professor.csv'
DELIMITER ','
CSV HEADER;

SELECT *FROM university_professor

-- The original table already satisfies 1NF.

--For 2NF
-- Step 1: Create the universities table 
CREATE TABLE universities (
    university_id SERIAL PRIMARY KEY,
    university VARCHAR(200) UNIQUE,
    university_shortname VARCHAR(200),
    university_city VARCHAR(200)
);

-- Step 2: Create the organization table
CREATE TABLE organizations (
    organization_id SERIAL PRIMARY KEY,
    organization VARCHAR(200) UNIQUE,
    organization_sector VARCHAR(200)
);

-- For 3NF
-- Step 3: Create the 'professors' table to store professor and function details
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    university_id INT REFERENCES universities(university_id),
    function VARCHAR(255),
    organization_id INT REFERENCES organizations(organization_id)
);



-- Step 4: Insert unique universities into the 'universities' table
INSERT INTO universities (university, university_shortname, university_city)
SELECT DISTINCT university, university_shortname, university_city
FROM university_professor;
SELECT *FROM universities;

-- Step 5: Insert unique organizations into the 'organizations' table
INSERT INTO organizations (organization, organization_sector)
SELECT DISTINCT organization, organization_sector
FROM university_professor;
SELECT *FROM organizations;

-- BCNF: Ensuring that every determinant is a candidate key
-- Step 6: Insert professor details into the 'professors' table
INSERT INTO professors (firstname, lastname, university_id, function, organization_id)
SELECT 
    firstname,
    lastname,
    u.university_id,
    function,
    o.organization_id
FROM university_professor t
JOIN universities u ON t.university = u.university
JOIN organizations o ON t.organization = o.organization;
SELECT *FROM professors;  