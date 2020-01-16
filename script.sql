USE [ConferencesFin]
GO

CREATE TABLE [DayPrices] (
  [PriceID] int NOT NULL IDENTITY,
  [DayID] int NOT NULL,
  [Value] money NOT NULL,
  [ToDate] date NOT NULL,
  [StudentDiscount] real NOT NULL CHECK (StudentDiscount>0 AND StudentDiscount<1)
  CONSTRAINT DayPricesPK PRIMARY KEY (PriceID)
)
GO

CREATE TABLE [Conferences] (
  [ConferenceID] int NOT NULL IDENTITY,
  [Name] nvarchar(255) NOT NULL,
  [StartDate] date NOT NULL,
  [EndDate] date NOT NULL,
  [IsCancelled] bit NOT NULL
  CONSTRAINT ConferencesPK PRIMARY KEY (ConferenceID)
)
GO
	
CREATE TABLE [Employees] (
  [EmployeeID] int NOT NULL IDENTITY,
  [Email] nvarchar(50) NOT NULL CHECK (Email LIKE '%_@%._%'),
  [Password] varchar(128) NOT NULL
  CONSTRAINT EmployeesPK PRIMARY KEY (EmployeeID)
)
GO

CREATE TABLE [Days] (
  [DayID] int NOT NULL IDENTITY(1, 1),
  [ConferenceID] int NOT NULL,
  [MaxParticipants] int NOT NULL CHECK (MaxParticipants > 0),
  [DayNumber] int NOT NULL CHECK (DayNumber > 0)
  CONSTRAINT UniqueDayNumbersInConference UNIQUE (ConferenceID, DayNumber),
  CONSTRAINT DaysPK PRIMARY KEY (DayID)
)
GO

CREATE TABLE [Workshops] (
  [WorkshopID] int NOT NULL IDENTITY,
  [DayID] int NOT NULL,
  [Title] nvarchar(255) NOT NULL,
  [MaxParticipants] int NOT NULL CHECK (MaxParticipants > 0),
  [StartTime] time(7) NOT NULL,
  [EndTime] time(7) NOT NULL,
  [Price] money NOT NULL CHECK (Price >= 0),
  [Classroom] varchar(50) NOT NULL,
  [BuildingID] int NOT NULL
  CONSTRAINT WorkshopsPK PRIMARY KEY (WorkshopID)
)
GO

CREATE TABLE [Buildings] (
  [BuildingID] int NOT NULL IDENTITY,
  [City] nvarchar(200) NOT NULL,
  [Address] nvarchar(200) NOT NULL,
  [Name] nvarchar(255),
  [Phone] varchar(20)
  CONSTRAINT BuildingsPK PRIMARY KEY (BuildingID)
  CONSTRAINT UniqueCityAddress UNIQUE (City, Address),

)
GO

CREATE TABLE [Payments] (
  [PaymentID] int NOT NULL IDENTITY,
  [ConferenceBookingID] int NOT NULL,
  [Total] money NOT NULL CHECK (Total > 0),
  [SendDate] datetime NOT NULL,
  [AcceptedDate] datetime NOT NULL
  CONSTRAINT PaymentsPK PRIMARY KEY (PaymentID)
)
GO

CREATE TABLE [ConferenceBookings] (
  [ConferenceBookingID] int NOT NULL IDENTITY,
  [ConferenceID] int NOT NULL,
  [ClientID] int NOT NULL,
  [Status] int NOT NULL CHECK (Status = -1 OR Status = 0 OR Status = 1),
  [BookingDate] datetime NOT NULL
  CONSTRAINT ConferenceBookingsPK PRIMARY KEY (ConferenceBookingID)
)
GO

CREATE TABLE [DayBookings] (
  [DayBookingID] int NOT NULL IDENTITY,
  [DayID] int NOT NULL,
  [ConferenceBookingID] int NOT NULL,
  [Status] int NOT NULL CHECK (Status = -1 OR Status = 0 OR Status = 1),
  [NumberOfParticipants] int NOT NULL CHECK (NumberOfParticipants > 0),
  [NumberOfStudents] int NOT NULL CHECK (NumberOfStudents >= 0)
  CONSTRAINT DayBookingsPK PRIMARY KEY (DayBookingID)
)
GO

CREATE TABLE [WorkshopBookings] (
  [WorkshopBookingID] int NOT NULL IDENTITY,
  [WorkshopID] int NOT NULL,
  [DayBookingID] int NOT NULL,
  [Status] int NOT NULL CHECK (Status = -1 OR Status = 0 OR Status = 1),
  [NumberOfParticipants] int NOT NULL CHECK (NumberOfParticipants > 0)
  CONSTRAINT WorkshopBookingsPK PRIMARY KEY (WorkshopBookingID)
)
GO

CREATE TABLE [Participants] (
  [ParticipantID] int NOT NULL IDENTITY,
  [ClientID] int NOT NULL,
  [FirstName] nvarchar(100),
  [LastName] nvarchar(100),
  [StudentCard] varchar(20),
  [BirthDate] date,
  [Email] nvarchar(50) CHECK (Email LIKE '%_@%._%'),
  [Password] varchar(128)
  CONSTRAINT ParticipantsPK PRIMARY KEY (ParticipantID)
)
GO

CREATE TABLE [Clients] (
  [ClientID] int NOT NULL IDENTITY,
  [Name] nvarchar(200) NOT NULL,
  [IsPerson] bit NOT NULL,
  [Phone] varchar(20) NOT NULL,
  [Country] nvarchar(100),
  [City] nvarchar(100),
  [Address] nvarchar(100),
  [Email] nvarchar(50) NOT NULL CHECK (Email LIKE '%_@%._%'),
  [Password] varchar(128) NOT NULL
  CONSTRAINT UniqueEmail UNIQUE (Email),
  CONSTRAINT ClientsPK PRIMARY KEY (ClientID)
)
GO

CREATE TABLE [EmployeesConferences] (
  [EmployeeID] int NOT NULL,
  [ConferenceID] int NOT NULL,
  CONSTRAINT EmployeesConferencesPK PRIMARY KEY ([EmployeeID], [ConferenceID])
)
GO

CREATE TABLE [DayReservations] (
  [DayReservationID] int NOT NULL IDENTITY,
  [ParticipantID] int NOT NULL,
  [DayBookingID] int NOT NULL
  CONSTRAINT DayReservationsPK PRIMARY KEY (DayReservationID)
)
GO

CREATE TABLE [WorkshopReservations] (
  [WorkshopReservationID] int NOT NULL IDENTITY,
  [DayReservationID] int NOT NULL,
  [WorkshopBookingID] int NOT NULL
  CONSTRAINT WorkshopReservationPK PRIMARY KEY (WorkshopReservationID)
)
GO

ALTER TABLE [DayPrices] ADD FOREIGN KEY ([DayID]) REFERENCES [Days] ([DayID])
GO

ALTER TABLE [Days] ADD FOREIGN KEY ([ConferenceID]) REFERENCES [Conferences] ([ConferenceID])
GO

ALTER TABLE [ConferenceBookings] ADD FOREIGN KEY ([ConferenceID]) REFERENCES [Conferences] ([ConferenceID])
GO

ALTER TABLE [Workshops] ADD FOREIGN KEY ([DayID]) REFERENCES [Days] ([DayID])
GO

ALTER TABLE [Workshops] ADD FOREIGN KEY ([BuildingID]) REFERENCES [Buildings] ([BuildingID])
GO

ALTER TABLE [WorkshopBookings] ADD FOREIGN KEY ([WorkshopID]) REFERENCES [Workshops] ([WorkshopID])
GO

ALTER TABLE [DayBookings] ADD FOREIGN KEY ([DayID]) REFERENCES [Days] ([DayID])
GO

