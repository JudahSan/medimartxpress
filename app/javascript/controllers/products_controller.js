import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
  connect() {
    console.log("wololo from controller")
  }
}
