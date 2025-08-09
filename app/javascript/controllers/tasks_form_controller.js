export default class {
  static targets = ["container", "template"]

  connect() {
  }

  add() {
    if (!this.hasTemplateTarget) return
    const clone = this.templateTarget.content.cloneNode(true)
    this.containerTarget.appendChild(clone)
  }

  remove(event) {
    const btn = event.target.closest(".remove-task")
    if (!btn) return
    const block = btn.closest(".task-fields")
    const destroyFlag = block?.querySelector(".task-destroy-flag")
    if (destroyFlag) destroyFlag.value = "1"
    block?.remove()
  }
}
