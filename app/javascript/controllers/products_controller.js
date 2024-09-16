import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { product: Object }

    // Method to add a product to the cart
    addToCart() {
        console.log("product: ", this.productValue)  // Log the product being added for debugging

        // Retrieve the existing cart from localStorage, if available
        const cart = localStorage.getItem("cart")
        let cartArray = []  // Initialize an empty cart array

        // Check if the cart already exists in localStorage
        if (cart) {
            // Parse the existing cart data into an array
            cartArray = JSON.parse(cart)

            // Check if the product is already in the cart (using product ID for comparison)
            const foundIndex = cartArray.findIndex(item => item.id === this.productValue.id)

            if (foundIndex !== -1) {
                // If the product is already in the cart, increase its quantity by 1
                cartArray[foundIndex].quantity += 1
            } else {
                // If the product is not in the cart, add it as a new item with quantity 1
                cartArray.push({
                    id: this.productValue.id,
                    name: this.productValue.name,
                    price: this.productValue.price,
                    quantity: 1
                })
            }
        } else {
            // If no cart exists, initialize it with the first product
            cartArray.push({
                id: this.productValue.id,
                name: this.productValue.name,
                price: this.productValue.price,
                quantity: 1
            })
        }

        // Update the localStorage with the modified cart (whether new or updated)
        localStorage.setItem("cart", JSON.stringify(cartArray))
    }
}
