/****** Object:  User [frvjqbLfacLogin_onlinesurveyUser]    Script Date: 22-09-2014 22:27:05 ******/
CREATE USER [frvjqbLfacLogin_onlinesurveyUser] FOR LOGIN [frvjqbLfacLogin_onlinesurvey] WITH DEFAULT_SCHEMA=[onlinesurvey]
GO
/****** Object:  Schema [onlinesurvey]    Script Date: 22-09-2014 22:27:08 ******/
CREATE SCHEMA [onlinesurvey]
GO
/****** Object:  StoredProcedure [dbo].[GetLatestRespondedSurvey]    Script Date: 22-09-2014 22:27:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLatestRespondedSurvey]
	
AS
create table #tmpsurveys(surveyid varchar(100),questiontext varchar(500))


insert into #tmpsurveys(surveyid,questiontext)
select id,questiontext from  onlinesurvey.Survey where id in (
	select distinct surveyid from onlinesurvey.Response where __createdAt between GETDATE() - 1 and getdate())


	select P.optiontext, P.id ,S.questiontext Question,S.surveyid Surveyid, (Select count(id) from onlinesurvey.Response where pollid = P.id and surveyid= S.Surveyid)  [count] from onlinesurvey.Polls P , #tmpsurveys S
	order by S.surveyid

drop table #tmpsurveys
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetSurveyResponse]    Script Date: 22-09-2014 22:27:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSurveyResponse]  
 @surveyid varchar(50)  
AS  
 select P.optiontext, P.id , (Select count(id) from onlinesurvey.Response where pollid = P.id and surveyid= @surveyid) as count from onlinesurvey.Polls P  
 join onlinesurvey.SurveyPollMapping map on P.id = map.pollid 
 where map.surveyid = @surveyid
RETURN 0  
GO
/****** Object:  Table [onlinesurvey].[Polls]    Script Date: 22-09-2014 22:27:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onlinesurvey].[Polls](
	[id] [nvarchar](255) NOT NULL,
	[__createdAt] [datetimeoffset](3) NOT NULL,
	[__updatedAt] [datetimeoffset](3) NULL,
	[__version] [timestamp] NOT NULL,
	[optiontext] [nvarchar](max) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [onlinesurvey].[Response]    Script Date: 22-09-2014 22:27:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onlinesurvey].[Response](
	[id] [nvarchar](255) NOT NULL,
	[__createdAt] [datetimeoffset](3) NOT NULL,
	[__updatedAt] [datetimeoffset](3) NULL,
	[__version] [timestamp] NOT NULL,
	[responsedevice] [nvarchar](max) NULL,
	[useragent] [nvarchar](max) NULL,
	[ipaddress] [nvarchar](max) NULL,
	[surveyid] [nvarchar](max) NULL,
	[pollid] [nvarchar](max) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [onlinesurvey].[Survey]    Script Date: 22-09-2014 22:27:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [onlinesurvey].[Survey](
	[id] [nvarchar](255) NOT NULL,
	[__createdAt] [datetimeoffset](3) NOT NULL,
	[__updatedAt] [datetimeoffset](3) NULL,
	[__version] [timestamp] NOT NULL,
	[questiontext] [nvarchar](max) NULL,
	[notificationemail] [nvarchar](max) NULL,
	[userid] [varchar](max) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [onlinesurvey].[SurveyPollMapping]    Script Date: 22-09-2014 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onlinesurvey].[SurveyPollMapping](
	[id] [nvarchar](255) NOT NULL,
	[__createdAt] [datetimeoffset](3) NOT NULL,
	[__updatedAt] [datetimeoffset](3) NULL,
	[__version] [timestamp] NOT NULL,
	[surveyid] [nvarchar](max) NULL,
	[pollid] [nvarchar](max) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [onlinesurvey].[SurveyResponseComments]    Script Date: 22-09-2014 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onlinesurvey].[SurveyResponseComments](
	[id] [nvarchar](255) NOT NULL,
	[__createdAt] [datetimeoffset](3) NOT NULL,
	[__updatedAt] [datetimeoffset](3) NULL,
	[__version] [timestamp] NOT NULL,
	[responseid] [nvarchar](max) NULL,
	[comment] [nvarchar](max) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [onlinesurvey].[User]    Script Date: 22-09-2014 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onlinesurvey].[User](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](200) NOT NULL,
	[ProfileID] [nvarchar](200) NULL,
	[ProfileAuthToken] [nvarchar](2100) NULL,
	[EmailAddress] [nvarchar](200) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[Gender] [nchar](1) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[BirthDate] [date] NULL,
	[UserRoleID] [int] NULL,
	[AuditCreateDate] [datetime2](7) NULL,
	[AuditModifyDate] [datetime2](7) NULL,
 CONSTRAINT [pk_User] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER TABLE [onlinesurvey].[Polls] ADD  CONSTRAINT [DF_Polls_id]  DEFAULT (CONVERT([nvarchar](255),newid(),(0))) FOR [id]
GO
ALTER TABLE [onlinesurvey].[Polls] ADD  CONSTRAINT [DF_Polls___createdAt]  DEFAULT (CONVERT([datetimeoffset](3),sysutcdatetime(),(0))) FOR [__createdAt]
GO
ALTER TABLE [onlinesurvey].[Response] ADD  CONSTRAINT [DF_Response_id]  DEFAULT (CONVERT([nvarchar](255),newid(),(0))) FOR [id]
GO
ALTER TABLE [onlinesurvey].[Response] ADD  CONSTRAINT [DF_Response___createdAt]  DEFAULT (CONVERT([datetimeoffset](3),sysutcdatetime(),(0))) FOR [__createdAt]
GO
ALTER TABLE [onlinesurvey].[Survey] ADD  CONSTRAINT [DF_Survey_id]  DEFAULT (CONVERT([nvarchar](255),newid(),(0))) FOR [id]
GO
ALTER TABLE [onlinesurvey].[Survey] ADD  CONSTRAINT [DF_Survey___createdAt]  DEFAULT (CONVERT([datetimeoffset](3),sysutcdatetime(),(0))) FOR [__createdAt]
GO
ALTER TABLE [onlinesurvey].[SurveyPollMapping] ADD  CONSTRAINT [DF_SurveyPollMapping_id]  DEFAULT (CONVERT([nvarchar](255),newid(),(0))) FOR [id]
GO
ALTER TABLE [onlinesurvey].[SurveyPollMapping] ADD  CONSTRAINT [DF_SurveyPollMapping___createdAt]  DEFAULT (CONVERT([datetimeoffset](3),sysutcdatetime(),(0))) FOR [__createdAt]
GO
ALTER TABLE [onlinesurvey].[SurveyResponseComments] ADD  CONSTRAINT [DF_SurveyResponseComments_id]  DEFAULT (CONVERT([nvarchar](255),newid(),(0))) FOR [id]
GO
ALTER TABLE [onlinesurvey].[SurveyResponseComments] ADD  CONSTRAINT [DF_SurveyResponseComments___createdAt]  DEFAULT (CONVERT([datetimeoffset](3),sysutcdatetime(),(0))) FOR [__createdAt]
GO
ALTER TABLE [onlinesurvey].[User] ADD  CONSTRAINT [df_MVUser_AuditCreateDate]  DEFAULT (getutcdate()) FOR [AuditCreateDate]
GO
