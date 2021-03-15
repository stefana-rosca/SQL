select *from History
select * from VersionNumber

exec goToVersion 0

--corectare default pt stringuri
delete from History
delete from VersionNumber

EXEC createTable 'String', 'one', 'int primary key','two','varchar(30)';
EXEC defaultConstraint 'String', 'two', 'df_two', 'ana';

EXEC createTable 'newTable', 'one', 'int primary key','two','varchar(30)';
EXEC modifyTyp 'newTable', 'two', 'varchar(50)'
EXEC addColumn 'newTable','three','date';
EXEC defaultConstraint 'newTable', 'three', 'df_three', 'GETDATE()';
EXEC defaultConstraint 'newTable', 'two', 'df_two', 'ana';
EXEC createTable 'newTable2', 'one', 'int primary key','two','varchar(30)';--ca sa pot face fk
EXEC foreignKey 'newTable2', 'newTable', 'one', 'one','FK_newTablenewTable2';