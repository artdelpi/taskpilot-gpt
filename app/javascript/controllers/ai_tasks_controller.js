import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { projectId: Number, count: Number }

  async generate() {
    const id = this.projectIdValue
    const count = this.countValue || 5

    try {
      const res = await fetch(`/projects/${id}/generate_ai_tasks`, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "text/vnd.turbo-stream.html",
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ count })
      })

      if (!res.ok) throw new Error(await res.text())

      const html = await res.text()
      Turbo.renderStreamMessage(html)
    } catch (err) {
      console.error(err)
      alert("Failed to generate tasks with AI.")
    }
  }
}
