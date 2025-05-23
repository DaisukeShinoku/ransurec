
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "message" ]
  static values = { timeout: Number }

  connect() {
    console.log("Flash controller connected!"); 
    if (this.hasTimeoutValue) {
      this.dismissAfterTimeout();
    }
  }

  dismissAfterTimeout() {
    setTimeout(() => {
      this.close(); 
    }, this.timeoutValue);
  }

  close() {
    console.log("Closing flash message."); 
    this.element.remove();
  }
}