ALTER TABLE [DayBookings] ADD FOREIGN KEY ([ConferenceBookingID]) REFERENCES [ConferenceBookings] ([ConferenceBookingID])
GO

ALTER TABLE [Payments] ADD FOREIGN KEY ([ConferenceBookingID]) REFERENCES [ConferenceBookings] ([ConferenceBookingID])
GO

ALTER TABLE [WorkshopBookings] ADD FOREIGN KEY ([DayBookingID]) REFERENCES [DayBookings] ([DayBookingID])
GO

ALTER TABLE [Participants] ADD FOREIGN KEY ([ClientID]) REFERENCES [Clients] ([ClientID])
GO

ALTER TABLE [EmployeesConferences] ADD FOREIGN KEY ([ConferenceID]) REFERENCES [Conferences] ([ConferenceID])
GO

ALTER TABLE [EmployeesConferences] ADD FOREIGN KEY ([EmployeeID]) REFERENCES [Employees] ([EmployeeID])
GO

ALTER TABLE [ConferenceBookings] ADD FOREIGN KEY ([ClientID]) REFERENCES [Clients] ([ClientID])
GO

ALTER TABLE [DayReservations] ADD FOREIGN KEY ([DayBookingID]) REFERENCES [DayBookings] ([DayBookingID])
GO

ALTER TABLE [DayReservations] ADD FOREIGN KEY ([ParticipantID]) REFERENCES [Participants] ([ParticipantID])
GO

ALTER TABLE [WorkshopReservations] ADD FOREIGN KEY ([WorkshopBookingID]) REFERENCES [WorkshopBookings] ([WorkshopBookingID])
GO

ALTER TABLE [WorkshopReservations] ADD FOREIGN KEY ([DayReservationID]) REFERENCES [DayReservations] ([DayReservationID])
GO

CREATE PROCEDURE [PROC_addConference]
@Name varchar,
@StartDate date,
@EndDate date
AS
BEGIN
	SET NOCOUNT ON;
		BEGIN TRY
			IF(@StartDate > @EndDate)
			BEGIN
			;THROW 52000, 'Invalid StartDate or EndDate',1
			END

/*			IF(@StartDate < GETDATE())
			BEGIN
			;THROW 52000, 'New conference cannot be in the past', 1
			END
*/

			INSERT INTO Conferences(Name, StartDate, EndDate, isCancelled) 
			VALUES (@Name, @StartDate, @EndDate, 0)

		END TRY
		BEGIN CATCH 
			DECLARE @errorMessage nvarchar(2048) = 'Failed to add conference. Error: ' + ERROR_MESSAGE();
			;THROW 52000,@errorMessage ,1;
		END CATCH
END
GO

CREATE PROCEDURE [PROC_addPriceThreshold]
@DayID int,
@Value money,
@ToDate date,
@StudentDiscount real
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF NOT EXISTS(
			SELECT DayID 
			FROM Days
			WHERE DayID = @DayID)
		BEGIN
		;THROW 52000, 'Day with given DayID does not exist.', 1
		END

		DECLARE @ConferenceID int = (
			SELECT ConferenceID
			FROM Days
			WHERE DayID = @DayID)

		IF(@ToDate < 
			(SELECT StartDate
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)
			)
		BEGIN
		;THROW 52000, 'Date cannot follow conference start date', 1
		END

		IF(@StudentDiscount NOT BETWEEN 0 AND 1)
		BEGIN
		;THROW 52000, 'Student discount must be a number between 0 and 1', 1
		END

		DECLARE @isConferenceCancelled int = (
			SELECT isCancelled
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)

		IF (@isConferenceCancelled = 1)
		BEGIN
		;THROW 52000, 'Cannot add price to cancelled conference.', 1
		END

		INSERT INTO DayPrices(DayID, Value, ToDate, StudentDiscount)
		VALUES(@DayID, @Value, @ToDate, @StudentDiscount)

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage nvarchar(2048)
			= 'Failed to add price. Error:' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage,1;
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addDay]
@ConferenceID int,
@MaxParticipants int,
@DayNumber int

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF NOT EXISTS (
			SELECT ConferenceID
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)
		BEGIN
		;THROW 52000, 'Conference with given ConferenceID does not exist.', 1
		END

		IF(@MaxParticipants <= 0)
		BEGIN
		;THROW 52000, 'Number of participants must be a positive number.',1
		END

		IF(@DayNumber IN(
			SELECT DayNumber
			FROM Days
			WHERE ConferenceID = @ConferenceID))
		BEGIN
		;THROW 52000, 'Day with that number already exists', 1
		END

		IF @DayNumber = 1 AND (SELECT COUNT(DayNumber)
								FROM Days
								WHERE ConferenceID = @ConferenceID) > 0
		BEGIN
		;THROW 52000, 'Cannot add first day if there are already any days of conference', 1
		END

		IF @DayNumber <> 1 AND (SELECT COUNT(*)
								FROM Days
								WHERE ConferenceID = @ConferenceID AND DayNumber = @DayNumber - 1) = 0
		BEGIN
		;THROW 52000, 'Cannot add a day that does not have a day that precedes it.', 1
		END					

		INSERT INTO Days(ConferenceID, MaxParticipants, DayNumber)
		VALUES(@ConferenceID, @MaxParticipants, @DayNumber)

		DECLARE @isConferenceCancelled int = (
			SELECT isCancelled
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)

		IF (@isConferenceCancelled = 1)
		BEGIN
		;THROW 52000, 'Cannot add day to cancelled conference.', 1
		END

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage nvarchar(2048) = 'Failed to add day. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage,1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addWorkshop]
@DayID int,
@Title varchar,
@MaxParticipants int,
@StartTime time,
@EndTime time,
@Price money,
@Classroom varchar,
@BuildingID int
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
		IF NOT EXISTS(
		SELECT DayID 
		FROM Days
		WHERE DayID = @DayID)
		BEGIN
		;THROW 52000, 'Day with given DayID does not exist.', 1
		END

		IF NOT EXISTS(
			SELECT BuildingID
			FROM Buildings
			WHERE BuildingID = @BuildingID)
		BEGIN
		;THROW 52000, 'Building with given BuildingID does not exist.', 1
		END

		IF(@MaxParticipants <= 0)
		BEGIN
		;THROW 52000, 'Number of participants must be a positive number.',1
		END

		IF(@EndTime < @StartTime)
		BEGIN
		;THROW 52000, 'Invalid StartTime or EndTime.', 1
		END

		DECLARE @ConferenceID int = (
			SELECT ConferenceID
			FROM Days
			WHERE DayID = @DayID)

		DECLARE @isConferenceCancelled int = (
			SELECT isCancelled
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)

		IF (@isConferenceCancelled = 1)
		BEGIN
		;THROW 52000, 'Cannot add workshop to cancelled conference.', 1
		END

		INSERT INTO Workshops(DayID, Title, MaxParticipants, StartTime, EndTime, Price, Classroom, BuildingID)
		VALUES(@DayID, @Title, @MaxParticipants, @StartTime, @EndTime, @Price, @Classroom, @BuildingID)
		
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage nvarchar(2048) = 'Failed to add workshop. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage,1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addBuilding]
@City NVARCHAR(200),
@Address NVARCHAR(200), 
@Name NVARCHAR(255), 
@Phone VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF @Address IN (
			SELECT Address
			FROM Buildings)
		BEGIN
		;THROW 52000, 'Building with that address already exists', 1
		END

		INSERT INTO Buildings(City, Address, Name, Phone)
		VALUES(@City, @Address, @Name, @Phone)
		
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage nvarchar(2048) = 'Failed to add building. Error :' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addEmployee]
@Email varchar,
@Password varchar
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		IF @Email IN (
			SELECT Email
			FROM Employees)
		BEGIN 
		;THROW 52000, 'This email address already exsists', 1
		END

		INSERT INTO Employees(Email, Password)
		VALUES(@Email, @Password)

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add employee. Error: ' + ERROR_MESSAGE();
		;THROW 25000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addEmployeeToConference]
