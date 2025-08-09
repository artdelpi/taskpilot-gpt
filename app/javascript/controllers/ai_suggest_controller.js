import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "description", "container", "template"]

  async generate() {
    const name = this.nameTarget.value.trim()
    const description = this.descriptionTarget.value.trim()
    if (!name && !description) {
      alert("Fill name or description to suggest tasks.")
      return
    }

    try {
      const res = await fetch("/projects/suggest_ai_tasks", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ name, description, count: 5 })
      })
      if (!res.ok) throw new Error(await res.text())
      const data = await res.json() 

      data.tasks.forEach((t) => this.appendTask(t))
    } catch (err) {
      console.error(err)
      alert("Failed to suggest tasks with AI.")
    }
  }

  appendTask(t) {
    const node = this.templateTarget.content.cloneNode(true)
    const block = node.querySelector(".task-fields") || node

    const titleInput = block.querySelector('input[name*="[title]"]')
    const descTextarea = block.querySelector('textarea[name*="[description]"]')
    const dueInput = block.querySelector('input[name*="[due_date]"]')

    if (titleInput) titleInput.value = t.title || ""
    if (descTextarea) descTextarea.value = t.description || ""
    if (dueInput && t.due_date) dueInput.value = t.due_date

    this.containerTarget.appendChild(node)
  }
}
