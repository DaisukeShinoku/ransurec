import { Controller } from "@hotwired/stimulus"

// QRコードモーダルを制御するコントローラー
export default class extends Controller {
  static targets = ["dialog"]

  openDialog(event) {
    event.preventDefault()
    this.dialogTarget.style.display = "flex"
  }

  closeDialog(event) {
    event.preventDefault()
    this.dialogTarget.style.display = "none"
  }
}