@EmployeeID int,
@ConferenceID int
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		IF @EmployeeID NOT IN (
			SELECT EmployeeID
			FROM Employees)
		BEGIN
		;THROW 52000, 'Employee with given EmployeeID does not exist', 1
		END

		IF @ConferenceID NOT IN (
			SELECT ConferenceID
			FROM Conferences)
		BEGIN
		;THROW 52000, 'Conference with given ConferenceID does not exist', 1
		END

		INSERT INTO EmployeesConferences (ConferenceID, EmployeeID)
		VALUES(@ConferenceID, @EmployeeID)

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add employee to conference. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addConferenceBooking]
@ConferenceID int,
@ClientID int,
@BookingDate date
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF (@ConferenceID NOT IN(
			SELECT ConferenceID
			FROM Conferences))
		BEGIN
		;THROW 52000, 'Conference with given ConferenceID does not exist', 1
		END
		
		IF (@BookingDate > (
			SELECT StartDate 
			FROM Conferences
			WHERE ConferenceID = @ConferenceID))
		BEGIN
		;THROW 52000, 'Chosen conference already took place.', 1
		END

		IF(@ClientID NOT IN(
			SELECT ClientID
			FROM Clients))
		BEGIN
		;THROW 52000, 'Client with given ClientID does not exist.', 1
		END

		IF EXISTS(
			SELECT ClientID
			FROM ConferenceBookings
			WHERE ClientID = @ClientID AND ConferenceID = @ConferenceID)
		BEGIN
		;THROW 52000, 'Cannot add already existing booking.', 1
		END

		INSERT INTO ConferenceBookings(ConferenceID, ClientID, Status, BookingDate)
		VALUES(@ConferenceID, @ClientID, 0, @BookingDate)

		END TRY
		BEGIN CATCH
			DECLARE @errorMessage varchar(2048) = 'Failed to add conference booking. Error: ' +ERROR_MESSAGE();
			;THROW 52000, @errorMessage, 1
		END CATCH
END
GO

CREATE PROCEDURE [PROC_addDayBooking]
@DayID int,
@ConferenceBookingID int,
@NumberOfParticipants int,
@NumberOfStudents int
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF @DayID NOT IN (
			SELECT DayID
			FROM Days)
		BEGIN
		;THROW 52000, 'Day with given DayID does not exist.', 1
		END

		IF @NumberOfParticipants <= 0
		BEGIN
		;THROW 52000, 'NumberOfParticipants must be a positive number', 1
		END
		
		IF @NumberOfStudents < 0
		BEGIN
		;THROW 52000, 'NumberOfStudents cannot be a negative number', 1
		END

		IF @NumberOfStudents > @NumberOfParticipants
		BEGIN
		;THROW 5200, 'NumberOfStudents cannot be greater than NumberOfParticipants', 1
		END

		DECLARE @ConferenceBookingStatus int = (
			SELECT Status
			FROM ConferenceBookings
			WHERE ConferenceBookingID = @ConferenceBookingID)

		IF @ConferenceBookingStatus = -1
		BEGIN
		;THROW 52000, 'Conference booking has been cancelled', 1
		END

		IF @ConferenceBookingID NOT IN(
			SELECT ConferenceBookingID
			FROM ConferenceBookings)
		BEGIN
		;THROW 52000, 'Booking with given ConferenceBookingID does not exist.', 1
		END

		DECLARE @ConferenceID int = (
			SELECT ConferenceID
			FROM Days
			WHERE DayID = @DayID)

		DECLARE @IsConferenceCancelled bit = (
			SELECT isCancelled
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)

		IF (@IsConferenceCancelled = 1)
		BEGIN
		;THROW 52000, 'This conference has been cancelled', 1
		END


		INSERT INTO DayBookings(DayID, ConferenceBookingID, Status, NumberOfParticipants, NumberOfStudents)
		VALUES (@DayID, @ConferenceBookingID, 0, @NumberOfParticipants, @NumberOfStudents)
	END TRY
	BEGIN CATCH
	DECLARE @errorMessage varchar(2048) = 'Failed to add day booking. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
		END CATCH
END
GO
		
CREATE PROCEDURE [PROC_addWorkshopBooking]
@WorkshopID int,
@DayBookingID int,
@NumberOfParticipants int
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF @WorkshopID NOT IN (
			SELECT WorkshopID
			FROM Workshops)
		BEGIN
		;THROW 52000, 'Workshop with given WorkshopID does not exist', 1
		END
	
		IF(@NumberOfParticipants <= 0)
		BEGIN
		;THROW 52000, 'NumberOfParticipants must be a positive number', 1
		END

		IF @DayBookingID NOT IN(
			SELECT DayBookingID
			FROM DayBookings)
		BEGIN
		;THROW 52000, 'Booking with given DayBookingID does not exist', 1
		END

		DECLARE @DayBookingStatus int = (
			SELECT Status
			FROM DayBookings
			WHERE DayBookingID = @DayBookingID)

		IF(@DayBookingStatus = -1)
		BEGIN
		;THROW 52000, 'Day booking has been cancelled', 1
		END

		DECLARE @DayID int = (
			SELECT DayID
			FROM Workshops
			WHERE WorkshopID = @WorkshopID)
		
		DECLARE @ConferenceID int = (
			SELECT ConferenceID
			FROM Days
			WHERE DayID = @DayID)

		DECLARE @IsConferenceCancelled bit = (
			SELECT isCancelled
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)

		IF @IsConferenceCancelled = 1
		BEGIN
		;THROW 52000, 'This conference has been cancelled', 1
		END

		INSERT INTO WorkshopBookings(WorkshopID, DayBookingID, Status, NumberOfParticipants)
		VALUES(@WorkshopID, @DayBookingID, 0, @NumberOfParticipants)
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add WorkshopBooking. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addDayReservation]
@ParticipantID int,
@DayBookingID int
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF @ParticipantID NOT IN (
			SELECT ParticipantID
			FROM Participants)
		BEGIN
		;THROW 52000, 'Participant with given ParticipantID does not exist', 1
		END

		IF @DayBookingID NOT IN (
			SELECT DayBookingID
			FROM DayBookings)
		BEGIN
		;THROW 52000, 'Day booking with given DayBookingID does not exist', 1
		END

		INSERT INTO DayReservations(ParticipantID, DayBookingID)
		VALUES(@ParticipantID, @DayBookingID)

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add day reservation. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addWorkshopReservation]
@DayReservationID int, 
@WorkshopBookingID int
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		IF @DayReservationID NOT IN (
			SELECT DayReservationID
			FROM DayReservations)
		BEGIN
		;THROW 52000, 'Day reservation with given DayReservationID does not exist', 1
		END

		IF @WorkshopBookingID NOT IN (
			SELECT WorkshopBookingID
			FROM WorkshopBookings)
		BEGIN
		;THROW 52000, 'Workshop booking with given WorkshopBookingID does not exist', 1
		END
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to create workshopreservation. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addClient]
@Name nvarchar(200),
@IsPerson bit,
@Phone varchar(20),
@Country nvarchar(100),
@City nvarchar(100),
@Address nvarchar(100),
@Email nvarchar(50),
@Password nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	IF @Email IN (
		SELECT Email
		FROM Clients)
	BEGIN
	;THROW 52000, 'Account with this email already exists', 1
	END

	INSERT INTO Clients(Name, IsPerson, Phone, Country, City, Address, Email, Password)
	VALUES (@Name, @IsPerson, @Phone, @Country, @City, @Address, @Email, @Password)

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add client. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addParticipant]
@ClientID int,
@FirstName nvarchar(100),
@LastName nvarchar(100),
@StudentCard varchar(20),
@BirthDate date,
@Email nvarchar(50),
@Password varchar(128)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		

		IF (SELECT IsPerson
			FROM Clients
			WHERE ClientID = @ClientID) = 1 AND
			((SELECT COUNT(ParticipantID)
			FROM Participants
			WHERE ClientID = @ClientID) > 0)
		BEGIN
		;THROW 52000, 'Individual client can have only one participant', 1
		END


		INSERT INTO Participants(ClientID, FirstName, LastName, StudentCard, BirthDate, Email, Password)
		VALUES (@ClientID, @FirstName, @LastName, @StudentCard, @BirthDate, @Email, @Password)

	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add participant. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_addPayment]
