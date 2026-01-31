class_name CustomerFactory

static func CreateCustomer(id : int) -> CustomerData:
	var customer : CustomerData = CustomerData.new(id, CustomerData.EMPTY_MASK_ID)
	print("Created Customer: " + str(customer.id) + " with mask id: " + str(customer.maskID))
	return customer
	
static func CreateCustomers(startingId: int, customerCount: int) -> Array[CustomerData]:
	var customers : Array[CustomerData] = []
	var currentID : int = 0
	
	for i in range(customerCount):
		customers.append(CreateCustomer(currentID))
		currentID += 1
		
	return customers
