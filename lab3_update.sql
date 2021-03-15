create database labor3_update
create table History(
id int primary key not null,
ProcedureName varchar(100),
param1 varchar(20),
param2 varchar(20),
param3 varchar(20),
param4 varchar(20),
param5 varchar(20),
param6 varchar(20),
)

create table VersionNumber(
actualVersion int 
);

--1) eine neue Tabelle erstellt (create table)
use labor3_update
CREATE PROCEDURE createTable
    @TableName VARCHAR(32),
    @Column1Name VARCHAR(32),
    @Column1DataType VARCHAR(32),
    @Column2Name VARCHAR(32),
    @Column2DataType VARCHAR(32)
AS
BEGIN
	declare @actual int=0
	select @actual=History.id from History
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	--daca nu am nimic in VersionNumber trebuie sa inserez 0 pt a putea updata valoarea
	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	--in cazul in care fac goToVersion de la o versiune mai mica la una mai mare 
	--dupa ce am mai facut inainte un goToVersion
	--nu vreau sa imi mai insereze procedura in History
	if @actual<=@actualVersion
	begin
		insert into History(id, ProcedureName,param1,param2,param3,param4,param5) values (@actual+1,'createTable',@TableName,@Column1Name,@Column1DataType,@Column2Name,@Column2DataType)
	end

	update dbo.VersionNumber set actualVersion=actualVersion+1

	DECLARE @SQLString NVARCHAR(MAX)
	SET @SQLString = 'CREATE TABLE '+@TableName + '( '+@Column1Name+' '+@Column1DataType +', '+@Column2Name+' '+@Column2DataType+ ' )'

	print (@SQLString)
	EXEC (@SQLString)
END
GO

--rollback
CREATE PROCEDURE rollback_createTable
    @TableName VARCHAR(32)
AS
BEGIN
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end
	
	update dbo.VersionNumber set actualVersion=actualVersion-1

	declare @actual int=0
	select @actual=History.id from History

	--insert into History(id, ProcedureName,param1) values (@actual+1,'rollback_createTable',@TableName)

	DECLARE @SQLString NVARCHAR(MAX)
	SET @SQLString = 'DROP TABLE '+@TableName

   print (@SQLString)
   EXEC (@SQLString)
END
GO


--2) den Typ einer Spalte (Attribut) ändert (modify type of column)
CREATE PROCEDURE modifyTyp
	@TableName varchar(32),
	@ColumName varchar(32),
	@ColumnNameType varchar(32)
AS
BEGIN	
	declare @actual int=0
	select @actual=History.id from History
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	if @actual<=@actualVersion
	begin
		insert into History(id, ProcedureName,param1,param2,param3) values (@actual+1,'modifyTyp',@TableName,@ColumName,@ColumnNameType)
	end

	update dbo.VersionNumber set actualVersion=actualVersion+1

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' ALTER COLUMN '+@ColumName+' '+@ColumnNameType
	PRINT(@SQL)
	EXEC(@SQL)
END
GO

--rollback
CREATE PROCEDURE rollback_modifyTyp
	@TableName varchar(32),
	@ColumName varchar(32),
	@ColumnNameType varchar(32)
AS
BEGIN
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	update dbo.VersionNumber set actualVersion=actualVersion-1
	
	declare @actual int=0
	select @actual=History.id from History

	--insert into History(id, ProcedureName,param1,param2,param3) values (@actual+1,'rollback_modifyTyp',@TableName,@ColumName,@ColumnNameType)

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' ALTER COLUMN '+@ColumName+' '+@ColumnNameType
	PRINT(@SQL)
	EXEC(@SQL)
END
GO


--3)eine neue Spalte für eine Tabelle erstellt (add a column)
CREATE PROCEDURE addColumn
	@TableName varchar(32),
	@ColumnName varchar(32),
	@ColumnType varchar(32)