@ConferenceBookingID int,
@Total money,
@SendDate datetime,
@AcceptedDate datetime
AS
BEGIN
	SET NOCOUNT ON 
	BEGIN TRY
		
		IF @ConferenceBookingID NOT IN (
			SELECT ConferenceBookingID
			FROM ConferenceBookings)
		BEGIN
		;THROW 52000, 'Conference booking with given ConferenceBookingID does not exist.', 1
		END

		IF @SendDate > @AcceptedDate
		BEGIN
		;THROW 52000, 'SendDate cannot be after AcceptedDate', 1
		END
	
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage varchar(2048) = 'Failed to add payment. Error: ' + ERROR_MESSAGE();
		;THROW 52000, @errorMessage, 1
	END CATCH
END
GO

CREATE PROCEDURE [PROC_cancelConference]
@ConferenceID int
AS 
BEGIN
	SET NOCOUNT ON
	UPDATE Conferences
	SET isCancelled = 1
	WHERE ConferenceID = @ConferenceID
END
GO

CREATE PROCEDURE [PROC_cancelConferenceBooking]
@ConferenceBookingID int
AS
BEGIN
	SET NOCOUNT ON
	UPDATE ConferenceBookings
	Set Status = -1
	WHERE ConferenceBookingID = @ConferenceBookingID
END 
GO

--FUNC_conferenceAttendeeList(cb.ConferenceID)
--FUNC_paymentsSum ( ConferenceBookingID )
--FUNC_paymentsLeft ( ConferenceBookingID )

--zwraca sumę kosztów warsztatów dla danego zamówienia
--znizka studencka obowiazuje tylko dla kosztu konferencji
CREATE FUNCTION [FUNC_workshopsCost]
	(
		@ConferenceBookingID int
	)
RETURNS money
AS
BEGIN
	RETURN(
		SELECT SUM(Price)
		FROM Workshops [w]
		INNER JOIN WorkshopBookings [wb] ON w.WorkshopID = wb.WorkshopID
		INNER JOIN DayBookings [db] ON wb.DayBookingID = db.DayBookingID
		INNER JOIN ConferenceBookings [cb] ON db.ConferenceBookingID = cb.ConferenceBookingID
		WHERE cb.ConferenceBookingID = @ConferenceBookingID AND cb.Status <> -1
	);
END
GO

CREATE FUNCTION [FUNC_dayPriceAtDate]
	(
		@DayID int,
		@Date date,
		@IsStudent bit
	)
RETURNS money
AS
BEGIN
	RETURN(
		SELECT TOP 1 Value*@IsStudent*(1-StudentDiscount)
		FROM DayPrices
		WHERE DayID = @DayID AND ToDate >= @Date
		ORDER BY ToDate);
END
GO

--NIE POTRZEBUJE NumberOfStudents!!!!
/*CREATE FUNCTION [FUNC_studentsInDayBooking]
	(
		@DayBookingID int
	)
RETURNS INT
AS
BEGIN
	RETURN(
		SELECT COUNT(*)
		FROM DayBookings [db]
		INNER JOIN DayReservations [dr] ON db.DayBookingID = dr.DayBookingID
		INNER JOIN Participants [p] ON dr.PatricipantID = p.ParticipantID
		WHERE StudentCard IS NOT NULL)
END
GO*/

CREATE FUNCTION [FUNC_dayBookingCost]
	(
		@DayBookingID int
	)
RETURNS money
AS
BEGIN
	DECLARE @StudentsNumber int = (SELECT NumberOfStudents
									FROM DayBookings
									WHERE DayBookingID = @DayBookingID);
	DECLARE @NormalNumber int = (SELECT NumberOfParticipants
							FROM DayBookings
							WHERE DayBookingID = @DayBookingID) - @StudentsNumber;
	
	DECLARE @Total int = 0;		
	
	DECLARE @DayID int = (
		SELECT DayID
		FROM DayBookings
		WHERE DayBookingID = @DayBookingID);

	DECLARE @Status int = (
		SELECT Status
		FROM DayBookings
		WHERE DayBookingID =  @DayBookingID);

	DECLARE @ConferenceBookingID int = (
		SELECT ConferenceBookingID
		FROM DayBookings
		WHERE DayBookingID = @DayBookingID)


	IF @Status = 0
	BEGIN
		SET @Total = @StudentsNumber*dbo.FUNC_dayPriceAtDate(@DayID, GETDATE() , 1) +
					@NormalNumber*dbo.FUNC_dayPriceAtDate(@DayID, GETDATE(), 0)
	END
	ELSE IF @Status = 1
	BEGIN
		DECLARE @Date date = (SELECT SendDate
						FROM Payments
						WHERE ConferenceBookingID = @ConferenceBookingID)
		SET @Total = @StudentsNumber*dbo.FUNC_dayPriceAtDate(@DayID, @Date , 1) +
					@NormalNumber*dbo.FUNC_dayPriceAtDate(@DayID, @Date, 0)
	END
	RETURN @Total;
END
GO

--zwraca koszt konferencji w danym dniu
CREATE FUNCTION [FUNC_bookingCost]
	(
		@ConferenceBookingID int
	)
RETURNS money
AS
BEGIN
	RETURN (
		SELECT SUM(dbo.FUNC_dayBookingCost(DayBookingID))
		FROM DayBookings
		WHERE ConferenceBookingID = @ConferenceBookingID) + dbo.FUNC_workshopsCost(@ConferenceBookingID);
END
GO

CREATE FUNCTION [FUNC_vacanciesForDay]
	(
		@DayID int
	)
RETURNS int
AS
BEGIN
	DECLARE @MaxParticipants int = (
		SELECT MaxParticipants
		FROM Days
		WHERE DayID = @DayID)

	DECLARE @Booked int = (
		SELECT SUM(NumberOfParticipants)
		FROM DayBookings
		WHERE DayID = @DayID)

	RETURN (@MaxParticipants - @Booked);
END
GO


CREATE FUNCTION [FUNC_vacanciesForWorkshop]
	(
		@WorkshopID int
	)
RETURNS int
AS
BEGIN
	DECLARE @MaxParticipants int = (
		SELECT MaxParticipants
		FROM Workshops
		WHERE WorkshopID = @WorkshopID)

	DECLARE @Booked int = (
		SELECT SUM(NumberOfParticipants)
		FROM WorkshopBookings
		WHERE WorkshopID = @WorkshopID)

	RETURN (@MaxParticipants - @Booked);
END
GO

CREATE FUNCTION [FUNC_createNametagsForDay]
(
	@DayID int
)
RETURNS @Nametags TABLE
(
	ParticipantID int,
	FirstName nvarchar(100),
	LastName nvarchar(100),
	IsStudent nvarchar(10),
	CompanyName nvarchar(200)
)
AS
BEGIN
	INSERT @Nametags 
		SELECT p.ParticipantID, FirstName, LastName, IIF(p.StudentCard IS NOT NULL, 'YES', 'NO'), IIF(c.IsPerson = 1, 'INDIVIDUAL', c.Name)
		FROM Participants [p]
		LEFT JOIN Clients [c] ON p.ClientID = c.ClientID
		INNER JOIN DayReservations [dr] ON p.ParticipantID = dr.ParticipantID
		INNER JOIN DayBookings [db] ON dr.DayBookingID = db.DayBookingID
		WHERE DayID = @DayID AND db.Status = 1
	RETURN
