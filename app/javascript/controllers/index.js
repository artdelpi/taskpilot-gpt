import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

window.Stimulus = Application.start()
eagerLoadControllersFrom("controllers", Stimulus)
console.log("[Stimulus] controllers carregados")