AS
BEGIN
	declare @actual int=0
	select @actual=History.id from History
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end
	--daca @actual(ce urmeaza sa pun in history) e o versiune mai mare decat @actualVersion(versiunea in care sunt acum)
	--inseamna ca am facut deja un goToVersion ca sa aj la @actualVersion deci nu mai vreau sa inserez 
	if @actual<=@actualVersion
	begin
		insert into History(id, ProcedureName,param1,param2,param3) values (@actual+1,'addColumn',@TableName,@ColumnName,@ColumnType)
	end

	update dbo.VersionNumber set actualVersion=actualVersion+1

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' ADD '+@ColumnName+' '+@ColumnType
	PRINT(@SQL)
	EXEC(@SQL)
END
GO

--rollback
CREATE PROCEDURE rollback_addColumn
	@TableName varchar(32),
	@ColumnName varchar(32)
AS
BEGIN
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	update dbo.VersionNumber set actualVersion=actualVersion-1
	
	declare @actual int=0
	select @actual=History.id from History

	--insert into History(id, ProcedureName,param1,param2) values (@actual+1,'rollback_addColumn',@TableName,@ColumnName)

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' DROP COLUMN '+@ColumnName
	PRINT(@SQL)
	EXEC(@SQL)
END
GO


--4)ein default Constraint erstellt
CREATE PROCEDURE defaultConstraint
	@TableName varchar(32),
	@ColumnName varchar(32),
	@DefaultColumn varchar(32),
	@DefaultVal varchar(32)
AS
BEGIN
	declare @actual int=0
	select @actual=History.id from History
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	if @actual<=@actualVersion
	begin
		insert into History(id, ProcedureName,param1,param2,param3,param4) values (@actual+1,'defaultConstraint',@TableName,@ColumnName,@DefaultColumn,@DefaultVal)
	end

	update dbo.VersionNumber set actualVersion=actualVersion+1

	DECLARE @SQL nvarchar(max)
		if @DefaultVal like '%[_0-9]%'
		SET @SQL = 'ALTER TABLE '+@TableName+' ADD CONSTRAINT '+@DefaultColumn+' DEFAULT '+@DefaultVal+' FOR '+@ColumnName
	else
		SET @SQL = 'ALTER TABLE '+@TableName+' ADD CONSTRAINT '+@DefaultColumn+' DEFAULT '+ '''' +@DefaultVal+ '''' +' FOR '+@ColumnName
	PRINT(@SQL)
	EXEC(@SQL)
END
GO

--rollback
CREATE PROCEDURE rollback_defaultConstraint
	@TableName varchar(32),
	@DefaultName varchar(32)
AS
BEGIN
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	update dbo.VersionNumber set actualVersion=actualVersion-1
	
	declare @actual int=0
	select @actual=History.id from History

	--insert into History(id, ProcedureName,param1,param2) values (@actual+1,'rollback_defaultConstraint',@TableName,@DefaultName)

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' DROP CONSTRAINT '+@DefaultName
	PRINT(@SQL)
	EXEC(@SQL)
END
GO


--5)eine Referenz-Integritätsregelerstellt (foreign key constraint)
CREATE PROCEDURE foreignKey
	@TableName varchar(32),
	@ForeignTable varchar(32),
	@ColumnName varchar(32),
	@ForeignColumn varchar(32),
	@Fk_T1T2 varchar(32)
AS
BEGIN
	declare @actual int=0
	select @actual=History.id from History
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	if @actual<=@actualVersion
	begin
		insert into History(id, ProcedureName,param1,param2,param3,param4,param5) values (@actual+1,'foreignKey',@TableName,@ForeignTable,@ColumnName,@ForeignColumn,@Fk_T1T2)
	end

	update dbo.VersionNumber set actualVersion=actualVersion+1

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' ADD CONSTRAiNT '+@Fk_T1T2++' FOREIGN KEY '+' ('+@ForeignColumn+') '+' REFERENCES '+@ForeignTable+'('+@ForeignColumn+')'
	PRINT(@SQL)
	EXEC(@SQL)
END
GO

--rollback
CREATE PROCEDURE rollback_foreignKey
	@TableName varchar(32),
	@Fk_T1T2 varchar(32)
