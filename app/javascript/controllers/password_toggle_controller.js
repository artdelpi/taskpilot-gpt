import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "box"]

  connect() {
    this.apply()
  }

  toggle() {
    this.apply()
  }

  apply() {
    const show = this.checkboxTarget.checked
    this.boxTarget.style.display = show ? "block" : "none"
  }
}