END
GO


CREATE FUNCTION [FUNC_participantsOnDay]
(
	@DayID int
)
RETURNS @ParticipantsOnDay TABLE
(
	ParticipantID int,
	FirstName nvarchar(100),
	LastName nvarchar(100),
	Email nvarchar(50)
)
AS
BEGIN
	INSERT @ParticipantsOnDay
		SELECT DISTINCT p.ParticipantID, FirstName, LastName, Email
		FROM Participants [p]
		JOIN DayReservations [dr] ON p.ParticipantID = dr.ParticipantID
		JOIN DayBookings [db] ON dr.DayBookingID = db.DayBookingID
		WHERE DayID = @DayID AND Status = 1
	RETURN
END
GO

CREATE FUNCTION [FUNC_participantsOnWorkshop]
(
	@WorkshopID int
)
RETURNS @ParticipantsOnWorkshop TABLE
(
	ParticipantID int,
	FirstName nvarchar(100),
	LastName nvarchar(100),
	Email nvarchar(50)
)
AS
BEGIN
	INSERT @ParticipantsOnWorkshop
		SELECT DISTINCT dr.ParticipantID, FirstName, LastName, Email
		FROM Participants [p]
		JOIN DayReservations [dr] ON dr.ParticipantID = p.ParticipantID
		JOIN WorkshopReservations [wr] ON dr.DayReservationID = wr.DayReservationID
		JOIN WorkshopBookings [wb] ON wr.WorkshopBookingID = wb.WorkshopBookingID
		WHERE WorkshopID = @WorkshopID AND Status = 1
	RETURN
END
GO


CREATE FUNCTION [FUNC_workshopDate]
(
	@WorkshopID int
)
RETURNS date
AS
BEGIN

	DECLARE @DayID int = (
		SELECT DayID
		FROM Workshops
		WHERE WorkshopID = @WorkshopID)

	DECLARE @Date date = (
		SELECT StartDate
		FROM Conferences [c]
		JOIN Days [d] ON c.ConferenceID = d.ConferenceID
		WHERE d.DayID = @DayID)

	DECLARE @DayNumber int = (
		SELECT DayNumber
		FROM Days
		WHERE DayID = @DayID)

	RETURN DATEADD(day, @DayNumber,@Date);
END
GO


CREATE FUNCTION [FUNC_workshopStartDatetime]
(
	@WorkshopID int
)
RETURNS date
AS
BEGIN
	RETURN(
		SELECT CAST(StartTime AS datetime) +CAST(dbo.FUNC_WorkshopDate(@WorkshopID) AS datetime)
		FROM Workshops
		WHERE WorkshopID = @WorkshopID);
END
GO

CREATE FUNCTION [FUNC_workshopEndDatetime]
(
	@WorkshopID int
)
RETURNS date
AS
BEGIN
	RETURN(
		SELECT CAST(EndTime AS datetime) +CAST(dbo.FUNC_WorkshopDate(@WorkshopID) AS datetime)
		FROM Workshops
		WHERE WorkshopID = @WorkshopID);
END
GO
	

CREATE FUNCTION [FUNC_doWorkshopsCollide]
(
	@WorkshopID1 int,
	@WorkshopID2 int
)
RETURNS bit
AS
BEGIN
	
	DECLARE @W1Start datetime = dbo.FUNC_WorkshopStartDatetime(@WorkshopID1)
	DECLARE @W2Start datetime = dbo.FUNC_WorkshopStartDatetime(@WorkshopID2)
	DECLARE @W1End datetime = dbo.FUNC_WorkshopEndDatetime(@WorkshopID1)
	DECLARE @W2End datetime = dbo.FUNC_WorkshopEndDatetime(@WorkshopID2)

	IF (@W1Start < @W2Start AND @W1End > @W2Start) OR (@W2Start < @W1Start AND @W2End > @W1Start)
		RETURN 1
	IF (@W1Start >= @W2Start AND @W1End <= @W2End) OR (@W2Start >= @W1Start AND @W2End <= @W1End)
		RETURN 1
	RETURN 0
END
GO

CREATE FUNCTION [FUNC_bookingDayFreeNormalPlaces]
(
	@DayBookingID int
)
RETURNS int
AS
BEGIN
	DECLARE @NumberOfReservations int = (SELECT COUNT(p.ParticipantID)
										FROM DayReservations [dr]
										JOIN Participants [p] ON dr.ParticipantID = p.ParticipantID
										WHERE DayBookingID =  @DayBookingID AND (p.StudentCard IS NULL OR DATEDIFF (year,  GETDATE(), p.BirthDate) > 25))

	RETURN (SELECT NumberOfParticipants - NumberOfStudents - @NumberOfReservations
			FROM DayBookings
			WHERE DayBookingID = @DayBookingID)
END
GO

CREATE FUNCTION [FUNC_bookingDayFreeStudentsPlaces]
(
	@DayBookingID int
)
RETURNS int
AS
BEGIN
	DECLARE @NumberOfStudentReservations int = (SELECT COUNT(dr.ParticipantID)
												FROM DayReservations [dr]
												JOIN Participants [p] ON dr.ParticipantID = p.ParticipantID
												WHERE DayBookingID =  @DayBookingID AND (p.StudentCard IS NOT NULL AND DATEDIFF (year,  GETDATE(), p.BirthDate) <= 25))
	RETURN (SELECT NumberOfStudents - @NumberOfStudentReservations
			FROM DayBookings
			WHERE DayBookingID = @DayBookingID)
END
GO

CREATE FUNCTION [FUNC_workshopDayFreeNormalPlaces]
(
	@WorkshopBookingID int
)
RETURNS int
AS
BEGIN
	DECLARE @NumberOfReservations int = (SELECT COUNT(ParticipantID)
										FROM WorkshopReservations [wr]
										JOIN DayReservations [dr] ON dr.DayReservationID = wr.DayReservationID
										WHERE WorkshopBookingID = @WorkshopBookingID)

	RETURN (SELECT NumberOfParticipants - @NumberOfReservations
			FROM WorkshopBookings
			WHERE WorkshopBookingID = @WorkshopBookingID)
END
GO
												
CREATE FUNCTION [FUNC_workshopsListForParticipant]
(
	@ParticipantID int
)
RETURNS @Workshops TABLE
(
	WorkshopID int
)
AS
BEGIN
	INSERT @Workshops
			SELECT wb.WorkshopID
			FROM Participants [p]
			JOIN DayReservations [dr] ON dr.ParticipantID = p.ParticipantID
			JOIN WorkshopReservations [wr] ON wr.DayReservationID = dr.DayReservationID
			JOIN WorkshopBookings [wb] ON wr.WorkshopBookingID = wb.WorkshopBookingID
			WHERE p.ParticipantID = @ParticipantID
	RETURN
END
GO

-- WIDOKI

--1
CREATE VIEW [VIEW_clients] 
AS
	SELECT ClientID,
	       Name,
	       Email,
	       Country,
	       City,
	       Address,
	       Phone, 
	       IIF(IsPerson = 1, 'Individual', 'Company') AS 'ClientType'
	FROM Clients
GO

--2
CREATE VIEW [VIEW_clientStats] 
AS
    SELECT c.ClientID,
            c.Name,
            c.Email,
            c.Phone,
            IIF(c.IsPerson = 1, 'Individual', 'Company') AS 'ClientType',
            (
                SELECT COUNT(*)
                FROM ConferenceBookings AS cb
                WHERE cb.ClientID = c.ClientID AND cb.status = 1
            ) AS 'ParticipatedInConferences',
            SUM( ISNULL(p.Total,0) ) AS 'TotalPayments'
    FROM Clients AS c
    LEFT JOIN ConferenceBookings AS cb ON c.ClientID = cb.ClientID AND cb.Status != -1
    LEFT JOIN Payments AS p ON p.ConferenceBookingID = cb.ConferenceBookingID
    GROUP BY c.ClientID, c.Name, c.Email, c.Phone, c.IsPerson
