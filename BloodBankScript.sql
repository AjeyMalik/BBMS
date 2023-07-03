create database BloodBankMS;
use BloodBankMS;

/* Creating the donor table*/
CREATE TABLE IF NOT EXISTS `BloodBankMS`.`Donor` (
  `donor_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `age` INT NULL,
  `gender` VARCHAR(10) NULL,
  `blood_group` VARCHAR(10) NOT NULL,
  `phone_number` VARCHAR(20) NULL,
  `email` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `medical_history` VARCHAR(45) NULL,
  PRIMARY KEY (`donor_id`))
ENGINE = InnoDB;

/* Inserting values in the Donor table */
insert into Donor values
(1001,'John Smith',30,'M','A+',1234567890,'johnsmith@email.com','123 Main St','High blood pressure'),
(1002,'Jane Doe',25,'F','O-',9876543210,'janedoe@email.com','456 Elm St','No medical history'),
(1003,'Robert Johnson',45,'M','B+',5555555555,'robertjohnson@email.com','789 Oak St','Diabetes'),
(1004,'Emily Rodriguez',29,'F','AB+',1111111111,'emilyrodriguez@email.com','321 Maple St','No medical history'),
(1005,'William Lee',20,'M','A-',2222222222,'williamlee@email.com','654 Pine St','Asthma'),
(1006,'Ashley Brown',35,'F','O+',3333333333,'ashleybrown@email.com','987 Cedar St','No medical history'),
(1007,'Michael Nguyen',28,'M','B-',4444444444,'michaelnguyen@email.com','1475 Walnut St','No medical history'),
(1008,'Samantha Chen',32,'F','AB+',6666666666,'samanthachen@email.com','369 Oakwood Ave','No medical history'),
(1009,'David Kim',27,'M','AB+',7777777777,'davidkim@email.com','852 Woodland Dr','No medical history'),
(1010,'Stephanie Patel',24,'F','O-',8888888888,'stephaniepatel@email.com','963 Oakwood Ave','Anemia');


/* Creating Blood_inventory Table */
CREATE TABLE IF NOT EXISTS `BloodBankMS`.`Blood_inventory` (
  `blood_unit_id` INT NOT NULL,
  `blood_group` VARCHAR(10) NOT NULL,
  `expiry_date` DATE NOT NULL,
  `storage_location` VARCHAR(45) NULL,
  `is_available` TINYINT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`blood_unit_id`))
ENGINE = InnoDB;

/* inserting values in the blood inventory */
insert into Blood_inventory values
(001, 'O-', 20230520, 'Refrigerator 1', '1',1),
(002, 'AB+', 20230511, 'Freezer 2', 0,1),
(003, 'O+', 20230510, 'Refrigerator 2', 1,2),
(004, 'B-', 20230419, 'Freezer 1', 0,4),
(005, 'AB+', 20230514, 'Refrigerator 3', 1,1),
(006, 'B-', 20230512, 'Refrigerator 1', '1',1),
(007, 'AB+', 20230518, 'Freezer 2', 1,2),
(008, 'AB+', 20230509, 'Refrigerator 2', 1,1),
(009, 'O-', 20230510, 'Freezer 1', 1,2)
;
delete from blood_inventory;

/* Creating the Donation Table */
CREATE TABLE IF NOT EXISTS `BloodBankMS`.`Donation` (
  `donation_id` INT NOT NULL,
  `donor_id` INT NOT NULL,
  `donation_date` DATE NOT NULL,
  `blood_unit_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`donation_id`),
  INDEX `donor_id_idx` (`donor_id` ASC) VISIBLE,
  INDEX `blood_unit_id_idx` (`blood_unit_id` ASC) VISIBLE,
  CONSTRAINT `donor_id`
    FOREIGN KEY (`donor_id`)
    REFERENCES `BloodBankMS`.`Donor` (`donor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `blood_unit_id`
    FOREIGN KEY (`blood_unit_id`)
    REFERENCES `BloodBankMS`.`Blood_inventory` (`blood_unit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
delete from donation;
select * from donation;
/* Inserting values in the donation Table */
insert into Donation values
(201,1002,20230410,001,1),
(202,1004,20230401,002,1),
(203,1006,20230330,003,2),
(204,1007,20230309,004,4),
(205,1009,20230404,005,1),
(206,1007,20230402,006,1),
(207,1009,20230408,007,2),
(208,1004,20230329,008,1),
(209,1002,20230330,009,2)
;

select * from donor;
select * from donation;
select * from blood_inventory;

/* QUERY 2: Retrieve the list of all blood units with their current availability status.  */
SELECT blood_unit_id, blood_group FROM blood_inventory
where is_available=true;


/* QUERY 3: Update the inventory of blood units after a new donation. */
/* lets assume there is a new donation with donation_id=210 and donor_id=1002on 11-04-2023 making the blood_unit_id=001 available*/
insert into Donation value (210,1004,20230411,002,1);
update Blood_inventory 
set is_available=true 
where blood_unit_id=002;
select * from blood_inventory;

/* QUERY 4: Retrieve the list of all blood donors along with their personal details and donation history. */
SELECT Donor.*, donation.donation_date, blood_inventory.blood_group 
FROM donor
INNER JOIN donation ON donor.donor_id = donation.donor_id
INNER JOIN blood_inventory ON donation.blood_unit_id = blood_inventory.blood_unit_id;


/* QUERY 5: Add a new blood donor to the database. */
insert into donor value(1011,'James Smith',32,'M','A+',2341345293,'jamessmith@email.com','321 John Street','No medical history');
select * from donor;

/* QUERY 6: Update the information of a blood donor. */
/* lets assume that address and phone no. of james smith changed */
UPDATE donor 
SET 
 phone_number = 1234567891, 
 address = '323 John Street' 
WHERE donor_id = 1011;
select * from donor;


/* QUERY 7: Add a new blood unit to the inventory. */
INSERT INTO blood_inventory 
VALUES (10,'B+',20230511,'Freezer 3',1,1);
select * from blood_inventory;

/* QUERY 8:Retrieve the information of all the donors whose blood group is AB+.*/
/* information about donors */
SELECT * FROM donor WHERE blood_group = 'AB+';


/* QUERY 8:Retrieve the information of all the donors whose blood group is AB+.*/
/* information with donation history*/
SELECT Donor.*, donation.donation_date
FROM donor
INNER JOIN donation ON donor.donor_id = donation.donor_id
INNER JOIN blood_inventory ON donation.blood_unit_id = blood_inventory.blood_unit_id
WHERE donor.blood_group='AB+';

/* QUERY 9:Delete the information of a specific donor. */
DELETE FROM donor WHERE donor_id = 1011;
select * from donor;

/* QUERY 10:Retrieve the list of blood units that are about to expire in the next 30 days. */
SELECT *,current_date() as 'Current Date' 
FROM blood_inventory 
WHERE expiry_date <= (select current_date()+0100);




