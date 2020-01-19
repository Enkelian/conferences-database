ALTER TABLE dbo.Employees ADD CONSTRAINT LikeEmail CHECK (Email LIKE'%_@%._%')
ALTER TABLE dbo.DayPrices ADD CONSTRAINT SDiscount CHECK (StudentDiscount>=0 AND StudentDiscount<=1)
ALTER TABLE dbo.Days ADD CONSTRAINT PositiveParticipants CHECK (MaxParticipants > 0)