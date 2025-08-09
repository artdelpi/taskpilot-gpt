export default class {
  static values = { projectId: Number }
  static targets = ["button"]

  connect() {
    this._original = this.buttonTarget?.innerHTML
  }

  async generate() {
    const id = this.projectIdValue
    if (!id) { alert("Crie/salve o projeto antes."); return }

    this._setLoading(true)
    try {
      const res = await fetch(`/projects/${id}/generate_ai_tasks`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          prompt: document.querySelector("#project_description")?.value || ""
        })
      })
      const payload = await res.json()
      if (!res.ok) throw new Error(payload.error || res.statusText)

      if (window.Turbo) {
        Turbo.visit(window.location.href, { action: "replace" })
      } else {
        window.location.reload()
      }
    } catch (e) {
      console.error(e)
      alert("Falha ao gerar tarefas por IA.")
    } finally {
      this._setLoading(false)
    }
  }

  _setLoading(state) {
    if (!this.hasButtonTarget) return
    if (state) {
      this.buttonTarget.disabled = true
      this.buttonTarget.innerHTML = `
        <span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>
        Generating...
      `
    } else {
      this.buttonTarget.disabled = false
      this.buttonTarget.innerHTML = this._original
    }
  }
}
