// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // `data-flash-target="message"` で指定された要素を参照できるようになる
  static targets = [ "message" ]
  // `data-flash-timeout-value` を `timeoutValue` として数値型で取得できるようになる
  static values = { timeout: Number }

  connect() {
    // コントローラーがDOMに接続されたときに自動的に実行される
    console.log("Flash controller connected!"); // デバッグ用

    // timeoutValue が設定されている場合のみ、自動非表示をスケジュールする
    if (this.hasTimeoutValue) {
      this.dismissAfterTimeout();
    }
  }

  // 指定されたタイムアウト後にメッセージを非表示にするメソッド
  dismissAfterTimeout() {
    setTimeout(() => {
      this.close(); // `close()` メソッドを呼び出して要素を削除する
    }, this.timeoutValue);
  }

  // メッセージ要素をDOMから削除するメソッド
  close() {
    console.log("Closing flash message."); // デバッグ用

    // ここで要素をDOMから削除します
    // フェードアウトアニメーションを付けたい場合はCSSのtransitionと組み合わせます
    this.element.remove(); // コントローラーが紐付いている要素（この場合はFlashメッセージのdiv）をDOMから削除
  }
}