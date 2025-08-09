import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.onFrameLoad = (e) => {
      if (e.target && e.target.id === "project_details") {
        const modal = this.element
        modal.style.display = "flex"
        requestAnimationFrame(() => modal.classList.add("show"))
      }
    }
    document.addEventListener("turbo:frame-load", this.onFrameLoad)
  }
  disconnect() {
    document.removeEventListener("turbo:frame-load", this.onFrameLoad)
  }
}
