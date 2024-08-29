import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
  static values = {  product: Object }

  addToCart() {
    const cart = JSON.parse(localStorage.getItem('cart')) || []
    cart.push(this.productValue)
    localStorage.setItem('cart', JSON.stringify(cart))
    console.log("product: ", this.productValue)
  }

}
