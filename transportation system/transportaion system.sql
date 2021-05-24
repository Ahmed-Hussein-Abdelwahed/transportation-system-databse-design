CREATE TABLE Account
(
  Email VARCHAR(30) NOT NULL,
  Pass_word VARCHAR(20) NOT NULL,
  UserName VARCHAR(50) NOT NULL,
  UserType VARCHAR(10) NOT NULL,
  PRIMARY KEY (Email)
);

CREATE TABLE Driver
(
  DriverEmail VARCHAR(30) NOT NULL,
  DriverName VARCHAR(50) NOT NULL,
  DriverLicenseNo INT NOT NULL,
  ContactNo VARCHAR(11) NOT NULL,
  Email VARCHAR(30) NOT NULL,
  PRIMARY KEY (DriverEmail),
  FOREIGN KEY (Email) REFERENCES Account(Email)
);

CREATE TABLE Passenger
(
  PassengerEmail VARCHAR(30) NOT NULL,
  PassengerName VARCHAR(50) NOT NULL,
  ContactNo VARCHAR(11) NOT NULL,
  PromoCode VARCHAR(5),
  CardNo INT,
  Email VARCHAR(30) NOT NULL,
  PRIMARY KEY (PassengerEmail),
  FOREIGN KEY (Email) REFERENCES Account(Email)
);

CREATE TABLE Trip
(
  TripNo INT NOT NULL,
  RidingDate DATE NOT NULL,
  LaunchPlace VARCHAR(30) NOT NULL,
  ArrivePlace VARCHAR(30) NOT NULL,
  TripTime FLOAT NOT NULL,
  VehicleType VARCHAR(15) NOT NULL,
  VehiclePlatesNo VARCHAR(5) NOT NULL,
  VehicleColor VARCHAR(15) NOT NULL,
  VehicleCapacity INT NOT NULL,
  DriverLicenseNo INT NOT NULL,
  DriverName VARCHAR(50) NOT NULL,
  DriverContactNo varchar(11) NOT NULL,
  TripFees FLOAT NOT NULL,
  PaymentMethod VARCHAR(15) NOT NULL,
  CardNo INT,
  RateingSatrsNo FLOAT NOT NULL,
  DriverEmail VARCHAR(30) NOT NULL,
  PRIMARY KEY (TripNo),
  FOREIGN KEY (DriverEmail) REFERENCES Driver(DriverEmail)
);

CREATE TABLE Books
(
  PassengerEmail VARCHAR(30) NOT NULL,
  TripNo INT NOT NULL,
  PRIMARY KEY (PassengerEmail, TripNo),
  FOREIGN KEY (PassengerEmail) REFERENCES Passenger(PassengerEmail),
  FOREIGN KEY (TripNo) REFERENCES Trip(TripNo)
);

/*DML statements*/

INSERT INTO Account
values('ahmed99.com','2524','ahmed hussein','passenger')
,('hazem88.com','1155','hazem tarek','passenger')
,('rushdi77.com','5536','ahmed rushdi','passenger')
,('yosef66.com','1145','yosef essam','driver')
,('atyia55.com','5987','mahmoud atyia','driver')
,('hany44.com','6689','hany mohamed','driver')
,('essam33.com','5533','essam mohamed','driver');

INSERT INTO Driver
values('yosef66.com','yosef essam',1050,'01125369817','yosef66.com')
,('atyia55.com','mahmoud atyia',1160,'01163542986','atyia55.com')
,('hany44.com','hany mohamed',5570,'01205348798','hany44.com')
,('essam33.com','essam mohamed',1555,'01203468976','essam33.com');

INSERT INTO Passenger
values('ahmed99.com','ahmed hussein','0112059367',null,null,'ahmed99.com')
,('hazem88.com','hazem tarek','01125934261','120c4',1145,'hazem88.com')
,('rushdi77.com','ahmed rushdi','01052369854','593c5',1593,'rushdi77.com');

