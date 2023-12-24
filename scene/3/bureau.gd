extends MarginContainer


@onready var portfolios = $Portfolios

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	init_portfolios()


func init_portfolios() -> void:
	for _i in 1:
		add_portfolio()


func add_portfolio() -> void:
	var input = {}
	input.bureau = self

	var portfolio = Global.scene.portfolio.instantiate()
	portfolios.add_child(portfolio)
	portfolio.set_attributes(input)