GO

--3
CREATE VIEW [VIEW_dayPlaces] 
AS
    SELECT d.DayID,
            d.ConferenceID,
            d.MaxParticipants AS TotalPlaces,
            ISNULL(SUM(db.NumberOfParticipants), 0) AS BookedPlaces,
            d.MaxParticipants - ISNULL(SUM(db.NumberOfParticipants), 0) AS FreePlaces
    FROM Days AS d
    LEFT JOIN DayBookings AS db ON db.DayID = d.DayID AND db.Status != -1
    GROUP BY d.DayID, d.ConferenceID, d.MaxParticipants
GO

--4
CREATE VIEW [VIEW_availableDays] 
AS
    SELECT dp. *
    FROM VIEW_dayPlaces AS dp
    WHERE dp.FreePlaces > 0
GO

--5
CREATE VIEW [VIEW_daysPopularity] 
AS
    SELECT TOP 10 dp. *,
            CAST(1.0 * dp.BookedPlaces / dp.TotalPlaces AS decimal(5,4)) AS 'Occupancy'
    FROM VIEW_dayPlaces AS dp
    ORDER BY 1.0 * dp.BookedPlaces / dp.TotalPlaces DESC
GO

--6
CREATE VIEW [VIEW_workshopPlaces] 
AS
	SELECT w.WorkshopID,
	        w.DayID,
	        w.Title,
	        w.MaxParticipants AS TotalPlaces,
	        ISNULL(SUM(wb.NumberOfParticipants), 0) AS BookedPlaces,
	        w.MaxParticipants - ISNULL(SUM(wb.NumberOfParticipants), 0) AS FreePlaces
	FROM Workshops AS w
	LEFT JOIN WorkshopBookings AS wb ON wb.WorkshopID = w.WorkshopID AND wb.status != -1
	GROUP BY w.WorkshopID, w.DayID, w.Title, w.MaxParticipants
GO

--7
CREATE VIEW [VIEW_availableWorkshops] 
AS
	SELECT wp. *
	FROM VIEW_workshopPlaces AS wp
	WHERE wp.FreePlaces > 0
GO

--8
CREATE VIEW [VIEW_workshopsPopularity] 
AS
	SELECT TOP 10
	        wa.*,
	        CAST(1.0 * wa.BookedPlaces / wa.TotalPlaces AS decimal(5,4)) AS 'Occupancy'
	FROM VIEW_availableWorkshops AS wa
	ORDER BY 1.0 * wa.BookedPlaces / wa.TotalPlaces DESC
GO

--9
CREATE VIEW [ VIEW_unpaidOnTimeConferenceBookings ]
AS
    SELECT cb.ConferenceBookingID,
            cb.ClientID,
            cb.ConferenceID ,
            c.Name,
            DATEADD (day , 7 , cb.BookingDate ) AS 'PaymentDeadline',
            dbo.FUNC_bookingCost ( cb.ConferenceBookingID ) AS 'BookingCost'
    FROM ConferenceBookings AS cb
    JOIN Conferences AS c ON cb.ConferenceID = c.ConferenceID
    LEFT JOIN Payments AS p ON p.ConferenceBookingID = cb.ConferenceBookingID
    WHERE cb.Status != -1 AND p.Total IS NULL
    AND DATEDIFF (day , DATEADD (day ,7 , cb.BookingDate ) , GETDATE () ) > 0
GO

--10
CREATE VIEW [ VIEW_yetUnpaidConferenceBookings ]
AS
    SELECT cb.ConferenceBookingID,
            cb.ClientID,
            cb.ConferenceID ,
            c.Name,
            DATEADD (day , 7 , cb.BookingDate ) AS 'PaymentDeadline',
            dbo.FUNC_bookingCost ( cb.ConferenceBookingID ) AS 'BookingCost'
    FROM ConferenceBookings AS cb
    JOIN Conferences AS c ON cb.ConferenceID = c.ConferenceID
    LEFT JOIN Payments AS p ON p.ConferenceBookingID = cb.ConferenceBookingID
    WHERE cb.Status != -1 AND p.Total IS NULL
    AND DATEDIFF (day , DATEADD (day ,7 , cb.BookingDate ) , GETDATE () ) <= 0
GO

--11
CREATE VIEW [ VIEW_cancelledConferenceBookings ]
AS
	SELECT ConferenceBookingID,
	        ClientID,
	        ConferenceID,
	        BookingDate
	FROM ConferenceBookings
	WHERE Status = -1
GO

--12
CREATE VIEW [ VIEW_paidConferenceBookings ]
AS
	SELECT cb.ConferenceBookingID,
	        cb.ClientID,
	        cb.ConferenceID,
	        c.Name,
	        p.Total AS BookingCost
	FROM ConferenceBookings AS cb
	JOIN Conferences AS c ON c.ConferenceID = cb.ConferenceID
	JOIN Payments AS P ON p.ConferenceBookingID = cb.ConferenceBookingID
	WHERE cb.Status = 1
	--WHERE cb.Status != -1 AND p.Total = FUNC_bookingCost( ConferenceBookingID )
GO

--13
CREATE VIEW [ VIEW_bookingsWithoutFilledParticipants ]
AS
    (SELECT cl.ClientID ,
            cl.Name AS 'ClientName',
            cl.Email,
            cl.Phone,
            co.Name AS 'ConferenceName' ,
            'Day : ' + CAST (d.DayNumber AS varchar ) AS 'Event',
            DATEADD (day , d.DayNumber - 1 , co.StartDate ) AS 'StartTime',
            db.NumberOfParticipants AS 'BookedPlaces',
            COUNT (dr.DayReservationID ) AS 'FilledPlaces'
    FROM DayBookings AS db
    JOIN ConferenceBookings AS cb ON cb.ConferenceBookingID = db.ConferenceBookingID
    JOIN Conferences AS co ON co.ConferenceID = cb.ConferenceID
    JOIN Clients AS cl ON cl.ClientID = cb.ClientID
    JOIN Days AS d ON d.DayID = db.DayID
    LEFT JOIN DayReservations AS dr ON dr.DayBookingID = db.DayBookingID
    WHERE db.Status != -1
    GROUP BY db.DayBookingID, db.NumberOfParticipants, co.Name, co.StartDate, d.DayNumber, cl.ClientID , cl.Name, cl.Email, cl. Phone
    HAVING db.NumberOfParticipants > COUNT (dr.DayReservationID))

    UNION

    (SELECT cl.ClientID,
            cl.Name AS 'ClientName',
            cl.Email ,
            cl.Phone ,
            c.Name AS 'ConferenceName',
            'Workshop : ' + w.Title AS 'Event',
            dbo.FUNC_workshopDate (w.WorkshopID ) AS 'StartTime',
            wb.NumberOfParticipants AS 'BookedPlaces',
            COUNT (wr.WorkshopReservationID ) AS 'FilledPlaces'
    FROM WorkshopBookings AS wb
    JOIN DayBookings AS db ON db.DayBookingID = wb.DayBookingID
    JOIN ConferenceBookings AS cb ON cb.ConferenceBookingID = db.ConferenceBookingID
    JOIN Conferences AS c ON c.ConferenceID = cb.ConferenceID
    JOIN Clients AS cl ON cl.ClientID = cb.ClientID
    JOIN Workshops AS w ON w.WorkshopID = wb.WorkshopID
    LEFT JOIN WorkshopReservations AS wr ON wr.WorkshopReservationID = wb.WorkshopBookingID
    WHERE wb.Status != -1
	GROUP BY wb.NumberOfParticipants, w.Title, w.WorkshopID, cl.ClientID, cl.Name, cl.Email, cl.Phone, c.Name
    HAVING wb.NumberOfParticipants > COUNT (wr.WorkshopReservationID ))