AS
BEGIN
	declare @actualVersion int=0
	select @actualVersion=VersionNumber.actualVersion from VersionNumber

	if not exists (select actualVersion from VersionNumber)
	begin
		insert into VersionNumber(actualVersion) values (0)
	end

	update dbo.VersionNumber set actualVersion=actualVersion-1
	
	declare @actual int=0
	select @actual=History.id from History

--	insert into History(id, ProcedureName,param1,param2) values (@actual+1,'rollback_foreignKey',@TableName,@Fk_T1T2)

	DECLARE @SQL nvarchar(max)
	SET @SQL = 'ALTER TABLE '+@TableName+' DROP CONSTRAINT '+@Fk_T1T2
	PRINT(@SQL)
	EXEC(@SQL)
END
GO


create procedure goToVersion (@version int)
as
begin
	declare @actual as int
	select @actual=actualVersion from VersionNumber--versiunea din VersionNumber
	declare @SQL varchar(128)
	declare @procedName char(28)
	declare @goback char(28)
	print @goback
	declare @arg1 varchar(20)
	declare @arg2 varchar(20)
	declare @arg3 varchar(20)
	declare @arg4 varchar(20)
	declare @arg5 varchar(20)
	
--	if @version != (select History.id from History)
	--begin
		--print('it is not a valid option version')
--	end

	if @version=@actual
	begin
		print('it is already at this version')
	end

	--ma duc la versiuni anterioare, deci fac pe rand rollback la procedurile din History pana ajung la versiunea dorita
	if @version<@actual
	begin
		while @version<@actual
			begin
				select @procedName=ProcedureName from History where id=@actual
				set @goback='rollback_'+@procedName+' '
				--toate au macar un argument
				select @arg1=History.param1 from History where History.id=@actual
				--rollback_createTable
				set @SQL=@goback+' '''+@arg1+''''

				select @arg2=History.param2 from History where History.id=@actual
				if @procedName like 'addColumn'		
				begin
					set @SQL=@SQL+','''+@arg2+''''
				end

				select @arg2=History.param2 from History where History.id=@actual
				declare @val as varchar(30)
				declare @temporar as int
				set @temporar=@actual
				select @val=History.param5 from History where History.id+1=@temporar--iau val de mai sus
				set @arg3=@val
				if @procedName like 'modifyTyp'
				begin
					set @SQL=@SQL+','''+@arg2+''','''+@arg3+''''
				end

				select @arg3=History.param3 from History where History.id=@actual
				if @procedName like 'defaultConstraint'		
				begin
					set @SQL=@SQL+','''+@arg3+''''
				end

				select @arg5=History.param5 from History where History.id=@actual
				if @procedName like'foreignKey'
				begin
					set @SQL=@SQL+','''+@arg5+''''
				end
				exec(@SQL)
				print(@SQL)
				set @actual=@actual-1
			end
		end

	--ma duc la versiuni mai mari, deci execut din nou procedurile din History
	else if @version>@actual
	begin
		while @version>@actual
		begin
			set @actual=@actual+1
			select @procedName=ProcedureName from History where id=@actual

				--select @goback=History.ProcedureName from History where History.id=@actual
				select @arg1=History.param1 from History where History.id=@actual
				select @arg2=History.param2 from History where History.id=@actual
				select @arg3=History.param3 from History where History.id=@actual
				
				--addColumn, modifyTyp
				set @SQL = @procedName+ ' '''+@arg1+''','''+@arg2+''','''+@arg3+''''
				
				select @arg4=History.param4 from History where History.id=@actual
				if @arg4!='NULL'
				begin
					--defaultConstraint
					set @SQL=@SQL+', '''+@arg4+''''
					select @arg5=History.param5 from History where History.id=@actual
					if @arg5!='NULL'
					begin
						--foreignKey,createTable
						set @SQL=@SQL+', '''+@arg5+''''
					end
				end
			exec(@SQL)
			print(@SQL)
		end
	end
	update VersionNumber set actualVersion=@actual
end
go

exec goToVersion 2;

	declare @procedName char(20)
	set @procedName='rollback_sal'
	declare @goback char(20)
	select @goback=SUBSTRING(@procedName,CHARINDEX('_',@procedName)+1,LEN(@procedName))
	print @goback