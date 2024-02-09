extends Resource
class_name ItemStack

@export var item: Item = null
@export var count: int = 0

func is_empty():
	return item == null or count == 0

func is_combinable(stack: ItemStack):
	return item == stack.item or is_empty() or stack.is_empty()

func combine(stack: ItemStack):
	item = stack.item
	count += stack.count
	stack.count = 0

func try_combine(stack: ItemStack) -> bool:
	if is_combinable(stack):
		combine(stack)
		return true
	return false

func take(n: int) -> ItemStack:
	if n <= count:
		count -= n
		var ret = ItemStack.new()
		ret.item = item
		ret.count = n
		return ret
	else:
		push_error("Attempted to take %s from ItemStack with %s items" % [n, count])
		return ItemStack.new()
