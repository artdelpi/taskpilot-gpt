import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { map: Object } 

  connect() {
    this.onClick = this.handleClick.bind(this)
    document.addEventListener("click", this.onClick)
    console.log("[modals] conectado", this.mapValue) 
  }

  disconnect() {
    document.removeEventListener("click", this.onClick)
  }

  handleClick(e) {
    const opener = e.target.closest("button[id], a[id]")
    if (opener) {
      const modalId = this.mapValue?.[opener.id]
      if (modalId) {
        const modal = document.getElementById(modalId)
        if (modal) {
          e.preventDefault()
          this.show(modal)
          return
        }
      }
    }

    const closer = e.target.closest("[data-close]")
    if (closer) {
      const modal = closer.closest(".modal-overlay")
      if (modal) this.hide(modal)
      return
    }

    if (e.target.classList?.contains("modal-overlay")) {
      this.hide(e.target)
    }
  }

  show(modal) {
    modal.style.display = "flex"
    requestAnimationFrame(() => modal.classList.add("show"))
  }

  hide(modal) {
    modal.classList.remove("show")
    setTimeout(() => (modal.style.display = "none"), 300)
  }
}
