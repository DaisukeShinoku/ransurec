import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = { timeout: Number }

  connect() {
    if (this.hasTimeoutValue) {
      this.timeout = setTimeout(() => {
        this.hide()
      }, this.timeoutValue)
    }
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  hide() {
    this.element.remove()
  }
}
