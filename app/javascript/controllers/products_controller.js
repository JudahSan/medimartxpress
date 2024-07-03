import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
    static values = {product: Object}

    addToCart() {
        // Add products to localstorage
        console.log("Product Value:", this.productValue)
        const cart = localStorage.getItem("cart")
        if (cart) {
            const cartArray = JSON.parse(cart)
            const foundIndex = cartArray.findIndex(item => item.id === this.productValue.id)
            if (foundIndex >= 0) {
                cartArray[foundIndex].quantity = parseInt(cartArray[foundIndex].quantity) + 1
            } else {
                const cartArray = []
                cartArray.push({
                    id: this.productValue.id,
                    name: this.productValue.name,
                    price: this.productValue.price,
                    quantity: 1
                })
            }
            localStorage.setItem("cart", JSON.stringify(cartArray))
        } else {
            const cartArray = []
            cartArray.push({
                id: this.productValue.id,
                name: this.productValue.name,
                price: this.productValue.price,
                quantity: 1
            })
            localStorage.setItem("cart", JSON.stringify(cartArray))
        }
    }
}
