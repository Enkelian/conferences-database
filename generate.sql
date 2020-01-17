USE test34
/*
EXEC PROC_addConference @Name = 'sadasdas',                -- varchar(1)
                            @StartDate = '2020-01-17', -- date
                            @EndDate = '2020-01-25'    -- date 
SELECT * FROM Conferences



EXEC dbo.PROC_addDay @ConferenceID = 1,    -- int
                     @MaxParticipants = 10, -- int
                     @DayNumber = 1        -- int



EXEC dbo.PROC_addClient @Name = 'sdad',      -- nvarchar(200)
                        @IsPerson = 1, -- bit
                        @Phone = '342342',      -- varchar(20)
                        @Country = 'dsada',   -- nvarchar(100)
                        @City = 'sadasd',      -- nvarchar(100)
                        @Address = 'dasdasd',   -- nvarchar(100)
                        @Email = 'adsad@sadasdsa.com',     -- nvarchar(50)
                        @Password = 'dfsafdf'   -- nvarchar(128)
						
						

							 
EXEC dbo.PROC_addClient @Name = 'sdasdasdas',      -- nvarchar(200)
                        @IsPerson = 0, -- bit
                        @Phone = '3123213',      -- varchar(20)
                        @Country = 'sdfsfd',   -- nvarchar(100)
                        @City = 'gfdgds',      -- nvarchar(100)
                        @Address = 'gfdasdf',   -- nvarchar(100)
                        @Email = 'dsgffs@daf.s',     -- nvarchar(50)
                        @Password = 'fdsafnsdf'   -- nvarchar(128)

EXEC dbo.PROC_addParticipant @ClientID = 2,             -- int
                             @FirstName = 'sadasd',          -- nvarchar(100)
                             @LastName = 'dfdsafd',           -- nvarchar(100)
                             @StudentCard = '',         -- varchar(20)
                             @BirthDate = '2020-01-17', -- date
                             @Email = 'sadas@dasd.com',              -- nvarchar(50)
                             @Password = 'dsfsaf'             -- varchar(128)

EXEC dbo.PROC_addPriceThreshold @DayID = 1,             -- int
                                @Value = 11200,          -- money
                                @ToDate = '2020-01-13', -- date
                                @StudentDiscount = 0.0  -- real

EXEC dbo.PROC_addBuilding @City = 'sada',    -- nvarchar(200)
                          @Address = 'sadas', -- nvarchar(200)
                          @Name = 'dasdas',    -- nvarchar(255)
                          @Phone = 'sdasda'     -- varchar(20)



EXEC dbo.PROC_addWorkshop @DayID = 1,              -- int
                          @Title = 'dasda',             -- varchar(1)
                          @MaxParticipants = 1,    -- int
                          @StartTime = '16:28:29', -- time(7)
                          @EndTime = '16:28:50',   -- time(7)
                          @Price = 34,           -- money
                          @Classroom = 'dsa',         -- varchar(1)
                          @BuildingID = 1          -- int

EXEC dbo.PROC_addEmployee @Email = 'dsadasdsa@sadsd.com',   -- varchar(1)
                          @Password = 'fsdfasdfsFSASD' -- varchar(1)

EXEC dbo.PROC_addEmployeeToConference @EmployeeID = 1,  -- int
                                      @ConferenceID = 1 -- int
									  
*/
									  
EXEC dbo.PROC_addConferenceBooking @ConferenceID = 1,          -- int
                                   @ClientID = 1,              -- int
                                   @BookingDate = '2020-01-17' -- date
								   

								   
EXEC dbo.PROC_addDayBooking @DayID = 1,                -- int
                            @ConferenceBookingID = 1,  -- int
                            @NumberOfParticipants = 1, -- int
                            @NumberOfStudents = 0      -- int
							
							
EXEC dbo.PROC_addWorkshopBooking @WorkshopID = 1,          -- int
                                 @DayBookingID = 1,        -- int
                                 @NumberOfParticipants = 1 -- int
								 

								 
EXEC dbo.PROC_addPayment @ConferenceBookingID = 1,             -- int
                         @Total = 200,                        -- money
                         @SendDate = '2020-01-17 16:59:41',    -- datetime
                         @AcceptedDate = '2020-01-17 16:59:41' -- datetime
						 
						 SELECT * FROM dbo.WorkshopBookings
						 SELECT * FROM dbo.DayBookings
	SELECT dbo.FUNC_bookingDayFreeNormalPlaces(1)
	
EXEC dbo.PROC_addDayReservation @ParticipantID = 1, -- int
                                @DayBookingID = 1   -- int
								
								
								SELECT * FROM dbo.DayReservations
					
								
								






								

								
