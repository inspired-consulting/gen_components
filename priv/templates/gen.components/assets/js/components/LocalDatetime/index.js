class LocalDatetime extends HTMLElement {
  static get observedAttributes () {
    return ['iso-datetime']
  }

  attributeChangedCallback (name, oldValue, newValue) {
    (({
      'iso-datetime': (newValue) => {
        this.innerHTML = new Date(newValue).toLocaleString()
      }
    })[name])(newValue)
  }
}

window.customElements.define('custom-local-datetime', LocalDatetime)