GO

-- TRIGGERY

--1 
CREATE TRIGGER [ TRIG_notEnoughFreePlacesForBookingDay ]
ON DayBookings 
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		WHERE dbo.FUNC_vacanciesForDay (i.DayID ) - i.NumberOfParticipants < 0
	)
	BEGIN
	;THROW 50001, 'Too few free places to book day.' ,1
	END
END
GO

--2
CREATE TRIGGER [ TRIG_notEnoughFreePlacesForBookingWorkshop ]
ON WorkshopBookings
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		WHERE dbo.FUNC_vacanciesForWorkshop (i.WorkshopID ) - i.NumberOfParticipants < 0
	)
	BEGIN
	;THROW 50001 , 'Too few free places to book workshop.' ,1
	END
END
GO

--3

CREATE TRIGGER [ TRIG_morePlacesBookedForWorkshopThanDay ]
ON WorkshopBookings
AFTER INSERT, UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		JOIN DayBookings AS db ON db.DayBookingID = i.DayBookingID
		WHERE db.NumberOfParticipants < i.NumberOfParticipants
	)
	BEGIN
	;THROW 50001 , 'The number of places booked for the workshop cannot exceed the number of places booked for a day.' ,1
	END
END
GO

--4
CREATE TRIGGER [ TRIG_moreBookedPlacesThanDayMaxParticipants ]
ON Days
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
	SELECT * FROM inserted AS i
	LEFT JOIN DayBookings AS db ON db.DayID = i.DayID
	GROUP BY i.DayID, i.MaxParticipants
	HAVING i.MaxParticipants < SUM (ISNULL(db.NumberOfParticipants,0))
	)
	BEGIN
	;THROW 50001 , 'Cannot decrease maximum number of participants since there are too many booked places.' ,1
	END
END
GO

--5
CREATE TRIGGER [ TRIG_moreBookedPlacesThanWorkshopMaxParticipants ]
ON Workshops
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		LEFT JOIN WorkshopBookings AS wb ON wb.WorkshopID = i.WorkshopID
		GROUP BY i.WorkshopID, i.MaxParticipants
		HAVING i.MaxParticipants < SUM (ISNULL(wb.NumberOfParticipants, 0))
	)
	BEGIN
	;THROW 50001 , 'Cannot decrease maximum number of participants since there are too many booked places.' ,1
	END
END
GO

--6
CREATE TRIGGER [ TRIG_cancelDayBookingAfterCancellingConferenceBooking ]
ON ConferenceBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	UPDATE DayBookings SET Status = -1
	WHERE ConferenceBookingID IN 
	(
		SELECT i.ConferenceBookingID FROM inserted AS i
		JOIN deleted AS d ON i.ConferenceBookingID = d.ConferenceBookingID
		WHERE i.Status = -1 AND d.Status != -1
	)
END
GO

--7
CREATE TRIGGER [ TRIG_bookingDayTwice ]
ON DayBookings
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		JOIN DayBookings AS db ON db.DayID = i.DayID AND db.ConferenceBookingID = i.ConferenceBookingID
		WHERE i.DayBookingID <> db.DayBookingID
	)
	BEGIN
	; THROW 50001, 'You have already booked this day.',1
	END
END
GO
--8
CREATE TRIGGER [ TRIG_bookingWorkshopInWrongDay ]
ON WorkshopBookings
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
	SELECT * FROM inserted AS i
	JOIN Workshops AS w ON w.WorkshopID = i.WorkshopID
	JOIN Days AS d1 on d1.DayID = w.DayID
	JOIN DayBookings AS db ON db.DayBookingID = i.DayBookingID
	JOIN Days AS d2 ON d2.DayID = db.DayID
	WHERE d1.DayID <> d2.DayID
	)
	BEGIN
	;THROW 50001, 'Booking workshop from different day than booking day is for.',1
	END
END
GO

--9
CREATE TRIGGER [ TRIG_cancelWorkshopBookingAfterCancellingDayBooking ]
ON DayBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	UPDATE WorkshopBookings SET Status = -1
	WHERE DayBookingID IN
	(
		SELECT i.DayBookingID FROM inserted AS i
		JOIN deleted AS d ON i.DayBookingID = d.DayBookingID
		WHERE d.Status != -1 AND i.Status = -1
	)
END
GO

--10
CREATE TRIGGER [ TRIG_removeWorkshopReservation ]
ON DayReservations
AFTER DELETE
AS
	BEGIN
	SET NOCOUNT ON;
	DELETE FROM WorkshopReservations
	WHERE WorkshopReservationID IN
	(
		SELECT wr.WorkshopReservationID
		FROM deleted AS d
		JOIN WorkshopReservations AS wr ON wr.DayReservationID = d.DayReservationID
	)
END
GO

--11
CREATE TRIGGER [ TRIG_confirmConferenceBookingPayment ]
ON Payments
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	UPDATE ConferenceBookings SET Status = 1
	WHERE ConferenceBookingID IN 
	(
		SELECT i.ConferenceBookingID FROM inserted AS i
		JOIN ConferenceBookings AS cb ON cb.ConferenceBookingID = i.ConferenceBookingID
		WHERE cb.Status != -1 
		--AND dbo.FUNC_bookingCost(i.ConferenceBookingID) = i.Total
	)
END
GO

--12
CREATE TRIGGER [ TRIG_confirmDayBookingPaymentAfterConfirmingConferenceBooking ]
ON ConferenceBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	UPDATE DayBookings SET Status = 1
	WHERE ConferenceBookingID IN 
	(
		SELECT i.ConferenceBookingID FROM inserted AS i
		JOIN deleted AS d ON d.ConferenceBookingID = i.ConferenceBookingID
		WHERE i.Status = 1 AND d.Status = 0
	)
END
GO

--13
CREATE TRIGGER [ TRIG_confirmWorkshopBookingPaymentAfterConfirmingDayBooking ]
ON DayBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	UPDATE WorkshopBookings SET Status = 1
	WHERE DayBookingID IN 
	(
		SELECT i.DayBookingID FROM inserted AS i
		JOIN deleted AS d ON d.DayBookingID = i.DayBookingID
		WHERE i.Status = 1 AND d.Status = 0
	)
END
GO

--14
CREATE TRIGGER [ TRIG_deleteDayReservationAfterCancellingDayBooking ]
ON DayBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	DELETE FROM DayReservations
	WHERE DayReservationID IN
	(
		SELECT dr.DayReservationID
		FROM inserted AS i
		JOIN deleted AS d ON i.DayBookingID = d.DayBookingID
		JOIN DayReservations AS dr ON dr.DayBookingID = i.DayBookingID
		WHERE d.Status != -1 AND i.Status = -1
	)
END
GO

--15
CREATE TRIGGER [ TRIG_deleteWorkshopReservationAfterCancellingWorkshopBooking ]
ON WorkshopBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	DELETE FROM WorkshopReservations
	WHERE WorkshopReservationID IN
	(
		SELECT wr.WorkshopReservationID
		FROM inserted AS i
		JOIN deleted AS d ON i.WorkshopBookingID = d.WorkshopBookingID
		JOIN WorkshopReservations AS wr ON wr.WorkshopBookingID = i.WorkshopBookingID
		WHERE d.Status != -1 AND i.Status = -1
	)
END
GO

--16
CREATE TRIGGER [ TRIG_dayOutsideConferenceDuration ]
ON Days
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		JOIN Conferences AS c ON c.ConferenceID = i.ConferenceID
		WHERE DATEADD(day, i.DayNumber - 1, c.StartDate) > c.EndDate
	)
	BEGIN
	;THROW 50001, 'Day is outside of conference duration.',1
	END
