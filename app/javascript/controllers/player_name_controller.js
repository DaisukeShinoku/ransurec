import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "form", "submitButton"]
  
  openDialog() {
    this.dialogTarget.style.display = "flex"
    
    document.addEventListener("click", this.handleOutsideClick = (e) => {
      if (e.target === this.dialogTarget) {
        this.closeDialog()
      }
    })

    document.addEventListener("keydown", this.handleEscKey = (e) => {
      if (e.key === "Escape") {
        this.closeDialog()
      }
    })
  }

  closeDialog() {
    this.dialogTarget.style.display = "none"
    
    document.removeEventListener("click", this.handleOutsideClick)
    document.removeEventListener("keydown", this.handleEscKey)
  }
  
  submitForm(event) {
    event.preventDefault()
    const form = event.currentTarget
    const submitButton = this.submitButtonTarget
    const originalText = submitButton.value
    
    submitButton.value = "送信中..."
    submitButton.disabled = true
    
    const formData = new FormData(form)
    
    fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      credentials: "same-origin"
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === "ok") {
        submitButton.value = "✓"
        submitButton.classList.remove("bg-indigo-600", "hover:bg-indigo-700")
        submitButton.classList.add("bg-green-600", "hover:bg-green-700")
        
        if (data.notice) {
          this.showFlashMessage(data.notice, "notice")
        }
        
        setTimeout(() => {
          this.closeDialog()
          
          // 画面をリロードして更新後の選手名を表示
          window.location.reload()
        }, 800)
      } else {
        submitButton.value = "エラー"
        submitButton.classList.remove("bg-indigo-600", "hover:bg-indigo-700")
        submitButton.classList.add("bg-red-600", "hover:bg-red-700")
        
        if (data.alert) {
          this.showFlashMessage(data.alert, "alert")
        }
        
        setTimeout(() => {
          submitButton.value = originalText
          submitButton.classList.remove("bg-red-600", "hover:bg-red-700")
          submitButton.classList.add("bg-indigo-600", "hover:bg-indigo-700")
          submitButton.disabled = false
        }, 1500)
      }
    })
    .catch(() => {
      submitButton.value = "エラー"
      submitButton.classList.remove("bg-indigo-600", "hover:bg-indigo-700")
      submitButton.classList.add("bg-red-600", "hover:bg-red-700")
      
      this.showFlashMessage("通信エラーが発生しました", "alert")
      
      setTimeout(() => {
        submitButton.value = originalText
        submitButton.classList.remove("bg-red-600", "hover:bg-red-700")
        submitButton.classList.add("bg-indigo-600", "hover:bg-indigo-700")
        submitButton.disabled = false
      }, 1500)
    })
  }
  
  showFlashMessage(message, type) {
    
    // 既存のフラッシュメッセージがあれば削除
    const existingFlash = document.querySelector(".flash-message")
    if (existingFlash) {
      existingFlash.remove()
    }

    // 新しいフラッシュメッセージを作成
    const flashDiv = document.createElement("div")
    flashDiv.className = `flash-message fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 ${type === 'notice' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`
    flashDiv.textContent = message

    // 閉じるボタンを追加
    const closeButton = document.createElement("button")
    closeButton.className = "ml-2 text-gray-500 hover:text-gray-700"
    closeButton.innerHTML = "×"
    closeButton.onclick = () => flashDiv.remove()
    flashDiv.appendChild(closeButton)

    // bodyに直接追加
    document.body.appendChild(flashDiv)

    // 3秒後に自動的に消える
    setTimeout(() => {
      if (document.body.contains(flashDiv)) {
        flashDiv.remove()
      }
    }, 3000)
  }
}
