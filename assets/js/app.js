// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

import hljs from 'highlight.js';

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const updateLineNumber = (val, element_id="line-numbers") => {
  const el = document.getElementById(element_id)
    if (!el) return
    const lines = val.split('\n')
    const numbers = lines.map((el, i) => i+1).join('\n') + "\n"
    el.value = numbers
  }

let Hooks= {}

Hooks.UpdateLineNumber = {
  mounted() {
    const parent = this.el.closest(".js-line-parent")
    this.lineNumberText = parent.querySelector('.js-line-number')
    console.log('this.lineNumberText', this.lineNumberText)
    this.el.addEventListener('input', (e) => {
      updateLineNumber(this.el.value)
    })

    this.el.addEventListener('scroll', () => {
      this.synchronizeScroll()
    })

    this.el.addEventListener('keydown', (e) => {
      if(e.key === "Tab") {
        e.preventDefault()
        let start = this.el.selectionStart;
        let end = this.el.selectionEnd;
        this.el.value = this.el.value.substring(0, start) + "\t" + this.el.value.substring(end)
        this.el.selectionStart = this.el.selectionEnd = start + 1;
      }
    })
    

    this.handleEvent("clear-textareas",() => {
      this.lineNumberText.value = '1\n'
      this.el.value = ''
    })

    updateLineNumber(this.el.value)
  },

  
  synchronizeScroll() {
    this.lineNumberText.scrollTop = this.el.scrollTop
  }
}

Hooks.Highlight = {
  mounted() {
    const codeblock = this.el.querySelector("pre code")
    const parent = this.el.closest(".js-line-parent")
    this.lineNumberText = parent.querySelector('js-line-number')

    if(codeblock)  {
      const name = this.el.dataset.name
      codeblock.className = codeblock.className.replace(/language-\S+/g, "")
      codeblock.classList.add(`language-${this.gitSyntaxType(name)}`)
      const trimmed = this.trimCodeBlock(codeblock)
      hljs.highlightElement(trimmed)
      updateLineNumber(trimmed.textContent, "syntax-numbers")
    }
  },

  gitSyntaxType(name) {
    let extantion = name.split('.').pop()

    const mapLang = {
      txt: 'text',
      json: 'json',
      html: 'html',
      heex: 'html',
      js: 'javascript'
    }

    return mapLang[extantion] || 'elixir'
  },

  trimCodeBlock(codeBlock) {
    const lines = codeBlock.textContent.split("\n")
    if(lines.length > 2) {
      lines.shift();
      lines.pop();
    }
    codeBlock.textContent = lines.join("\n")
    return codeBlock;
  }
}

Hooks.CopyToClipboard = {
  mounted() {
    this.el.addEventListener('click', () => {
      const textToCopy = this.el.dataset.clipboardGist
      if(!textToCopy) return;
      navigator.clipboard.writeText(textToCopy).then(() => {
        console.log('Gist copied to clipboard')
      }).catch((err) => {
        console.log('Failed to copy text: ', err)
      })
    })
  }
}

Hooks.ToggleEdit = {
  mounted() {
    this.el.addEventListener('click', () => {
      const editSection = document.getElementById('edit-section')
      const syntaxSection = document.getElementById('syntax-section')
      if(editSection && editSection) {
        editSection.style.display = "block"
        syntaxSection.style.display = "none"
      }
    })
  }
}


let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

