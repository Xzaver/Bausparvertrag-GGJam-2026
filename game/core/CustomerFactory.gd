class_name CustomerFactory

enum CULT {ELECTRO, SHOE , ANIMAL, PLANT}



static func CreateCustomer(id : int, sprite : int, cult : int) -> CustomerData:
	var customer : CustomerData = CustomerData.new(id, CustomerData.EMPTY_MASK_ID, sprite,  cult)
	print("Created Customer: " + str(customer.id) + " with mask id: " + str(customer.maskID))
	return customer
	
static func CreateCustomers(startingId: int, customerCount: int) -> Array[CustomerData]:
	
	
	var customers : Array[CustomerData] = []
	var currentID : int = 0
	
	for i in range(customerCount):
		var sprite = currentID % 3
		var cult = currentID % 4
		print("sprite ",sprite, "cult ", cult)
		
		customers.append(CreateCustomer(currentID, sprite, cult))
		currentID += 1
		
	return customers
