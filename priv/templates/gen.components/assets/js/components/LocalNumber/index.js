class LocalNumber extends HTMLElement {
  static get observedAttributes () {
    return ['value']
  }

  attributeChangedCallback (name, oldValue, newValue) {
    (({
      value: (newValue) => {
        this.innerHTML = parseFloat(newValue).toLocaleString([], { maximumFractionDigits: 20 })
      }
    })[name])(newValue)
  }
}

window.customElements.define('custom-local-number', LocalNumber)