END
GO

--17
CREATE TRIGGER [ TRIG_collidingWorkshops ]
ON WorkshopReservations
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		JOIN DayReservations AS dr ON dr.DayReservationID = i.DayReservationID
		CROSS APPLY FUNC_workshopsListForParticipant(dr.ParticipantID) AS w1
		JOIN WorkshopBookings AS wb ON wb.WorkshopBookingID = i.WorkshopBookingID
		JOIN Workshops AS w ON w.WorkshopID = wb.WorkshopID
		WHERE dbo.FUNC_doWorkshopsCollide(w1.WorkshopID , w.WorkshopID) = 1
		AND w1.WorkshopID <> w.WorkshopID
	)
	BEGIN
	;THROW 50001, 'Tried to book place for workshop when you already booked another workshop in the same time.',1
	END
END
GO

--18
CREATE TRIGGER [ TRIG_reservationForDay ]
ON DayReservations
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		JOIN Participants AS p ON p.ParticipantID = i.ParticipantID
		JOIN DayBookings AS db ON db.DayBookingID = i.DayBookingID
		JOIN Days AS d ON d.DayID = db.DayID
		JOIN Conferences AS c ON c.ConferenceID = d.ConferenceID
		WHERE (
				p.StudentCard IS NOT NULL AND DATEDIFF (year, c.StartDate, p.BirthDate) <= 25
				AND dbo.FUNC_bookingDayFreeStudentsPlaces(i.DayBookingID) <= 0
				)
				OR
				(
				((p.StudentCard IS NULL) OR (p.StudentCard IS NOT NULL AND DATEDIFF (year, c.StartDate, p.BirthDate) > 25))
				AND dbo.FUNC_bookingDayFreeNormalPlaces(i.DayBookingID) <= 0
				)
	)
	BEGIN
	;THROW 50001, 'There are no more places that the client has booked. ',1
	END
END
GO


--19
CREATE TRIGGER [ TRIG_reservationForWorkshop]
ON WorkshopReservations
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		WHERE dbo.FUNC_workshopDayFreeNormalPlaces(i.WorkshopBookingID) <= 0
	)
	BEGIN
	;THROW 50001, 'There are no more places that the client has booked.',1
	END
END
GO

--20
CREATE TRIGGER [ TRIG_tooManyWorkshopReservationsAfterDecrasingPlaces]
ON WorkshopBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		WHERE dbo.FUNC_workshopDayFreeNormalPlaces(i.WorkshopBookingID) < 0
	)
	BEGIN
	;THROW 50001, 'Too many workshop reservations after decreasing number of booked places.',1
	END
END
GO

--21
CREATE TRIGGER [ TRIG_tooManyDayReservationsAfterDecrasingPlaces]
ON DayBookings
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		WHERE dbo.FUNC_bookingDayFreeNormalPlaces(i.DayBookingID) < 0
		OR dbo.FUNC_bookingDayFreeStudentsPlaces(i.DayBookingID) < 0
	)
	BEGIN
	;THROW 50001, 'Too many day reservations after decreasing number of booked places.',1
	END
END
GO

--22
CREATE TRIGGER [ TRIG_bookingDayFromWrongConference]
ON DayBookings
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT * FROM inserted AS i
		JOIN Days AS d ON d.DayID = i.DayID
		JOIN Conferences AS c1 ON c1.ConferenceID = d.ConferenceID
		JOIN ConferenceBookings AS cb ON cb.ConferenceBookingID = i.ConferenceBookingID
		JOIN Conferences AS c2 ON c2.ConferenceID = cb.ConferenceID
		WHERE c1.ConferenceID != c2.ConferenceID
	)
	BEGIN
	;THROW 50001, 'Booking day from wrong conference.',1
	END
END
GO

--23 nowy trigger
CREATE TRIGGER [Trig_checkDayPrices]
ON DayPrices
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS(
			SELECT d.DayID 
			FROM Days AS d
			JOIN inserted AS i ON i.DayID = d.DayID)
		BEGIN
		;THROW 50001, 'Day with given DayID does not exist.', 1
		END
	DECLARE @ConferenceID int = (
			SELECT ConferenceID
			FROM Days AS d
			JOIN inserted AS i ON i.DayID = d.DayID)
	DECLARE @ToDate date = (
		SELECT ToDate FROM inserted)

	IF(@ToDate < 
			(SELECT StartDate
			FROM Conferences
			WHERE ConferenceID = @ConferenceID)
			)
		BEGIN
		;THROW 50001, 'Date cannot follow conference start date', 1
		END
END
GO

--24 nowy
CREATE TRIGGER [Trig_checkDay]
ON Days
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS (
			SELECT c.ConferenceID
			FROM Conferences AS c
			JOIN inserted AS i ON i.ConferenceID = c.ConferenceID)
		BEGIN
		;THROW 52000, 'Conference with given ConferenceID does not exist.', 1
		END

	DECLARE @DayNumber int = (
			SELECT DayNumber
			FROM inserted)
	DECLARE @ConferenceID int = (
			SELECT ConferenceID
			FROM inserted)
	DECLARE @isConferenceCancelled bit = (
		SELECT IsCancelled FROM Conferences
		WHERE ConferenceID = @ConferenceID
	)
	IF @DayNumber = 1 AND (SELECT COUNT(DayNumber)
								FROM Days
								WHERE ConferenceID = @ConferenceID) > 1
		BEGIN
		;THROW 52000, 'Cannot add first day if there are already any days of conference', 1
		END

		IF @DayNumber <> 1 AND (SELECT COUNT(*)
								FROM Days
								WHERE ConferenceID = @ConferenceID AND DayNumber = @DayNumber - 1) > 1
		BEGIN
		;THROW 52000, 'Cannot add a day that does not have a day that precedes it.', 1
		END	

	IF (@isConferenceCancelled = 1)
		BEGIN
		;THROW 52000, 'Cannot add day to cancelled conference.', 1
		END				

END
GO

--25 nowy
CREATE TRIGGER [Trig_checkWorkshop]
ON Workshops
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON
	DECLARE @isConferenceCancelled bit = (
		SELECT c.IsCancelled FROM Days AS d
		JOIN inserted AS i ON i.DayID = d.DayID
		JOIN Conferences AS c ON c.ConferenceID = d.ConferenceID)
	IF NOT EXISTS(
		SELECT Days.DayID 
		FROM Days
		JOIN inserted AS i ON i.DayID = Days.DayID)
		BEGIN
		;THROW 52000, 'Day with given DayID does not exist.', 1
		END
	IF NOT EXISTS(
			SELECT b.BuildingID
			FROM Buildings AS b
			JOIN inserted AS i ON i.BuildingID = b.BuildingID)
		BEGIN
		;THROW 52000, 'Building with given BuildingID does not exist.', 1
		END
	IF (@isConferenceCancelled = 1)
		BEGIN
		;THROW 52000, 'Cannot add workshop to cancelled conference.', 1
		END
END
GO


-- INDEKSY

CREATE NONCLUSTERED INDEX [INDEX_workshopBookingsDayBookingID] ON [WorkshopBookings]
( 
    [DayBookingID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [INDEX_dayBookingsConferenceBookingID] ON [DayBookings]
( 
    [ConferenceBookingID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [INDEX_conferenceBookingsClientID] ON [ConferenceBookings]
( 
    [ClientID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [INDEX_paymentsConferenceBookingID] ON [Payments]
( 
    [ConferenceBookingID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [INDEX_workshopsDayID] ON [Workshops]
( 
    [DayID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [INDEX_daysConferenceID] ON [Days]
( 
    [ConferenceID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [INDEX_dayPricesDayID] ON [DayPrices]
( 
    [DayID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB =
OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)