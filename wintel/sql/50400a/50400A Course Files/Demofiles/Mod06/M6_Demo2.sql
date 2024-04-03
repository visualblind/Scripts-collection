Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'Database Status', @description=N'', @facet=N'Database', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>EQ</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>Bool</TypeClass>
    <Name>IsAccessible</Name>
  </Attribute>
  <Function>
    <TypeClass>Bool</TypeClass>
    <FunctionType>True</FunctionType>
    <ReturnType>Bool</ReturnType>
    <Count>0</Count>
  </Function>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id

GO


Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'Database Status_ObjectSet', @facet=N'Database', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'Database Status_ObjectSet', @type_skeleton=N'Server/Database', @type=N'DATABASE', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database', @level_name=N'Database', @condition_name=N'', @target_set_level_id=0


GO

Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'Database Status', @condition_name=N'Database Status', @execution_mode=0, @policy_id=@policy_id OUTPUT, @object_set=N'Database Status_ObjectSet'
Select @policy_id


GO


