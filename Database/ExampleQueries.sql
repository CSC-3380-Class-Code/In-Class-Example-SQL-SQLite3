#Queries

#1. The top 5 Cities with the most items being shipped there
Select Address.City, Address.State, Sum(CartItem.Quantity)
From Address
Join CartItem
On Address.Address_ID = CartItem.Address_ID
Group by Address.City
Order by sum(CartItem.Quantity) DESC
Limit 5;

#2. Top 5 revenue items
Select CI.Item_ID, Round(Sum(I.ItemPrice * CI.Quantity),2) as Revenue
From CartItem CI, Item I
Where CI.Item_ID = I.Item_ID
And CI.Purchased = TRUE
Group by CI.Item_ID
Order by Revenue DESC
Limit 5;

#3. Locate all the sellers in Louisiana
Select Account.Account_ID
From Account
Left Join Address
On Account.Account_ID = Address.Account_ID
Where Address.State = "Louisiana"
And Account.IsSeller = TRUE;

#FIXME - Misued alias
#4. Top 50% of states with highest number of orders
Select A.State, Count(A.State) as numOrders
From (Address as A)
Right Join (CartItem as CI)
on A.Address_ID = CI.Address_ID
Where CI.OrderStatus in ("pending", "processed")
Group by A.State
Having numOrders > Avg(numOrders)
Order by numOrders desc;

#5. Most Expensive Item Per Category
Select Category,Item_ID, MAX(ItemPrice) as Total_Price
From Item
Group by Category;

#6. Top Revenue Generating Cities
Select A.City, A.State, ROUND(I.ItemPrice * CI.Quantity, 2) AS Revenue
From Address A, Item I, CartItem CI
Where A.Address_ID = CI.Address_ID AND I.Item_ID = CI.Item_ID
Group by A.City
Order by Revenue desc
Limit 5;

#7. Item categories with highest number of sellers
select Category, count(Seller_ID) as num_sellers
From Item
Group by Category
Order by num_sellers;

#8. The Top 5 Spenders most purchased Item Category
Select a.FirstName, a.LastName, ct.Total, I.Category AS Top_Category
From Item I, CartItem CI, Account a, Customer c, Cart ct,
	(Select count(I.Category)
	 From Item I, CartItem CI, Account a, Customer c, Cart ct
	 Where I.Item_ID = CI.Item_ID
	 AND c.Cart_ID = CI.Cart_ID
	 AND CI.Cart_ID = ct.Cart_ID
	 AND c.Account_ID = a.Account_ID
	 Group by 	ct.Cart_ID, I.Category
	 Order by count(I.Category) desc
	 Limit 1) as top
Where I.Item_ID = CI.Item_ID
AND c.Cart_ID = CI.Cart_ID
AND CI.Cart_ID = ct.Cart_ID
AND c.Account_ID = a.Account_ID
Group by CI.Cart_ID
Order by ct.total desc
Limit 5;

#9. Checks if a product is pending and the purchase is true and the total is over 10 dollars
select  CI.CartItem_ID, round(sum(CI.Quantity*I.ItemPrice),2) as total
from (CartItem CI)
Left join Item I
on CI.Item_ID = I.Item_ID
where CI.OrderStatus = "pending" and CI.Purchased = TRUE
group by CI.CartItem_ID
having total >= 10.0;

#10. Find the seller with the most sales
Select Seller_ID, count(Seller_ID) as Total_Sales
From Item
Group by Seller_ID
Order by Total_Sales DESC
Limit 5;