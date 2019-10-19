USE [master]
GO
/****** Object:  Database [Clinica]    Script Date: 10/18/2019 11:59:21 PM ******/
CREATE DATABASE [Clinica]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Clinica', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Clinica.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Clinica_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Clinica_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Clinica] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Clinica].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Clinica] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Clinica] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Clinica] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Clinica] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Clinica] SET ARITHABORT OFF 
GO
ALTER DATABASE [Clinica] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Clinica] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Clinica] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Clinica] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Clinica] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Clinica] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Clinica] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Clinica] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Clinica] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Clinica] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Clinica] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Clinica] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Clinica] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Clinica] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Clinica] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Clinica] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Clinica] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Clinica] SET RECOVERY FULL 
GO
ALTER DATABASE [Clinica] SET  MULTI_USER 
GO
ALTER DATABASE [Clinica] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Clinica] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Clinica] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Clinica] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Clinica] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Clinica', N'ON'
GO
ALTER DATABASE [Clinica] SET QUERY_STORE = OFF
GO
USE [Clinica]
GO
/****** Object:  Table [dbo].[Consulta]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Consulta](
	[id_consulta] [int] IDENTITY(1,1) NOT NULL,
	[id_paciente] [int] NOT NULL,
	[Inicio] [datetime] NOT NULL,
	[Fim] [datetime] NOT NULL,
	[Observacoes] [varchar](max) NULL,
	[Finalizada] [bit] NULL,
	[Cancelada] [bit] NULL,
 CONSTRAINT [pk_consulta] PRIMARY KEY CLUSTERED 
(
	[id_consulta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paciente]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paciente](
	[id_paciente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Nascimento] [date] NOT NULL,
 CONSTRAINT [pk_paciente] PRIMARY KEY CLUSTERED 
(
	[id_paciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Consulta]  WITH CHECK ADD  CONSTRAINT [fk_paciente] FOREIGN KEY([id_paciente])
REFERENCES [dbo].[Paciente] ([id_paciente])
GO
ALTER TABLE [dbo].[Consulta] CHECK CONSTRAINT [fk_paciente]
GO
/****** Object:  StoredProcedure [dbo].[alterarPaciente]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[alterarPaciente]
	@Id INTEGER,
	@Nome VARCHAR(50),
	@Nascimento DATE
AS
BEGIN
	UPDATE
		dbo.Paciente
	SET
		Nome = COALESCE(@Nome, Nome),
		Nascimento = COALESCE(@Nascimento, Nascimento)
	WHERE
		id_paciente = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[CancelarConsulta]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CancelarConsulta]
	@Id INT
AS
BEGIN
	UPDATE Consulta
	SET Cancelada = 1
	WHERE id_consulta = @Id
		
END
GO
/****** Object:  StoredProcedure [dbo].[excluirPaciente]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[excluirPaciente]
	@Id INTEGER
AS
BEGIN
	DELETE
		dbo.Paciente
	WHERE
		id_paciente = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[finalizarConsulta]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[finalizarConsulta]
	@Id INT
AS
BEGIN
	UPDATE Consulta
	SET Finalizada = 1
	WHERE id_consulta = @Id
		
END
GO
/****** Object:  StoredProcedure [dbo].[incluirConsulta]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[incluirConsulta] 
	@id_paciente INT,
	@Inicio DATETIME,
	@Fim DATETIME,
	@Observacoes VARCHAR(MAX)
AS
BEGIN

	INSERT INTO 
		[dbo].[Consulta]
		    ([id_paciente]
           ,[Inicio]
           ,[Fim]
           ,[Observacoes])
     VALUES
            (@id_paciente,
			@Inicio,
			@Fim,
			@Observacoes)

END
GO
/****** Object:  StoredProcedure [dbo].[incluirPaciente]    Script Date: 10/18/2019 11:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[incluirPaciente]
	@Nome VARCHAR(50),
	@Nascimento DATE
AS
BEGIN
	INSERT INTO
		dbo.Paciente
	(Nome, Nascimento)
	VALUES
	(@Nome, @Nascimento)
END
GO
USE [master]
GO
ALTER DATABASE [Clinica] SET  READ_WRITE 
GO
