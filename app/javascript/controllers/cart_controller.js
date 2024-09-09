import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
    initialize() {
        console.log("Combined Cart Controller")
        const cart = JSON.parse(localStorage.getItem("cart"))
        if (!cart) {
            return
        }

        let total = 0;
        let cartLen = cart.length;
        for (let i = 0; i < cartLen; i++) {
            const item = cart[i];
            total += item.price * 1;
            const formattedTotal = total.toLocaleString();

            const div = document.createElement("div");
            div.classList.add("rounded-lg", "border", "border-gray-200", "bg-white", "p-4", "shadow-sm", "dark:border-gray-700", "dark:bg-gray-800", "md:p-6", "mt-2");
            div.innerHTML = `
        <div class="space-y-4 md:flex md:items-center md:justify-between md:gap-6 md:space-y-0">
          <img class="h-20 w-20 dark:hidden" src="${item.image_url}" alt="${item.name} image" />
          <div class="w-full min-w-0 flex-1 space-y-4 md:order-2 md:max-w-md">
            <p class="text-base font-medium text-gray-900 dark:text-white">${item.name}</p>
            <div class="flex items-center gap-4">
              <button type="button" class="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 hover:underline dark:text-gray-400 dark:hover:text-white" data-id="${item.id}" data-action="click->cart#addToFavorites">
                <svg class="me-1.5 h-5 w-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12.01 6.001C6.5 1 1 8 5.782 13.001L12.011 20l6.23-7C23 8 17.5 1 12.01 6.002Z" />
                </svg>
                Add to Favorites
              </button>
              <button type="button" class="inline-flex items-center text-sm font-medium text-red-600 hover:underline dark:text-red-500" data-id="${item.id}" data-size="${item.size}" data-action="click->cart#removeFromCart">
                <svg class="me-1.5 h-5 w-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18 17.94 6M18 18 6.06 6" />
                </svg>
                Remove
              </button>
            </div>
          </div>
          <div class="flex items-center">
        <!--    <button type="button" id="decrement-button" data-input-counter-decrement="counter-input" class="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-md border border-gray-300 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-100 dark:border-gray-600 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-700">
              <svg class="h-2.5 w-2.5 text-gray-900 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 18 2">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h16" />
              </svg>
            </button>
            <input type="text" id="counter-input" data-input-counter class="w-10 shrink-0 border-0 bg-transparent text-center text-sm font-medium text-gray-900 focus:outline-none focus:ring-0 dark:text-white" value="${item.quantity}" required />
            <button type="button" id="increment-button" data-input-counter-increment="counter-input" class="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-md border border-gray-300 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-100 dark:border-gray-600 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-700">
              <svg class="h-2.5 w-2.5 text-gray-900 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 18 18">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 1v16M1 9h16" />
              </svg>
            </button>
          </div>
          <div class="text-end md:order-4 md:w-32">
            <p class="text-base font-bold text-gray-900 dark:text-white">KSH ${(item.price * 1)}</p>
          </div>
        </div>
      `;
            this.element.querySelector("#cart-items").appendChild(div);
        }

        const totalEl = document.createElement("div");
        totalEl.innerText = `Total: KSH ${total.toLocaleString()}`;
        let totalContainer = document.getElementById("total");
        totalContainer.appendChild(totalEl);
    }

    removeFromCart(event) {
        const cart = JSON.parse(localStorage.getItem("cart"))
        const itemId = event.target.getAttribute("data-id")
        const itemSize = event.target.getAttribute("data-size")
        const updatedCart = cart.filter(item => !(item.id === itemId && item.size === itemSize))
        localStorage.setItem("cart", JSON.stringify(updatedCart))
        window.location.reload()
    }

    clear() {
        localStorage.removeItem("cart")
        window.location.reload()
    }

    checkout() {
        const cart = JSON.parse(localStorage.getItem("cart"))
        const payload = {
            authenticity_token: "",
            cart: cart
        }

        const csrfToken = document.querySelector("[name='csrf-token']").content

        fetch("/checkout", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": csrfToken
            },
            body: JSON.stringify(payload)
        }).then(response => {
            if (response.ok) {
                response.json().then(body => {
                    window.location.href = body.url
                })
            } else {
                response.json().then(body => {
                    const errorEl = document.createElement("div")
                    errorEl.innerText = `There was an error processing your order. ${body.error}`
                    let errorContainer = document.getElementById("errorContainer")
                    errorContainer.appendChild(errorEl)
                })
            }
        })
    }
}