INSERT INTO Trip
values(1,'2020/04/20','fysal','ataba',8.5,'car','1532','red',5,1050,'yosef essam','0112536987',10.5,'cash',null,4.5,'yosef66.com')
,(2,'2020/04/25','fysal','ataba',9.5,'car','5436','white',7,1160,'mahmoud atyia','01163542986',35.5,'visa',1593,4.8,'atyia55.com')
,(3,'2020/05/22','dokki','haram',11.5,'scooter','1534','green',3,5570,'hany mohamed','01205348798',50.5,'masterCard',1145,5,'hany44.com')
,(4,'2020/03/01','dokki','ataba',10.5,'car','7580','selver',4,1555,'essam mohamed','01203468976',40.25,'cash',null,5,'essam33.com')
,(5,'2020/04/30','haram','ataba',12.5,'car','1532','red',5,1050,'yosef essam','0112536987',10.5,'visa',1593,5,'yosef66.com')
,(6,'2020/05/01','fysal','haram',3.5,'scooter','5436','white',7,1160,'mahmoud atyia','01163542986',55.5,'masterCard',1145,4.9,'atyia55.com')
,(7,'2020/05/10','haram','ataba',1.5,'car','1532','red',5,1050,'yosef essam','0112536987',25.5,'visa',1593,4.6,'yosef66.com');

INSERT INTO Books
values('ahmed99.com',1)
,('hazem88.com',2)
,('rushdi77.com',3)
,('ahmed99.com',4)
,('hazem88.com',5)
,('rushdi77.com',6)
,('rushdi77.com',7);

/*Querie (a) What was the area that had the most/least ride requests last month?*/

SELECT MIN(ArrivePlace) AS HighRequests , MAX(ArrivePlace) AS Lowrequests FROM (SELECT COUNT(ArrivePlace) AS Area , ArrivePlace FROM Trip
WHERE RidingDate <= GETDATE() AND RidingDate >= DATEADD(MONTH,-1,GETDATE())
GROUP BY ArrivePlace) AS RequstedErea;

/*Querie (b) Who were the drivers with the maximum number of rides last month?*/

SELECT MAX(DriverName) AS DriverName FROM(
(SELECT COUNT(DriverName) AS MaxRidingNo, DriverName FROM Trip
WHERE RidingDate <= GETDATE() AND RidingDate >= DATEADD(MONTH,-1,GETDATE())
GROUP BY DriverName ) ) AS MaxRidingNo ;


/*Querie (c) For each driver, retrieve all his/her information and the number of rides he/she had.*/

SELECT DriverName , DriverLicenseNo , DriverContactNo , COUNT(DriverName) AS RidingsNumber FROM Trip 
GROUP BY DriverName, DriverName , DriverLicenseNo , DriverContactNo;

/*Querie (d) Which driver got at least 4.5 out of 5 on every user rating he/she got?*/

SELECT RateingSatrsNo , DriverName FROM Trip
WHERE RateingSatrsNo >= 4.5 
ORDER BY RateingSatrsNo;

/*Querie (e) Who were the drivers that didn’t have any ride last month?*/

SELECT DriverName FROM Trip
WHERE (RidingDate <= GETDATE() and RidingDate <= DATEADD(MONTH,-1,GETDATE())) and DriverName <> all (
select DriverName from Trip 
where RidingDate <= GETDATE() and RidingDate >= DATEADD(MONTH,-1,GETDATE()));

/*Querie (f) What is the most type of vehicle (car, bus, and scooter) requested last month?*/

SELECT MIN(VehicleType) AS MostRequestedVehicle FROM(
(SELECT COUNT(VehicleType) AS MOST, VehicleType FROM Trip
WHERE RidingDate <= GETDATE() AND RidingDate >= DATEADD(MONTH,-1,GETDATE())
GROUP BY VehicleType ) ) AS MOSTREQUESTEDVehicle ;
