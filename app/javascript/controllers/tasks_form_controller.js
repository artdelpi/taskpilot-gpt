import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
  }

  add() {
    const fragment = this.templateTarget.content.cloneNode(true)
    this.containerTarget.appendChild(fragment)
  }

  remove(event) {
    const block = event.target.closest(".task-fields")
    if (block) block.remove()
  }
}
