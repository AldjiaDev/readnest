import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book-autocomplete"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Book autocomplete connecté")
    this.suggestionsContainer = document.createElement("div")
    this.suggestionsContainer.classList.add("autocomplete-suggestions", "position-absolute", "bg-white", "border", "rounded", "shadow", "w-100")
    this.element.appendChild(this.suggestionsContainer)
  }

  search(event) {
    const query = event.target.value.trim()
    if (query.length < 3) {
      this.suggestionsContainer.innerHTML = ""
      return
    }

    fetch(`https://openlibrary.org/search.json?title=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.showSuggestions(data.docs.slice(0, 5))
      })
  }

  showSuggestions(books) {
    this.suggestionsContainer.innerHTML = books.map(book => `
      <div class="p-2 suggestion-item" style="cursor:pointer;">
        <strong>${book.title}</strong><br>
        <small class="text-muted">${book.author_name ? book.author_name.join(", ") : "Auteur inconnu"}</small>
      </div>
    `).join("")

    this.suggestionsContainer.querySelectorAll(".suggestion-item").forEach((el, i) => {
      el.addEventListener("click", () => {
        const book = books[i]
        this.inputTarget.value = book.title
        this.suggestionsContainer.innerHTML = ""
      })
    })
  }
}
