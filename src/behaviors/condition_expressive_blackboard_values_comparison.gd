@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btconditionblackboardvaluescomparison.png")
extends BTConditionBlackboardValuesComparison
class_name ConditionExpressiveBlackboardValuesComparison

@export_multiline var success_expression: String = "" :
	set(value):
		success_expression = value
		update_configuration_warnings()

@export_multiline var failure_expression: String = "" :
	set(value):
		failure_expression = value
		update_configuration_warnings()


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	var result = super.tick(actor, blackboard)
	match result:
		BTTickResult.SUCCESS:
			if success_expression != null and success_expression.length() > 0:
				_execute_expression(success_expression, actor, blackboard)
		BTTickResult.FAILURE:
			if failure_expression != null and failure_expression.length() > 0:
				_execute_expression(failure_expression, actor, blackboard)
	return result


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	warnings.append_array(super._get_configuration_warnings())
	if not _success_expression_is_valid():
		warnings.append("Success expression is not valid")
	if not _failure_expression_is_valid():
		warnings.append("Failure expression is not valid")
	return warnings


func _success_expression_is_valid() -> bool:
	return _parse_expression(success_expression) != null


func _failure_expression_is_valid() -> bool:
	return _parse_expression(failure_expression) != null


func _parse_expression(expression: String) -> Expression:
	var expr: Expression = Expression.new()
	var parse_code: int = expr.parse(expression, ["actor", "blackboard"])
	if parse_code != OK:
		push_error("Unable to parse expression '%s' : %s" % [expression, expr.get_error_text()])
		return null
	return expr


func _execute_expression(expression: String, actor: Node2D, blackboard: BTBlackboard) -> Variant:
	var result:Variant = null
	var expr: Expression = _parse_expression(expression)
	if expr != null:
		result = expr.execute([actor, blackboard], self, true)
		if expr.has_execute_failed():
			result = null
			push_error("Unable to execute expression '%s' : %s" % [expression, expr.get_error_text()])
	return result
